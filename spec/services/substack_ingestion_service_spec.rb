# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubstackIngestionService, type: :service do
  let(:api_key) { 'test-api-key' }
  let(:publication_url) { 'https://example.substack.com' }

  let(:api_response_data) do
    [
      {
        'title' => 'First Post',
        'slug' => 'first-post',
        'description' => 'A great first post',
        'excerpt' => 'This is the excerpt of the first post...',
        'url' => 'https://example.substack.com/p/first-post',
        'date' => '2026-03-10T12:00:00.000Z',
        'reading_time_minutes' => 5,
        'likes' => 42,
        'cover_image' => { 'large' => 'https://cdn.substack.com/image/first-large.jpg' },
        'author' => 'Lorraine Lai',
        'paywall' => false
      },
      {
        'title' => 'Second Post',
        'slug' => 'second-post',
        'description' => 'Another post',
        'excerpt' => 'Excerpt for the second post...',
        'url' => 'https://example.substack.com/p/second-post',
        'date' => '2026-03-12T12:00:00.000Z',
        'reading_time_minutes' => 3,
        'likes' => 10,
        'cover_image' => nil,
        'author' => 'Lorraine Lai',
        'paywall' => true
      }
    ]
  end

  let(:success_response) do
    instance_double(Net::HTTPOK, code: '200', body: { "data" => api_response_data }.to_json, is_a?: true).tap do |resp|
      allow(resp).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
    end
  end

  let(:error_response) do
    instance_double(Net::HTTPInternalServerError, code: '500', body: 'Internal Server Error').tap do |resp|
      allow(resp).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false)
    end
  end

  before do
    allow(Rails.application.credentials).to receive(:dig).with(:substack, :api_key).and_return(api_key)
    allow(Rails.application.credentials).to receive(:dig).with(:substack, :publication_url).and_return(publication_url)
  end

  describe '.call' do
    context 'with a successful API response' do
      before do
        allow(Net::HTTP).to receive(:start).and_return(success_response)
      end

      it 'creates new posts' do
        result = described_class.call
        expect(result[:created]).to eq(2)
        expect(result[:updated]).to eq(0)
        expect(result[:errors]).to be_empty
      end

      it 'sets post attributes correctly' do
        described_class.call
        post = Post.find_by(slug: 'first-post')
        expect(post.title).to eq('First Post')
        expect(post.description).to eq('A great first post')
        expect(post.excerpt).to eq('This is the excerpt of the first post...')
        expect(post.substack_url).to eq('https://example.substack.com/p/first-post')
        expect(post.reading_time_minutes).to eq(5)
        expect(post.likes).to eq(42)
        expect(post.cover_image_url).to eq('https://cdn.substack.com/image/first-large.jpg')
        expect(post.author).to eq('Lorraine Lai')
        expect(post.paywall).to be false
      end

      it 'updates existing posts on re-run (idempotent)' do
        Post.create!(title: 'Old Title', slug: 'first-post', substack_url: 'https://example.substack.com/p/first-post', likes: 10)

        result = described_class.call
        expect(result[:created]).to eq(1)
        expect(result[:updated]).to eq(1)

        post = Post.find_by(slug: 'first-post')
        expect(post.title).to eq('First Post')
        expect(post.likes).to eq(42)
      end

      it 'does not create duplicate posts' do
        2.times { described_class.call }
        expect(Post.count).to eq(2)
      end
    end

    context 'when the API returns an error' do
      before do
        allow(Net::HTTP).to receive(:start).and_return(error_response)
      end

      it 'returns error information' do
        result = described_class.call
        expect(result[:created]).to eq(0)
        expect(result[:updated]).to eq(0)
        expect(result[:errors]).to include(match(/HTTP 500/))
      end
    end

    context 'when a network error occurs' do
      before do
        allow(Net::HTTP).to receive(:start).and_raise(SocketError.new('Failed to open TCP connection'))
      end

      it 'returns error information' do
        result = described_class.call
        expect(result[:created]).to eq(0)
        expect(result[:updated]).to eq(0)
        expect(result[:errors]).to include(match(/Failed to open TCP connection/))
      end
    end

    context 'when credentials are missing' do
      before do
        allow(Rails.application.credentials).to receive(:dig).with(:substack, :api_key).and_return(nil)
      end

      it 'returns an error' do
        result = described_class.call
        expect(result[:errors]).to include(match(/missing/i))
      end
    end
  end
end
