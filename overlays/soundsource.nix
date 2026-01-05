final: prev: {
  soundsource = prev.soundsource.overrideAttrs {

    # last version of the 5.x branch, which has easier activation
    version = "5.8.11";
    src = prev.fetchurl {
      url = "https://web.archive.org/web/20251207152157/https://rogueamoeba.com/legacy/downloads/SoundSource-5811.zip";
      hash = "sha256-p7ICta9FR2zQD3JpVZqpPIqolIVES+f9LUIEtor4IAo=";
    };
  };
}
