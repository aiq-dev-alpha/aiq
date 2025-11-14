import 'package:flutter/material.dart';

enum SocialProvider { google, facebook, apple, twitter, microsoft, github }

class SocialLoginScreen extends StatefulWidget {
  const SocialLoginScreen({super.key});

  @override
  State<SocialLoginScreen> createState() => _SocialLoginScreenState();
}

class _SocialLoginScreenState extends State<SocialLoginScreen> {
  bool _isLoading = false;
  SocialProvider? _loadingProvider;
  String? _error;

  Future<void> _signInWithProvider(SocialProvider provider) async {
    setState(() {
      _isLoading = true;
      _loadingProvider = provider;
      _error = null;
    });

    try {
      // Simulate social login API call
      await Future.delayed(const Duration(seconds: 2));

      // Handle successful login
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully signed in with ${_getProviderName(provider)}!')),
        );
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      setState(() => _error = 'Failed to sign in with ${_getProviderName(provider)}. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadingProvider = null;
        });
      }
    }
  }

  String _getProviderName(SocialProvider provider) {
    switch (provider) {
      case SocialProvider.google:
        return 'Google';
      case SocialProvider.facebook:
        return 'Facebook';
      case SocialProvider.apple:
        return 'Apple';
      case SocialProvider.twitter:
        return 'Twitter';
      case SocialProvider.microsoft:
        return 'Microsoft';
      case SocialProvider.github:
        return 'GitHub';
    }
  }

  IconData _getProviderIcon(SocialProvider provider) {
    switch (provider) {
      case SocialProvider.google:
        return Icons.google;
      case SocialProvider.facebook:
        return Icons.facebook;
      case SocialProvider.apple:
        return Icons.apple;
      case SocialProvider.twitter:
        return Icons.alternate_email;
      case SocialProvider.microsoft:
        return Icons.microsoft;
      case SocialProvider.github:
        return Icons.code;
    }
  }

  Color _getProviderColor(SocialProvider provider) {
    switch (provider) {
      case SocialProvider.google:
        return const Color(0xFFDB4437);
      case SocialProvider.facebook:
        return const Color(0xFF4267B2);
      case SocialProvider.apple:
        return Colors.black;
      case SocialProvider.twitter:
        return const Color(0xFF1DA1F2);
      case SocialProvider.microsoft:
        return const Color(0xFF0078D4);
      case SocialProvider.github:
        return Colors.black87;
    }
  }

  Widget _buildSocialButton({
    required SocialProvider provider,
    required VoidCallback onPressed,
  }) {
    final isCurrentlyLoading = _isLoading && _loadingProvider == provider;

    return Container(
      width: double.infinity,
      height: 56,
      margin: const EdgeInsets.only(bottom: 12),
      child: OutlinedButton.icon(
        onPressed: _isLoading ? null : onPressed,
        icon: isCurrentlyLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                _getProviderIcon(provider),
                color: _getProviderColor(provider),
              ),
        label: Text(
          'Continue with ${_getProviderName(provider)}',
          style: TextStyle(
            color: _isLoading ? Colors.grey : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              // App Logo/Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.account_circle,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              Text(
                'Choose your preferred sign-in method',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              if (_error != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _error!,
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Social Login Buttons
              _buildSocialButton(
                provider: SocialProvider.google,
                onPressed: () => _signInWithProvider(SocialProvider.google),
              ),

              _buildSocialButton(
                provider: SocialProvider.apple,
                onPressed: () => _signInWithProvider(SocialProvider.apple),
              ),

              _buildSocialButton(
                provider: SocialProvider.facebook,
                onPressed: () => _signInWithProvider(SocialProvider.facebook),
              ),

              _buildSocialButton(
                provider: SocialProvider.microsoft,
                onPressed: () => _signInWithProvider(SocialProvider.microsoft),
              ),

              _buildSocialButton(
                provider: SocialProvider.twitter,
                onPressed: () => _signInWithProvider(SocialProvider.twitter),
              ),

              _buildSocialButton(
                provider: SocialProvider.github,
                onPressed: () => _signInWithProvider(SocialProvider.github),
              ),

              const SizedBox(height: 32),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[300])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[300])),
                ],
              ),

              const SizedBox(height: 24),

              // Email/Password Login Button
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/login'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Sign in with Email',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 32),

              // Privacy Notice
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.security,
                      color: Colors.blue[700],
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your Privacy Matters',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'We use secure authentication and never store your social media passwords.',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account? ',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushNamed('/signup'),
                    child: const Text('Sign Up'),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Terms and Privacy
              Text.rich(
                TextSpan(
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                  children: [
                    const TextSpan(text: 'By continuing, you agree to our '),
                    TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Alternative compact social login widget that can be used in other screens
class CompactSocialLogin extends StatelessWidget {
  final Function(SocialProvider) onProviderSelected;
  final bool isLoading;

  const CompactSocialLogin({
    super.key,
    required this.onProviderSelected,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[300])),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey[300])),
          ],
        ),
        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child: _buildCompactSocialButton(
                context: context,
                provider: SocialProvider.google,
                icon: Icons.google,
                color: const Color(0xFFDB4437),
                onPressed: () => onProviderSelected(SocialProvider.google),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCompactSocialButton(
                context: context,
                provider: SocialProvider.apple,
                icon: Icons.apple,
                color: Colors.black,
                onPressed: () => onProviderSelected(SocialProvider.apple),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCompactSocialButton(
                context: context,
                provider: SocialProvider.facebook,
                icon: Icons.facebook,
                color: const Color(0xFF4267B2),
                onPressed: () => onProviderSelected(SocialProvider.facebook),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompactSocialButton({
    required BuildContext context,
    required SocialProvider provider,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 50),
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Icon(
        icon,
        color: isLoading ? Colors.grey : color,
        size: 24,
      ),
    );
  }
}