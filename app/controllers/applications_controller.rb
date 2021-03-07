class ApplicationsController < ApplicationController
    before_action :redirect_if_not_logged_in

    def new
        # if here via /jobs/:id/:slug/apply
        if params[:id]
            # look for job in current user's jobs
            @job = current_user.jobs.find_by(id: params[:id])
            
            # redirect if job not found
            redirect_to jobs_path, flash: {type: 'warning', content: "Job not found"} if !@job
        # if here via /applications/new
        else
            @jobs = current_user.jobs
        end

        render :new
    end
end