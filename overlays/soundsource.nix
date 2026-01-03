final: prev: {
  soundsource = prev.soundsource.overrideAttrs {

    # web.archive seems to have removed some .zips, so get this one for now
    version = "5.8.11";
    src = prev.fetchurl {
      url = "https://rogueamoeba.com/legacy/downloads/SoundSource-5811.zip";
      hash = "sha256-p7ICta9FR2zQD3JpVZqpPIqolIVES+f9LUIEtor4IAo=";
    };
  };
}
