{
  description = "Flake templates";

  outputs = { self }: {
    templates = {
      bevy = {
        path = ./bevy;
        description = "A project using the Bevy game engine";
      };
      rust = {
        path = ./rust;
        description = "A rust project";
      };
    };
  };
}
