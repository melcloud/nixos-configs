{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {
    time.timeZone = "Australia/Melbourne";
    i18n = {
      defaultLocale = "en_AU.UTF-8";
      extraLocaleSettings = ''
        LANGUAGE=en_AU:en_GB:en:C:zh_CN
      '';
      supportedLocale = builtins.map (l: l + "/UTF-8") (
        [
          "C.UTF-8"
          "en_AU.UTF-8"
          "en_GB.UTF-8"
          "zh_CN.UTF-8"
        ]
      );
    };
  };
}
