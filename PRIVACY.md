# Privacy Policy

**Last updated: 2026-02-28**

## Overview

The `ng` Angular Plugin for Claude Code is an open-source plugin distributed via GitHub. It runs entirely on your local machine as a set of markdown instruction files read by Claude Code. It has no server, no backend, and no network requests of its own.

## What this plugin does

When installed, this plugin provides Claude Code with:
- Slash commands (`/ng:generate`, `/ng:review`, etc.)
- Skill instructions that guide how Claude generates Angular code
- Agent definitions for architecture and review tasks
- A post-write hook that runs ESLint/Prettier locally on your files

## Data collection

**This plugin does not collect, store, or transmit any data.**

- No analytics or telemetry
- No usage tracking
- No personal information collected
- No network requests made by the plugin itself
- No third-party services integrated

## Your code and Claude

When you use this plugin, your code and prompts are processed by **Anthropic's Claude AI** through Claude Code. The plugin's skill and command files are loaded as instructions into your Claude Code session.

How Anthropic handles your data is governed by:
- [Anthropic's Privacy Policy](https://www.anthropic.com/privacy)
- [Anthropic's Usage Policy](https://www.anthropic.com/legal/usage-policy)

## Local file access

The post-write lint hook (`scripts/lint-angular.sh`) reads file paths from Claude Code's hook events and runs ESLint/Prettier on files you write. It does not read, copy, or transmit file contents — it only passes the file path to your locally installed linting tools.

## GitHub

This plugin's source code is hosted on GitHub. Visiting or interacting with the repository is subject to [GitHub's Privacy Statement](https://docs.github.com/en/site-policy/privacy-policies/github-general-privacy-statement).

## Changes

If this policy changes materially, the `Last updated` date above will be updated and a note added to [CHANGELOG.md](./CHANGELOG.md).

## Contact

Open an issue at [github.com/mayeedwin/angular-plugin/issues](https://github.com/mayeedwin/angular-plugin/issues).
