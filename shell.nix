with import <nixpkgs> { };
stdenv.mkDerivation {
  name = "env";
  nativeBuildInputs = [ ];
  buildInputs = [
    python311Packages.python-dotenv
    python311Packages.requests
    python311Packages.pynvim
    python311Packages.prompt-toolkit
    python311Packages.tiktoken
  ];
}
