class JobsController < ApplicationController
    def new
        @countries = ProviderCountry.all
    end
end