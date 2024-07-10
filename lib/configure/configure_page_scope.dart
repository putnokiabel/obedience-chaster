import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:provider/provider.dart';

import 'package:obedience_chaster/services/chaster_config_service.dart';
import 'package:obedience_chaster/services/extension_id_service.dart';
import 'package:obedience_chaster/services/launch_url.dart';
import 'package:obedience_chaster/services/obedience_api.dart';

class ConfigurePageScope extends ChangeNotifier {
  ConfigurePageScope({
    required ChasterConfigService chasterConfigService,
    required ExtensionIdService extensionIdService,
    required ObedienceApi obedienceApi,
    required LaunchUrl launchUrl,
  })  : _chasterConfigService = chasterConfigService,
        _extensionIdService = extensionIdService,
        _obedienceApi = obedienceApi,
        _launchUrl = launchUrl;

  factory ConfigurePageScope.of(BuildContext context) {
    return ConfigurePageScope(
      chasterConfigService: context.read(),
      extensionIdService: context.read(),
      obedienceApi: context.read(),
      launchUrl: context.read(),
    );
  }

  final ChasterConfigService _chasterConfigService;
  final ExtensionIdService _extensionIdService;
  final ObedienceApi _obedienceApi;
  final LaunchUrl _launchUrl;

  bool get hasGivenAccess => _config?.extensionSecret != null;

  String? _extensionId;

  StreamSubscription? _configSubscription;
  ChasterConfig? _config;

  List<ObjectData>? _rewards;
  List<ObjectData> get rewards => _rewards ?? [];

  List<ObjectData>? _punishments;
  List<ObjectData> get punishments => _punishments ?? [];

  Future<void> initialize(String hash) async {
    final json = jsonDecode(hash);

    final partnerConfigurationToken =
        json['partnerConfigurationToken'] as String;

    try {
      _extensionId = await _extensionIdService.get(partnerConfigurationToken);

      _configSubscription = _chasterConfigService.listen(_extensionId!).listen(
        (config) {
          _config = config;
          notifyListeners();

          _fetchObjectsIfNeeded();
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchObjectsIfNeeded() async {
    if (_config?.extensionSecret == null) {
      return;
    }

    try {
      if (_rewards == null) {
        _rewards = await _obedienceApi.getRewards(
          _extensionId!,
          _config!.extensionSecret!,
        );

        notifyListeners();
      }

      if (_punishments == null) {
        _punishments = await _obedienceApi.getPunishments(
          _extensionId!,
          _config!.extensionSecret!,
        );

        notifyListeners();
      }
    } catch (e, stack) {
      print(e);
      print(stack);
    }
  }

  Future<void> giveAccess() async {
    await _launchUrl(
      Uri.parse(
        'https://app.obedienceapp.com/home/extension-request?'
        'id=${_extensionId!}'
        '&name=Obedience-Chaster Extension'
        '&redirect=https://obedience-chaster.web.app/redirect',
      ),
    );
  }

  @override
  void dispose() {
    _configSubscription?.cancel();

    super.dispose();
  }
}
