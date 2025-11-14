import React, { useState, useEffect, useRef } from 'react';
import {
  Typography,
  Box,
  Container,
  Paper,
  Alert,
  Card,
  CardContent,
  Button,
  TextField,
  IconButton
} from '@mui/material';
import {
  Smartphone,
  Info,
  ArrowBack,
  Refresh
} from '@mui/icons-material';

interface OTPVerificationScreenProps {
  phoneNumber?: string;
  email?: string;
  onVerificationSuccess?: () => Unit;
  onNavigateBack?: () => Unit;
}

const OTPVerificationScreen: React.FC<OTPVerificationScreenProps> = ({
  phoneNumber = '',
  email = '',
  onVerificationSuccess,
  onNavigateBack
}) => {
  const [otp, setOtp] = useState<string[]>(Array(6).fill(''));
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string>('');
  const [canResend, setCanResend] = useState(false);
  const [countdown, setCountdown] = useState(30);

  const inputRefs = useRef<(HTMLInputElement | null)[]>([]);

  useEffect(() => {
    startCountdown();
    // Focus first input
    inputRefs.current[0]?.focus();
  }, []);

  const startCountdown = () => {
    setCanResend(false);
    setCountdown(30);

    const timer = setInterval(() => {
      setCountdown(prev => {
        if (prev <= 1) {
          setCanResend(true);
          clearInterval(timer);
          return 0;
        }
        return prev - 1;
      });
    }, 1000);

    return () => clearInterval(timer);
  };

  const handleInputChange = (index: number, value: string) => {
    // Only allow digits
    if (value && !/^\d$/.test(value)) return;

    const newOtp = [...otp];
    newOtp[index] = value;
    setOtp(newOtp);

    // Clear error when user starts typing
    if (error) setError('');

    // Auto-focus next input
    if (value && index < 5) {
      inputRefs.current[index + 1]?.focus();
    }

    // Auto-verify when all fields are filled
    if (newOtp.every(digit => digit !== '') && newOtp.join('').length === 6) {
      verifyOtp(newOtp.join(''));
    }
  };

  const handleKeyDown = (index: number, event: React.KeyboardEvent) => {
    if (event.key === 'Backspace') {
      if (!otp[index] && index > 0) {
        // Move to previous input if current is empty
        inputRefs.current[index - 1]?.focus();
      } else {
        // Clear current input
        const newOtp = [...otp];
        newOtp[index] = '';
        setOtp(newOtp);
      }
    } else if (event.key === 'ArrowLeft' && index > 0) {
      inputRefs.current[index - 1]?.focus();
    } else if (event.key === 'ArrowRight' && index < 5) {
      inputRefs.current[index + 1]?.focus();
    }
  };

  const handlePaste = (event: React.ClipboardEvent) => {
    event.preventDefault();
    const pastedData = event.clipboardData.getData('text').replace(/\D/g, '');

    if (pastedData.length === 6) {
      const newOtp = pastedData.split('');
      setOtp(newOtp);
      verifyOtp(pastedData);
    }
  };

  const verifyOtp = async (otpCode: string = otp.join('')) => {
    if (otpCode.length !== 6) return;

    setIsLoading(true);
    setError('');

    try {
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 2000));

      // Mock verification - in real app, call your API
      if (otpCode === '123456') {
        onVerificationSuccess?.();
      } else {
        throw new Error('Invalid OTP');
      }
    } catch (error) {
      setError('Invalid OTP. Please check and try again.');
      clearOtp();
    } finally {
      setIsLoading(false);
    }
  };

  const resendOtp = async () => {
    if (!canResend) return;

    setIsLoading(true);
    setError('');

    try {
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 1000));
      startCountdown();
      // Show success message
      console.log('OTP sent successfully!');
    } catch (error) {
      setError('Failed to resend OTP. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  const clearOtp = () => {
    setOtp(Array(6).fill(''));
    inputRefs.current[0]?.focus();
  };

  const handleVerifyButton = () => {
    verifyOtp();
  };

  const isOtpComplete = otp.every(digit => digit !== '');

  return (
    <Container maxWidth="sm">
      <Box sx={{ mt: 4, mb: 4 }}>
        <Paper elevation={3} sx={{ p: 4 }}>
          {/* Back Button */}
          <Box sx={{ display: 'flex', justifyContent: 'flex-start', mb: 2 }}>
            <IconButton onClick={onNavigateBack}>
              <ArrowBack />
            </IconButton>
          </Box>

          <Box textAlign="center" mb={4}>
            {/* Icon */}
            <Smartphone
              sx={{
                fontSize: 80,
                color: 'primary.main',
                mb: 3
              }}
            />

            {/* Header */}
            <Typography variant="h4" component="h1" fontWeight="bold" gutterBottom>
              Verify Your Account
            </Typography>
            <Typography variant="body1" color="text.secondary">
              We've sent a 6-digit code to
              <br />
              {phoneNumber || email}
            </Typography>
          </Box>

          {/* OTP Input Fields */}
          <Box
            display="flex"
            justifyContent="center"
            gap={1.5}
            mb={3}
            onPaste={handlePaste}
          >
            {otp.map((digit, index) => (
              <TextField
                key={index}
                inputRef={el => inputRefs.current[index] = el}
                value={digit}
                onChange={(e) => handleInputChange(index, e.target.value)}
                onKeyDown={(e) => handleKeyDown(index, e)}
                disabled={isLoading}
                inputProps={{
                  maxLength: 1,
                  style: {
                    textAlign: 'center',
                    fontSize: '24px',
                    fontWeight: 'bold',
                    padding: '16px 0'
                  }
                }}
                sx={{
                  width: 56,
                  '& .MuiOutlinedInput-root': {
                    '&.Mui-focused fieldset': {
                      borderWidth: 2,
                      borderColor: 'primary.main'
                    }
                  }
                }}
              />
            ))}
          </Box>

          {/* Error Alert */}
          {error && (
            <Alert severity="error" sx={{ mb: 3 }}>
              {error}
            </Alert>
          )}

          {/* Resend Section */}
          <Box display="flex" justifyContent="center" alignItems="center" mb={3}>
            <Typography variant="body2" color="text.secondary">
              Didn't receive the code?{' '}
            </Typography>
            {canResend ? (
              <Button
                onClick={resendOtp}
                disabled={isLoading}
                sx={{ ml: 1, textTransform: 'none' }}
              >
                Resend
              </Button>
            ) : (
              <Typography variant="body2" color="text.secondary" sx={{ ml: 1 }}>
                Resend in {countdown}s
              </Typography>
            )}
          </Box>

          {/* Verify Button */}
          <Button
            fullWidth
            variant="contained"
            size="large"
            onClick={handleVerifyButton}
            disabled={!isOtpComplete || isLoading}
            sx={{
              height: 56,
              mb: 3,
              backgroundColor: isOtpComplete ? 'primary.main' : 'action.disabled'
            }}
          >
            {isLoading ? 'Verifying...' : 'Verify OTP'}
          </Button>

          {/* Info Card */}
          <Card sx={{ bgcolor: 'info.light' }}>
            <CardContent>
              <Box display="flex" alignItems="flex-start">
                <Info sx={{ color: 'info.main', mr: 1, mt: 0.5, fontSize: 20 }} />
                <Typography variant="body2" color="info.main">
                  Enter the 6-digit code sent to your {phoneNumber ? 'phone' : 'email'}.
                  The code expires in 10 minutes.
                </Typography>
              </Box>
            </CardContent>
          </Card>

          {/* Change Contact Info */}
          <Box textAlign="center" mt={4}>
            <Button
              color="primary"
              onClick={onNavigateBack}
              sx={{ textTransform: 'none' }}
            >
              Change {phoneNumber ? 'Phone Number' : 'Email'}
            </Button>
          </Box>
        </Paper>
      </Box>
    </Container>
  );
};

export default OTPVerificationScreen;