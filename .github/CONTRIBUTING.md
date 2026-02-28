# Contributing

Contributions are welcome. This project is an open-source Claude Code plugin for Angular developers.

## What can you contribute?

- New commands (e.g., `/ng:schematics`, `/ng:i18n`)
- New skills (e.g., `angular-accessibility`, `angular-seo`)
- Improvements to existing skills and commands
- Updates when Angular releases new versions
- Bug reports and corrections to patterns

## Getting started

```bash
git clone https://github.com/mayeedwin/angular-plugin
cd angular-plugin
```

Test your changes locally:
```bash
claude --plugin-dir .
```

## Adding a command

1. Create `commands/{name}.md`
2. Add a `description` frontmatter field (keep it short — one line)
3. Write clear instructions for Claude to follow
4. Document the `$ARGUMENTS` format with examples
5. Update `README.md` usage section

## Adding a skill

1. Create `skills/{name}/SKILL.md`
2. Add `name` and `description` frontmatter (description should say when Claude auto-invokes it)
3. Write concise, precise instructions — Claude reads these at runtime
4. Reference `https://angular.dev/llms.txt` for any Angular-specific guidance
5. Update `README.md` skills section

## Adding an agent

1. Create `agents/{name}.md`
2. Add `name` and `description` frontmatter
3. Write the agent's system prompt — its role, expertise, and how it responds
4. Update `README.md`

## Angular version updates

When Angular releases a new version:
1. Update patterns in `docs/STRUCTURE.md` if conventions changed
2. Add version-specific notes to `skills/angular-migration/SKILL.md`
3. Update the roadmap in `README.md`
4. Bump version in `.claude-plugin/plugin.json` and add entry to `CHANGELOG.md`

## Pull request guidelines

- One feature or fix per PR
- Keep skill/command content concise — Claude reads every word at runtime, verbosity has a cost
- Test locally with `claude --plugin-dir .` before submitting
- Update `CHANGELOG.md` under `[Unreleased]`

## Reporting issues

Open an issue at [github.com/mayeedwin/angular-plugin/issues](https://github.com/mayeedwin/angular-plugin/issues) with:
- Plugin version (from `.claude-plugin/plugin.json`)
- Angular version of the project you're working on
- The command/skill that produced the unexpected result
- What you expected vs what happened
