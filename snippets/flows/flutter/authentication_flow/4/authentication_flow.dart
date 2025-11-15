import 'package:flutter/material.dart';

class AuthFlowConfig {
  final Color primaryColor;
  final Color backgroundColor;
  final bool enableSocialLogin;
  final bool enableBiometric;

  const AuthFlowConfig({
    this.primaryColor = const Color(0xFF1976D2),
    this.backgroundColor = Colors.white,
    this.enableSocialLogin = true,
    this.enableBiometric = false,
  });
}

class AuthenticationFlow {
  final AuthFlowConfig config;

  const AuthenticationFlow({this.config = const AuthFlowConfig()});

  void startLogin(BuildContext context, {Function(String, String)? onLogin}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _LoginScreen(config: config, onLogin: onLogin),
      ),
    );
  }

  void startSignup(BuildContext context, {Function(String, String)? onSignup}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _SignupScreen(config: config, onSignup: onSignup),
      ),
    );
  }
}

class _LoginScreen extends StatefulWidget {
  final AuthFlowConfig config;
  final Function(String, String)? onLogin;

  const _LoginScreen({required this.config, this.onLogin});

  @override
  State<_LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.config.backgroundColor,
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: widget.config.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Icon(Icons.lock_outline, size: 80, color: widget.config.primaryColor),
              const SizedBox(height: 48),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (v) => v?.contains('@') == true ? null : 'Invalid email',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (v) => v?.length ?? 0 >= 6 ? null : 'Password too short',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.config.primaryColor,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    widget.onLogin?.call(_emailController.text, _passwordController.text);
                  }
                },
                child: const Text('Login'),
              ),
              if (widget.config.enableSocialLogin) ...[
                const SizedBox(height: 24),
                const Text('Or continue with', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _SocialButton(icon: Icons.g_mobiledata, label: 'Google'),
                    _SocialButton(icon: Icons.facebook, label: 'Facebook'),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => _navigateToSignup(context),
                child: const Text("Don't have an account? Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToSignup(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => _SignupScreen(config: widget.config),
      ),
    );
  }
}

class _SignupScreen extends StatefulWidget {
  final AuthFlowConfig config;
  final Function(String, String)? onSignup;

  const _SignupScreen({required this.config, this.onSignup});

  @override
  State<_SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<_SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.config.backgroundColor,
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: widget.config.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Icon(Icons.person_add, size: 80, color: widget.config.primaryColor),
              const SizedBox(height: 48),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (v) => v?.contains('@') == true ? null : 'Invalid email',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (v) => v?.length ?? 0 >= 6 ? null : 'Password too short',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.config.primaryColor,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    widget.onSignup?.call(_emailController.text, _passwordController.text);
                  }
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SocialButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }
}
