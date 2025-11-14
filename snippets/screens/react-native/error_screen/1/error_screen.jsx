import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
} from 'react-native';
import Icon from 'react-native-vector-icons/MaterialIcons';

const ErrorScreen = ({
  title = "Oops! Something went wrong",
  message = "We encountered an unexpected error. Don't worry, it happens to the best of us! Please try again.",
  buttonText = "Try Again",
  onRetry,
  onGoBack,
}) => {
  return (
    <View style={styles.container}>
      <View style={styles.content}>
        {/* Error Icon */}
        <View style={styles.iconContainer}>
          <View style={styles.iconCircle}>
            <Icon name="error-outline" size={60} color="#EF4444" />
          </View>
        </View>

        {/* Content */}
        <Text style={styles.title}>{title}</Text>
        <Text style={styles.message}>{message}</Text>

        {/* Error Illustration */}
        <View style={styles.illustration}>
          <Text style={styles.robotEmoji}>🤖</Text>
        </View>

        {/* Action Buttons */}
        <View style={styles.buttonContainer}>
          <TouchableOpacity style={styles.retryButton} onPress={onRetry}>
            <Icon name="refresh" size={20} color="white" />
            <Text style={styles.retryButtonText}>{buttonText}</Text>
          </TouchableOpacity>

          <TouchableOpacity style={styles.backButton} onPress={onGoBack}>
            <Icon name="arrow-back" size={20} color="#6B7280" />
            <Text style={styles.backButtonText}>Go Back</Text>
          </TouchableOpacity>
        </View>

        <Text style={styles.helpText}>
          If the problem persists, please contact our support team
        </Text>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'white',
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 24,
  },
  content: {
    alignItems: 'center',
    width: '100%',
    maxWidth: 320,
  },
  iconContainer: {
    marginBottom: 40,
  },
  iconCircle: {
    width: 120,
    height: 120,
    backgroundColor: 'rgba(239, 68, 68, 0.1)',
    borderRadius: 60,
    borderWidth: 2,
    borderColor: 'rgba(239, 68, 68, 0.2)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#1F2937',
    textAlign: 'center',
    marginBottom: 16,
  },
  message: {
    fontSize: 16,
    color: '#6B7280',
    textAlign: 'center',
    lineHeight: 24,
    marginBottom: 40,
  },
  illustration: {
    marginBottom: 40,
  },
  robotEmoji: {
    fontSize: 60,
  },
  buttonContainer: {
    width: '100%',
    marginBottom: 20,
  },
  retryButton: {
    backgroundColor: '#6366F1',
    paddingVertical: 16,
    paddingHorizontal: 24,
    borderRadius: 16,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 12,
  },
  retryButtonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: '600',
    marginLeft: 8,
  },
  backButton: {
    borderWidth: 2,
    borderColor: '#E5E7EB',
    paddingVertical: 16,
    paddingHorizontal: 24,
    borderRadius: 16,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
  },
  backButtonText: {
    color: '#6B7280',
    fontSize: 16,
    fontWeight: '500',
    marginLeft: 8,
  },
  helpText: {
    fontSize: 12,
    color: 'rgba(107, 114, 128, 0.8)',
    textAlign: 'center',
  },
});

export default ErrorScreen;