# Update Isengard CLI
update-cli:
    #!/bin/bash
    echo "Updating Isengard CLI"
    systemctl --user start isengard-cli-update.service

# Check Just Syntax
check-just:
    #!/bin/bash
    just --unstable --fmt --check -f
