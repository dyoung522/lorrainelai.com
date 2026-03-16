# frozen_string_literal: true

class SubstackIngestionJob < ApplicationJob
  queue_as :default

  def perform
    result = SubstackIngestionService.call
    Rails.logger.info(
      "[SubstackIngestionJob] Completed: created=#{result[:created]} updated=#{result[:updated]} errors=#{result[:errors].length}"
    )
    result[:errors].each { |error| Rails.logger.warn("[SubstackIngestionJob] #{error}") }
  end
end
