import 'package:flutter/material.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'app.dart';

Future<void> main() async {
  setUrlStrategy(PathUrlStrategy());

  const app = App();

  runApp(app);
}
