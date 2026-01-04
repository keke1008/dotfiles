{
  lib,
  ...
}:
{
  options.keke = {
    trustedUserNames = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of trusted user names.";
    };
  };
}
