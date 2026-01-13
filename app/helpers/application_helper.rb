# frozen_string_literal: true

module ApplicationHelper
  SOCIAL_ICONS = {
    "instagram" => {
      name: "Instagram",
      icon: <<~SVG
        <svg class="size-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
          <path fill-rule="evenodd" d="M12.315 2c2.43 0 2.784.013 3.808.06 1.064.049 1.791.218 2.427.465a4.902 4.902 0 011.772 1.153 4.902 4.902 0 011.153 1.772c.247.636.416 1.363.465 2.427.048 1.067.06 1.407.06 4.123v.08c0 2.643-.012 2.987-.06 4.043-.049 1.064-.218 1.791-.465 2.427a4.902 4.902 0 01-1.153 1.772 4.902 4.902 0 01-1.772 1.153c-.636.247-1.363.416-2.427.465-1.067.048-1.407.06-4.123.06h-.08c-2.643 0-2.987-.012-4.043-.06-1.064-.049-1.791-.218-2.427-.465a4.902 4.902 0 01-1.772-1.153 4.902 4.902 0 01-1.153-1.772c-.247-.636-.416-1.363-.465-2.427-.047-1.024-.06-1.379-.06-3.808v-.63c0-2.43.013-2.784.06-3.808.049-1.064.218-1.791.465-2.427a4.902 4.902 0 011.153-1.772A4.902 4.902 0 015.45 2.525c.636-.247 1.363-.416 2.427-.465C8.901 2.013 9.256 2 11.685 2h.63zm-.081 1.802h-.468c-2.456 0-2.784.011-3.807.058-.975.045-1.504.207-1.857.344-.467.182-.8.398-1.15.748-.35.35-.566.683-.748 1.15-.137.353-.3.882-.344 1.857-.047 1.023-.058 1.351-.058 3.807v.468c0 2.456.011 2.784.058 3.807.045.975.207 1.504.344 1.857.182.466.399.8.748 1.15.35.35.683.566 1.15.748.353.137.882.3 1.857.344 1.054.048 1.37.058 4.041.058h.08c2.597 0 2.917-.01 3.96-.058.976-.045 1.505-.207 1.858-.344.466-.182.8-.398 1.15-.748.35-.35.566-.683.748-1.15.137-.353.3-.882.344-1.857.048-1.055.058-1.37.058-4.041v-.08c0-2.597-.01-2.917-.058-3.96-.045-.976-.207-1.505-.344-1.858a3.097 3.097 0 00-.748-1.15 3.098 3.098 0 00-1.15-.748c-.353-.137-.882-.3-1.857-.344-1.023-.047-1.351-.058-3.807-.058zM12 6.865a5.135 5.135 0 110 10.27 5.135 5.135 0 010-10.27zm0 1.802a3.333 3.333 0 100 6.666 3.333 3.333 0 000-6.666zm5.338-3.205a1.2 1.2 0 110 2.4 1.2 1.2 0 010-2.4z" clip-rule="evenodd"/>
        </svg>
      SVG
    },
    "linkedin" => {
      name: "LinkedIn",
      icon: <<~SVG
        <svg class="size-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
          <path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/>
        </svg>
      SVG
    },
    "twitter" => {
      name: "X (Twitter)",
      icon: <<~SVG
        <svg class="size-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
          <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z"/>
        </svg>
      SVG
    },
    "youtube" => {
      name: "YouTube",
      icon: <<~SVG
        <svg class="size-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
          <path fill-rule="evenodd" d="M19.812 5.418c.861.23 1.538.907 1.768 1.768C21.998 8.746 22 12 22 12s0 3.255-.418 4.814a2.504 2.504 0 0 1-1.768 1.768c-1.56.419-7.814.419-7.814.419s-6.255 0-7.814-.419a2.505 2.505 0 0 1-1.768-1.768C2 15.255 2 12 2 12s0-3.255.417-4.814a2.507 2.507 0 0 1 1.768-1.768C5.744 5 11.998 5 11.998 5s6.255 0 7.814.418ZM15.194 12 10 15V9l5.194 3Z" clip-rule="evenodd"/>
        </svg>
      SVG
    },
    "substack" => {
      name: "Substack",
      icon: <<~SVG
        <svg class="size-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
          <path d="M22.539 8.242H1.46V5.406h21.08v2.836zM1.46 10.812V24L12 18.11 22.54 24V10.812H1.46zM22.54 0H1.46v2.836h21.08V0z"/>
        </svg>
      SVG
    },
    "bookshop" => {
      name: "Bookshop.org",
      icon: <<~SVG
        <svg class="size-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
          <path d="M6 2h2v20H6V2zm2 0h6c2.5 0 4.5 1.5 4.5 4s-1.5 4-4 4h-2v0h2c3 0 5 2 5 5s-2.5 5-5.5 5H8v-4h5c1.5 0 2.5-1 2.5-2s-1-2-2.5-2H8V8h4.5c1.2 0 2-0.8 2-1.8S13.7 4.5 12.5 4.5H8V2z"/>
        </svg>
      SVG
    }
  }.freeze

  def social_link_icon(platform, url)
    return nil unless url.present?

    config = SOCIAL_ICONS[platform.to_s]
    return nil unless config

    content_tag(:a,
      href: url,
      target: "_blank",
      rel: "noopener noreferrer",
      class: "text-text-secondary hover:text-dusty-rose-dark transition-colors",
      title: config[:name]) do
      config[:icon].html_safe
    end
  end

  def render_social_links(site_profile)
    # Standard platform links with icons
    icon_links = SiteProfile::SOCIAL_PLATFORMS.filter_map do |platform|
      url = site_profile.social_link(platform)
      social_link_icon(platform, url) if url.present?
    end

    # Custom social platforms (with uploaded icons)
    custom_platform_links = site_profile.custom_social_platforms.filter_map do |platform|
      next unless platform.url.present?

      content_tag(:a,
        href: platform.url,
        target: "_blank",
        rel: "noopener noreferrer",
        class: "text-text-secondary hover:text-dusty-rose-dark transition-colors",
        title: platform.name) do
        if platform.icon.attached?
          image_tag(platform.icon, class: "size-6", alt: platform.name)
        else
          content_tag(:span, platform.name, class: "text-sm")
        end
      end
    end

    all_links = icon_links + custom_platform_links
    return nil if all_links.empty?

    content_tag(:div, class: "flex gap-4 justify-center items-center flex-wrap") do
      safe_join(all_links)
    end
  end
end
