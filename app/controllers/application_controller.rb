class ApplicationController < ActionController::Base
    helper_method :logged_in?, :current_user

    def logged_in?
        !!session[:user_id]
    end
    
    def current_user
        @current_user ||= User.find(session[:user_id])
    end

    def redirect_if_not_logged_in
        if !logged_in?
            session[:origin] = request.env["REQUEST_PATH"]
            redirect_to login_path
        end
    end
end
