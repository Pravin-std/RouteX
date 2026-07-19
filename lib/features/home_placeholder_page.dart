import 'package:flutter/material.dart';

class HomePlaceholderPage extends StatelessWidget {
  const HomePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RouteX'),
      ),
      body: const Center(
        child: Text('RouteX Project Initialized'),
      ),
    );
  }
}
