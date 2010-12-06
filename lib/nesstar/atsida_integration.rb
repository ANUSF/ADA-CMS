require 'rubygems'
require 'ruote/engine'
require 'ruby-debug'
require 'nesstar/atsida_config'
require 'ruote/storage/base'
require 'ruote/storage/fs_storage'
require 'ruote/worker'
require 'ruote/participant'
require 'ruote'
require 'fileutils'
require 'yaml'

module Nesstar
  class AtsidaIntegration
    include AtsidaConfig

    #helper method - takes a url like http://bonus.anu.edu.au:80/obj/fStudy/au.edu.anu.assda.ddi.00570@relatedMaterials
    #and returns 00570_relatedMaterials.xml
    def self.related_materials_document_id(url)
      trailer = url.split(".").last
      id = trailer.split("@").first
      return id
    end

    #call this from the client to run the integration.
    def self.run
      @storage = Ruote::FsStorage.new("/tmp/atsida-ruote/")
      @worker = Ruote::Worker.new(@storage)
      @engine = Ruote::Engine.new(@worker)

      register_workflow_participants(@engine)

      dataset_process_def = Ruote.process_definition :name => 'convert_datasets' do
        sequence do
          subprocess :ref => 'initialize_directories'
          participant :ref => 'load_dataset_ids', :datasets_yaml => $datasets_file
          cancel_process :if => '${f:dataset_ids.size} == 0'
          participant :ref => 'download_dataset_xmls'
          participant :ref => 'convert'

          participant :ref => 'generate_editors_report', :if => '${f:new_pages.size} != 0'
          participant :ref => 'email_editors_report', :notify_list => ["editors@atsida.assda.edu.au"], :if => '${f:new_pages.size} != 0'
        end

        process_definition :name => 'initialize_directories' do
          sequence do
            participant :ref => 'initialize_directory', :dir => $nesstar_dir
            participant :ref => 'recreate_xml_directory', :dir => $xml_dir
          end
        end
      end

      ARGV << "-d"
      wfid = @engine.launch(dataset_process_def)
      @engine.wait_for(wfid)
    end

    # registers the workflow logic participants with ruote
    def self.register_workflow_participants(engine)
      engine.register_participant 'initialize_directory' do |workitem|
        mkdir(workitem.fields["params"]['dir']) unless File.exists?(workitem.fields["params"]['dir'])
      end

      engine.register_participant 'recreate_xml_directory' do |workitem|
        rm_rf(workitem.fields['params']['dir'])
        mkdir(workitem.fields['params']['dir'])
      end

      ## load_dataset_ids
      engine.register_participant 'load_dataset_ids' do |workitem|
        dataset_urls = []
        whitelist = DocumentIdentifierList.find_by_name("whitelist")
        for doc_identifier in whitelist.document_identifiers
          dataset_urls << doc_identifier.resource_url
        end
        queries = DocumentQuery.all

        for query in queries
          query_response_file = "#{$xml_dir}query_response_#{Time.now.to_i}.xml"

          `curl -o #{query_response_file} --compressed "#{query.query}"`
          handler = Nesstar::QueryResponseParser.new(query_response_file)
          dataset_urls += handler.datasets
        end

        blacklist = DocumentIdentifierList.find_by_name("blacklist")
        banned_urls = []
        for doc_identifier in blacklist.document_identifiers
          banned_urls << doc_identifier.resource_url
        end

        dataset_urls -= banned_urls
        workitem.fields['config'] = {'urls' => dataset_urls}
      end

      ## download_dataset_xmls
      engine.register_participant 'download_dataset_xmls' do |workitem|
        fetch_errors = []
        downloaded_files = []
        workitem.fields['config']['urls'].each do |url|
          file_name = "#{url.split(".").last}.xml"
          begin
