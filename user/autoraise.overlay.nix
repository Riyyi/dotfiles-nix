final: prev: {
  autoraise = prev.autoraise.overrideAttrs {
    buildPhase = ''
      runHook preBuild
      $CXX -std=c++03 -fobjc-arc -D"NS_FORMAT_ARGUMENT(A)=" -D"SKYLIGHT_AVAILABLE=1" -D"EXPERIMENTAL_FOCUS_FIRST=1" -o AutoRaise AutoRaise.mm -framework AppKit -framework SkyLight
      bash create-app-bundle.sh
      runHook postBuild
    '';
  };
}
