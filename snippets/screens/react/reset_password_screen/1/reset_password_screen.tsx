import React, { useState, useEffect } from 'react';
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
  IconButton,
  LinearProgress,
  List,
  ListItem,
  ListItemIcon,
  ListItemText
} from '@mui/material';
import {
  Lock,
  LockReset,
  CheckCircle,
  Visibility,
  VisibilityOff,
  Security,
  Check,
  RadioButtonUnchecked
} from '@mui/icons-material';

interface FormData {
  password: string;
  confirmPassword: string;
}

interface FormErrors {
  password?: string;
  confirmPassword?: string;
  general?: string;
}

interface PasswordStrength {
  score: number;
  text: string;
  color: string;
}

interface PasswordRequirement {
  label: string;
  test: (password: string) => boolean;
  met: boolean;
}

interface ResetPasswordScreenProps {
  token?: string;
}

const ResetPasswordScreen: React.FC<ResetPasswordScreenProps> = ({ token }) => {
  const [formData, setFormData] = useState<FormData>({
    password: '',
    confirmPassword: ''
  });

  const [errors, setErrors] = useState<FormErrors>({});
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [passwordReset, setPasswordReset] = useState(false);
  const [validToken, setValidToken] = useState(true);

  useEffect(() => {
    // Validate token on component mount
    if (!token) {
      setValidToken(false);
      setErrors({ general: 'Invalid or expired reset link' });
    }
  }, [token]);

  const validatePassword = (password: string): boolean => {
    return password.length >= 8 &&
           /[A-Z]/.test(password) &&
           /[a-z]/.test(password) &&
           /\d/.test(password) &&
           /[^A-Za-z0-9]/.test(password);
  };

  const calculatePasswordStrength = (password: string): PasswordStrength => {
    let score = 0;
    if (password.length >= 8) score++;
    if (/[A-Z]/.test(password)) score++;
    if (/[a-z]/.test(password)) score++;
    if (/\d/.test(password)) score++;
    if (/[^A-Za-z0-9]/.test(password)) score++;

    if (score <= 1) return { score, text: 'Weak', color: '#f44336' };
    if (score <= 3) return { score, text: 'Medium', color: '#ff9800' };
    return { score, text: 'Strong', color: '#4caf50' };
  };

  const getPasswordRequirements = (password: string): PasswordRequirement[] => [
    {
      label: 'At least 8 characters long',
      test: (pwd) => pwd.length >= 8,
      met: password.length >= 8
    },
    {
      label: 'Contains uppercase and lowercase letters',
      test: (pwd) => /[A-Z]/.test(pwd) && /[a-z]/.test(pwd),
      met: /[A-Z]/.test(password) && /[a-z]/.test(password)
    },
    {
      label: 'Contains at least one number',
      test: (pwd) => /\d/.test(pwd),
      met: /\d/.test(password)
    },
    {
      label: 'Contains at least one special character',
      test: (pwd) => /[^A-Za-z0-9]/.test(pwd),
      met: /[^A-Za-z0-9]/.test(password)
    }
  ];

  const validateForm = (): boolean => {
    const newErrors: FormErrors = {};

    if (!formData.password) {
      newErrors.password = 'Password is required';
    } else if (!validatePassword(formData.password)) {
      newErrors.password = 'Password must meet all requirements';
    }

    if (!formData.confirmPassword) {
      newErrors.confirmPassword = 'Please confirm your password';
    } else if (formData.password !== formData.confirmPassword) {
      newErrors.confirmPassword = 'Passwords do not match';
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleInputChange = (field: keyof FormData) => (
    event: React.ChangeEvent<HTMLInputElement>
  ) => {
    const { value } = event.target;
    setFormData(prev => ({ ...prev, [field]: value }));

    // Clear error when user starts typing
    if (errors[field]) {
      setErrors(prev => ({ ...prev, [field]: undefined }));
    }
  };

  const handleSubmit = async (event: React.FormEvent) => {
    event.preventDefault();

    if (!validToken || !validateForm()) return;

    setIsLoading(true);
    setErrors({});

    try {
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 2000));
      setPasswordReset(true);
    } catch (error) {
      setErrors({ general: 'Failed to reset password. Please try again or request a new reset link.' });
    } finally {
      setIsLoading(false);
    }
  };

  const handleContinueToLogin = () => {
    // Navigate to login screen
    console.log('Navigate to login');
  };

  const passwordStrength = formData.password ? calculatePasswordStrength(formData.password) : null;
  const passwordRequirements = getPasswordRequirements(formData.password);

  if (passwordReset) {
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
              Password Reset Successfully!
            </Typography>

            <Typography variant="body1" color="text.secondary" paragraph sx={{ mb: 4 }}>
              Your password has been reset successfully. You can now sign in with your new password.
            </Typography>

            {/* Continue Button */}
            <Button
              fullWidth
              variant="contained"
              size="large"
              onClick={handleContinueToLogin}
              sx={{ height: 56 }}
            >
              Continue to Sign In
            </Button>
          </Paper>
        </Box>
      </Container>
    );
  }

  return (
    <Container maxWidth="sm">
      <Box sx={{ mt: 4, mb: 4 }}>
        <Paper elevation={3} sx={{ p: 4 }}>
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
              Create New Password
            </Typography>
            <Typography variant="body1" color="text.secondary">
              Enter a new password for your account.
            </Typography>
          </Box>

          {/* Error Alert */}
          {errors.general && (
            <Alert severity="error" sx={{ mb: 3 }}>
              {errors.general}
            </Alert>
          )}

          <form onSubmit={handleSubmit}>
            {/* New Password */}
            <TextField
              fullWidth
              label="New Password"
              type={showPassword ? 'text' : 'password'}
              value={formData.password}
              onChange={handleInputChange('password')}
              error={!!errors.password}
              helperText={errors.password || 'At least 8 characters with uppercase, lowercase, number, and special character'}
              InputProps={{
                startAdornment: (
                  <InputAdornment position="start">
                    <Lock />
                  </InputAdornment>
                ),
                endAdornment: (
                  <InputAdornment position="end">
                    <IconButton
                      onClick={() => setShowPassword(!showPassword)}
                      edge="end"
                    >
                      {showPassword ? <VisibilityOff /> : <Visibility />}
                    </IconButton>
                  </InputAdornment>
                )
              }}
              disabled={isLoading}
              sx={{ mb: 2 }}
            />

            {/* Password Strength Indicator */}
            {passwordStrength && (
              <Box mb={2}>
                <LinearProgress
                  variant="determinate"
                  value={(passwordStrength.score / 5) * 100}
                  sx={{
                    height: 4,
                    borderRadius: 2,
                    backgroundColor: '#e0e0e0',
                    '& .MuiLinearProgress-bar': {
                      backgroundColor: passwordStrength.color
                    }
                  }}
                />
                <Typography
                  variant="caption"
                  sx={{ color: passwordStrength.color, mt: 0.5, display: 'block' }}
                >
                  Password strength: {passwordStrength.text}
                </Typography>
              </Box>
            )}

            {/* Confirm Password */}
            <TextField
              fullWidth
              label="Confirm New Password"
              type={showConfirmPassword ? 'text' : 'password'}
              value={formData.confirmPassword}
              onChange={handleInputChange('confirmPassword')}
              error={!!errors.confirmPassword}
              helperText={errors.confirmPassword}
              InputProps={{
                startAdornment: (
                  <InputAdornment position="start">
                    <Lock />
                  </InputAdornment>
                ),
                endAdornment: (
                  <InputAdornment position="end">
                    <IconButton
                      onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                      edge="end"
                    >
                      {showConfirmPassword ? <VisibilityOff /> : <Visibility />}
                    </IconButton>
                  </InputAdornment>
                )
              }}
              disabled={isLoading}
              sx={{ mb: 3 }}
            />

            {/* Password Requirements */}
            <Card sx={{ mb: 3, bgcolor: 'primary.light', color: 'primary.contrastText' }}>
              <CardContent>
                <Box display="flex" alignItems="center" mb={1}>
                  <Security sx={{ mr: 1 }} />
                  <Typography variant="subtitle2" fontWeight="bold">
                    Password Requirements:
                  </Typography>
                </Box>
                <List dense>
                  {passwordRequirements.map((requirement, index) => (
                    <ListItem key={index} sx={{ py: 0.5 }}>
                      <ListItemIcon sx={{ minWidth: 28 }}>
                        {requirement.met ? (
                          <Check sx={{ fontSize: 16, color: 'success.main' }} />
                        ) : (
                          <RadioButtonUnchecked sx={{ fontSize: 16, color: 'text.secondary' }} />
                        )}
                      </ListItemIcon>
                      <ListItemText
                        primary={requirement.label}
                        primaryTypographyProps={{
                          variant: 'caption',
                          color: requirement.met ? 'success.main' : 'text.secondary'
                        }}
                      />
                    </ListItem>
                  ))}
                </List>
              </CardContent>
            </Card>

            {/* Reset Password Button */}
            <Button
              type="submit"
              fullWidth
              variant="contained"
              size="large"
              disabled={isLoading || !validToken}
              sx={{ height: 56, mb: 3 }}
            >
              {isLoading ? 'Resetting Password...' : 'Reset Password'}
            </Button>

            {/* Back to Login */}
            <Box textAlign="center">
              <Button
                color="primary"
                onClick={handleContinueToLogin}
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

export default ResetPasswordScreen;