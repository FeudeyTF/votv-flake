# Voices of the Void flake

This flake provides Voices of the Void package and options for it

# Installation

Add flake as inputs to your `flake.nix`:

```nix
inputs = {

  votv = {
    url = "github:FeudeyTF/votv-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # Other inputs ...
}
```

# Integration

## I just want to play, give me that package already

Simply add the following to your `environment.systemPackages` or `home.packages`:

```nix
inputs.votv.packages."${pkgs.stdenv.hostPlatform.system}".default # votv
inputs.votv.packages."${pkgs.stdenv.hostPlatform.system}".votv
```

## Home Manager

You can add the provided votv module for Home Manager as follows:

```nix
imports = [
    inputs.zen-browser.homeModules.votv
];

programs.votv = {
  enable = true;

  # Your environment variables for votv wrapper
  extraVariables = {
    MY_VAR = "value";
  };
};
```

## Build your configuration:

```sh
$ sudo nixos-rebuild switch # or home-manager switch
```

## Start the game

> [!NOTE]
> On the first launch, the launcher will install all necessary dependencies in `.local/share/votv`, and then launch the game. It will take some time

```sh
votv
```

# Troubleshooting

## I have both integrated and discrete graphics, but only the integrated one works when I launch the game

Make sure the drivers for your discrete graphics card are installed and the system can detect it. If not - https://wiki.nixos.org/wiki/Graphics

Add these variables to `extraVariables` if you are using the module for Home Manager, or set them for the entire system, depending on the graphics you are using:

### DirectX 11/12

```nix
DXVK_FILTER_DEVICE_NAME = "Your GPU's name. For example, NVIDIA GeForce GTX 1050";
```

### Vulkan

```nix
VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/<name, check the Internet>.json";
```

# Contributing

Feel free to contribute!

# License

Project code is licensed by the license in the LICENSE file.

Voices of the Void is unfree software and is licensed by its authors. You must comply with the official VotV terms: https://votv.dev/legal 

This repository does not claim ownership of VotV binaries, trademarks, or brand assets.
