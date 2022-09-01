{
  description = "Flake templates";

  outputs = { self }: {
    templates = {
      default = self.templates.empty;
      bevy = {
        path = ./bevy;
        description = "A project using the Bevy game engine";
      };
      empty = {
        path = ./empty;
        description = "An empty project";
      };
      gtk = {
        path = ./gtk;
        description = "A gtk project using rust";
      };
      qml = {
        path = ./qml;
        description = "A qml project using rust";
      };
      rust = {
        path = ./rust;
        description = "A rust project";
      };
    };
  };
}
