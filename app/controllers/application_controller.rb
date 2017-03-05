class ApplicationController < ActionController::Base
  before_action :set_current_user
  before_action :reload_rails_admin, if: :rails_admin_path?
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to '/', alert: exception.message
  end

  rescue_from UserNoEmailException do |exception|
    redirect_to edit_user_registration_path, alert: "Your must input your email before creating a repository! It is only used to receive notification."
  end


  protected
    def render_404(exception = nil)
      if exception
        logger.info "Rendering 404 with exception: #{exception.message}"
      end

      respond_to do |format|
        format.html { render :file => "#{Rails.root}/public/404", :formats => [:html], :status => :not_found, :layout => false }
        format.xml  { head :not_found }
        format.any  { head :not_found }
      end
    end

    def set_current_user
      User.current = current_user
    end

  private
    def reload_rails_admin
      models = %W(User Build Repository)
      models.each do |m|
        RailsAdmin::Config.reset_model(m)
      end
      RailsAdmin::Config::Actions.reset

      load("#{Rails.root}/config/initializers/rails_admin.rb")
    end

    def rails_admin_path?
      controller_path =~ /rails_admin/ && Rails.env == "development"
    end
end
