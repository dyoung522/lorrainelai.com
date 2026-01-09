# Credentials Setup Guide

## Current State ✅

The Substack API token has been migrated to Rails encrypted credentials.

## What's Configured

1. **Substack API token** - Already in encrypted credentials
2. **Master key** - Located at `config/master.key` (gitignored)

## Adding Additional Credentials

To add Google OAuth or S3 credentials:

```bash
bin/rails credentials:edit
```

Follow the structure in `config/credentials.yml.example`:

```yaml
# Google OAuth for admin authentication
google_oauth:
  client_id: your_google_client_id_here
  client_secret: your_google_client_secret_here

# S3-compatible object storage (self-hosted in homelab)
s3:
  access_key_id: your_s3_access_key_here
  secret_access_key: your_s3_secret_access_key_here
  bucket: your_bucket_name_here
  region: us-east-1
  endpoint: https://your-s3-endpoint.com
```

## Using Credentials in Code

Access credentials using:
```ruby
Rails.application.credentials.dig(:substack, :api_token)
Rails.application.credentials.dig(:google_oauth, :client_id)
Rails.application.credentials.dig(:s3, :access_key_id)
```

## Production Deployment

Only `RAILS_MASTER_KEY` needs to be set in the production environment to decrypt credentials. The master key value is in `config/master.key`.

## Security Notes

- ✅ All secrets encrypted at rest
- ✅ `config/master.key` is gitignored
- ✅ `config/credentials.yml.enc` is safe to commit (encrypted)
- ✅ `.env` file cleaned (no secrets)
