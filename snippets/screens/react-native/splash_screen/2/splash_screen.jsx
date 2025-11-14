import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  Animated,
  Dimensions,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import Icon from 'react-native-vector-icons/MaterialIcons';

const { width, height } = Dimensions.get('window');

const SplashScreen = ({ onComplete }) => {
  const [logoScale] = useState(new Animated.Value(0.8));
  const [logoOpacity] = useState(new Animated.Value(0));
  const [textOpacity] = useState(new Animated.Value(0));
  const [showProgress, setShowProgress] = useState(false);

  useEffect(() => {
    const animateSequence = () => {
      // Logo fade in
      Animated.timing(logoOpacity, {
        toValue: 1,
        duration: 500,
        useNativeDriver: true,
      }).start();

      // Logo scale animation
      setTimeout(() => {
        Animated.spring(logoScale, {
          toValue: 1,
          tension: 50,
          friction: 7,
          useNativeDriver: true,
        }).start();
      }, 200);

      // Text fade in
      setTimeout(() => {
        Animated.timing(textOpacity, {
          toValue: 1,
          duration: 600,
          useNativeDriver: true,
        }).start();
      }, 400);

      // Progress indicator
      setTimeout(() => {
        setShowProgress(true);
      }, 800);

      // Navigate after 3 seconds
      setTimeout(() => {
        onComplete?.();
      }, 3000);
    };

    animateSequence();
  }, []);

  return (
    <LinearGradient
      colors={['#6366F1', 'rgba(99, 102, 241, 0.8)']}
      style={styles.container}
    >
      <View style={styles.content}>
        {/* Logo */}
        <Animated.View
          style={[
            styles.logoContainer,
            {
              transform: [{ scale: logoScale }],
              opacity: logoOpacity,
            },
          ]}
        >
          <View style={styles.logoCard}>
            <Icon name="rocket-launch" size={60} color="#6366F1" />
          </View>
        </Animated.View>

        {/* Title */}
        <Animated.View
          style={[styles.titleContainer, { opacity: textOpacity }]}
        >
          <Text style={styles.title}>AIQ</Text>
          <Text style={styles.subtitle}>Artificial Intelligence Quotient</Text>
        </Animated.View>

        {/* Progress Indicator */}
        {showProgress && (
          <Animated.View style={styles.progressContainer}>
            <View style={styles.spinner} />
          </Animated.View>
        )}
      </View>
    </LinearGradient>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  content: {
    alignItems: 'center',
  },
  logoContainer: {
    marginBottom: 32,
  },
  logoCard: {
    width: 120,
    height: 120,
    backgroundColor: 'white',
    borderRadius: 24,
    justifyContent: 'center',
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 10,
    },
    shadowOpacity: 0.1,
    shadowRadius: 20,
    elevation: 20,
  },
  titleContainer: {
    alignItems: 'center',
    marginBottom: 80,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    color: 'white',
    letterSpacing: 2,
    marginBottom: 16,
  },
  subtitle: {
    fontSize: 16,
    color: 'rgba(255, 255, 255, 0.7)',
    letterSpacing: 0.5,
  },
  progressContainer: {
    alignItems: 'center',
  },
  spinner: {
    width: 32,
    height: 32,
    borderWidth: 2,
    borderColor: 'rgba(255, 255, 255, 0.7)',
    borderTopColor: 'transparent',
    borderRadius: 16,
    // Note: You'd need to add rotation animation here
  },
});

export default SplashScreen;