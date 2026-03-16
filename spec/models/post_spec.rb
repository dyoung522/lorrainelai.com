# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validations' do
    it 'is valid with all required attributes' do
      post = Post.new(title: 'Test Post', slug: 'test-post', substack_url: 'https://example.substack.com/p/test-post')
      expect(post).to be_valid
    end

    it 'requires title' do
      post = Post.new(slug: 'test-post', substack_url: 'https://example.substack.com/p/test-post')
      expect(post).not_to be_valid
      expect(post.errors[:title]).to include("can't be blank")
    end

    it 'requires slug' do
      post = Post.new(title: 'Test Post', substack_url: 'https://example.substack.com/p/test-post')
      expect(post).not_to be_valid
      expect(post.errors[:slug]).to include("can't be blank")
    end

    it 'requires substack_url' do
      post = Post.new(title: 'Test Post', slug: 'test-post')
      expect(post).not_to be_valid
      expect(post.errors[:substack_url]).to include("can't be blank")
    end

    it 'requires unique slug' do
      Post.create!(title: 'First', slug: 'same-slug', substack_url: 'https://example.substack.com/p/first')
      duplicate = Post.new(title: 'Second', slug: 'same-slug', substack_url: 'https://example.substack.com/p/second')
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:slug]).to include('has already been taken')
    end
  end

  describe 'defaults' do
    it 'defaults likes to 0' do
      post = Post.new
      expect(post.likes).to eq(0)
    end

    it 'defaults paywall to false' do
      post = Post.new
      expect(post.paywall).to be false
    end
  end

  describe 'scopes' do
    let!(:published_post) do
      Post.create!(title: 'Published', slug: 'published', substack_url: 'https://example.substack.com/p/published', published_at: 2.days.ago)
    end

    let!(:unpublished_post) do
      Post.create!(title: 'Draft', slug: 'draft', substack_url: 'https://example.substack.com/p/draft', published_at: nil)
    end

    let!(:older_post) do
      Post.create!(title: 'Older', slug: 'older', substack_url: 'https://example.substack.com/p/older', published_at: 5.days.ago)
    end

    describe '.published' do
      it 'returns only posts with a published_at date' do
        expect(Post.published).to contain_exactly(published_post, older_post)
      end

      it 'excludes posts without a published_at date' do
        expect(Post.published).not_to include(unpublished_post)
      end
    end

    describe '.newest_first' do
      it 'orders posts by published_at descending' do
        expect(Post.newest_first.to_a).to eq([ published_post, older_post, unpublished_post ])
      end
    end
  end
end
