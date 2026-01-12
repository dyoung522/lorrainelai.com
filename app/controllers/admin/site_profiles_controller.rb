# frozen_string_literal: true

module Admin
  class SiteProfilesController < ApplicationController
    before_action :require_authentication
    before_action :set_site_profile

    def edit
    end

    def update
      if @site_profile.update(site_profile_params)
        respond_to do |format|
          format.turbo_stream { redirect_to root_path, notice: "Profile updated successfully" }
          format.html { redirect_to root_path, notice: "Profile updated successfully" }
        end
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def edit_field
      @field = params[:field]
      render partial: "admin/site_profiles/fields/#{@field}_form", locals: { site_profile: @site_profile }
    end

    private

    def set_site_profile
      @site_profile = SiteProfile.instance
    end

    def site_profile_params
      params.require(:site_profile).permit(
        :tagline,
        :about_me,
        :profile_picture,
        social_links: {}
      )
    end
  end
end
