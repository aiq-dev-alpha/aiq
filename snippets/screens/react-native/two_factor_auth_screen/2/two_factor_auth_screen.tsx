import React, { useState, useEffect, useRef } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  ScrollView,
  Alert,
  ActivityIndicator,
  StyleSheet,
  Modal,
  Clipboard
} from 'react-native';
import Icon from 'react-native-vector-icons/MaterialIcons';
import { SafeAreaView } from 'react-native-safe-area-context';

enum TwoFactorMode {
  Setup = 'setup',
  Verify = 'verify'
}

interface TwoFactorAuthScreenProps {
  mode?: TwoFactorMode;
  secret?: string;
  onNavigateBack?: () => void;
  onSetupComplete?: () => void;
  onVerificationSuccess?: () => void;
}

const TwoFactorAuthScreen: React.FC<TwoFactorAuthScreenProps> = ({
  mode = TwoFactorMode.Setup,
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
  const [showBackupModal, setShowBackupModal] = useState(false);
  const [backupCodeInput, setBackupCodeInput] = useState('');

  const inputRefs = useRef<(TextInput | null)[]>(Array(6).fill(null));

  useEffect(() => {
    if (mode === TwoFactorMode.Setup) {
      generateBackupCodes();
    }
    inputRefs.current[0]?.focus();
  }, [mode]);

  const generateBackupCodes = () => {
    const codes = Array.from({ length: 8 }, () => {
      const part1 = Math.random().toString(36).substring(2, 6).toUpperCase();
      const part2 = Math.random().toString(36).substring(2, 6).toUpperCase();
      return `${part1}-${part2}`;
    });
    setBackupCodes(codes);
  };

  const handleInputChange = (index: number, value: string) => {
    if (value && !/^\d$/.test(value)) return;

    const newCode = [...verificationCode];
    newCode[index] = value;
    setVerificationCode(newCode);

    if (error) setError('');

    if (value && index < 5) {
      inputRefs.current[index + 1]?.focus();
    }

    if (newCode.every(digit => digit !== '') && newCode.join('').length === 6) {
      if (mode === TwoFactorMode.Setup) {
        enable2FA(newCode.join(''));
      } else {
        verify2FA(newCode.join(''));
      }
    }
  };

  const handleKeyPress = (index: number, key: string) => {
    if (key === 'Backspace') {
      if (!verificationCode[index] && index > 0) {
        inputRefs.current[index - 1]?.focus();
      } else {
        const newCode = [...verificationCode];
        newCode[index] = '';
        setVerificationCode(newCode);
      }
    }
  };

  const enable2FA = async (code: string) => {
    setIsLoading(true);
    setError('');

    try {
      await new Promise(resolve => setTimeout(resolve, 2000));
      setSetupComplete(true);
    } catch (error) {
      setError('Failed to enable 2FA. Please try again.');
      clearCode();
    } finally {
      setIsLoading(false);
    }
  };

  const verify2FA = async (code: string) => {
    setIsLoading(true);
    setError('');

    try {
      await new Promise(resolve => setTimeout(resolve, 2000));
      Alert.alert('Success', '2FA verification successful!', [
        { text: 'OK', onPress: onVerificationSuccess }
      ]);
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

  const copyToClipboard = async (text: string) => {
    await Clipboard.setString(text);
    Alert.alert('Copied', 'Copied to clipboard!');
  };

  const copyAllCodes = () => {
    const allCodes = `Your backup codes:\n\n${backupCodes.join('\n')}`;
    copyToClipboard(allCodes);
  };

  const isCodeComplete = verificationCode.every(digit => digit !== '');

  if (mode === TwoFactorMode.Setup && setupComplete) {
    return (
      <SafeAreaView style={styles.container}>
        <ScrollView contentContainerStyle={styles.successContent}>
          <View style={styles.iconContainer}>
            <View style={[styles.iconBackground, { backgroundColor: '#e8f5e8' }]}>
              <Icon name="check-circle" size={80} color="#4caf50" />
            </View>
          </View>

          <Text style={styles.title}>2FA Setup Complete!</Text>
          <Text style={styles.subtitle}>
            Save these backup codes in a safe place. You can use them to access your account
            if you lose your authenticator app.
          </Text>

          <View style={styles.warningBox}>
            <Icon name="warning" size={20} color="#ff9800" />
            <View style={{ marginLeft: 12, flex: 1 }}>
              <Text style={[styles.warningTitle, { color: '#ff9800' }]}>
                Important: Save Your Backup Codes
              </Text>
              <Text style={[styles.warningText, { color: '#ff9800' }]}>
                These codes can only be used once. Store them securely offline.
              </Text>
            </View>
          </View>

          <View style={styles.backupCodesContainer}>
            <View style={styles.codesHeader}>
              <Text style={styles.codesTitle}>Backup Codes</Text>
              <TouchableOpacity onPress={copyAllCodes}>
                <Icon name="content-copy" size={20} color="#2196F3" />
              </TouchableOpacity>
            </View>

            <View style={styles.codesGrid}>
              {backupCodes.map((code, index) => (
                <View key={index} style={styles.codeItem}>
                  <Text style={styles.codeText}>{code}</Text>
                </View>
              ))}
            </View>
          </View>

          <TouchableOpacity style={styles.primaryButton} onPress={onSetupComplete}>
            <Text style={styles.primaryButtonText}>Continue</Text>
          </TouchableOpacity>

          <TouchableOpacity style={styles.secondaryButton} onPress={copyAllCodes}>
            <Icon name="content-copy" size={18} color="#2196F3" style={{ marginRight: 8 }} />
            <Text style={styles.secondaryButtonText}>Copy All Codes</Text>
          </TouchableOpacity>
        </ScrollView>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity style={styles.backButton} onPress={onNavigateBack}>
          <Icon name="arrow-back" size={24} color="#333" />
        </TouchableOpacity>
      </View>

      <ScrollView contentContainerStyle={styles.scrollContent}>
        <View style={styles.iconContainer}>
          <Icon name="security" size={80} color="#2196F3" />
        </View>

        <Text style={styles.title}>
          {mode === TwoFactorMode.Setup ? 'Setup Two-Factor Authentication' : 'Two-Factor Authentication'}
        </Text>

        <Text style={styles.subtitle}>
          {mode === TwoFactorMode.Setup
            ? 'Secure your account with an additional layer of protection.'
            : 'Enter the 6-digit code from your authenticator app.'
          }
        </Text>

        {mode === TwoFactorMode.Setup && (
          <>
            <View style={styles.setupSection}>
              <Text style={styles.sectionTitle}>Step 1: Install an Authenticator App</Text>
              <View style={styles.appsRow}>
                {['Google\nAuthenticator', 'Microsoft\nAuthenticator', 'Authy'].map((app, index) => (
                  <View key={index} style={styles.appItem}>
                    <View style={styles.appIcon}>
                      <Icon name="security" size={24} color="#2196F3" />
                    </View>
                    <Text style={styles.appText}>{app}</Text>
                  </View>
                ))}
              </View>
            </View>

            <View style={styles.setupSection}>
              <Text style={styles.sectionTitle}>Step 2: Scan QR Code or Enter Secret</Text>
              <View style={styles.qrSection}>
                <View style={styles.qrPlaceholder}>
                  <Icon name="qr-code" size={60} color="#999" />
                  <Text style={styles.qrText}>QR Code</Text>
                </View>
                <Text style={styles.manualText}>Can't scan? Enter this code manually:</Text>
                <View style={styles.secretContainer}>
                  <Text style={styles.secretText}>{secret}</Text>
                  <TouchableOpacity onPress={() => copyToClipboard(secret)}>
                    <Icon name="content-copy" size={20} color="#2196F3" />
                  </TouchableOpacity>
                </View>
              </View>
            </View>

            <View style={styles.setupSection}>
              <Text style={styles.sectionTitle}>Step 3: Enter Verification Code</Text>
            </View>
          </>
        )}

        <Text style={styles.inputLabel}>
          {mode === TwoFactorMode.Setup
            ? 'Enter the 6-digit code from your authenticator app:'
            : 'Verification Code'
          }
        </Text>

        <View style={styles.otpContainer}>
          {verificationCode.map((digit, index) => (
            <TextInput
              key={index}
              ref={(ref) => inputRefs.current[index] = ref}
              style={[styles.otpInput, digit ? styles.otpInputFilled : null]}
              value={digit}
              onChangeText={(value) => handleInputChange(index, value)}
              onKeyPress={({ nativeEvent }) => handleKeyPress(index, nativeEvent.key)}
              keyboardType="numeric"
              maxLength={1}
              editable={!isLoading}
            />
          ))}
        </View>

        {error && (
          <View style={styles.errorContainer}>
            <Icon name="error-outline" size={20} color="#f44336" />
            <Text style={styles.errorText}>{error}</Text>
          </View>
        )}

        <TouchableOpacity
          style={[styles.primaryButton, (!isCodeComplete || isLoading) && styles.buttonDisabled]}
          onPress={() => mode === TwoFactorMode.Setup ? enable2FA(verificationCode.join('')) : verify2FA(verificationCode.join(''))}
          disabled={!isCodeComplete || isLoading}
        >
          {isLoading ? (
            <ActivityIndicator size="small" color="#fff" />
          ) : (
            <Text style={styles.primaryButtonText}>
              {mode === TwoFactorMode.Setup ? 'Verify & Enable 2FA' : 'Verify'}
            </Text>
          )}
        </TouchableOpacity>

        {mode === TwoFactorMode.Verify && (
          <TouchableOpacity onPress={() => setShowBackupModal(true)}>
            <Text style={styles.linkText}>Use Backup Code Instead</Text>
          </TouchableOpacity>
        )}
      </ScrollView>

      <Modal
        visible={showBackupModal}
        transparent
        animationType="slide"
        onRequestClose={() => setShowBackupModal(false)}
      >
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <Text style={styles.modalTitle}>Enter Backup Code</Text>
            <Text style={styles.modalSubtitle}>Enter one of your backup codes to sign in:</Text>

            <TextInput
              style={styles.modalInput}
              placeholder="XXXX-XXXX"
              value={backupCodeInput}
              onChangeText={setBackupCodeInput}
              autoCapitalize="characters"
            />

            <View style={styles.modalButtons}>
              <TouchableOpacity
                style={styles.modalCancelButton}
                onPress={() => setShowBackupModal(false)}
              >
                <Text style={styles.modalCancelText}>Cancel</Text>
              </TouchableOpacity>

              <TouchableOpacity
                style={[styles.modalVerifyButton, !backupCodeInput && styles.buttonDisabled]}
                onPress={() => {
                  setShowBackupModal(false);
                  onVerificationSuccess?.();
                }}
                disabled={!backupCodeInput}
              >
                <Text style={styles.modalVerifyText}>Verify</Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </Modal>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#fff' },
  header: { paddingHorizontal: 16, paddingVertical: 12 },
  backButton: { width: 40, height: 40, borderRadius: 20, backgroundColor: '#f5f5f5', alignItems: 'center', justifyContent: 'center' },
  scrollContent: { paddingHorizontal: 24, paddingBottom: 20 },
  successContent: { flexGrow: 1, paddingHorizontal: 24, paddingVertical: 40 },
  iconContainer: { alignItems: 'center', marginVertical: 40 },
  iconBackground: { width: 120, height: 120, borderRadius: 60, alignItems: 'center', justifyContent: 'center' },
  title: { fontSize: 24, fontWeight: 'bold', color: '#333', textAlign: 'center', marginBottom: 8 },
  subtitle: { fontSize: 16, color: '#666', textAlign: 'center', lineHeight: 24, marginBottom: 32 },
  setupSection: { marginBottom: 24 },
  sectionTitle: { fontSize: 16, fontWeight: '600', color: '#333', marginBottom: 16 },
  appsRow: { flexDirection: 'row', justifyContent: 'space-around' },
  appItem: { alignItems: 'center' },
  appIcon: { width: 48, height: 48, borderRadius: 12, backgroundColor: '#f0f0f0', alignItems: 'center', justifyContent: 'center', marginBottom: 8 },
  appText: { fontSize: 10, textAlign: 'center', color: '#666' },
  qrSection: { alignItems: 'center' },
  qrPlaceholder: { width: 160, height: 160, backgroundColor: '#f5f5f5', borderRadius: 12, alignItems: 'center', justifyContent: 'center', marginBottom: 16 },
  qrText: { fontSize: 12, color: '#999', marginTop: 8 },
  manualText: { fontSize: 12, color: '#666', marginBottom: 8 },
  secretContainer: { flexDirection: 'row', alignItems: 'center', backgroundColor: '#f5f5f5', padding: 12, borderRadius: 8 },
  secretText: { fontFamily: 'monospace', fontSize: 14, fontWeight: 'bold', marginRight: 12 },
  inputLabel: { fontSize: 14, color: '#666', marginBottom: 16, textAlign: 'center' },
  otpContainer: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 24, paddingHorizontal: 20 },
  otpInput: { width: 44, height: 52, borderWidth: 2, borderColor: '#ddd', borderRadius: 8, textAlign: 'center', fontSize: 18, fontWeight: 'bold', color: '#333' },
  otpInputFilled: { borderColor: '#2196F3', backgroundColor: '#f3f8ff' },
  errorContainer: { flexDirection: 'row', alignItems: 'center', backgroundColor: '#ffebee', padding: 12, borderRadius: 8, marginBottom: 16 },
  errorText: { fontSize: 14, color: '#f44336', marginLeft: 8, flex: 1 },
  warningBox: { flexDirection: 'row', alignItems: 'flex-start', backgroundColor: '#fff3e0', padding: 16, borderRadius: 12, marginBottom: 24 },
  warningTitle: { fontSize: 14, fontWeight: 'bold', marginBottom: 4 },
  warningText: { fontSize: 12 },
  backupCodesContainer: { backgroundColor: '#f5f5f5', padding: 16, borderRadius: 12, marginBottom: 24 },
  codesHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 },
  codesTitle: { fontSize: 16, fontWeight: '600', color: '#333' },
  codesGrid: { flexDirection: 'row', flexWrap: 'wrap', justifyContent: 'space-between' },
  codeItem: { width: '48%', backgroundColor: '#fff', padding: 8, borderRadius: 6, marginBottom: 8, alignItems: 'center' },
  codeText: { fontFamily: 'monospace', fontSize: 12, fontWeight: 'bold', color: '#333' },
  primaryButton: { backgroundColor: '#2196F3', paddingVertical: 16, borderRadius: 12, alignItems: 'center', marginBottom: 16, minHeight: 56, justifyContent: 'center' },
  secondaryButton: { backgroundColor: 'transparent', paddingVertical: 16, borderRadius: 12, borderWidth: 2, borderColor: '#2196F3', alignItems: 'center', marginBottom: 16, minHeight: 56, justifyContent: 'center', flexDirection: 'row' },
  buttonDisabled: { opacity: 0.5 },
  primaryButtonText: { color: '#fff', fontSize: 16, fontWeight: '600' },
  secondaryButtonText: { color: '#2196F3', fontSize: 16, fontWeight: '600' },
  linkText: { color: '#2196F3', fontSize: 14, fontWeight: '500', textAlign: 'center', paddingVertical: 16 },
  modalOverlay: { flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'center', alignItems: 'center' },
  modalContent: { backgroundColor: '#fff', margin: 20, padding: 24, borderRadius: 12, width: '90%' },
  modalTitle: { fontSize: 18, fontWeight: 'bold', marginBottom: 8 },
  modalSubtitle: { fontSize: 14, color: '#666', marginBottom: 16 },
  modalInput: { borderWidth: 1, borderColor: '#ddd', borderRadius: 8, padding: 12, fontSize: 16, marginBottom: 20 },
  modalButtons: { flexDirection: 'row', justifyContent: 'space-between' },
  modalCancelButton: { flex: 1, paddingVertical: 12, alignItems: 'center', marginRight: 8 },
  modalVerifyButton: { flex: 1, backgroundColor: '#2196F3', paddingVertical: 12, borderRadius: 8, alignItems: 'center', marginLeft: 8 },
  modalCancelText: { color: '#666', fontSize: 16 },
  modalVerifyText: { color: '#fff', fontSize: 16, fontWeight: '600' }
});

export default TwoFactorAuthScreen;