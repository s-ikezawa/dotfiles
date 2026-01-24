{ pkgs, username, ... }: {
  system.stateVersion = 5;
  system.primaryUser = username;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
    };
    casks = [
      "1password"
      "1password-cli"
    ];
  };
}
