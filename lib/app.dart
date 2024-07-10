import 'package:flutter/material.dart' hide MaterialPage;

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'routes.dart';
import 'services/chaster_config_service.dart';
import 'services/extension_id_service.dart';
import 'services/generate_uuid.dart';
import 'services/launch_url.dart';
import 'services/obedience_api.dart';
import 'themes.dart';
import 'widgets/not_found_page.dart';

class App extends StatefulWidget {
  const App({
    super.key,
    required this.chasterConfigService,
    required this.extensionIdService,
    required this.obedienceApi,
    required this.generateUuid,
    required this.launchUrl,
  });

  final ChasterConfigService chasterConfigService;
  final ExtensionIdService extensionIdService;
  final ObedienceApi obedienceApi;
  final GenerateUuid generateUuid;
  final LaunchUrl launchUrl;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final router = GoRouter(
    routes: routes,
    errorPageBuilder: (_, __) => const MaterialPage(child: NotFoundPage()),
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: widget.chasterConfigService),
        Provider.value(value: widget.extensionIdService),
        Provider.value(value: widget.obedienceApi),
        Provider.value(value: widget.generateUuid),
        Provider.value(value: widget.launchUrl),
      ],
      child: MaterialApp.router(
        title: 'Obedience Chaster Extension',
        theme: Themes.red.getData(true),
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
      ),
    );
  }
}
