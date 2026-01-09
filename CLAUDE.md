# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Required Reading

Before starting work on this project, read these supplemental guidance files:
- **RUBY.md** - Ruby-specific best practices and idioms
- **RAILS.md** - Rails conventions, especially the section on using encrypted credentials over ENV variables
- **WEBUI.md** - Frontend/UI design guidelines

These files are located in the parent directory (`/home/dyoung/.claude/`) and provide essential context for this Rails project.

## Project Overview

Personal website (full-stack Rails) for Lorraine Lai. Phase 1 focuses on publishing content and syncing published posts from Substack.

**Tech Stack:**
- Ruby 4.0 (latest stable)
- Rails 8.1 (latest stable)
- Database: SQLite (single-server production)
- CSS: TailwindCSS (no Node toolchain)
- Background Jobs: Solid Queue (separate "jobs" container)
- Deployment: Docker + Kamal
- Object Storage: S3-compatible (self-hosted homelab)

## Development Commands

**Setup:**
```bash
bundle install
bin/rails db:setup
```

**Run locally:**
```bash
# Web server
bin/rails server

# Background jobs (development)
bin/rails solid_queue:start
```

**Testing:**
```bash
# Backend tests (RSpec)
bundle exec rspec

# Run single test file
bundle exec rspec spec/path/to/file_spec.rb

# Run single test
bundle exec rspec spec/path/to/file_spec.rb:LINE_NUMBER

# Frontend tests (Playwright)
npm test

# Interactive test mode
npm run test:ui

# Run tests in headed mode (see browser)
npm run test:headed
```

**Linting:**
```bash
bundle exec rubocop

# Auto-fix
bundle exec rubocop -a
```

**Credentials Management:**
```bash
# Edit encrypted credentials (opens in $EDITOR)
bin/rails credentials:edit

# View credentials structure template
cat config/credentials.yml.example
```

All secrets are stored in Rails encrypted credentials, NOT environment variables. Only `RAILS_MASTER_KEY` should be in ENV for production deployment.

## Architecture & Key Concepts

### Core Pages (Phase 1)
- **Home**: "About Me" information, social media links, navigation
- **Musings**: Published posts synced from Substack
- **Gallery**: Photographs and original artwork

### Substack Integration
- API: <https://substackapi.dev>
- **Source of truth**: Substack (published posts only)
- **Ingestion requirements**:
  - Must be idempotent
  - Runs as scheduled background job in separate jobs container
  - Logic should live in dedicated service/module
  - Must be covered by tests

### Data & Storage
- **SQLite DB**: Must be on local persistent storage (Docker volume), NOT NFS
- **Media/uploads**: Use S3-compatible object storage, NOT local disk/NFS
- **Backups**:
  - DB: hourly-to-daily snapshots (target RPO: hours)
  - Object storage: per provider implementation (target RPO: hours-to-daily)

### Authentication
- Admin authentication via Google OAuth using Rails defaults

## Critical Constraints

1. **Gems**: Avoid adding new gems unless clearly justified. Prefer standard library solutions.
2. **Migrations**: Append-only once merged. Never modify existing migrations in main branch.
3. **Storage**: SQLite DB on local persistent storage only. Media on S3-compatible object storage only.
4. **Testing**: Backend (RSpec), Frontend (Playwright). All ingestion logic must have test coverage.

## Frontend Guidelines

Refer to WEBUI.md for specific frontend/UI guidance.
