# frozen_string_literal: true

class SubstackIngestionService
  API_BASE = "https://api.substackapi.dev"

  def self.call
    new.call
  end

  def call
    api_key = Rails.application.credentials.dig(:substack, :api_key)
    publication_url = Rails.application.credentials.dig(:substack, :publication_url)

    return error_result("Substack credentials missing: api_key or publication_url") if api_key.blank? || publication_url.blank?

    response = fetch_posts(api_key, publication_url)
    return error_result("HTTP #{response.code}: #{response.body}") unless response.is_a?(Net::HTTPSuccess)

    parsed = JSON.parse(response.body)
    posts = parsed.is_a?(Hash) && parsed.key?("data") ? parsed["data"] : parsed
    upsert_posts(Array(posts))
  rescue SocketError, Timeout::Error, Errno::ECONNREFUSED, JSON::ParserError => e
    error_result(e.message)
  end

  private

  def fetch_posts(api_key, publication_url)
    uri = URI("#{API_BASE}/posts/latest")
    uri.query = URI.encode_www_form(publication_url: publication_url)

    request = Net::HTTP::Get.new(uri)
    request["X-API-Key"] = api_key

    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
  end

  def upsert_posts(posts_data)
    created = 0
    updated = 0
    errors = []

    posts_data.each do |data|
      post = Post.find_or_initialize_by(slug: data["slug"])
      new_record = post.new_record?

      post.assign_attributes(
        title: data["title"],
        description: data["description"],
        excerpt: data["excerpt"],
        substack_url: data["url"],
        published_at: data["date"],
        reading_time_minutes: data["reading_time_minutes"],
        likes: data["likes"],
        cover_image_url: data.dig("cover_image", "large"),
        author: data["author"],
        paywall: data["paywall"] || false,
      )

      if post.save
        new_record ? created += 1 : updated += 1
      else
        errors << "#{data['slug']}: #{post.errors.full_messages.join(', ')}"
      end
    end

    { created: created, updated: updated, errors: errors }
  end

  def error_result(message)
    Rails.logger.error("[SubstackIngestionService] #{message}")
    { created: 0, updated: 0, errors: [ message ] }
  end
end
