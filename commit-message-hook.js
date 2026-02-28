const fs = require('fs');

// Format: type(scope): description  [optional: #issue]
// Types:  feat | fix | docs | style | refactor | test | chore | perf | ci | build | hotfix
// Scope:  kebab-case context — e.g. skills, commands, agents, hooks, docs, plugin
// Example: feat(skills): add angular-signals skill
// Example: fix(commands): correct generate path resolution #12
const regexStr =
  '((feat|fix|docs|style|refactor|test|chore|perf|ci|build|hotfix)\\([a-z0-9-]+\\): .+)|(Merge.* branch .* into .*)';

const regex = new RegExp(regexStr);
const commitMsg = fs.readFileSync(process.argv[2], 'utf8').trim();

if (!regex.test(commitMsg)) {
  console.error(`
  ✗ Commit message does not follow the convention:

    type(scope): description

  Types:  feat | fix | docs | style | refactor | test | chore | perf | ci | build | hotfix
  Scope:  skills | commands | agents | hooks | docs | plugin | scripts | readme

  Examples:
    feat(skills): add angular-signals skill
    fix(commands): correct generate path resolution
    docs(readme): update installation instructions
    chore(plugin): bump version to 1.0.0

  Your message: "${commitMsg}"
`);
  process.exit(1);
}
