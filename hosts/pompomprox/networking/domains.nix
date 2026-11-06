{ lib, ... }:

{
  options = {
    domain = lib.mkOption {
      type = lib.types.str;
      default = "pompomsoft.de";
      description = "Main domain for the server";
    };
    matrixDomain = lib.mkOption {
      type = lib.types.str;
      default = "iwannafuckmy.computer";
      description = "Domain for Matrix services";
    };
  };

  config = {
  };
}
