import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'services/chaster_config_service.dart';

class RedirectPage extends StatefulWidget {
  const RedirectPage({
    super.key,
    required this.id,
    required this.secret,
    required this.uid,
  });

  static const path = '/redirect';
  static const name = 'redirect';

  final String id;
  final String secret;
  final String uid;

  @override
  State<RedirectPage> createState() => _RedirectPageState();
}

class _RedirectPageState extends State<RedirectPage> {
  @override
  void initState() {
    super.initState();

    ChasterConfigService chasterConfigService = context.read();

    chasterConfigService
        .update(
          widget.id,
          ChasterConfig(
            userId: widget.uid,
            extensionSecret: widget.secret,
            rewardId: null,
            rewardMinutes: null,
            punishmentId: null,
            punishmentMinutes: null,
            sessionId: null,
          ),
        )
        .catchError(print);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Obedience is now connected to your Chaster account. '
                  'You can close this tab, and return to Chaster to continue configuring your extension.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
