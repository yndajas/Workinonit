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

    def logged_in_redirect
        if logged_in?
            # if user was redirected to login via another route, return to that route
            if session[:origin]
                origin = session[:origin]
                session.delete :origin
                redirect_to origin
            # if they came to login route normally, go to dashboard
            else
                redirect_to dashboard_path
            end
        end
    end

    def redirect_if_no_application_or_does_not_belong_to_user(path)
        unless @application.try(:user).try(:==, current_user)
            redirect_to path, flash: {type: 'warning', content: "Application not found"}
        end
    end
end