#            puts "curl -o #{$xml_dir}#{file_name} --compressed #{url}"
            `curl -o #{$xml_dir}#{file_name} --compressed "#{url}"`
            downloaded_files << file_name
          rescue StandardError => boom
            puts "#{boom}.to_s"
            fetch_errors << "Error while downloading #{url}: #{boom} \n"
          end
        end

        workitem.fields['fetch_errors'] = fetch_errors
        workitem.fields['downloads'] = downloaded_files
      end


      ## convert
      engine.register_participant 'convert' do |workitem|
        database_errors = []
        new_pages = []
        section = Section.find_by_name("Datasets Collection")

        Dir.entries($xml_dir).each do |file_name|
          next if file_name == "." or file_name == ".."
          begin
            ds_hash = RDF::Parser.parse("#{$xml_dir}/#{file_name}")
            ds = Dataset.store_with_entries(ds_hash)

            #create mappings entries for any DDI elements/attributes we have not yet noticed
            Mapping.batch_create(ds_hash)

            #we looks for a dataset_entry which records the URL of a related materials document
            related_materials_entry = ds.related_materials_attribute
            unless related_materials_entry.nil?
              # puts "curl -o #{@@xml_dir}#{related_materials_document_id(related_materials_entry.value)}.xml --compressed '#{related_materials_entry.value}'"
              document_name = related_materials_document_id(related_materials_entry.value) + ".xml"
              `curl -o #{$xml_dir}#{document_name} --compressed "#{related_materials_entry.value}"`
              related_materials_list = RDF::Parser.parse_related_materials_document("#{$xml_dir}/#{document_name}")

              related_materials_list.each do |related|
                pre_existing = DatasetRelatedMaterial.find_by_dataset_id_and_uri_and_label(ds.id, related[:uri], related[:label])
                next if pre_existing

                related_material = DatasetRelatedMaterial.new(:dataset_id => ds.id, :uri => related[:uri], :label => related[:label],
                            :comment => related[:comment], :creation_date => related[:creationDate], :complete => related[:complete],
                            :resource => related[:study_resource])
                related_material.save!
              end
            end

            path = ds.label.split(".").last
            path.gsub!(/[^\w\s]/, "")
            path = path.gsub(" ", "-").downcase

            page = Page.find_by_name(ds.label)

            if page.nil?
              page = Page.new(:name => ds.label, :title => ds.label,
              :description => "A page automatically created to hold the #{ds.label} dataset.",
              :partial =>"dataset_page.html.ren", :path => path, :published => true)
              page.save!

              ds.page_id = page.id
              ds.save!

              new_pages << page
            end
          rescue StandardError => boom
            puts "#{boom}.to_s"
            database_errors << "Error converting #{file_name} into a dataset with a page: #{boom} \n"
          end
        end

        workitem.fields['database_errors'] = database_errors
        workitem.fields['new_pages'] = new_pages
      end

      ## generate_report
      engine.register_participant 'generate_administrators_report' do |workitem|
        administrator_report = "Report:"
        administrator_report << "\n#{workitem.fields['downloads'].size} files were fetched from Nesstar with #{workitem.fields['database_errors'].size} errors."
        administrator_report << "\n#{(workitem.fields['downloads'].size - workitem.fields['database_errors'].size).to_s} of these were successfully stored in the db."

        if workitem.fields['fetch_errors'].any? or workitem.fields['database_errors'].any?
          administrator_report << "\n\nThere were errors in this run ..."
          administrator_report << "\nNesstar download errors:"
          workitem.fields['fetch_errors'].each {|e| administrator_report << "\n #{e}"}
          administrator_report << "\n\n Database errors:"
          workitem.fields['database_errors'].each {|e| administrator_report << "\n #{e}"}
        end

        `echo "#{administrator_report}" > #{$tmp_dir}/integration_report_#{Time.now.strftime("%d-%m-%y_%I:%M")}.txt`
        workitem.fields['administrators_report'] = administrator_report
      end


      engine.register_participant 'generate_editors_report' do |workitem|
        editor_report = "Report:"
        editor_report << "\n#{workitem.fields['new_pages'].size} new pages were created in the CMS, one for each new dataset."

        for page in workitem.fields['new_pages']
          editor_report << "\n http://atsida.assda.edu.au#{page['page']['path']} is in draft state."
        end

        workitem.fields['editors_report'] = editor_report
      end

      ## email_report
      engine.register_participant 'email_administrators_report' do |workitem|
        for email in workitem.fields['params']['notify_list']
          Net::SMTP.start("anusf.anu.edu.au", 25) do |smtp|
#            Net::SMTP.start("localhost", 25) do |smtp|
            email_report = <<-EMAIL_END
Subject: ASSDA Integration Report
From: ATSIDA CMS <atsida_cms@atsida.assda.edu.au>
To: #{email}

#{workitem.fields['administrators_report']}
      EMAIL_END
            smtp.send_message(email_report, "administrators@atsida.assda.edu.au", email)
          end
        end
      end

      engine.register_participant 'email_editors_report' do |workitem|
        for email in workitem.fields['params']['notify_list']
          Net::SMTP.start("anusf.anu.edu.au", 25) do |smtp|
#          Net::SMTP.start("localhost", 25) do |smtp|
            email_report = <<-EMAIL_END
Subject: ATSIDA CMS - new content
From: ATSIDA CMS <atsida_cms@atsida.assda.edu.au>
To: #{email}

#{workitem.fields['editors_report']}
      EMAIL_END

            smtp.send_message(email_report, "editors@atsida.assda.edu.au", email)
          end
        end
      end
    end
  end
end
