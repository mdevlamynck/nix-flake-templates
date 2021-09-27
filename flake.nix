{
  description = "Flake templates";

  outputs = { self }: {
    templates = {
      bevy = {
        path = ./bevy;
        description = "A project using the Bevy game engine";
      };
      gtk = {
        path = ./gtk;
        description = "A gtk project using rust";
      };
      rust = {
        path = ./rust;
        description = "A rust project";
      };
    };
  };
}
