enum MusicPlayerMethodChannelMethods {
  prepareForReproduceInBackground("prepareForReproduceInBackground"),
  prepareForReproduceInForeground("prepareForReproduceInForeground"),
  play("play"),
  pause("pause");

  const MusicPlayerMethodChannelMethods(this.value);
  final String value;
}