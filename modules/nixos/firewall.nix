{
  config,
  lib,
  ...
}:

let
  cfg = config.features.firewall;

  # https://www.cloudflare.com/ips
  cloudflareIPv4 = [
    "173.245.48.0/20"
    "103.21.244.0/22"
    "103.22.200.0/22"
    "103.31.4.0/22"
    "141.101.64.0/18"
    "108.162.192.0/18"
    "190.93.240.0/20"
    "188.114.96.0/20"
    "197.234.240.0/22"
    "198.41.128.0/17"
    "162.158.0.0/15"
    "104.16.0.0/13"
    "104.24.0.0/14"
    "172.64.0.0/13"
    "131.0.72.0/22"
  ];

  cloudflareIPv6 = [
    "2400:cb00::/32"
    "2606:4700::/32"
    "2803:f800::/32"
    "2405:b500::/32"
    "2405:8100::/32"
    "2a06:98c0::/29"
    "2c0f:f248::/32"
  ];

  cloudflareIPv4Str = lib.concatStringsSep ", " (map toString cloudflareIPv4);
  cloudflareIPv6Str = lib.concatStringsSep ", " (map toString cloudflareIPv6);

  allowedTCPPortsStr = lib.concatStringsSep ", " (map toString cfg.allowedTCPPorts);
  allowedUDPPortsStr = lib.concatStringsSep ", " (map toString cfg.allowedUDPPorts);
in
{

  options.features.firewall = {
    allowedTCPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      default = [ ];
      description = "TCP ports to allow from LAN/Cloudflare.";
    };

    allowedUDPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      default = [ ];
      description = "UDP ports to allow from LAN/Cloudflare.";
    };

    safeTCPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      default = [ ];
      description = "TCP ports to allow from all IPs.";
    };

    safeUDPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      default = [ ];
      description = "UDP ports to allow from all IPs.";
    };
  };

  config = lib.mkIf cfg.enable {

    networking.nftables.enable = true;
    networking.firewall = {
      enable = true;

      allowedTCPPorts = cfg.safeTCPPorts;
      allowedUDPPorts = cfg.safeUDPPorts;

      extraInputRules = ''
        # Allow LAN
        ip saddr 192.168.0.0/16 tcp dport { ${allowedTCPPortsStr} } accept
        ip saddr 192.168.0.0/16 udp dport { ${allowedUDPPortsStr} } accept

        # Cloudflare IPv4
        ip saddr { ${cloudflareIPv4Str} } tcp dport { ${allowedTCPPortsStr} } accept
        ip saddr { ${cloudflareIPv4Str} } udp dport { ${allowedUDPPortsStr} } accept

        # Cloudflare IPv6
        ip6 saddr { ${cloudflareIPv6Str} } tcp dport { ${allowedTCPPortsStr} } accept
        ip6 saddr { ${cloudflareIPv6Str} } udp dport { ${allowedUDPPortsStr} } accept
      '';
    };

  };

}
