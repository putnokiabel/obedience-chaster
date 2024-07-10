import 'package:flutter/widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:uuid/uuid.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'services/chaster_config_service.dart';
import 'services/extension_id_service.dart';
import 'services/obedience_api.dart';

Future<void> main() async {
  setUrlStrategy(
    PathUrlStrategy(
      const BrowserPlatformLocation(),
      true,
    ),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final app = App(
    chasterConfigService:
        ChasterConfigService(firestore: FirebaseFirestore.instance),
    extensionIdService:
        ExtensionIdService(functions: FirebaseFunctions.instance),
    obedienceApi: ObedienceApi(),
    generateUuid: const Uuid().v4,
    launchUrl: _launchUrl,
  );

  runApp(app);
}

Future<bool> _launchUrl(url, {bool newTab = true}) =>
    url_launcher.launchUrl(url, webOnlyWindowName: newTab ? '_blank' : '_self');
