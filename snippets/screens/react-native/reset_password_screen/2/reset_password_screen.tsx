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
  KeyboardAvoidingView,
  Platform
} from 'react-native';
import Icon from 'react-native-vector-icons/MaterialIcons';
import { SafeAreaView } from 'react-native-safe-area-context';

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
  met: boolean;
}

interface ResetPasswordScreenProps {
  token?: string;
  onNavigateToLogin?: () => void;
}

const ResetPasswordScreen: React.FC<ResetPasswordScreenProps> = ({
  token,
  onNavigateToLogin
}) => {
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

  const confirmPasswordRef = useRef<TextInput>(null);

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
      met: password.length >= 8
    },
    {
      label: 'Contains uppercase and lowercase letters',
      met: /[A-Z]/.test(password) && /[a-z]/.test(password)
    },
    {
      label: 'Contains at least one number',
      met: /\d/.test(password)
    },
    {
      label: 'Contains at least one special character',
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

  const handleInputChange = (field: keyof FormData, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));

    // Clear error when user starts typing
    if (errors[field]) {
      setErrors(prev => ({ ...prev, [field]: undefined }));
    }
  };

  const handleSubmit = async () => {
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

  const passwordStrength = formData.password ? calculatePasswordStrength(formData.password) : null;
  const passwordRequirements = getPasswordRequirements(formData.password);

  if (passwordReset) {
    return (
      <SafeAreaView style={styles.container}>
        <ScrollView contentContainerStyle={styles.successContent}>
          {/* Success Icon */}
          <View style={styles.iconContainer}>
            <View style={[styles.iconBackground, { backgroundColor: '#e8f5e8' }]}>
              <Icon name="check-circle" size={80} color="#4caf50" />
            </View>
          </View>

          {/* Header */}
          <View style={styles.textCenter}>
            <Text style={styles.title}>Password Reset Successfully!</Text>
            <Text style={styles.subtitle}>
              Your password has been reset successfully. You can now sign in with your new password.
            </Text>
          </View>

          {/* Continue Button */}
          <TouchableOpacity
            style={styles.primaryButton}
            onPress={onNavigateToLogin}
          >
            <Text style={styles.primaryButtonText}>Continue to Sign In</Text>
          </TouchableOpacity>
        </ScrollView>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <KeyboardAvoidingView
        behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
        style={styles.keyboardView}
      >
        <ScrollView
          contentContainerStyle={styles.scrollContent}
          keyboardShouldPersistTaps="handled"
          showsVerticalScrollIndicator={false}
        >
          {/* Icon */}
          <View style={styles.iconContainer}>
            <Icon name="lock-reset" size={80} color="#2196F3" />
          </View>

          {/* Header */}
          <View style={styles.textCenter}>
            <Text style={styles.title}>Create New Password</Text>
            <Text style={styles.subtitle}>
              Enter a new password for your account.
            </Text>
          </View>

          {/* General Error */}
          {errors.general && (
            <View style={styles.errorContainer}>
              <Icon name="error-outline" size={20} color="#f44336" />
              <Text style={[styles.errorText, { marginLeft: 8 }]}>{errors.general}</Text>
            </View>
          )}

          {/* Form */}
          <View style={styles.form}>
            {/* New Password Field */}
            <View style={styles.inputContainer}>
              <View style={styles.inputWrapper}>
                <Icon name="lock" size={20} color="#666" style={styles.inputIcon} />
                <TextInput
                  style={styles.input}
                  placeholder="New Password"
                  secureTextEntry={!showPassword}
                  value={formData.password}
                  onChangeText={(text) => handleInputChange('password', text)}
                  returnKeyType="next"
                  onSubmitEditing={() => confirmPasswordRef.current?.focus()}
                  blurOnSubmit={false}
                />
                <TouchableOpacity
                  onPress={() => setShowPassword(!showPassword)}
                  style={styles.eyeIcon}
                >
                  <Icon
                    name={showPassword ? 'visibility' : 'visibility-off'}
                    size={20}
                    color="#666"
                  />
                </TouchableOpacity>
              </View>
              <Text style={styles.helperText}>
                At least 8 characters with uppercase, lowercase, number, and special character
              </Text>
              {errors.password && <Text style={styles.errorText}>{errors.password}</Text>}

              {/* Password Strength Indicator */}
              {passwordStrength && (
                <View style={styles.passwordStrength}>
                  <View style={styles.strengthBar}>
                    <View
                      style={[
                        styles.strengthFill,
                        {
                          width: `${(passwordStrength.score / 5) * 100}%`,
                          backgroundColor: passwordStrength.color
                        }
                      ]}
                    />
                  </View>
                  <Text style={[styles.strengthText, { color: passwordStrength.color }]}>
                    Password strength: {passwordStrength.text}
                  </Text>
                </View>
              )}
            </View>

            {/* Confirm Password Field */}
            <View style={styles.inputContainer}>
              <View style={styles.inputWrapper}>
                <Icon name="lock" size={20} color="#666" style={styles.inputIcon} />
                <TextInput
                  ref={confirmPasswordRef}
                  style={styles.input}
                  placeholder="Confirm New Password"
                  secureTextEntry={!showConfirmPassword}
                  value={formData.confirmPassword}
                  onChangeText={(text) => handleInputChange('confirmPassword', text)}
                  returnKeyType="done"
                  onSubmitEditing={handleSubmit}
                />
                <TouchableOpacity
                  onPress={() => setShowConfirmPassword(!showConfirmPassword)}
                  style={styles.eyeIcon}
                >
                  <Icon
                    name={showConfirmPassword ? 'visibility' : 'visibility-off'}
                    size={20}
                    color="#666"
                  />
                </TouchableOpacity>
              </View>
              {errors.confirmPassword && <Text style={styles.errorText}>{errors.confirmPassword}</Text>}
            </View>

            {/* Password Requirements */}
            <View style={styles.requirementsContainer}>
              <View style={styles.requirementsHeader}>
                <Icon name="security" size={20} color="#2196F3" />
                <Text style={styles.requirementsTitle}>Password Requirements:</Text>
              </View>
              {passwordRequirements.map((requirement, index) => (
                <View key={index} style={styles.requirementItem}>
                  <Icon
                    name={requirement.met ? 'check-circle' : 'radio-button-unchecked'}
                    size={16}
                    color={requirement.met ? '#4caf50' : '#999'}
                  />
                  <Text style={[
                    styles.requirementText,
                    { color: requirement.met ? '#4caf50' : '#999' }
                  ]}>
                    {requirement.label}
                  </Text>
                </View>
              ))}
            </View>

            {/* Reset Password Button */}
            <TouchableOpacity
              style={[styles.primaryButton, (isLoading || !validToken) && styles.buttonDisabled]}
              onPress={handleSubmit}
              disabled={isLoading || !validToken}
            >
              {isLoading ? (
                <ActivityIndicator size="small" color="#fff" />
              ) : (
                <Text style={styles.primaryButtonText}>Reset Password</Text>
              )}
            </TouchableOpacity>

            {/* Back to Login */}
            <TouchableOpacity style={styles.linkButton} onPress={onNavigateToLogin}>
              <Text style={styles.linkText}>Back to Sign In</Text>
            </TouchableOpacity>
          </View>
        </ScrollView>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  keyboardView: {
    flex: 1,
  },
  scrollContent: {
    flexGrow: 1,
    paddingHorizontal: 24,
    paddingVertical: 20,
  },
  successContent: {
    flexGrow: 1,
    paddingHorizontal: 24,
    paddingVertical: 80,
    justifyContent: 'center',
  },
  iconContainer: {
    alignItems: 'center',
    marginVertical: 40,
  },
  iconBackground: {
    width: 120,
    height: 120,
    borderRadius: 60,
    alignItems: 'center',
    justifyContent: 'center',
  },
  textCenter: {
    alignItems: 'center',
    marginBottom: 40,
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 8,
    textAlign: 'center',
  },
  subtitle: {
    fontSize: 16,
    color: '#666',
    textAlign: 'center',
    lineHeight: 24,
  },
  form: {
    flex: 1,
  },
  inputContainer: {
    marginBottom: 16,
  },
  inputWrapper: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 12,
    paddingHorizontal: 16,
    backgroundColor: '#fff',
    minHeight: 56,
  },
  inputIcon: {
    marginRight: 12,
  },
  input: {
    flex: 1,
    fontSize: 16,
    color: '#333',
    paddingVertical: 0,
  },
  eyeIcon: {
    padding: 4,
  },
  helperText: {
    fontSize: 12,
    color: '#666',
    marginTop: 4,
    marginLeft: 4,
    lineHeight: 16,
  },
  errorText: {
    fontSize: 12,
    color: '#f44336',
    marginTop: 4,
    marginLeft: 4,
  },
  errorContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#ffebee',
    padding: 12,
    borderRadius: 8,
    marginBottom: 16,
  },
  passwordStrength: {
    marginTop: 8,
  },
  strengthBar: {
    height: 4,
    backgroundColor: '#e0e0e0',
    borderRadius: 2,
    marginBottom: 4,
  },
  strengthFill: {
    height: '100%',
    borderRadius: 2,
  },
  strengthText: {
    fontSize: 12,
    fontWeight: '500',
  },
  requirementsContainer: {
    backgroundColor: '#e3f2fd',
    padding: 16,
    borderRadius: 12,
    marginBottom: 24,
  },
  requirementsHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
  },
  requirementsTitle: {
    fontSize: 14,
    fontWeight: '600',
    color: '#2196F3',
    marginLeft: 8,
  },
  requirementItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  requirementText: {
    fontSize: 12,
    marginLeft: 8,
    flex: 1,
  },
  primaryButton: {
    backgroundColor: '#2196F3',
    paddingVertical: 16,
    borderRadius: 12,
    alignItems: 'center',
    marginBottom: 24,
    minHeight: 56,
    justifyContent: 'center',
  },
  buttonDisabled: {
    opacity: 0.7,
  },
  primaryButtonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: '600',
  },
  linkButton: {
    paddingVertical: 12,
    alignItems: 'center',
  },
  linkText: {
    color: '#2196F3',
    fontSize: 14,
    fontWeight: '500',
  },
});

export default ResetPasswordScreen;