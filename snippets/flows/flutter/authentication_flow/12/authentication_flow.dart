import 'package:flutter/material.dart';

class AuthenticationFlow {
  final Color primaryColor;

  const AuthenticationFlow({this.primaryColor = const Color(0xFF1976D2)});

  void startLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => _LoginScreen(color: primaryColor)),
    );
  }
}

class _LoginScreen extends StatefulWidget {
  final Color color;

  const _LoginScreen({required this.color});

  @override
  State<_LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), backgroundColor: widget.color),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.color,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => _SignupScreen(color: widget.color)),
              ),
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignupScreen extends StatelessWidget {
  final Color color;

  const _SignupScreen({required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up'), backgroundColor: color),
      body: const Center(child: Text('Sign Up Form')),
    );
  }
}
