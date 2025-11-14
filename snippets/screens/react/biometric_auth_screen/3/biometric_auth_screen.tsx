import React, { useState, useEffect } from 'react';
import {
  Typography,
  Box,
  Container,
  Paper,
  Alert,
  Card,
  CardContent,
  Button,
  Radio,
  RadioGroup,
  FormControlLabel,
  FormControl,
  FormLabel,
  List,
  ListItem,
  ListItemIcon,
  ListItemText,
  CircularProgress,
  IconButton,
  Fade
} from '@mui/material';
import {
  Fingerprint,
  Face,
  Security,
  CheckCircle,
  Error,
  Info,
  ArrowBack
} from '@mui/icons-material';

enum BiometricType {
  FINGERPRINT = 'fingerprint',
  FACE_ID = 'faceId',
  NONE = 'none'
}

interface BiometricAuthScreenProps {
  isSetup?: boolean;
  onNavigateBack?: () => Unit;
  onSetupComplete?: () => Unit;
  onAuthenticationSuccess?: () => Unit;
}

const BiometricAuthScreen: React.FC<BiometricAuthScreenProps> = ({
  isSetup = false,
  onNavigateBack,
  onSetupComplete,
  onAuthenticationSuccess
}) => {
  const [isAvailable, setIsAvailable] = useState(false);
  const [biometricType, setBiometricType] = useState<BiometricType>(BiometricType.NONE);
  const [availableBiometrics, setAvailableBiometrics] = useState<BiometricType[]>([]);
  const [selectedBiometric, setSelectedBiometric] = useState<BiometricType>(BiometricType.NONE);
  const [isLoading, setIsLoading] = useState(false);
  const [setupComplete, setSetupComplete] = useState(false);
  const [error, setError] = useState<string>('');
  const [isAnimating, setIsAnimating] = useState(true);

  useEffect(() => {
    checkBiometricAvailability();
  }, []);

  useEffect(() => {
    // Animate the biometric icon
    const interval = setInterval(() => {
      setIsAnimating(prev => !prev);
    }, 1500);

    return () => clearInterval(interval);
  }, []);

  const checkBiometricAvailability = async () => {
    try {
      // Check if Web Authentication API is available
      if (!window.PublicKeyCredential) {
        throw new Error('Web Authentication API not supported');
      }

      // Check if authenticator is available
      const available = await PublicKeyCredential.isUserVerifyingPlatformAuthenticatorAvailable();

      if (available) {
        setIsAvailable(true);
        // For web, we typically have fingerprint or face ID
        const availableTypes = [BiometricType.FINGERPRINT];
        setAvailableBiometrics(availableTypes);
        setBiometricType(BiometricType.FINGERPRINT);
        setSelectedBiometric(BiometricType.FINGERPRINT);
      } else {
        setIsAvailable(false);
        setError('Biometric authentication is not available on this device');
      }
    } catch (err) {
      setIsAvailable(false);
      setError('Unable to check biometric availability');
    }
  };

  const authenticateWithBiometric = async () => {
    if (!isAvailable) return;

    setIsLoading(true);
    setError('');

    try {
      // Create WebAuthn credential request
      const publicKeyCredentialRequestOptions: PublicKeyCredentialRequestOptions = {
        challenge: new Uint8Array(32),
        allowCredentials: [],
        userVerification: 'required',
        timeout: 60000,
      };

      // Request authentication
      const credential = await navigator.credentials.get({
        publicKey: publicKeyCredentialRequestOptions,
      });

      if (credential) {
        if (isSetup) {
          setSetupComplete(true);
        } else {
          onAuthenticationSuccess?.();
        }
      }
    } catch (err: any) {
      let errorMessage = 'Authentication failed. Please try again.';

      switch (err.name) {
        case 'NotAllowedError':
          errorMessage = 'Authentication was cancelled or not allowed';
          break;
        case 'InvalidStateError':
          errorMessage = 'Biometric authentication is not set up';
          break;
        case 'NotSupportedError':
          errorMessage = 'Biometric authentication is not supported';
          break;
        case 'SecurityError':
          errorMessage = 'Security error during authentication';
          break;
        case 'AbortError':
          errorMessage = 'Authentication was aborted';
          break;
      }

      setError(errorMessage);
    } finally {
      setIsLoading(false);
    }
  };

  const getBiometricIcon = (type: BiometricType) => {
    switch (type) {
      case BiometricType.FINGERPRINT:
        return <Fingerprint />;
      case BiometricType.FACE_ID:
        return <Face />;
      default:
        return <Security />;
    }
  };

  const getBiometricName = (type: BiometricType) => {
    switch (type) {
      case BiometricType.FINGERPRINT:
        return 'Fingerprint';
      case BiometricType.FACE_ID:
        return 'Face ID';
      default:
        return 'Biometric';
    }
  };

  const getBiometricDescription = (type: BiometricType) => {
    switch (type) {
      case BiometricType.FINGERPRINT:
        return 'Use your fingerprint to authenticate';
      case BiometricType.FACE_ID:
        return 'Use your face to authenticate';
      default:
        return 'Use biometric authentication';
    }
  };

  if (setupComplete) {
    return (
      <Container maxWidth="sm">
        <Box sx={{ mt: 4, mb: 4 }}>
          <Paper elevation={3} sx={{ p: 4, textAlign: 'center' }}>
            {/* Success Icon */}
            <Box sx={{ mb: 3 }}>
              <CheckCircle
                sx={{
                  fontSize: 80,
                  color: 'success.main',
                  p: 2,
                  borderRadius: '50%',
                  bgcolor: 'success.light',
                  opacity: 0.1
                }}
              />
              <CheckCircle
                sx={{
                  fontSize: 80,
                  color: 'success.main',
                  position: 'absolute',
                  ml: -10,
                  mt: -10
                }}
              />
            </Box>

            {/* Header */}
            <Typography variant="h4" component="h1" fontWeight="bold" gutterBottom>
              Biometric Authentication Enabled!
            </Typography>

            <Typography variant="body1" color="text.secondary" paragraph>
              You can now use {getBiometricName(selectedBiometric).toLowerCase()} to quickly and
              securely access your account.
            </Typography>

            {/* Features Card */}
            <Card sx={{ mb: 3, bgcolor: 'success.light', color: 'success.contrastText' }}>
              <CardContent>
                <Box display="flex" alignItems="center" justifyContent="center" mb={1}>
                  <CheckCircle sx={{ mr: 1 }} />
                  <Typography variant="subtitle1" fontWeight="bold">
                    Biometric Authentication Features:
                  </Typography>
                </Box>
                <List dense>
                  {[
                    'Quick and secure login',
                    'No need to remember passwords',
                    'Your biometric data stays on your device',
                    'Can be disabled anytime in settings'
                  ].map((feature, index) => (
                    <ListItem key={index}>
                      <ListItemText
                        primary={`• ${feature}`}
                        primaryTypographyProps={{ variant: 'body2' }}
                      />
                    </ListItem>
                  ))}
                </List>
              </CardContent>
            </Card>

            {/* Continue Button */}
            <Button
              fullWidth
              variant="contained"
              size="large"
              onClick={onSetupComplete}
              sx={{ height: 56, mb: 2 }}
            >
              Continue to App
            </Button>

            {/* Test Button */}
            <Button
              fullWidth
              variant="outlined"
              size="large"
              onClick={authenticateWithBiometric}
              sx={{ height: 56 }}
            >
              Test Biometric Login
            </Button>
          </Paper>
        </Box>
      </Container>
    );
  }

  if (!isAvailable) {
    return (
      <Container maxWidth="sm">
        <Box sx={{ mt: 4, mb: 4 }}>
          <Paper elevation={3} sx={{ p: 4, textAlign: 'center' }}>
            {/* Back Button */}
            {isSetup && (
              <Box sx={{ display: 'flex', justifyContent: 'flex-start', mb: 2 }}>
                <IconButton onClick={onNavigateBack}>
                  <ArrowBack />
                </IconButton>
              </Box>
            )}

            {/* Error Icon */}
            <Error
              sx={{
                fontSize: 80,
                color: 'warning.main',
                mb: 3
              }}
            />

            {/* Header */}
            <Typography variant="h4" component="h1" fontWeight="bold" gutterBottom>
              Biometric Authentication Unavailable
            </Typography>

            <Typography variant="body1" color="text.secondary" paragraph>
              {error || 'Biometric authentication is not available on this device or browser.'}
            </Typography>

            {/* Instructions Card */}
            <Alert severity="warning" sx={{ mb: 3, textAlign: 'left' }}>
              <Typography variant="subtitle2" fontWeight="bold" gutterBottom>
                To use biometric authentication:
              </Typography>
              <Typography variant="body2" component="div">
                • Use a supported browser (Chrome, Firefox, Safari)
                <br />
                • Ensure your device has biometric sensors
                <br />
                • Enable biometrics in your device settings
                <br />
                • Use HTTPS (required for WebAuthn)
              </Typography>
            </Alert>

            {/* Check Again Button */}
            <Button
              fullWidth
              variant="contained"
              size="large"
              onClick={checkBiometricAvailability}
              sx={{ height: 56, mb: 2 }}
            >
              Check Again
            </Button>

            {/* Alternative Button */}
            <Button
              fullWidth
              variant="outlined"
              size="large"
              onClick={isSetup ? onSetupComplete : onNavigateBack}
              sx={{ height: 56 }}
            >
              {isSetup ? 'Skip Setup' : 'Use Password Instead'}
            </Button>
          </Paper>
        </Box>
      </Container>
    );
  }

  return (
    <Container maxWidth="sm">
      <Box sx={{ mt: 4, mb: 4 }}>
        <Paper elevation={3} sx={{ p: 4, textAlign: 'center' }}>
          {/* Back Button */}
          {isSetup && (
            <Box sx={{ display: 'flex', justifyContent: 'flex-start', mb: 2 }}>
              <IconButton onClick={onNavigateBack}>
                <ArrowBack />
              </IconButton>
            </Box>
          )}

          {/* Animated Biometric Icon */}
          <Fade in timeout={1000}>
            <Box
              sx={{
                mb: 4,
                transform: isAnimating ? 'scale(1.1)' : 'scale(1)',
                transition: 'transform 1.5s ease-in-out',
                opacity: isAnimating ? 0.8 : 1
              }}
            >
              {React.cloneElement(getBiometricIcon(biometricType), {
                sx: {
                  fontSize: 120,
                  color: 'primary.main'
                }
              })}
            </Box>
          </Fade>

          {/* Header */}
          <Typography variant="h4" component="h1" fontWeight="bold" gutterBottom>
            {isSetup ? `Setup ${getBiometricName(biometricType)}` : 'Biometric Authentication'}
          </Typography>

          <Typography variant="body1" color="text.secondary" paragraph>
            {isSetup
              ? `Enable ${getBiometricName(biometricType).toLowerCase()} authentication for quick and secure access to your account.`
              : getBiometricDescription(biometricType)
            }
          </Typography>

          {/* Available Biometric Selection */}
          {availableBiometrics.length > 1 && (
            <Card sx={{ mb: 3 }}>
              <CardContent>
                <FormControl component="fieldset">
                  <FormLabel component="legend">
                    <Typography variant="subtitle1" fontWeight="bold">
                      Available Authentication Methods:
                    </Typography>
                  </FormLabel>
                  <RadioGroup
                    value={selectedBiometric}
                    onChange={(e) => setSelectedBiometric(e.target.value as BiometricType)}
                    sx={{ mt: 1 }}
                  >
                    {availableBiometrics.map((type) => (
                      <FormControlLabel
                        key={type}
                        value={type}
                        control={<Radio />}
                        label={
                          <Box display="flex" alignItems="center">
                            {getBiometricIcon(type)}
                            <Typography sx={{ ml: 1 }}>
                              {getBiometricName(type)}
                            </Typography>
                          </Box>
                        }
                      />
                    ))}
                  </RadioGroup>
                </FormControl>
              </CardContent>
            </Card>
          )}

          {/* Error Alert */}
          {error && (
            <Alert severity="error" sx={{ mb: 3 }}>
              {error}
            </Alert>
          )}

          {/* Security Info */}
          <Alert severity="info" icon={<Security />} sx={{ mb: 3 }}>
            Your biometric data is processed locally on your device and is never transmitted or stored on our servers.
          </Alert>

          {/* Authenticate Button */}
          <Button
            fullWidth
            variant="contained"
            size="large"
            onClick={authenticateWithBiometric}
            disabled={isLoading}
            sx={{ height: 56, mb: 2 }}
          >
            {isLoading ? (
              <Box display="flex" alignItems="center">
                <CircularProgress size={20} sx={{ mr: 1 }} />
                Authenticating...
              </Box>
            ) : (
              `${isSetup ? 'Enable' : 'Authenticate with'} ${getBiometricName(selectedBiometric)}`
            )}
          </Button>

          {/* Alternative Actions */}
          {isSetup ? (
            <Button
              fullWidth
              variant="text"
              onClick={onSetupComplete}
              sx={{ textTransform: 'none' }}
            >
              Skip for Now
            </Button>
          ) : (
            <Button
              fullWidth
              variant="outlined"
              size="large"
              onClick={onNavigateBack}
              sx={{ height: 56 }}
            >
              Use Password Instead
            </Button>
          )}
        </Paper>
      </Box>
    </Container>
  );
};

export default BiometricAuthScreen;