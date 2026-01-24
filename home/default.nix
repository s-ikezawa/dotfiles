{ pkgs, username, ... }: {
  home.stateVersion = "24.05";
  home.username = username;
  home.homeDirectory = "/Users/${username}";

  home.packages = with pkgs; [
    ghostty-bin
    plemoljp-nf
  ];

  xdg.configFile = {
    "ghostty" = {
      source = ./config/ghostty;
      recursive = true;
    };
  };
}
