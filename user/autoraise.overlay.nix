final: prev: {
  autoraise = prev.autoraise.overrideAttrs {

    # version = "5.4";

    src = prev.fetchFromGitHub {
      owner = "sbmpost";
      repo = "AutoRaise";
      # rev = "v5.5";
      # hash = "sha256-Fnlca2+XsRaCz3lQ5deQkwBqpt40wp+CfWxtRJAOGvE=";
      rev = "v5.4";
      hash = "sha256-5qL+GxlMLMA+1CFxMTTZnpicX8FPOOJV2VTjlYgwqJg=";
      # rev = "AutoRaise-5.6";
      # hash = "sha256-bUE8wKX8L7Rl4FFjE2oGFbjSZnhLi0Vmaz2PC4qDFDA=";
    };

    buildPhase = ''
      runHook preBuild
      $CXX -O2 -fobjc-arc -D"NS_FORMAT_ARGUMENT(A)=" -D"SKYLIGHT_AVAILABLE=1" -D"EXPERIMENTAL_FOCUS_FIRST=1" -o AutoRaise AutoRaise.mm -framework AppKit -framework SkyLight
      bash create-app-bundle.sh
      runHook postBuild
    '';
  };
}
