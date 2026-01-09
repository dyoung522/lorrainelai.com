---
publish:
title: PROJECT.md
type: Prompt
status:
date: 2026-01-07
tags:
  - AI
---

# PROJECT.md

## Project

Personal website (full-stack Rails) for Lorraine Lai. Phase 1 focuses on publishing content and syncing published posts from Substack.

Specific frontend/UI guidance lives in WEBUI.md

## Tech Stack

- Ruby: latest stable (currently v4.0)
- Rails: latest stable (currently v8.1)
- Database: SQLite (single-server production)
- CSS: TailwindCSS (no Node toolchain)
- Testing
    - Backend: RSpec
    - Frontend: Playwright (use Playwright MCP)
- JS: Rails defaults only (no bundlers unless explicitly required)
- Background jobs: separate "jobs" container
- Deployment: Docker + Kamal
- Object storage: S3-compatible (self-hosted in homelab) for uploads/media

## Phase 1

### Scope

- Public pages (home/musings/gallery)
- Scheduled ingestion of *published* Substack posts (Substack is source of truth)
- Admin authentication via Google using Rails defaults

### Pages

- home - contains the "About Me" information, social media links, and navigation to other pages in the site
- musings - displays the published posts from Substack for Lorraine Lai. This will be pulled from the subject's account on Substack.com
- gallery - a gallery of photographs the subject has taken. This includes real life photos as well as pictures of her original artwork

## Local Development

- Setup:
  - bundle install
  - bin/rails db:setup
- Run web:
  - bin/rails server
- Run jobs (dev):
  - bin/rails solid_queue:start (or project-selected command)
- Tests:
  - bin/rails test (or project-selected test runner)
- Lint:
  - bundle exec rubocop

## Substack Ingestion

- use <https://substackapi.dev>
- Source of truth: Substack (published posts only).
- Ingestion must be idempotent.
- Schedule runs in the separate jobs container.
- Ingestion logic should live in a dedicated service/module and be covered by tests.
- Prefer not to add external dependencies unless clearly justified.

## Data and Storage

- SQLite DB must live on local persistent storage (Docker volume). Do not place the DB file on NFS.
- Uploaded media should use S3-compatible object storage (not local disk/NFS).
- Backups:
  - DB: snapshot on an hourly-to-daily cadence (target RPO: hours).
  - Object storage: back up per provider/implementation (target RPO: hours-to-daily).

## Guardrails / Do Not Touch

- Avoid adding new gems unless clearly justified.
- Migrations are append-only once merged.
