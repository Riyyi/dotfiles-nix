{

  flake.modules.nixos."nixosConfigurations/nixos-nas" =
    { inputs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        sops
      ];
    };

}
