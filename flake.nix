{
  description = "Flake templates";

  outputs = { self }: {
    templates = {
      bevy = {
        path = ./bevy;
        description = "A project using the Bevy game engine";
      };
    };
  };
}
