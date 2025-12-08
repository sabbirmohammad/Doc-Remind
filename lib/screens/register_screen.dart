import 'package:flutter/material.dart';

/// This screen is no longer used
/// Profile creation is now handled directly on the LoginScreen
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: const Center(child: Text('This screen is deprecated')),
    );
  }
}
