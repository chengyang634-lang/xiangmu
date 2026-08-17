import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('PulseDesk'),
            SizedBox(height: 8),
            Text('Sign in'),
          ],
        ),
      ),
    );
  }
}