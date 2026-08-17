import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'router/app_router.dart';

class PulseDeskApp extends StatelessWidget {
  const PulseDeskApp({super.key, this.router});

  final GoRouter? router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router ?? appRouter);
  }
}
