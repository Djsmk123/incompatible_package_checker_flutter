import 'dart:io';

import 'package:incompatible_package_checker/package_checker.dart';
import 'package:incompatible_package_checker/platforms.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

Future<void> run(List<String> arguments) async {
  // Check for valid platforms in arguments or use default platforms
  List<String> platforms = platformCheck(arguments, Platforms.values);
  if (platforms.isEmpty) {
    exit(0);
  }
  // Read and parse the pubspec.yaml file
  final pubspec = _getPubspec();
  // Get the dependencies section from the parsed pubspec
  final dependencies = pubspec.dependencies;
  // Check for incompatible packages
  final incompatiblePackages =
      await checkIncompatiblePackages(dependencies, platforms);
  // Print statistics for each platform
  for (var platform in platforms) {
    printStats(
        incompatiblePackages[platform]!, platform, dependencies.keys.length);
  }
}

Pubspec _getPubspec() {
  final pubspecFile = File('pubspec.yaml');
  final pubspecYaml = pubspecFile.readAsStringSync();
  return Pubspec.parse(pubspecYaml);
}
