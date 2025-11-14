import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum BiometricType { fingerprint, faceId, voice, none }

class BiometricAuthScreen extends StatefulWidget {
  final bool isSetup;

  const BiometricAuthScreen({super.key, this.isSetup = false});

  @override
  State<BiometricAuthScreen> createState() => _BiometricAuthScreenState();
}

class _BiometricAuthScreenState extends State<BiometricAuthScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  bool _isLoading = false;
  bool _isAvailable = false;
  List<BiometricType> _availableBiometrics = [];
  BiometricType _selectedBiometric = BiometricType.none;
  String? _error;
  bool _setupComplete = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkBiometricAvailability();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      // Simulate checking available biometrics
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock available biometrics - in real app, use local_auth package
      final availableBiometrics = <BiometricType>[
        BiometricType.fingerprint,
        BiometricType.faceId,
      ];

      setState(() {
        _isAvailable = availableBiometrics.isNotEmpty;
        _availableBiometrics = availableBiometrics;
        _selectedBiometric = availableBiometrics.first;
      });
    } catch (e) {
      setState(() {
        _isAvailable = false;
        _error = 'Unable to check biometric availability';
      });
    }
  }

  Future<void> _authenticateWithBiometric() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Simulate biometric authentication
      await Future.delayed(const Duration(seconds: 2));

      if (widget.isSetup) {
        setState(() => _setupComplete = true);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Biometric authentication successful!')),
          );
          Navigator.of(context).pushReplacementNamed('/home');
        }
      }
    } on PlatformException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'NotAvailable':
          errorMessage = 'Biometric authentication is not available';
          break;
        case 'NotEnrolled':
          errorMessage = 'No biometrics enrolled on this device';
          break;
        case 'LockedOut':
          errorMessage = 'Too many failed attempts. Try again later';
          break;
        case 'UserCancel':
          errorMessage = 'Authentication was cancelled';
          break;
        default:
          errorMessage = 'Authentication failed. Please try again';
      }
      setState(() => _error = errorMessage);
    } catch (e) {
      setState(() => _error = 'Authentication failed. Please try again');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _skipBiometric() async {
    if (widget.isSetup) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  IconData _getBiometricIcon(BiometricType type) {
    switch (type) {
      case BiometricType.fingerprint:
        return Icons.fingerprint;
      case BiometricType.faceId:
        return Icons.face;
      case BiometricType.voice:
        return Icons.record_voice_over;
      case BiometricType.none:
        return Icons.security;
    }
  }

  String _getBiometricName(BiometricType type) {
    switch (type) {
      case BiometricType.fingerprint:
        return 'Fingerprint';
      case BiometricType.faceId:
        return 'Face ID';
      case BiometricType.voice:
        return 'Voice';
      case BiometricType.none:
        return 'Biometric';
    }
  }

  String _getBiometricDescription(BiometricType type) {
    switch (type) {
      case BiometricType.fingerprint:
        return 'Use your fingerprint to authenticate';
      case BiometricType.faceId:
        return 'Use your face to authenticate';
      case BiometricType.voice:
        return 'Use your voice to authenticate';
      case BiometricType.none:
        return 'Use biometric authentication';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isSetup
          ? AppBar(
              title: const Text('Setup Biometric Auth'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: !_isAvailable ? _buildUnavailableView()
              : (_setupComplete ? _buildSetupCompleteView() : _buildAuthView()),
        ),
      ),
    );
  }

  Widget _buildAuthView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!widget.isSetup) const SizedBox(height: 60),

        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Icon(
                  _getBiometricIcon(_selectedBiometric),
                  size: 120,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 40),

        Text(
          widget.isSetup ? 'Setup ${_getBiometricName(_selectedBiometric)}' : 'Biometric Authentication',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),

        Text(
          widget.isSetup
              ? 'Enable ${_getBiometricName(_selectedBiometric).toLowerCase()} authentication for quick and secure access to your account.'
              : _getBiometricDescription(_selectedBiometric),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 40),

        if (_availableBiometrics.length > 1) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available Authentication Methods:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                ..._availableBiometrics.map((biometric) {
                  return RadioListTile<BiometricType>(
                    value: biometric,
                    groupValue: _selectedBiometric,
                    onChanged: (value) {
                      setState(() => _selectedBiometric = value!);
                    },
                    title: Row(
                      children: [
                        Icon(_getBiometricIcon(biometric)),
                        const SizedBox(width: 12),
                        Text(_getBiometricName(biometric)),
                      ],
                    ),
                    contentPadding: EdgeInsets.zero,
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],

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

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.security, color: Colors.blue[700]),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Your biometric data is stored securely on your device and is never shared.',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        ElevatedButton(
          onPressed: _isLoading ? null : _authenticateWithBiometric,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.isSetup ? 'Enable ${_getBiometricName(_selectedBiometric)}' : 'Authenticate'),
        ),

        const SizedBox(height: 16),

        if (!widget.isSetup) ...[
          OutlinedButton(
            onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
            ),
            child: const Text('Use Password Instead'),
          ),
        ] else ...[
          TextButton(
            onPressed: _skipBiometric,
            child: const Text('Skip for Now'),
          ),
        ],

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildUnavailableView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 100),

        Icon(
          Icons.error_outline,
          size: 80,
          color: Colors.orange[600],
        ),
        const SizedBox(height: 32),

        Text(
          'Biometric Authentication Unavailable',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),

        Text(
          _error ?? 'Biometric authentication is not available on this device or no biometrics are enrolled.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 40),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange[200]!),
          ),
          child: Column(
            children: [
              Icon(Icons.info_outline, color: Colors.orange[700]),
              const SizedBox(height: 8),
              Text(
                'To use biometric authentication:',
                style: TextStyle(
                  color: Colors.orange[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '• Enable fingerprint or face unlock in your device settings\n• Make sure at least one biometric is enrolled\n• Restart the app after enabling biometrics',
                style: TextStyle(color: Colors.orange[700]),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),

        const Spacer(),

        ElevatedButton(
          onPressed: () => _checkBiometricAvailability(),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
          ),
          child: const Text('Check Again'),
        ),

        const SizedBox(height: 16),

        OutlinedButton(
          onPressed: widget.isSetup ? _skipBiometric : () => Navigator.of(context).pushReplacementNamed('/login'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
          ),
          child: Text(widget.isSetup ? 'Skip Setup' : 'Use Password Instead'),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSetupCompleteView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 100),

        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.green[50],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle,
            size: 80,
            color: Colors.green[600],
          ),
        ),
        const SizedBox(height: 32),

        Text(
          'Biometric Authentication Enabled!',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),

        Text(
          'You can now use ${_getBiometricName(_selectedBiometric).toLowerCase()} to quickly and securely access your account.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 40),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Biometric Authentication Features:',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '• Quick and secure login\n• No need to remember passwords\n• Your biometric data stays on your device\n• Can be disabled anytime in settings',
                style: TextStyle(color: Colors.green[700]),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),

        const Spacer(),

        ElevatedButton(
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
          ),
          child: const Text('Continue to App'),
        ),

        const SizedBox(height: 16),

        OutlinedButton(
          onPressed: () {
            // Test biometric authentication
            _authenticateWithBiometric();
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
          ),
          child: const Text('Test Biometric Login'),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}