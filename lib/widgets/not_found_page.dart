import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:obedience_chaster/home_page.dart';

import 'buttons.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Oops! This page does not exist.',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 32),
            LargeFlatPillButton(
              showBackground: true,
              onPressed: () => context.goNamed(HomePage.name),
              child: const Text('Go home'),
            ),
          ],
        ),
      ),
    );
  }
}
