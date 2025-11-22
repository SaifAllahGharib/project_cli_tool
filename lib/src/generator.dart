import 'dart:io';

import 'package:project_tools/src/utils.dart';

Future<void> runCli(List<String> args) async {
  if (args.isEmpty) {
    print(
      "Usage: your_package_name <feature_name> [-c | -b | -r | -d | -f] [--name <CustomClassName>]",
    );
    exit(1);
  }

  final featureName = args.first;
  final flags = args.where((a) => a.startsWith("-") && a != "--name").toList();

  if (flags.isEmpty) {
    print("❌ Must provide at least one flag");
    exit(1);
  }

  final nameFlagIndex = args.indexOf("--name");
  String? customName;
  if (nameFlagIndex != -1 && args.length > nameFlagIndex + 1) {
    customName = args[nameFlagIndex + 1];
  }

  final className = customName != null
      ? toPascal(customName)
      : toPascal(featureName);
  final fileName = customName != null
      ? customName.toLowerCase()
      : featureName.toLowerCase();

  final featuresRoot = Directory("lib/features");
  if (!featuresRoot.existsSync()) featuresRoot.createSync(recursive: true);

  final featureDir = Directory("${featuresRoot.path}/$fileName");

  for (var flag in flags) {
    switch (flag) {
      case "-c":
        await generateTemplate(
          "cubit",
          className,
          fileName,
          Directory("${featureDir.path}/presentation/cubit"),
          templateFolderName: "cubit",
        );
        await generateTemplate(
          "state",
          className,
          fileName,
          Directory("${featureDir.path}/presentation/cubit"),
          templateFolderName: "cubit",
        );
        break;
      case "-b":
        await generateTemplate(
          "bloc",
          className,
          fileName,
          Directory("${featureDir.path}/presentation/bloc"),
          templateFolderName: "bloc",
        );
        await generateTemplate(
          "bloc_event",
          className,
          fileName,
          Directory("${featureDir.path}/presentation/bloc"),
          templateFolderName: "bloc",
        );
        await generateTemplate(
          "state",
          className,
          fileName,
          Directory("${featureDir.path}/presentation/bloc"),
          templateFolderName: "bloc",
        );
        break;
      case "-r":
        await generateTemplate(
          "repository",
          className,
          fileName,
          Directory("${featureDir.path}/data/repository"),
          templateFolderName: "repository",
        );
        break;
      case "-d":
        await generateTemplate(
          "remote_datasource",
          className,
          fileName,
          Directory("${featureDir.path}/data/data_sources"),
          templateFolderName: "remote_datasource",
        );
        break;
      case "-f":
        if (!featureDir.existsSync()) {
          createFeatureFolders(featureDir);
        } else {
          print(
            "⚠ Feature folder '${featureDir.path}' already exists, skipping creation.",
          );
        }
        break;
      default:
        print("❌ Unknown flag $flag");
    }
  }

  print("✨ Generation done!");
}
