# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create default site profile if one doesn't exist
unless SiteProfile.exists?
  SiteProfile.create!(
    tagline: "Creative thinker. Storyteller. Explorer.",
    about_me: <<~ABOUT,
      Welcome! I'm Lorraine Lai, a creative professional passionate about art, photography, and thoughtful writing.

      Through my work, I explore the intersection of creativity and everyday life. Whether it's capturing moments through my camera, putting thoughts to paper, or curating visual experiences, I believe in the power of authentic expression.

      This space is where I share my musings, showcase my gallery, and connect with fellow curious minds.
    ABOUT
    social_links: {
      "instagram" => "",
      "linkedin" => "",
      "twitter" => "",
      "youtube" => "",
      "substack" => ""
    }
  )

  puts "Created default site profile"

  # Create sample featured links
  site_profile = SiteProfile.instance
  site_profile.featured_links.create!(
    title: "Musings",
    url: "https://example.com/musings",
    position: 1
  )
  site_profile.featured_links.create!(
    title: "Gallery",
    url: "https://example.com/gallery",
    position: 2
  )
  puts "Created sample featured links"
end
