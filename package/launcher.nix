{ writeShellScript }:

writeShellScript "votv-launcher" ''
  set -euo pipefail

  : "''${XDG_DATA_HOME:=$HOME/.local/share}"
  prefix="''${VOTV_WINEPREFIX:-$XDG_DATA_HOME/votv/wine}"
  marker="$prefix/.votv-dxvk-installed"

  export WINEPREFIX="$prefix"
  export WINEARCH="win64"

  log() {
    printf '\033[1;36m(votv)\033[0m %s\n' "$*" >&2
  }

  setup() {
    log "Setting up Wine prefix at $prefix (network heavy step)"
    mkdir -p "$prefix"

    log "Installing Wine prefix"
    "$WINE" wineboot --init
    "$WINESERVER" -w

    log "Installing DXVK"
    winetricks -q dxvk vkd3d d3dcompiler_47
    "$WINESERVER" -w

    touch "$marker"
    log "Setup complete"
  }

  case "''${1:-}" in
    --setup)
      setup
      exit 0
      ;;
    --reset)
      if [ "$prefix" = "/" ] || [ "$prefix" = "$HOME" ]; then
        log "Refusing to remove unsafe prefix path: $prefix"
        exit 1
      fi
      log "Removing prefix $prefix"
      rm -rf -- "$prefix"
      exit 0
      ;;
  esac

  if [ ! -f "$marker" ]; then
    setup
  fi

  cd "$VOTV_DIR"
  exec "$WINE" "$VOTV_EXE"
''
