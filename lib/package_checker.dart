import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:pubspec_parse/pubspec_parse.dart';

/// A utility function to check for incompatible packages based on their platform support.
/// It takes a map of dependencies and a list of platforms to check against.
/// Returns a map with platform names as keys and lists of incompatible packages as values.
Future<Map<String, List<String>>> checkIncompatiblePackages(
    Map<String, Dependency> dependencies, List<String> platforms) async {
  // Create an empty map to store the incompatible packages for each platform.
  Map<String, List<String>> incompatiblePackages = {};
  for (var platform in platforms) {
    // Initialize an empty list for each platform in the map.
    incompatiblePackages[platform] = [];
  }

  // Iterate through each package in the dependencies map.
  for (var package in dependencies.keys) {
    // Exclude "flutter" and "incompatible_package_checker" packages from the check.
    if (package != "flutter" && package != "incompatible_package_checker") {
      // Check if the package supports each platform in the provided list.
      final response = await packageSupportsPlatform(package);
      for (var platform in platforms) {
        // If the package doesn't support the platform, add it to the incompatiblePackages map.
        if (!response.contains(platform.toUpperCase())) {
          incompatiblePackages[platform]!.add(package);
        }
      }
    }
  }

  // Return the map of incompatible packages for each platform.
  return incompatiblePackages;
}

/// Fetches the supported platforms for a given package from its pub.dev page.
/// Returns a list of supported platforms in uppercase.
Future<List<String>> packageSupportsPlatform(String packageName) async {
  // Fetch the package's page from pub.dev.
  var response = await http
      .get(Uri.parse("https://pub.dev/packages/$packageName"))
      .timeout(
    const Duration(seconds: 3),
    onTimeout: () {
      print("timeout");
      throw Exception("Timeout");
    },
  );

  // If the response is successful (status code 200), parse the HTML to extract platform information.
  if (response.statusCode == 200) {
    var document = parse(response.body);
    List<Element> tagBadgeDiv = document.querySelectorAll('.-pub-tag-badge');

    // Check if the tag badge div exists and extract the supported platforms from it.
    if (tagBadgeDiv.isNotEmpty) {
      List<Element> platformElements =
          tagBadgeDiv[1].querySelectorAll('.tag-badge-sub');
      List<String> supportedPlatforms = [];
      for (Element platformElement in platformElements) {
        supportedPlatforms.add(platformElement.text.toUpperCase());
      }
      return supportedPlatforms;
    }
  }

  // If the package page doesn't provide platform information or there was an error, return an empty list.
  return [];
}

/// Prints statistics about incompatible packages for a given platform.
/// Parameters:
/// - incompatiblePackages: List of incompatible package names.
/// - platform: The name of the platform being checked.
/// - totalPackages: Total number of packages being checked.
void printStats(
    List<String> incompatiblePackages, String platform, int totalPackages) {
  double incompatiblePercentage =
      (incompatiblePackages.length / totalPackages) * 100;
  print('Platform: ${platform.toUpperCase()}');
  print('Total Packages: $totalPackages');
  print('Incompatible Packages: ${incompatiblePackages.length}');
  print('Percentage of Incompatible Packages: $incompatiblePercentage%');
  print('Incompatible Packages:');
  for (var package in incompatiblePackages) {
    print('- $package');
  }
}
