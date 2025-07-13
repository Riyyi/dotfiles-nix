{ config, pkgs, lib, ... }:

let
  profile = "dotfiles";
in
{

# https://hugosum.com/blog/customizing-firefox-with-nix-and-home-manager

# "/Applications/Nix Apps/Firefox.app/Contents/MacOS/firefox" -P "8cnqiyr4.default"

# via firefox-addons directly
# https://github.com/rhoriguchi/nixos-setup/blob/master/flake.nix#L19
# https://github.com/rhoriguchi/nixos-setup/blob/master/modules/home-manager/firefox.nix#L13

# via nur
# https://github.com/search?q=repo%3Abooxter%2Fnix%20rycee&type=code
# https://github.com/booxter/nix/blob/master/flake.nix#L38

# via .xpi
# https://github.com/IanHollow/nix-conf/blob/main/configs/home/programs/firefox/extensions.nix

  options.firefox = {
    enable = lib.mkEnableOption "firefox";
  };

  config = lib.mkIf config.firefox.enable {

    programs.firefox = {
      enable = true;
      nativeMessagingHosts = with pkgs; [
        ff2mpv-go
      ];

      profiles.${profile} = {
        id = 0;
        name = profile;
        isDefault = true;

        userChrome = builtins.readFile ./dotfiles/.mozilla/firefox/userChrome.css;
        #userContent = builtins.readFile ./dotfiles/.mozilla/firefox/userContent.css; # FIXME: this is broken
        # For some reason it seems like userContent.css doesnt allow symlinking to outside the profile directory

        # https://gitlab.com/rycee/nur-expressions/-/blob/master/pkgs/firefox-addons/addons.json
        # https://discourse.nixos.org/t/using-nur-in-nixos-configuration-via-flakes/51221/7
        extensions.packages = with pkgs.firefox-addons; [
          clearurls
          decentraleyes
          fastforwardteam
          ff2mpv
          tree-style-tab
          ublock-origin
          vimium
          violentmonkey
        ];

        settings = {
          # Download directory
          "browser.download.dir" = "~/Downloads";

          # Display a blank new tab
          "browser.newtabpage.enabled" = false;
          "browser.newtab.url" = "about:blank";

          # Disable Ctrl+q browser close shortcut
          "browser.quitShortcut.disabled" = true;

          # Old style URL bar
          "browser.urlbar.openViewOnFocus" = false;
          "browser.urlbar.update1" = false;
          "browser.urlbar.update1.interventions" = false;
          "browser.urlbar.update1.searchTips" = false;

          # Disable extension recommendations
          "extensions.htmlaboutaddons.recommendations.enabled" = false;

          # No full screen warning
          "full-screen-api.warning.timeout" = 0;

          # Disable video autoplay
          "media.autoplay.blocking_policy" = 2;
          "media.autoplay.default" = 5;

          # Enable video acceleration
          "media.ffmpeg.vaapi-drm-display.enabled" = true;
          "media.ffmpeg.vaapi.enabled" = true;

          # Don't make it too easy for phishers
          "network.IDN_show_punycode" = true;

          # Do not save logins
          "signon.rememberSignons" = false;

          # Enable userChrome.css and userContent.css
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          # Disable ALT key menu toggle
          "ui.key.menuAccessKeyFocuses" = false;

          # Reduce motion
          "ui.prefersReducedMotion" = true;

          # Fix dark GTK themes
          "widget.content.gtk-theme-override" = "Arc";

          # Disable tracking
          "privacy.resistFingerprinting" = true;
          "privacy.resistFingerprinting.autoDeclineNoUserInputCanvasPrompts" = true;
          "geo.enabled" = false;
          "network.connectivity-service.enabled" = false;
          "browser.startup.homepage" = "about:blank";
          "browser.newtab.preload" = false;
          "browser.search.geoip.url" = "";
          "app.update.enabled" = false;
          "extensions.update.enabled" = false;
          "app.update.auto" = false;
          "extensions.update.autoUpdateDefault" = false;
          "app.update.service.enabled" = false;
          "app.update.staging.enabled" = false;
          "app.update.silent" = false;
          "extensions.getAddons.cache.enabled" = false;
          "lightweightThemes.update.enabled" = false;
          "browser.search.update" = false;
          "dom.ipc.plugins.flash.subprocess.crashreporter.enabled" = false;
          "dom.ipc.plugins.reportCrashURL" = false;
          "extensions.getAddons.showPane" = false;
          "extensions.webservice.discoverURL" = "";
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.server" = "data:,";
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.cachedClientID" = "";
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "breakpad.reportURL" = "";
          "browser.tabs.crashReporting.sendReport" = false;
          "browser.crashReports.unsubmittedCheck.enabled" = false;
          "browser.crashReports.unsubmittedCheck.autoSubmit" = false;
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
          "browser.aboutHomeSnippets.updateUrl" = "data:,";
          "browser.chrome.errorReporter.enabled" = false;
          "browser.chrome.errorReporter.submitUrl" = "";
          "extensions.blocklist.enabled" = false;
          "extensions.blocklist.url" = "";
          "services.blocklist.update_enabled" = false;
          "services.blocklist.onecrl.collection" = "";
          "services.blocklist.addons.collection" = "";
          "services.blocklist.plugins.collection" = "";
          "services.blocklist.gfx.collection" = "";
          "browser.safebrowsing.malware.enabled" = false;
          "browser.safebrowsing.phishing.enabled" = false;
          "browser.safebrowsing.downloads.enabled" = false;
          "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
          "browser.safebrowsing.downloads.remote.block_uncommon" = false;
          "browser.safebrowsing.downloads.remote.block_dangerous" = false;
          "browser.safebrowsing.downloads.remote.block_dangerous_host" = false;
          "browser.safebrowsing.provider.google.updateURL" = "";
          "browser.safebrowsing.provider.google.gethashURL" = "";
          "browser.safebrowsing.provider.google4.updateURL" = "";
          "browser.safebrowsing.provider.google4.gethashURL" = "";
          "browser.safebrowsing.downloads.remote.enabled" = false;
          "browser.safebrowsing.downloads.remote.url" = "";
          "browser.safebrowsing.provider.google.reportURL" = "";
          "browser.safebrowsing.reportPhishURL" = "";
          "browser.safebrowsing.provider.google4.reportURL" = "";
          "browser.safebrowsing.provider.google.reportMalwareMistakeURL" = "";
          "browser.safebrowsing.provider.google.reportPhishMistakeURL" = "";
          "browser.safebrowsing.provider.google4.reportMalwareMistakeURL" = "";
          "browser.safebrowsing.provider.google4.reportPhishMistakeURL" = "";
          "browser.safebrowsing.allowOverride" = false;
          "browser.safebrowsing.provider.google4.dataSharing.enabled" = false;
          "browser.safebrowsing.provider.google4.dataSharingURL" = "";
          "browser.safebrowsing.blockedURIs.enabled" = false;
          "browser.safebrowsing.provider.mozilla.gethashURL" = "";
          "browser.safebrowsing.provider.mozilla.updateURL" = "";
          "network.allow-experiments" = false;
          "app.normandy.enabled" = false;
          "app.normandy.api_url" = "";
          "app.shield.optoutstudies.enabled" = false;
          "shield.savant.enabled" = false;
          "extensions.systemAddon.update.enabled" = false;
          "extensions.systemAddon.update.url" = "";
          "browser.ping-centre.telemetry" = false;
          "extensions.pocket.enabled" = false;
          "browser.library.activity-stream.enabled" = false;
          "extensions.screenshots.disabled" = true;
          "extensions.screenshots.upload-disabled" = true;
          "browser.onboarding.enabled" = false;
          "extensions.formautofill.addresses.enabled" = false;
          "extensions.formautofill.available" = "off";
          "extensions.formautofill.creditCards.enabled" = false;
          "extensions.formautofill.heuristics.enabled" = false;
          "extensions.webcompat-reporter.enabled" = false;
          "network.prefetch-next" = false;
          "network.dns.disablePrefetch" = true;
          "network.dns.disablePrefetchFromHTTPS" = true;
          "network.predictor.enabled" = false;
          "captivedetect.canonicalURL" = "";
          "network.captive-portal-service.enabled" = false;
          "browser.send_pings" = false;
          "browser.send_pings.require_same_host" = true;
          "network.protocol-handler.external.ms-windows-store" = false;
          "network.predictor.enable-prefetch" = false;
          "network.trr.mode" = 0;
          "network.trr.bootstrapAddress" = "";
          "network.trr.uri" = "";
          "network.file.disable_unc_paths" = true;
          "browser.search.suggest.enabled" = false;
          "browser.urlbar.suggest.searches" = false;
          "browser.urlbar.userMadeSearchSuggestionsChoice" = true;
          "browser.urlbar.usepreloadedtopurls.enabled" = false;
          "browser.urlbar.speculativeConnect.enabled" = false;
          "security.ssl.errorReporting.automatic" = false;
          "security.ssl.errorReporting.enabled" = false;
          "security.ssl.errorReporting.url" = "";
          "dom.push.enabled" = false;
          "dom.push.connection.enabled" = false;
          "dom.push.serverURL" = "";
          "dom.push.userAgentID" = "";
          "beacon.enabled" = false;
          "browser.uitour.enabled" = false;
          "browser.uitour.url" = "";
          "permissions.manager.defaultsUrl" = "";
          "webchannel.allowObject.urlWhitelist" = "";
          "browser.startup.homepage_override.mstone" = "ignore";
          "startup.homepage_welcome_url" = "";
          "startup.homepage_welcome_url.additional" = "";
          "startup.homepage_override_url" = "";
          "media.gmp-gmpopenh264.autoupdate" = false;
          "browser.shell.shortcutFavicons" = false;
          "media.gmp-eme-adobe.autoupdate" = false;
          "media.gmp-manager.url" = "data:text/plain,";
          "media.gmp-manager.url.override" = "data:text/plain,";
          "media.gmp-manager.updateEnabled" = false;
          "media.gmp-widevinecdm.autoupdate" = false;
          "devtools.webide.autoinstallADBHelper" = false;
        };
      };
    };

  };

}
