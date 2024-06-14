import 'dart:io';

void main() {
  final envFile = File('.env');
  final env = Map.fromEntries(
    envFile.readAsLinesSync().map((line) {
      final split = line.split('=');
      return MapEntry(split[0], split[1]);
    }),
  );

  final templateFile = File('lib/utils/google-services-template.json');
  var template = templateFile.readAsStringSync();

  env.forEach((key, value) {
    template = template.replaceAll('\${$key}', value);
  });

  final outputFile = File('android/app/google-services.json');
  outputFile.writeAsStringSync(template);

  // print('google-services.json generated successfully.');
}
