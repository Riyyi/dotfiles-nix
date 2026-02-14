{
  inputs,
  rootPath,
  ...
}:

{

  flake.modules.generic.sops =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [ pkgs.ssh-to-age ];

      # Configure sops
      sops.defaultSopsFile = "${rootPath}/sops/secrets/secrets.yaml";
      sops.defaultSopsFormat = "yaml";
      sops.age.generateKey = false;
      sops.age.sshKeyPaths = [ "${config.dot.home}/.ssh/id_ed25519" ];
      sops.gnupg.sshKeyPaths = [ ]; # do not import

      programs.zsh = lib.mkIf config.programs.zsh.enable {
        interactiveShellInit = lib.mkAfter ''
          export SOPS_AGE_KEY_CMD="ssh-to-age -private-key -i "${config.dot.home}/.ssh/id_ed25519""
        '';
      };
    };

  flake.modules.nixos.sops = {
    imports = [
      inputs.sops-nix.nixosModules.sops
      inputs.self.modules.generic.sops
    ];
  };

  flake.modules.darwin.sops = {
    imports = [
      inputs.sops-nix.darwinModules.sops
      inputs.self.modules.generic.sops
    ];
  };

}
