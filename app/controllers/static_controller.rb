class StaticController < ApplicationController
    before_action :logged_in_redirect, only: [:home]

    def home
    end

    def about
    end
end