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
  IconButton,
  Grid,
  Stepper,
  Step,
  StepLabel,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  Chip
} from '@mui/material';
import {
  Security,
  ArrowBack,
  CheckCircle,
  ContentCopy,
  QrCode,
  Warning
} from '@mui/icons-material';

enum TwoFactorMode {
  Setup = 'setup',
  Verify = 'verify'
}

interface TwoFactorAuthScreenProps {
  mode?: TwoFactorMode;
  qrCodeUrl?: string;
  secret?: string;
  onNavigateBack?: () => Unit;
  onSetupComplete?: () => Unit;
  onVerificationSuccess?: () => Unit;
}

const TwoFactorAuthScreen: React.FC<TwoFactorAuthScreenProps> = ({
  mode = TwoFactorMode.Setup,
  qrCodeUrl,
  secret = 'JBSWY3DPEHPK3PXP',
  onNavigateBack,
  onSetupComplete,
  onVerificationSuccess
}) => {
  const [verificationCode, setVerificationCode] = useState<string[]>(Array(6).fill(''));
  const [isLoading, setIsLoading] = useState(false);
  const [setupComplete, setSetupComplete] = useState(false);
  const [error, setError] = useState<string>('');
  const [backupCodes, setBackupCodes] = useState<string[]>([]);
  const [showBackupCodeDialog, setShowBackupCodeDialog] = useState(false);
  const [backupCodeInput, setBackupCodeInput] = useState('');

  const inputRefs = useRef<(HTMLInputElement | null)[]>([]);

  useEffect(() => {
    if (mode === TwoFactorMode.Setup) {
      generateBackupCodes();
    }
    // Focus first input
    inputRefs.current[0]?.focus();
  }, [mode]);

  const generateBackupCodes = () => {
    // Generate 8 backup codes
    const codes = Array.from({ length: 8 }, () => {
      const part1 = Math.random().toString(36).substring(2, 6).toUpperCase();
      const part2 = Math.random().toString(36).substring(2, 6).toUpperCase();
      return `${part1}-${part2}`;
    });
    setBackupCodes(codes);
  };

  const handleInputChange = (index: number, value: string) => {
    // Only allow digits
    if (value && !/^\d$/.test(value)) return;

    const newCode = [...verificationCode];
    newCode[index] = value;
    setVerificationCode(newCode);

    // Clear error when user starts typing
    if (error) setError('');

    // Auto-focus next input
    if (value && index < 5) {
      inputRefs.current[index + 1]?.focus();
    }

    // Auto-verify when all fields are filled
    if (newCode.every(digit => digit !== '') && newCode.join('').length === 6) {
      if (mode === TwoFactorMode.Setup) {
        enable2FA(newCode.join(''));
      } else {
        verify2FA(newCode.join(''));
      }
    }
  };

  const handleKeyDown = (index: number, event: React.KeyboardEvent) => {
    if (event.key === 'Backspace') {
      if (!verificationCode[index] && index > 0) {
        inputRefs.current[index - 1]?.focus();
      } else {
        const newCode = [...verificationCode];
        newCode[index] = '';
        setVerificationCode(newCode);
      }
    } else if (event.key === 'ArrowLeft' && index > 0) {
      inputRefs.current[index - 1]?.focus();
    } else if (event.key === 'ArrowRight' && index < 5) {
      inputRefs.current[index + 1]?.focus();
    }
  };

  const enable2FA = async (code: string = verificationCode.join('')) => {
    if (code.length !== 6) return;

    setIsLoading(true);
    setError('');

    try {
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 2000));
      setSetupComplete(true);
    } catch (error) {
      setError('Failed to enable 2FA. Please try again.');
      clearCode();
    } finally {
      setIsLoading(false);
    }
  };

  const verify2FA = async (code: string = verificationCode.join('')) => {
    if (code.length !== 6) return;

    setIsLoading(true);
    setError('');

    try {
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 2000));
      onVerificationSuccess?.();
    } catch (error) {
      setError('Invalid code. Please try again.');
      clearCode();
    } finally {
      setIsLoading(false);
    }
  };

  const clearCode = () => {
    setVerificationCode(Array(6).fill(''));
    inputRefs.current[0]?.focus();
  };

  const handleCopySecret = async () => {
    await navigator.clipboard.writeText(secret);
    // Show success message
  };

  const handleCopyAllBackupCodes = async () => {
    const allCodes = `Your backup codes:\n\n${backupCodes.join('\n')}`;
    await navigator.clipboard.writeText(allCodes);
  };

  const handleBackupCodeVerification = async () => {
    setShowBackupCodeDialog(false);
    // Handle backup code verification
    onVerificationSuccess?.();
  };

  const isCodeComplete = verificationCode.every(digit => digit !== '');

  if (mode === TwoFactorMode.Setup && setupComplete) {
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
              2FA Setup Complete!
            </Typography>

            <Typography variant="body1" color="text.secondary" paragraph>
              Save these backup codes in a safe place. You can use them to access your account
              if you lose your authenticator app.
            </Typography>

            {/* Warning Alert */}
            <Alert severity="warning" icon={<Warning />} sx={{ mb: 3, textAlign: 'left' }}>
              <Typography variant="subtitle2" fontWeight="bold" gutterBottom>
                Important: Save Your Backup Codes
              </Typography>
              <Typography variant="body2">
                These codes can only be used once. Store them securely offline.
              </Typography>
            </Alert>

            {/* Backup Codes Grid */}
            <Card sx={{ mb: 3, bgcolor: 'grey.50' }}>
              <CardContent>
                <Box display="flex" justifyContent="space-between" alignItems="center" mb={2}>
                  <Typography variant="subtitle1" fontWeight="bold">
                    Backup Codes
                  </Typography>
                  <IconButton onClick={handleCopyAllBackupCodes}>
                    <ContentCopy />
                  </IconButton>
                </Box>

                <Grid container spacing={1}>
                  {backupCodes.map((code, index) => (
                    <Grid item xs={6} key={index}>
                      <Paper
                        elevation={1}
                        sx={{
                          p: 1,
                          textAlign: 'center',
                          fontFamily: 'monospace',
                          fontWeight: 'bold',
                          fontSize: '0.9rem'
                        }}
                      >
                        {code}
                      </Paper>
                    </Grid>
                  ))}
                </Grid>
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
              Continue
            </Button>

            {/* Copy All Button */}
            <Button
              fullWidth
              variant="outlined"
              size="large"
              onClick={handleCopyAllBackupCodes}
              startIcon={<ContentCopy />}
              sx={{ height: 56 }}
            >
              Copy All Codes
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
          {/* Back Button */}
          <Box sx={{ display: 'flex', justifyContent: 'flex-start', mb: 2 }}>
            <IconButton onClick={onNavigateBack}>
              <ArrowBack />
            </IconButton>
          </Box>

          <Box textAlign="center" mb={4}>
            {/* Icon */}
            <Security
              sx={{
                fontSize: 80,
                color: 'primary.main',
                mb: 3
              }}
            />

            {/* Header */}
            <Typography variant="h4" component="h1" fontWeight="bold" gutterBottom>
              {mode === TwoFactorMode.Setup
                ? 'Setup Two-Factor Authentication'
                : 'Two-Factor Authentication'
              }
            </Typography>
            <Typography variant="body1" color="text.secondary">
              {mode === TwoFactorMode.Setup
                ? 'Secure your account with an additional layer of protection.'
                : 'Enter the 6-digit code from your authenticator app.'
              }
            </Typography>
          </Box>

          {mode === TwoFactorMode.Setup ? (
            <>
              {/* Setup Steps */}
              <Box mb={4}>
                <Stepper activeStep={2} orientation="vertical">
                  <Step completed>
                    <StepLabel>Install an Authenticator App</StepLabel>
                  </Step>
                  <Step completed>
                    <StepLabel>Scan QR Code or Enter Secret</StepLabel>
                  </Step>
                  <Step active>
                    <StepLabel>Enter Verification Code</StepLabel>
                  </Step>
                </Stepper>
              </Box>

              {/* Authenticator Apps */}
              <Card sx={{ mb: 3 }}>
                <CardContent>
                  <Typography variant="subtitle1" fontWeight="bold" gutterBottom>
                    Step 1: Install an Authenticator App
                  </Typography>
                  <Box display="flex" justifyContent="space-around" mt={2}>
                    {['Google Authenticator', 'Microsoft Authenticator', 'Authy'].map((app) => (
                      <Box key={app} textAlign="center">
                        <Paper
                          elevation={2}
                          sx={{
                            width: 60,
                            height: 60,
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                            mb: 1
                          }}
                        >
                          <Security />
                        </Paper>
                        <Typography variant="caption">{app}</Typography>
                      </Box>
                    ))}
                  </Box>
                </CardContent>
              </Card>

              {/* QR Code Section */}
              <Card sx={{ mb: 3 }}>
                <CardContent>
                  <Typography variant="subtitle1" fontWeight="bold" gutterBottom>
                    Step 2: Scan QR Code or Enter Secret
                  </Typography>

                  <Box textAlign="center" mb={2}>
                    {/* QR Code Placeholder */}
                    <Paper
                      elevation={2}
                      sx={{
                        width: 200,
                        height: 200,
                        display: 'flex',
                        flexDirection: 'column',
                        alignItems: 'center',
                        justifyContent: 'center',
                        mx: 'auto',
                        mb: 2
                      }}
                    >
                      <QrCode sx={{ fontSize: 60, color: 'text.secondary' }} />
                      <Typography variant="caption" color="text.secondary">
                        QR Code
                      </Typography>
                    </Paper>

                    <Typography variant="caption" display="block" mb={1}>
                      Can't scan? Enter this code manually:
                    </Typography>

                    <Paper
                      elevation={1}
                      sx={{
                        display: 'inline-flex',
                        alignItems: 'center',
                        p: 1,
                        bgcolor: 'grey.50'
                      }}
                    >
                      <Typography
                        variant="body2"
                        sx={{ fontFamily: 'monospace', fontWeight: 'bold', mr: 1 }}
                      >
                        {secret}
                      </Typography>
                      <IconButton size="small" onClick={handleCopySecret}>
                        <ContentCopy fontSize="small" />
                      </IconButton>
                    </Paper>
                  </Box>
                </CardContent>
              </Card>

              {/* Verification Step */}
              <Card sx={{ mb: 3 }}>
                <CardContent>
                  <Typography variant="subtitle1" fontWeight="bold" gutterBottom>
                    Step 3: Enter Verification Code
                  </Typography>
                  <Typography variant="body2" color="text.secondary" mb={2}>
                    Enter the 6-digit code from your authenticator app:
                  </Typography>

                  {/* OTP Input */}
                  <Box display="flex" justifyContent="center" gap={1} mb={2}>
                    {verificationCode.map((digit, index) => (
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
                            fontSize: '18px',
                            fontWeight: 'bold',
                            padding: '12px 0'
                          }
                        }}
                        sx={{ width: 48 }}
                      />
                    ))}
                  </Box>

                  {error && (
                    <Alert severity="error" sx={{ mb: 2 }}>
                      {error}
                    </Alert>
                  )}
                </CardContent>
              </Card>

              {/* Enable 2FA Button */}
              <Button
                fullWidth
                variant="contained"
                size="large"
                onClick={() => enable2FA()}
                disabled={!isCodeComplete || isLoading}
                sx={{ height: 56 }}
              >
                {isLoading ? 'Verifying...' : 'Verify & Enable 2FA'}
              </Button>
            </>
          ) : (
            <>
              {/* Verification Mode */}
              <Box display="flex" justifyContent="center" gap={1.5} mb={3}>
                {verificationCode.map((digit, index) => (
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
                          borderWidth: 2
                        }
                      }
                    }}
                  />
                ))}
              </Box>

              {error && (
                <Alert severity="error" sx={{ mb: 3 }}>
                  {error}
                </Alert>
              )}

              {/* Verify Button */}
              <Button
                fullWidth
                variant="contained"
                size="large"
                onClick={() => verify2FA()}
                disabled={!isCodeComplete || isLoading}
                sx={{ height: 56, mb: 2 }}
              >
                {isLoading ? 'Verifying...' : 'Verify'}
              </Button>

              {/* Backup Code Option */}
              <Box textAlign="center">
                <Button
                  onClick={() => setShowBackupCodeDialog(true)}
                  sx={{ textTransform: 'none' }}
                >
                  Use Backup Code Instead
                </Button>
              </Box>
            </>
          )}
        </Paper>
      </Box>

      {/* Backup Code Dialog */}
      <Dialog open={showBackupCodeDialog} onClose={() => setShowBackupCodeDialog(false)}>
        <DialogTitle>Enter Backup Code</DialogTitle>
        <DialogContent>
          <Typography variant="body2" color="text.secondary" paragraph>
            Enter one of your backup codes to sign in:
          </Typography>
          <TextField
            fullWidth
            label="Backup Code"
            placeholder="XXXX-XXXX"
            value={backupCodeInput}
            onChange={(e) => setBackupCodeInput(e.target.value.toUpperCase())}
            sx={{ mt: 1 }}
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setShowBackupCodeDialog(false)}>
            Cancel
          </Button>
          <Button
            onClick={handleBackupCodeVerification}
            variant="contained"
            disabled={!backupCodeInput}
          >
            Verify
          </Button>
        </DialogActions>
      </Dialog>
    </Container>
  );
};

export default TwoFactorAuthScreen;