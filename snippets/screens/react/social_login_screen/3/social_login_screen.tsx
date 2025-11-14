import React, { useState } from 'react';
import {
  Typography,
  Box,
  Container,
  Paper,
  Alert,
  Card,
  CardContent,
  Button,
  Divider,
  Grid,
  CircularProgress
} from '@mui/material';
import {
  Google,
  Facebook,
  Apple,
  Microsoft,
  GitHub,
  AccountCircle,
  Security,
  Email,
  Twitter
} from '@mui/icons-material';

enum SocialProvider {
  GOOGLE = 'google',
  APPLE = 'apple',
  FACEBOOK = 'facebook',
  MICROSOFT = 'microsoft',
  TWITTER = 'twitter',
  GITHUB = 'github'
}

interface SocialLoginScreenProps {
  onNavigateToEmailLogin?: () => Unit;
  onNavigateToSignup?: () => Unit;
  onLoginSuccess?: () => Unit;
}

const SocialLoginScreen: React.FC<SocialLoginScreenProps> = ({
  onNavigateToEmailLogin,
  onNavigateToSignup,
  onLoginSuccess
}) => {
  const [isLoading, setIsLoading] = useState(false);
  const [loadingProvider, setLoadingProvider] = useState<SocialProvider | null>(null);
  const [error, setError] = useState<string>('');

  const socialProviders = [
    {
      provider: SocialProvider.GOOGLE,
      name: 'Google',
      icon: <Google />,
      color: '#DB4437',
      bgColor: '#ffffff'
    },
    {
      provider: SocialProvider.APPLE,
      name: 'Apple',
      icon: <Apple />,
      color: '#000000',
      bgColor: '#ffffff'
    },
    {
      provider: SocialProvider.FACEBOOK,
      name: 'Facebook',
      icon: <Facebook />,
      color: '#4267B2',
      bgColor: '#ffffff'
    },
    {
      provider: SocialProvider.MICROSOFT,
      name: 'Microsoft',
      icon: <Microsoft />,
      color: '#0078D4',
      bgColor: '#ffffff'
    },
    {
      provider: SocialProvider.TWITTER,
      name: 'Twitter',
      icon: <Twitter />,
      color: '#1DA1F2',
      bgColor: '#ffffff'
    },
    {
      provider: SocialProvider.GITHUB,
      name: 'GitHub',
      icon: <GitHub />,
      color: '#333333',
      bgColor: '#ffffff'
    }
  ];

  const signInWith = async (provider: SocialProvider) => {
    setIsLoading(true);
    setLoadingProvider(provider);
    setError('');

    try {
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 2000));

      // Handle successful login
      console.log(`Successfully signed in with ${provider}!`);
      onLoginSuccess?.();
    } catch (error) {
      setError(`Failed to sign in with ${provider}. Please try again.`);
    } finally {
      setIsLoading(false);
      setLoadingProvider(null);
    }
  };

  return (
    <Container maxWidth="sm">
      <Box sx={{ mt: 4, mb: 4 }}>
        <Paper elevation={3} sx={{ p: 4 }}>
          <Box textAlign="center" mb={4}>
            {/* App Logo */}
            <Card
              sx={{
                width: 80,
                height: 80,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                mx: 'auto',
                mb: 3,
                background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
                color: 'white'
              }}
            >
              <AccountCircle sx={{ fontSize: 50 }} />
            </Card>

            {/* Header */}
            <Typography variant="h4" component="h1" fontWeight="bold" gutterBottom>
              Welcome Back
            </Typography>
            <Typography variant="body1" color="text.secondary">
              Choose your preferred sign-in method
            </Typography>
          </Box>

          {/* Error Alert */}
          {error && (
            <Alert severity="error" sx={{ mb: 3 }}>
              {error}
            </Alert>
          )}

          {/* Social Login Buttons */}
          <Box sx={{ mb: 4 }}>
            {socialProviders.map(({ provider, name, icon, color, bgColor }) => (
              <Button
                key={provider}
                fullWidth
                variant="outlined"
                size="large"
                onClick={() => signInWith(provider)}
                disabled={isLoading}
                startIcon={
                  isLoading && loadingProvider === provider ? (
                    <CircularProgress size={20} sx={{ color }} />
                  ) : (
                    React.cloneElement(icon, { sx: { color } })
                  )
                }
                sx={{
                  height: 56,
                  mb: 1.5,
                  backgroundColor: bgColor,
                  borderColor: '#e0e0e0',
                  color: '#333333',
                  justifyContent: 'flex-start',
                  textTransform: 'none',
                  fontSize: '16px',
                  fontWeight: 500,
                  '&:hover': {
                    backgroundColor: '#f5f5f5',
                    borderColor: '#d0d0d0'
                  },
                  '&:disabled': {
                    backgroundColor: bgColor,
                    color: '#999999'
                  }
                }}
              >
                <Box sx={{ width: '100%', textAlign: 'left', ml: 2 }}>
                  Continue with {name}
                </Box>
              </Button>
            ))}
          </Box>

          {/* Divider */}
          <Box display="flex" alignItems="center" my={3}>
            <Divider sx={{ flex: 1 }} />
            <Typography
              variant="body2"
              color="text.secondary"
              sx={{ mx: 2, fontWeight: 500 }}
            >
              OR
            </Typography>
            <Divider sx={{ flex: 1 }} />
          </Box>

          {/* Email Login Button */}
          <Button
            fullWidth
            variant="contained"
            size="large"
            onClick={onNavigateToEmailLogin}
            startIcon={<Email />}
            sx={{
              height: 56,
              mb: 4,
              textTransform: 'none',
              fontSize: '16px',
              fontWeight: 600
            }}
          >
            Sign in with Email
          </Button>

          {/* Privacy Notice */}
          <Card sx={{ mb: 3, bgcolor: 'primary.light' }}>
            <CardContent>
              <Box display="flex" alignItems="flex-start">
                <Security sx={{ color: 'primary.main', mr: 2, mt: 0.5 }} />
                <Box>
                  <Typography variant="subtitle2" fontWeight="bold" color="primary.main">
                    Your Privacy Matters
                  </Typography>
                  <Typography variant="body2" color="primary.main">
                    We use secure authentication and never store your social media passwords.
                  </Typography>
                </Box>
              </Box>
            </CardContent>
          </Card>

          {/* Sign Up Link */}
          <Box textAlign="center" mb={3}>
            <Typography variant="body2" color="text.secondary">
              Don't have an account?{' '}
              <Box
                component="span"
                sx={{
                  color: 'primary.main',
                  cursor: 'pointer',
                  fontWeight: 'medium',
                  textDecoration: 'underline'
                }}
                onClick={onNavigateToSignup}
              >
                Sign Up
              </Box>
            </Typography>
          </Box>

          {/* Terms and Privacy */}
          <Typography variant="caption" color="text.secondary" textAlign="center" display="block">
            By continuing, you agree to our{' '}
            <Box component="span" sx={{ color: 'primary.main', textDecoration: 'underline', cursor: 'pointer' }}>
              Terms of Service
            </Box>{' '}
            and{' '}
            <Box component="span" sx={{ color: 'primary.main', textDecoration: 'underline', cursor: 'pointer' }}>
              Privacy Policy
            </Box>
          </Typography>
        </Paper>
      </Box>
    </Container>
  );
};

