# IDA Free (Classroom Edition), built via https://github.com/msanft/ida-pro-overlay
#
# The overlay hardcodes the paid IDA Pro installer as the package's `src`, so we
# override it to point at the free classroom installer instead. Download the
# installer from https://hex-rays.com/ida-free and add it to the store first:
#
#   nix-store --add-fixed sha256 ida-classroom-free_94_x64linux.run
#
# To bump versions, drop in the new runfile and update `version`/`sha256` below
# (`nix hash file --type sha256 --base16 <runfile>`).
{ config, lib, pkgs-unstable, ida-pro-overlay, ... }:

let
  # Mirrors the overlay's own `pythonForIDA`, so this resolves to the very same
  # store path the package already puts on its RPATH. postInstall asserts the
  # two still agree, so an overlay-side Python bump fails the build rather than
  # silently pointing IDAPython at the wrong interpreter.
  pythonForIDA = pkgs-unstable.python313.withPackages (ps: with ps; [ rpyc ]);
  libpython = "${pythonForIDA}/lib/libpython3.13.so";

  # Two pieces of IDA's setup live in the user's $IDAUSR (~/.idapro) and so
  # cannot be supplied from the store, and both record an absolute path that a
  # rebuild invalidates:
  #
  #   * ida.reg's `Python3TargetDLL` tells IDAPython which libpython to dlopen.
  #     There is no env-var override, and `idapyswitch`'s autodetection scans the
  #     ldconfig cache, which NixOS does not populate -- hence --force-path.
  #   * ida-config.json's `ida-install-dir` tells the idalib `idapro` module
  #     where IDA lives. Refreshed with the vendor's own activation script so any
  #     other keys in the file are preserved.
  #
  # The launcher reconciles both whenever the stamp does not match the running
  # build. Placeholders are substituted in postInstall, where $out is known.
  idaLauncher = pkgs-unstable.writeText "ida-launcher.sh" ''
    #!/bin/sh
    idausr="$IDAUSR"
    [ -n "$idausr" ] || idausr="$HOME/.idapro"
    stamp="$idausr/.nix-ida-configured"

    if [ "$(cat "$stamp" 2>/dev/null)" != "@idadir@" ]; then
      mkdir -p "$idausr"
      configured=yes

      if ! @idapyswitch@ --force-path "@libpython@" >/dev/null 2>&1; then
        configured=no
        echo "ida: idapyswitch failed; IDAPython will be unavailable" >&2
      fi

      if ! @python@ @activateIdalib@ -d "@idadir@" >/dev/null 2>&1; then
        configured=no
        echo "ida: idalib activation failed; 'import idapro' will need IDADIR set" >&2
      fi

      [ "$configured" = yes ] && printf '%s' "@idadir@" > "$stamp"
    fi

    exec @ida@ "$@"
  '';

  # Stateless entry point for headless idalib work: IDADIR takes precedence over
  # ida-config.json in idapro/config.py, so this works without the launcher ever
  # having run and never goes stale.
  idaPython = package: pkgs-unstable.writeShellScriptBin "ida-python" ''
    export IDADIR=${package}/opt
    export PYTHONPATH=${package}/opt/idalib/python''${PYTHONPATH:+:$PYTHONPATH}
    exec ${pythonForIDA}/bin/python3 "$@"
  '';
in

with lib; {
  options = with types; {
    myIda = {
      enable = mkOption {
        type = bool;
        default = true;
        description = "Install IDA Free (Classroom Edition).";
      };
      package = mkOption {
        type = package;
        readOnly = true;
        description = "The IDA package built from the local installer runfile.";
      };
      pythonPackage = mkOption {
        type = package;
        readOnly = true;
        description = "`ida-python`, a Python interpreter set up for headless idalib use.";
      };
    };
  };

  config = mkMerge [
    ({
      myIda.package = pkgs-unstable.ida-pro.overrideAttrs (old: {
        pname = "ida-free-classroom";
        version = "9.4";

        src = pkgs-unstable.requireFile {
          name = "ida-classroom-free_94_x64linux.run";
          url = "https://hex-rays.com/ida-free";
          sha256 = "1c9be1ba470a576b6e58b6d8c19532264595fe5a6169235b18c9d1702c49a454";
        };

        # The overlay's desktop entry is labelled for IDA Pro.
        desktopItems = [
          (pkgs-unstable.makeDesktopItem {
            name = "ida-free-classroom";
            exec = "ida";
            icon = "${ida-pro-overlay}/share/appico.png";
            desktopName = "IDA Free (Classroom)";
            genericName = "Interactive Disassembler";
            comment = old.meta.description;
            categories = [ "Development" ];
            startupWMClass = "IDA";
          })
        ];

        postInstall = (old.postInstall or "") + ''
          # The overlay adds libpython as a NEEDED entry on libida.so; if that
          # ever stops matching our `pythonForIDA`, the launcher below would
          # configure IDAPython against a different interpreter than the one
          # actually loaded. Fail the build instead.
          if ! patchelf --print-needed $out/lib/libida.so | grep -qx libpython3.13.so; then
            echo "libida.so no longer needs libpython3.13.so -- update pythonForIDA in ida.nix" >&2
            exit 1
          fi

          # The overlay's wrapper sets PYTHONPATH to $out/bin/idalib/python,
          # which does not exist -- idalib ships under $out/opt. The wrapper is a
          # compiled binary, so the only way to correct the value is to drop it
          # and re-wrap the untouched .ida-wrapped the overlay left behind.
          if [ ! -d $out/opt/idalib/python ] \
            || [ ! -e $out/opt/.ida-wrapped ] \
            || [ ! -e $out/opt/idalib/python/py-activate-idalib.py ]; then
            echo "unexpected overlay layout -- re-check the re-wrap in ida.nix" >&2
            exit 1
          fi

          rm $out/opt/ida
          makeWrapper $out/opt/.ida-wrapped $out/opt/ida \
            --inherit-argv0 \
            --prefix IDADIR : $out/opt \
            --prefix QT_PLUGIN_PATH : $out/opt/plugins/platforms \
            --prefix PYTHONPATH : $out/opt/idalib/python \
            --prefix PATH : ${pythonForIDA}/bin:$out/opt \
            --prefix LD_LIBRARY_PATH : $out/opt

          ln -s $out/opt/idapyswitch $out/bin/idapyswitch

          # Replace the plain symlink to the wrapped binary with the launcher.
          rm $out/bin/ida
          substitute ${idaLauncher} $out/bin/ida \
            --subst-var-by libpython ${libpython} \
            --subst-var-by idapyswitch $out/opt/idapyswitch \
            --subst-var-by python ${pythonForIDA}/bin/python3 \
            --subst-var-by activateIdalib $out/opt/idalib/python/py-activate-idalib.py \
            --subst-var-by idadir $out/opt \
            --subst-var-by ida $out/opt/ida
          chmod +x $out/bin/ida
        '';
      });
    })
    ({
      myIda.pythonPackage = idaPython config.myIda.package;
    })
    (mkIf config.myIda.enable {
      myPackages = [ config.myIda.package config.myIda.pythonPackage ];
    })
  ];
}
