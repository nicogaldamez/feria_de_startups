require "request_exceptions"

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  rescue_from RequestExceptions::BadRequestError, :with => :bad_request
  rescue_from RequestExceptions::ForbiddenError, :with => :forbidden
  rescue_from RequestExceptions::UnauthorizedError, :with => :unauthorized
  
  include SessionsHelper
  
  delegate :allow?, to: :current_permission
  helper_method :allow?
  
  before_filter :authorize
 
  private
    def current_permission
      @current_permission ||= Permission.new(current_user)
    end
    
    # REQUEST ERRORS
    def bad_request (exception)    
      @message = exception.message
      respond_to do |f|
        f.json { render 'shared/error', layout: false, status: 400 }
        f.html do
          flash[:error] = @message 
          redirect_to root_url
        end
      end
      return
    end
  
    def forbidden (exception)   
      @message = exception.message
      respond_to do |f|
        f.json { render 'shared/error', layout: false, status: 401 }
        f.html do
          flash[:error] = @message 
          redirect_to root_url
        end
      end
      return  
    end
  
    def unauthorized (exception)   
      @message = exception.message
      respond_to do |f|
        f.json { render 'shared/error', layout: false, status: 403 }
        f.html do
          flash[:error] = @message 
          redirect_to root_url
        end
      end
      return   
    end

    def current_resource
      nil
    end

    def authorize
      if current_permission.allow?(params[:controller], params[:action], current_resource)
        current_permission.permit_params! params
      else
        raise(RequestExceptions::UnauthorizedError.new(t(:please_sign_in))) unless signed_in?
        raise(RequestExceptions::UnauthorizedError.new(t(:no_permission)))
      end
    end  
end
