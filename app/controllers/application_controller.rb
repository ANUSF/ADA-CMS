require "application_responder"

class ApplicationController < ActionController::Base
  include OpenidClient::Helpers

  rescue_from ActionController::RoutingError, :with => :four_o_four

  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery

  helper_method :current_user, :get_atom_feed


  before_filter :update_authentication #in case the user logs out externally

  def four_o_four
  	@title = "#{request.path} 404"
    @current_archive = Archive.ada

    respond_to do |format| 
      format.html { render :template => "errors/404", :status => 404 } 
      format.all  { render :nothing => true, :status => 404 } 
    end
  	true
  end

  def update_authentication
    openid = oid_authentication_state
    # debugger
    # puts "-"
  end

  def get_atom_feed(archive)
    feed = Inkling::Feed.find_by_title("#{archive.name} Feed")
    feed ||=  Inkling::Feed.create!(:title => "#{archive.name} Feed", :format => "Inkling::Feeds::Atom", :source => "ArchiveFeedsSource", :authors => archive.name, :criteria => {:archive_id => archive.id})    
  end

end

