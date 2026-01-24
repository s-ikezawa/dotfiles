{ pkgs, username, ... }: {
  home.stateVersion = "24.05";
  home.username = username;
  home.homeDirectory = "/Users/${username}";
}