// Compact Social Login Component for use in other screens
interface CompactSocialLoginProps {
  onProviderSelected: (provider: SocialProvider) => Unit;
  isLoading?: boolean;
}

export const CompactSocialLogin: React.FC<CompactSocialLoginProps> = ({
  onProviderSelected,
  isLoading = false
}) => {
  const mainProviders = [
    { provider: SocialProvider.GOOGLE, name: 'Google', icon: <Google />, color: '#DB4437' },
    { provider: SocialProvider.APPLE, name: 'Apple', icon: <Apple />, color: '#000000' },
    { provider: SocialProvider.FACEBOOK, name: 'Facebook', icon: <Facebook />, color: '#4267B2' }
  ];

  return (
    <Box>
      {/* Divider */}
      <Box display="flex" alignItems="center" my={3}>
        <Divider sx={{ flex: 1 }} />
        <Typography
          variant="body2"
          color="text.secondary"
          sx={{ mx: 2, fontWeight: 500 }}
        >
          OR
        </Typography>
        <Divider sx={{ flex: 1 }} />
      </Box>

      {/* Social Buttons Row */}
      <Grid container spacing={1.5}>
        {mainProviders.map(({ provider, name, icon, color }) => (
          <Grid item xs={4} key={provider}>
            <Button
              fullWidth
              variant="outlined"
              onClick={() => onProviderSelected(provider)}
              disabled={isLoading}
              sx={{
                height: 50,
                borderColor: '#e0e0e0',
                '&:hover': {
                  backgroundColor: '#f5f5f5'
                }
              }}
            >
              {React.cloneElement(icon, { sx: { color } })}
            </Button>
          </Grid>
        ))}
      </Grid>
    </Box>
  );
};

// Full-width colored social buttons alternative
interface FullWidthSocialLoginProps {
  providers: SocialProvider[];
  onProviderSelected: (provider: SocialProvider) => Unit;
  isLoading?: boolean;
  loadingProvider?: SocialProvider | null;
}

export const FullWidthSocialLogin: React.FC<FullWidthSocialLoginProps> = ({
  providers,
  onProviderSelected,
  isLoading = false,
  loadingProvider = null
}) => {
  const providerConfigs = {
    [SocialProvider.GOOGLE]: { name: 'Google', icon: <Google />, color: '#DB4437' },
    [SocialProvider.APPLE]: { name: 'Apple', icon: <Apple />, color: '#000000' },
    [SocialProvider.FACEBOOK]: { name: 'Facebook', icon: <Facebook />, color: '#4267B2' },
    [SocialProvider.MICROSOFT]: { name: 'Microsoft', icon: <Microsoft />, color: '#0078D4' },
    [SocialProvider.TWITTER]: { name: 'Twitter', icon: <Twitter />, color: '#1DA1F2' },
    [SocialProvider.GITHUB]: { name: 'GitHub', icon: <GitHub />, color: '#333333' }
  };

  return (
    <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1.5 }}>
      {providers.map(provider => {
        const config = providerConfigs[provider];
        const isCurrentlyLoading = isLoading && loadingProvider === provider;

        return (
          <Button
            key={provider}
            fullWidth
            variant="contained"
            size="large"
            onClick={() => onProviderSelected(provider)}
            disabled={isLoading}
            startIcon={
              isCurrentlyLoading ? (
                <CircularProgress size={20} sx={{ color: 'white' }} />
              ) : (
                React.cloneElement(config.icon, { sx: { color: 'white' } })
              )
            }
            sx={{
              height: 56,
              backgroundColor: config.color,
              textTransform: 'none',
              fontSize: '16px',
              fontWeight: 600,
              '&:hover': {
                backgroundColor: config.color,
                opacity: 0.9
              }
            }}
          >
            <Box sx={{ width: '100%', textAlign: 'left', ml: 2 }}>
              Continue with {config.name}
            </Box>
          </Button>
        );
      })}
    </Box>
  );
};

export default SocialLoginScreen;