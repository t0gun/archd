#!/usr/bin/env bash
set -euo pipefail

# Create nftables ruleset
sudo tee /etc/nftables.conf >/dev/null <<'EOF'
#!/usr/sbin/nft -f

table inet filter {
  chain input {
    type filter hook input priority 0;
    policy drop;

    # Allow loopback
    iif "lo" accept

    # Accept established/related connections
    ct state established,related accept

    # Allow SSH
    tcp dport 22 accept

    # Allow LocalSend (UDP/TCP 53317)
    tcp dport 53317 accept
    udp dport 53317 accept

    # Allow Docker DNS from containers to host
    iifname "docker0" udp dport 53 accept
    iifname "docker0" tcp dport 53 accept
  }

  chain forward {
    type filter hook forward priority 0;
    policy drop;

    # Allow Docker forwarding
    iifname "docker0" accept
    oifname "docker0" accept
  }

  chain output {
    type filter hook output priority 0;
    policy accept;
  }
}
EOF

# Restart firewall to apply new config
sudo systemctl restart nftables
