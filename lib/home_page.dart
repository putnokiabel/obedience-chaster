import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const path = '/home';
  static const name = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Obedience Chaster Extension'),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'With the Obedience Chaster extension, '
                'you can connect your lock to an Obedience reward or punishment.',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 4),
              Text(
                'The Obedience reward will subtract time from the lock, '
                'while the Obedience punishment will add time to the lock.',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 8),
              Text(
                'Go to the "Configure" page to configure this extension.',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
