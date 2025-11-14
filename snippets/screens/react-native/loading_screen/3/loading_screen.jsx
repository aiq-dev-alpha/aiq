import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  Animated,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import Icon from 'react-native-vector-icons/MaterialIcons';

const LoadingScreen = ({
  title = "Loading",
  message,
  showProgress = false,
  progress,
  primaryColor = '#6366F1',
}) => {
  const [currentMessageIndex, setCurrentMessageIndex] = useState(0);
  const rotateAnim = new Animated.Value(0);
  const pulseAnim = new Animated.Value(1);

  const loadingMessages = [
    "Preparing your experience...",
    "Loading AI challenges...",
    "Setting up your profile...",
    "Almost ready..."
  ];

  useEffect(() => {
    // Rotation animation
    Animated.loop(
      Animated.timing(rotateAnim, {
        toValue: 1,
        duration: 2000,
        useNativeDriver: true,
      })
    ).start();

    // Pulse animation
    Animated.loop(
      Animated.sequence([
        Animated.timing(pulseAnim, {
          toValue: 1.2,
          duration: 1500,
          useNativeDriver: true,
        }),
        Animated.timing(pulseAnim, {
          toValue: 1,
          duration: 1500,
          useNativeDriver: true,
        }),
      ])
    ).start();

    // Message cycling
    if (!message) {
      const interval = setInterval(() => {
        setCurrentMessageIndex((prev) => (prev + 1) % loadingMessages.length);
      }, 2000);

      return () => clearInterval(interval);
    }
  }, [message]);

  const spin = rotateAnim.interpolate({
    inputRange: [0, 1],
    outputRange: ['0deg', '360deg'],
  });

  return (
    <LinearGradient
      colors={[primaryColor, `${primaryColor}CC`]}
      style={styles.container}
    >
      <View style={styles.content}>
        {/* Loading Animation */}
        <View style={styles.animationContainer}>
          <Animated.View
            style={[
              styles.pulseRing,
              {
                transform: [{ scale: pulseAnim }],
              },
            ]}
          />

          <Animated.View
            style={[
              styles.spinnerRing,
              {
                transform: [{ rotate: spin }],
              },
            ]}
          />

          <View style={styles.innerIcon}>
            <Icon name="psychology" size={24} color={primaryColor} />
          </View>
        </View>

        {/* Title */}
        <Text style={styles.title}>{title}</Text>

        {/* Message */}
        <View style={styles.messageContainer}>
          <Text style={styles.message}>
            {message || loadingMessages[currentMessageIndex]}
          </Text>
        </View>

        {/* Progress */}
        <View style={styles.progressContainer}>
          {showProgress ? (
            <View style={styles.progressBarContainer}>
              {progress !== undefined && (
                <View style={styles.progressTextContainer}>
                  <Text style={styles.progressText}>
                    {Math.round(progress * 100)}%
                  </Text>
                </View>
              )}
              <View style={styles.progressTrack}>
                <View
                  style={[
                    styles.progressBar,
                    { width: `${(progress || 0) * 100}%` },
                  ]}
                />
              </View>
            </View>
          ) : (
            <View style={styles.dotsContainer}>
              {[0, 1, 2].map((i) => (
                <View key={i} style={styles.dot} />
              ))}
            </View>
          )}
        </View>
      </View>
    </LinearGradient>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 32,
  },
  content: {
    alignItems: 'center',
    width: '100%',
    maxWidth: 280,
  },
  animationContainer: {
    position: 'relative',
    width: 80,
    height: 80,
    marginBottom: 40,
    alignItems: 'center',
    justifyContent: 'center',
  },
  pulseRing: {
    position: 'absolute',
    width: 80,
    height: 80,
    borderRadius: 40,
    backgroundColor: 'rgba(255, 255, 255, 0.2)',
  },
  spinnerRing: {
    position: 'absolute',
    width: 64,
    height: 64,
    borderRadius: 32,
    borderWidth: 3,
    borderColor: 'white',
    borderTopColor: 'transparent',
  },
  innerIcon: {
    width: 48,
    height: 48,
    borderRadius: 24,
    backgroundColor: 'white',
    justifyContent: 'center',
    alignItems: 'center',
    position: 'absolute',
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: 'white',
    marginBottom: 16,
  },
  messageContainer: {
    height: 48,
    justifyContent: 'center',
    marginBottom: 40,
  },
  message: {
    fontSize: 16,
    color: 'rgba(255, 255, 255, 0.8)',
    textAlign: 'center',
    lineHeight: 22,
  },
  progressContainer: {
    width: '100%',
  },
  progressBarContainer: {
    width: '100%',
  },
  progressTextContainer: {
    alignItems: 'flex-end',
    marginBottom: 8,
  },
  progressText: {
    fontSize: 14,
    fontWeight: '500',
    color: 'rgba(255, 255, 255, 0.7)',
  },
  progressTrack: {
    height: 4,
    backgroundColor: 'rgba(255, 255, 255, 0.3)',
    borderRadius: 2,
    overflow: 'hidden',
  },
  progressBar: {
    height: '100%',
    backgroundColor: 'white',
    borderRadius: 2,
  },
  dotsContainer: {
    flexDirection: 'row',
    justifyContent: 'center',
  },
  dot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: 'rgba(255, 255, 255, 0.6)',
    marginHorizontal: 4,
  },
});

export default LoadingScreen;