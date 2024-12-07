{
  description = "Flake templates";

  outputs =
    { self }:
    {
      templates = {
        default = self.templates.empty;
        empty = {
          path = ./empty;
          description = "An empty project";
        };
        rust = {
          path = ./rust;
          description = "A rust project";
        };
        zig = {
          path = ./zig;
          description = "A zig project";
        };
      };
    };
}
