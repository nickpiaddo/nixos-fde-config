alias ct := check-typos

# List recipes
default:
  just --list

# Spell check source code
check-typos:
  @typos --exclude '*.svg' --exclude 'tests/' --exclude 'web-snapshots/'

# Push commits to online repo
do-push: check-typos
  @git push origin main
