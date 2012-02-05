class AdaDataController < ApplicationController

  def show
    # TODO - put this into a config file
    base = File.join('', 'projects_qfs', 'd10', 'assda', 'publish', 'ADAData')

    path = File.join base, File.absolute_path(File.join '', params[:rest])
    if path.starts_with?(File.join base, '')
      send_file(path,
                :filename => File.basename(path),
                :disposition => "attachment",
                :stream => true,
                :buffer_size => 1024 * 1024)
    else
      raise "File not found: ADAData/#{params[:rest]}"
    end
  end
end
