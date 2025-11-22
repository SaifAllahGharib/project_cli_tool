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

  final fileName = toSnake(customName ?? featureName);

  final featureDir = Directory("lib/features/$featureName");
  if (!featureDir.existsSync()) {
    featureDir.createSync(recursive: true);
    print("⚠ Feature folder '${featureDir.path}' created.");
  } else {
    print("ℹ Using existing feature folder '${featureDir.path}'.");
  }

  for (var flag in flags) {
    switch (flag) {
      case "-c":
        final cubitDir = Directory(
          "${featureDir.path}/presentation/cubit/$fileName",
        );
        if (!cubitDir.existsSync()) cubitDir.createSync(recursive: true);

        await generateTemplate(
          "cubit",
          className,
          fileName,
          cubitDir,
          templateFolderName: "cubit",
        );
        await generateTemplate(
          "state",
          className,
          fileName,
          cubitDir,
          templateFolderName: "cubit",
        );
        break;
      case "-b":
        final blocDir = Directory(
          "${featureDir.path}/presentation/bloc/$fileName",
        );
        if (!blocDir.existsSync()) blocDir.createSync(recursive: true);

        await generateTemplate(
          "bloc",
          className,
          fileName,
          blocDir,
          templateFolderName: "bloc",
        );
        await generateTemplate(
          "bloc_event",
          className,
          fileName,
          blocDir,
          templateFolderName: "bloc",
        );
        await generateTemplate(
          "state",
          className,
          fileName,
          blocDir,
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
        createFeatureFolders(featureDir);
        break;
      default:
        print("❌ Unknown flag $flag");
    }
  }

  print("✨ Generation done!");
}
