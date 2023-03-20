alias ct := check-typos
alias sv  := start-test-vm
alias xv  := stop-test-vm
alias clt := clean-test-vm

# List recipes
default:
  just --list

# Spell check source code
check-typos:
  @typos --exclude '*.svg' --exclude 'tests/test_helper' --exclude 'web-snapshots/'

# Push commits to online repo
do-push: check-typos
  @git push origin main

# Start the test virtual machine
start-test-vm:
  ./utils/start-test-vm

# Stop the test virtual machine
stop-test-vm:
  ./utils/stop-test-vm

# Delete test VM
clean-test-vm:
  #!/usr/bin/env -S uv run --script
  # /// script
  # requires-python = ">=3.13"
  # dependencies = [
  #     "click",
  # ]
  # ///
  import click
  import subprocess

  if click.confirm("Would you like to delete the test VM?"):
    subprocess.run(["rm", "-r", "-f", "area51/test-vm"])
  else:
    print("Aborted!")
