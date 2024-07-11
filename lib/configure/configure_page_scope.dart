import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:provider/provider.dart';
import 'package:universal_html/html.dart';

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

  bool get didLoadExtension => _extensionId != null;

  String? _extensionId;
  String? _sessionId;

  StreamSubscription? _configSubscription;
  ChasterConfig? _config;

  List<ObjectData>? _rewards;
  List<ObjectData> get rewards => _rewards ?? [];

  List<ObjectData>? _punishments;
  List<ObjectData> get punishments => _punishments ?? [];

  String? _currentReward;
  String? get currentReward => _currentReward ?? _rewards?.firstOrNull?.id;
  set currentReward(String? value) {
    _currentReward = value;
    notifyListeners();
  }

  String? _currentPunishment;
  String? get currentPunishment =>
      _currentPunishment ?? _punishments?.firstOrNull?.id;
  set currentPunishment(String? value) {
    _currentPunishment = value;
    notifyListeners();
  }

  int _rewardMinutes = 30;
  int get rewardMinutes => _rewardMinutes;
  set rewardMinutes(int value) {
    _rewardMinutes = value;
    notifyListeners();
  }

  final TextEditingController rewardMinutesController = TextEditingController();

  int _punishmentMinutes = 30;
  int get punishmentMinutes => _punishmentMinutes;
  set punishmentMinutes(int value) {
    _punishmentMinutes = value;
    notifyListeners();
  }

  final TextEditingController punishmentMinutesController =
      TextEditingController();

  bool _isMainPage = false;
  bool get isMainPage => _isMainPage;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  Future<void> initialize(String hash) async {
    final json = jsonDecode(hash);

    final partnerConfigurationToken =
        json['partnerConfigurationToken'] as String?;
    final mainToken = json['mainToken'] as String?;
    _isMainPage = mainToken != null;

    // Send a message to the Chaster modal to tell it that your configuration page
    // supports the save capability
    window.parent?.postMessage(
      jsonEncode({
        'type': "partner_configuration",
        'event': "capabilities",
        'payload': {
          'features': {'save': true}
        },
      }),
      "*",
    );
    window.addEventListener("message", _onEventCallback);

    try {
      final extensionData = await _extensionIdService.get(
        configToken: partnerConfigurationToken,
        mainToken: mainToken,
      );
      _extensionId = extensionData.extensionId;
      _sessionId = extensionData.sessionId;
      notifyListeners();

      _configSubscription = _chasterConfigService.listen(_extensionId!).listen(
        (config) {
          _config = config;
          rewardMinutes = config.rewardMinutes ?? 30;
          rewardMinutesController.text = rewardMinutes.toString();
          punishmentMinutes = config.punishmentMinutes ?? 30;
          punishmentMinutesController.text = punishmentMinutes.toString();

          notifyListeners();

          _fetchObjectsIfNeeded();
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onEventCallback(
    Event event,
  ) async {
    if (event is! MessageEvent) return;

    final data = event.data;
    if (data is! String) return;

    final json = jsonDecode(data);
    if (json['type'] != 'chaster' ||
        json['event'] != 'partner_configuration_save') return;

    window.parent!.postMessage(
      jsonEncode({
        'type': "partner_configuration",
        'event': "save_loading",
      }),
      "*",
    );

    final didSave = await save();
    if (didSave) {
      window.parent!.postMessage(
        jsonEncode({
          'type': "partner_configuration",
          'event': "save_success",
        }),
        "*",
      );
    } else {
      window.parent!.postMessage(
        jsonEncode({
          'type': "partner_configuration",
          'event': "save_failed",
        }),
        "*",
      );
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
        _currentReward = _config?.rewardId;

        notifyListeners();
      }

      if (_punishments == null) {
        _punishments = await _obedienceApi.getPunishments(
          _extensionId!,
          _config!.extensionSecret!,
        );
        _currentPunishment = _config?.punishmentId;

        notifyListeners();
      }
    } catch (e) {
      print(e);
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

  Future<bool> save() async {
    if (_config?.extensionSecret == null) {
      return false;
    }

    if (_isSaving) return false;
    _isSaving = true;
    notifyListeners();

    try {
      await _chasterConfigService.update(
        _extensionId!,
        _config!.copyWith(
          sessionId: _sessionId,
          rewardId: currentReward,
          rewardMinutes: rewardMinutes,
          punishmentId: currentPunishment,
          punishmentMinutes: punishmentMinutes,
        ),
      );

      await _obedienceApi.setupWebhooks(
        extensionId: _extensionId!,
        extensionSecret: _config!.extensionSecret!,
        url: 'https://obedience-chaster.web.app/obedience_webhook',
        habits: false,
        rewards: true,
        punishments: true,
      );

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _configSubscription?.cancel();

    super.dispose();
  }
}
