# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
 imports =
   [ # Include the results of the hardware scan.
     ./hardware-configuration.nix
   <home-manager/nixos>
   ];
   nixpkgs.config.allowUnfree = true;
 # Use the systemd-boot EFI boot loader.
 boot.loader.systemd-boot.enable = true;
 boot.loader.efi.canTouchEfiVariables = true;
 boot.initrd.kernelModules = [ "amdgpu" ];
boot.initrd.systemd.enable = true; 
 boot.kernelParams = ["quiet"];
 boot.plymouth.enable = true;
   boot.plymouth.theme="breeze";

 services.fstrim.enable = true;
 networking.hostName = "nixos"; # Define your hostname.
 # Pick only one of the below networking options.
 # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
zramSwap = {
   enable = true;
   algorithm = "zstd";
 };

 # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

 # Configure network proxy if necessary
 # networking.proxy.default = "http://user:password@proxy:port/";
 # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

 # Select internationalisation properties.
  i18n.defaultLocale = "nl_NL.UTF-8";
  #console = {
   # font = "Lat2-Terminus16";
   #keyMap = "us";
   # useXkbConfig = true; # use xkbOptions in tty.
  #};
#Teams fix
nixpkgs.config.permittedInsecurePackages = [
     "electron-24.8.6"
];
              
 # Enable the X11 windowing system.
 services.xserver.enable = true;
hardware.opengl.driSupport = true;
# For 32 bit applications
hardware.opengl.extraPackages = with pkgs; [
 rocm-opencl-icd
 rocm-opencl-runtime
];
hardware.opengl.driSupport32Bit = true;
 # Enable the Desktop Environment.
 services.xserver.displayManager.sddm.enable = true;
 services.xserver.desktopManager.plasma5.enable = true;
 #services.xserver.windowManager.dk.enable =true;
 services.dbus.packages = with pkgs; [ gnome2.GConf ];
 services.xserver.desktopManager.kodi.enable = true;
 #services.xserver.windowManager.dk.enable =true;

 # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e,caps:escape";
#Fix Qt apps
  environment.variables = {
    "QT_STYLE_OVERRIDE" = pkgs.lib.mkForce "adwaita-dark";
  };
 # Enable CUPS to print documents.
 # services.printing.enable = true;

 # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
 enable = true;
 alsa.enable = true;
 alsa.support32Bit = true;
 pulse.enable = true;
};

 hardware.bluetooth.enable = true;


 # Enable touchpad support (enabled default in most desktopManager).
 # services.xserver.libinput.enable = true;

 # Define a user account. Don't forget to set a password with .
  users.users.simon = {
    isNormalUser = true;
     description  = "Simon de Waal";
    extraGroups = [ "wheel" "libvirtd" ]; # Enable  for the user.
    packages = with pkgs; [
    ];
  };
 # List packages installed in system profile. To search, run:
 # $ nix search wget
  environment.systemPackages = with pkgs; [
    libsForQt5.kcodecs
    libsForQt5.phonon-backend-vlc
adwaita-qt
adwaita-qt
#Kodi 

(pkgs.kodi.passthru.withPackages (kodiPkgs: with kodiPkgs; [
 netflix
 vfs-sftp
 inputstreamhelper
 inputstream-adaptive
 youtube
	]))
 #diverse pakketen
 python3
  xdg-user-dirs
 filezilla
teams-for-linux
  vim_configurable # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
   wget
   handbrake
git  
dvdbackup
fuse
   vlc 
lutris
fuse3
spotify
kdenlive
 onlyoffice-bin
 krita
neofetch
  gnome.gnome-software
gnome.gnome-system-monitor
 gnome.zenity
  sxhkd
  xorg.xhost 
  virt-manager
 glxinfo
#guake
libsForQt5.yakuake

google-chrome
 variety
 pkgs.nil
  distrobox
dosfstools
appimage-run 
python311Full
python311Packages.pip
kitty
 wl-clipboard
 mako
 dunst
 swww
 wofi
openmsx
 microsoft-edge-dev
gettext
networkmanagerapplet
vmware-workstation
nodejs
rofi
github-desktop
#Gnome extentions
amf-headers
libheif
];

#fonts
fonts.packages = with pkgs; [
 noto-fonts
 noto-fonts-cjk
 noto-fonts-emoji
 liberation_ttf
 fira-code
 fira-code-symbols
 mplus-outline-fonts.githubRelease
 dina-font
 proggyfonts
 corefonts
 nerdfonts
 vistafonts
];
#Virtualisatie en containers
programs.dconf.enable = true;
virtualisation.libvirtd.enable = true;
virtualisation.podman.enable = true;
services.flatpak.enable = true;

virtualisation.vmware.host.enable=true;


#Steam
programs.steam.enable =true;
#Hyprland
  programs.hyprland.enable = true;

#Bashrc
programs.bash.interactiveShellInit ="neofetch" ;

#autoupdater
system.autoUpgrade.enable = true;
system.autoUpgrade.allowReboot = false;
#Auto garbagecollector
 nix.gc = {
       automatic = true;
     dates = "daily";
     options = "--delete-older-than 2d";
   };
#auto optimise Nix store
nix.settings.auto-optimise-store = true;

#aliassen

environment.shellAliases ={
 #ls = "ls -la";
 sysupgr = "sudo nixos-rebuild boot --upgrade";
 sysswitch = "sudo nixos-rebuild switch --upgrade";  
 sysconfig = "sudo vim /etc/nixos/configuration.nix";
 sysclean  = "sudo nix-collect-garbage -d";
 listgen = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";

};

#Vim config 
environment.etc."vimrc".text = ''
   syntax on
   set number
   colorscheme elflord
 '';

# started in user sessions.
 # programs.mtr.enable = true;
 # programs.gnupg.agent = {
 #   enable = true;
 #   enableSSHSupport = true;
 # };

 # List services that you want to enable:

 # Enable the OpenSSH daemon.
 # services.openssh.enable = true;

 # Open ports in the firewall.
 # networking.firewall.allowedTCPPorts = [ ... ];
 # networking.firewall.allowedUDPPorts = [ ... ];
 # Or disable the firewall altogether.
 # networking.firewall.enable = false;

 # Copy the NixOS configuration file and link it from the resulting system
 # (/run/current-system/configuration.nix). This is useful in case you
 # accidentally delete configuration.nix.
 # system.copySystemConfiguration = true;

 # This value determines the NixOS release from which the default
 # settings for stateful data, like file locations and database versions
 # on your system were taken. It's perfectly fine and recommended to leave
 # this value at the release version of the first install of this system.
 # Before changing this value read the documentation for this option
 # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
 system.stateVersion = "23.11"; # Did you read the comment?
#----------------------------------------------------------
#Home manager

home-manager.users.simon = { pkgs, ... }: {
 home.stateVersion = "23.11";
nixpkgs.config.allowUnfree = true;
 home.packages = [ 
 pkgs.helix
 pkgs.tree
pkgs.nodePackages_latest.neovim
 pkgs.tree-sitter


   ];
  
programs.vscode = {
  enable = true;
  extensions = with pkgs.vscode-extensions; [
    dracula-theme.theme-dracula
    vscodevim.vim
jnoortheen.nix-ide
bbenoist.nix
    yzhang.markdown-all-in-one
  ];
};
};
programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = ''
        set undofile
        set undodir=~/.vim/undodir
      '';
      packages.nix.start = with pkgs.vimPlugins; [  nvim-treesitter.withAllGrammars ];
    };

  };


 

}
