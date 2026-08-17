import 'package:flutter/material.dart';
import 'router/app_router.dart';

class PulseDeskApp extends StatelessWidget {
  const PulseDeskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: appRouter);
  }
}
