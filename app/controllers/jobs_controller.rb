class JobsController < ApplicationController
    def new
        @countries = ProviderCountry.all
    end

    def create
        raise params.inspect
    end
end