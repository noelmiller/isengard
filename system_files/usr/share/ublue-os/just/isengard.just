# vim: set ft=make :

alias upgrade := update

# Update system, flatpaks, and containers all at once
update:
    #!/usr/bin/bash
    /usr/bin/topgrade --config /usr/share/ublue-os/topgrade.toml --keep

# Fix the default Steam config to improve download speeds
fix-steam-download-speed:
    mkdir -p $HOME/.local/share/Steam
    rm -f $HOME/.local/share/Steam/steam_dev.cfg
    bash -c 'printf "@nClientDownloadEnableHTTP2PlatformLinux 0\n@fDownloadRateImprovementToAddAnotherConnection 1.0\n" > $HOME/.local/share/Steam/steam_dev.cfg'