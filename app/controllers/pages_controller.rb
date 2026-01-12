# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @site_profile = SiteProfile.instance
  end
end
