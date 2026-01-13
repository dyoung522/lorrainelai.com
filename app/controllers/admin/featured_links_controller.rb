# frozen_string_literal: true

module Admin
  class FeaturedLinksController < ApplicationController
    before_action :require_authentication
    before_action :set_site_profile
    before_action :set_featured_link, only: [ :edit, :update, :destroy ]

    def new
      @featured_link = @site_profile.featured_links.build
    end

    def create
      @featured_link = @site_profile.featured_links.build(featured_link_params)
      if @featured_link.save
        redirect_to root_path, notice: "Featured link created successfully"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @featured_link.update(featured_link_params)
        redirect_to root_path, notice: "Featured link updated successfully"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @featured_link.destroy
      redirect_to root_path, notice: "Featured link deleted successfully"
    end

    private

    def set_site_profile
      @site_profile = SiteProfile.instance
    end

    def set_featured_link
      @featured_link = @site_profile.featured_links.find(params[:id])
    end

    def featured_link_params
      params.require(:featured_link).permit(:title, :url, :position)
    end
  end
end
