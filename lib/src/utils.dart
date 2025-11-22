import 'dart:io';
import 'dart:isolate';

Future<String> getPackageRoot() async {
  final uri = await Isolate.resolvePackageUri(
    Uri.parse('package:project_tools/src/generator.dart'),
  );

  if (uri == null) throw Exception("Cannot resolve package root");

  return File.fromUri(uri).parent.parent.path;
}

Future<void> generateTemplate(
  String templateName,
  String className,
  String fileName,
  Directory dir, {
  required String templateFolderName,
}) async {
  final root = await getPackageRoot();

  final templatePath =
      "$root/templates/$templateFolderName/$templateName.template";

  if (!File(templatePath).existsSync()) {
    throw Exception("Template not found: $templatePath");
  }

  final content = File(templatePath)
      .readAsStringSync()
      .replaceAll("{{ClassName}}", className)
      .replaceAll("{{fileName}}", fileName);

  if (!dir.existsSync()) dir.createSync(recursive: true);
  final outPath = "${dir.path}/${fileName}_$templateName.dart";
  File(outPath).writeAsStringSync(content);

  print("  ✓ $outPath");
}

void createFeatureFolders(Directory baseDir) {
  final folders = [
    "data/data_sources",
    "data/models",
    "data/repository",
    "domain/entities",
    "presentation/cubit",
    "presentation/screens",
    "presentation/widgets",
  ];

  for (var folder in folders) {
    final dir = Directory("${baseDir.path}/$folder");
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
      print("✅ Created folder: ${dir.path}");
    }
  }
}

String toPascal(String text) => text
    .split(RegExp(r'[_\s-]+'))
    .map((w) => w.isEmpty ? "" : w[0].toUpperCase() + w.substring(1))
    .join();

String toSnake(String text) {
  return text
      .replaceAllMapped(
        RegExp(r'([a-z0-9])([A-Z])'),
        (m) => '${m.group(1)}_${m.group(2)!.toLowerCase()}',
      )
      .toLowerCase();
}
