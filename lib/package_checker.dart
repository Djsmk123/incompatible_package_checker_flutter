import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

Future<Map<String, List<String>>> checkIncompatiblePackages(
    dependencies, List<String> platforms) async {
  Map<String, List<String>> incompatiblePackages = {};
  for (var platform in platforms) {
    incompatiblePackages[platform] = [];
  }
  for (var package in dependencies.keys) {
    if (package != "flutter") {
      final response = await packageSupportsPlatform(package);
      for (var platform in platforms) {
        if (!response.contains(platform.toUpperCase())) {
          incompatiblePackages[platform]!.add(package);
        }
      }
    }
  }
  return incompatiblePackages;
}

Future<List<String>> packageSupportsPlatform(String packageName) async {
  var response = await http
      .get(Uri.parse("https://pub.dev/packages/$packageName"))
      .timeout(
    const Duration(seconds: 3),
    onTimeout: () {
      print("timeout");
      throw Exception("Timeout");
    },
  );
  if (response.statusCode == 200) {
    var document = parse(response.body);
    List<Element> tagBadgeDiv = document.querySelectorAll('.-pub-tag-badge');
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
  return [];
}

void printStats(
    List<String> incompatiblePackages, String platform, int totalPackages) {
  double incompatiblePercentage =
      (incompatiblePackages.length / totalPackages) * 100;
  print('Platform: $platform');
  print('Total Packages: $totalPackages');
  print('Incompatible Packages: ${incompatiblePackages.length}');
  print('Percentage of Incompatible Packages: $incompatiblePercentage%');
  print('Incompatible Packages:');
  for (var package in incompatiblePackages) {
    print('- $package');
  }
}
