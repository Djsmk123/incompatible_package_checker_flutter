enum Platforms {
  android,
  ios,
  windows,
  linux,
  macos,
  web,
}

List<String> platformCheck(
    List<String> arguments, List<Platforms> defaultPlatforms) {
  if (arguments.isNotEmpty) {
    var platform = arguments[0].split(',');
    for (String p in platform) {
      var lst = defaultPlatforms
          .map((element) => element.name.toLowerCase() == p.toLowerCase())
          .toList();
      if (lst.isEmpty) {
        print('Error: Invalid platform argument: $p');
        return [];
      }
    }
    return platform;
  }
  return defaultPlatforms.map((e) => e.toString()).toList();
}
