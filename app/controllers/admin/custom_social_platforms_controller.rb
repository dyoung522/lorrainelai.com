# frozen_string_literal: true

module Admin
  class CustomSocialPlatformsController < ApplicationController
    before_action :require_authentication
    before_action :set_site_profile
    before_action :set_custom_social_platform, only: [:edit, :update, :destroy]

    def new
      @custom_social_platform = @site_profile.custom_social_platforms.build
    end

    def create
      @custom_social_platform = @site_profile.custom_social_platforms.build(custom_social_platform_params)
      if @custom_social_platform.save
        redirect_to root_path, notice: "Custom platform added successfully"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @custom_social_platform.update(custom_social_platform_params)
        redirect_to root_path, notice: "Custom platform updated successfully"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @custom_social_platform.destroy
      redirect_to root_path, notice: "Custom platform deleted successfully"
    end

    private

    def set_site_profile
      @site_profile = SiteProfile.instance
    end

    def set_custom_social_platform
      @custom_social_platform = @site_profile.custom_social_platforms.find(params[:id])
    end

    def custom_social_platform_params
      params.require(:custom_social_platform).permit(:name, :url, :icon, :position)
    end
  end
end
