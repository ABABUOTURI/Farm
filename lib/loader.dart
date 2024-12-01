import 'package:flutter/material.dart';

class LoaderPage extends StatelessWidget {
  const LoaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farm Inventory')),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
