import React, { useState } from 'react';
import {
  TextField,
  Button,
  Typography,
  Box,
  Container,
  Paper,
  Alert,
  Card,
  CardContent,
  InputAdornment,
  IconButton
} from '@mui/material';
import {
  Email,
  LockReset,
  CheckCircle,
  Info,
  ArrowBack,
  Refresh
} from '@mui/icons-material';

interface FormData {
  email: string;
}

interface FormErrors {
  email?: string;
  general?: string;
}

const ForgotPasswordScreen: React.FC = () => {
  const [formData, setFormData] = useState<FormData>({ email: '' });
  const [errors, setErrors] = useState<FormErrors>({});
  const [isLoading, setIsLoading] = useState(false);
  const [emailSent, setEmailSent] = useState(false);

  const validateEmail = (email: string): boolean => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  };

  const validateForm = (): boolean => {
    const newErrors: FormErrors = {};

    if (!formData.email.trim()) {
      newErrors.email = 'Email is required';
    } else if (!validateEmail(formData.email)) {
      newErrors.email = 'Enter a valid email';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleInputChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const { value } = event.target;
    setFormData({ email: value });

    // Clear error when user starts typing
    if (errors.email) {
      setErrors(prev => ({ ...prev, email: undefined }));
    }
  };

  const handleSendResetLink = async (event: React.FormEvent) => {
    event.preventDefault();

    if (!validateForm()) return;

    setIsLoading(true);
    setErrors({});

    try {
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 2000));
      setEmailSent(true);
    } catch (error) {
      setErrors({ general: 'Failed to send reset email. Please try again.' });
    } finally {
      setIsLoading(false);
    }
  };

  const handleResendEmail = async () => {
    setIsLoading(true);
    setErrors({});

    try {
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 1000));
      // Show success message or update UI
      console.log('Reset email sent again!');
    } catch (error) {
      setErrors({ general: 'Failed to resend email. Please try again.' });
    } finally {
      setIsLoading(false);
    }
  };

  const handleBackToLogin = () => {
    // Navigate to login screen
    console.log('Navigate to login');
  };

  const handleUseDifferentEmail = () => {
    setEmailSent(false);
    setFormData({ email: '' });
    setErrors({});
  };

  if (emailSent) {
    return (
      <Container maxWidth="sm">
        <Box sx={{ mt: 4, mb: 4 }}>
          <Paper elevation={3} sx={{ p: 4, textAlign: 'center' }}>
            {/* Back Button */}
            <Box sx={{ display: 'flex', justifyContent: 'flex-start', mb: 2 }}>
              <IconButton onClick={handleBackToLogin}>
                <ArrowBack />
              </IconButton>
            </Box>

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
              Check Your Email
            </Typography>

            <Typography variant="body1" color="text.secondary" paragraph>
              We've sent a password reset link to:
            </Typography>

            <Typography variant="body1" fontWeight="bold" gutterBottom>
              {formData.email}
            </Typography>

            {/* Info Alert */}
            <Alert
              icon={<Info />}
              severity="info"
              sx={{ mt: 3, mb: 3, textAlign: 'left' }}
            >
              Didn't receive the email? Check your spam folder or try again.
            </Alert>

            {/* Resend Button */}
            <Button
              fullWidth
              variant="contained"
              size="large"
              onClick={handleResendEmail}
              disabled={isLoading}
              startIcon={<Refresh />}
              sx={{ height: 56, mb: 2 }}
            >
              {isLoading ? 'Sending...' : 'Resend Email'}
            </Button>

            {/* Back to Login */}
            <Button
              fullWidth
              variant="outlined"
              size="large"
              onClick={handleBackToLogin}
              sx={{ height: 56, mb: 2 }}
            >
              Back to Sign In
            </Button>

            {/* Error Alert */}
            {errors.general && (
              <Alert severity="error" sx={{ mt: 2 }}>
                {errors.general}
              </Alert>
            )}

            {/* Use Different Email */}
            <Box mt={3}>
              <Button
                color="primary"
                onClick={handleUseDifferentEmail}
              >
                Use Different Email
              </Button>
            </Box>
          </Paper>
        </Box>
      </Container>
    );
  }

  return (
    <Container maxWidth="sm">
      <Box sx={{ mt: 4, mb: 4 }}>
        <Paper elevation={3} sx={{ p: 4 }}>
          {/* Back Button */}
          <Box sx={{ display: 'flex', justifyContent: 'flex-start', mb: 2 }}>
            <IconButton onClick={handleBackToLogin}>
              <ArrowBack />
            </IconButton>
          </Box>

          <Box textAlign="center" mb={4}>
            {/* Icon */}
            <LockReset
              sx={{
                fontSize: 80,
                color: 'primary.main',
                mb: 3
              }}
            />

            {/* Header */}
            <Typography variant="h4" component="h1" fontWeight="bold" gutterBottom>
              Forgot Password?
            </Typography>
            <Typography variant="body1" color="text.secondary">
              Enter your email address and we'll send you a link to reset your password.
            </Typography>
          </Box>

          <form onSubmit={handleSendResetLink}>
            {/* Email Input */}
            <TextField
              fullWidth
              label="Email Address"
              type="email"
              value={formData.email}
              onChange={handleInputChange}
              error={!!errors.email}
              helperText={errors.email || "We'll send a reset link to this email"}
              InputProps={{
                startAdornment: (
                  <InputAdornment position="start">
                    <Email />
                  </InputAdornment>
                )
              }}
              disabled={isLoading}
              sx={{ mb: 2 }}
            />

            {/* Error Alert */}
            {errors.general && (
              <Alert severity="error" sx={{ mb: 3 }}>
                {errors.general}
              </Alert>
            )}

            {/* Send Reset Link Button */}
            <Button
              type="submit"
              fullWidth
              variant="contained"
              size="large"
              disabled={isLoading || !formData.email}
              sx={{ height: 56, mb: 3 }}
            >
              {isLoading ? 'Sending...' : 'Send Reset Link'}
            </Button>

            {/* Back to Login */}
            <Box textAlign="center">
              <Button
                color="primary"
                onClick={handleBackToLogin}
              >
                Back to Sign In
              </Button>
            </Box>
          </form>
        </Paper>
      </Box>
    </Container>
  );
};

export default ForgotPasswordScreen;