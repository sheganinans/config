  let
    pkgs = import <nixpkgs> {};
    repo = import /home/a2/Projects/nixpkgs {};
    rhng = repo.haskell-ng;
    ghc710c = rhng.compiler.ghc7101;
    ghc710p = rhng.packages.ghc7101;
    hsEnv = repo.haskellngPackages.ghcWithPackages (hs: with hs; ([
      hlint
      hdevtools
      hasktags
      cabal-install
      ghc710c
      ]
    ));
  in
    pkgs.myEnvFun {
      name = "proj";
      buildInputs = with repo; with haskellngPackages; [
        binutils
        coreutils
        zlib
        pkgconfig
        hsEnv
        ];
      extraCmds = with repo; ''
      '';
      }
