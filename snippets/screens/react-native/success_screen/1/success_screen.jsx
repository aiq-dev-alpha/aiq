import React, { useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  Animated,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import Icon from 'react-native-vector-icons/MaterialIcons';

const SuccessScreen = ({
  title = "Success!",
  message = "Your profile has been created successfully. You're ready to start your AIQ journey!",
  buttonText = "Get Started",
  onContinue,
}) => {
  const scaleAnim = new Animated.Value(0);
  const fadeAnim = new Animated.Value(0);

  useEffect(() => {
    Animated.sequence([
      Animated.spring(scaleAnim, {
        toValue: 1,
        tension: 50,
        friction: 7,
        useNativeDriver: true,
      }),
      Animated.timing(fadeAnim, {
        toValue: 1,
        duration: 600,
        useNativeDriver: true,
      }),
    ]).start();
  }, []);

  return (
    <LinearGradient
      colors={['#10B981', '#059669']}
      style={styles.container}
    >
      <View style={styles.content}>
        {/* Success Icon */}
        <Animated.View
          style={[
            styles.iconContainer,
            {
              transform: [{ scale: scaleAnim }],
            },
          ]}
        >
          <View style={styles.iconCircle}>
            <Icon name="check" size={60} color="#10B981" />
          </View>
        </Animated.View>

        {/* Content */}
        <Animated.View
          style={[styles.textContainer, { opacity: fadeAnim }]}
        >
          <Text style={styles.title}>{title}</Text>
          <Text style={styles.message}>{message}</Text>
        </Animated.View>

        {/* Floating Elements */}
        <View style={styles.floatingElements}>
          <Text style={[styles.emoji, styles.emoji1]}>✨</Text>
          <Text style={[styles.emoji, styles.emoji2]}>🎉</Text>
          <Text style={[styles.emoji, styles.emoji3]}>⭐</Text>
          <Text style={[styles.emoji, styles.emoji4]}>🚀</Text>
        </View>

        {/* Continue Button */}
        <Animated.View style={[styles.buttonContainer, { opacity: fadeAnim }]}>
          <TouchableOpacity style={styles.continueButton} onPress={onContinue}>
            <Text style={styles.buttonText}>{buttonText}</Text>
            <Icon name="arrow-forward" size={20} color="#10B981" />
          </TouchableOpacity>
        </Animated.View>
      </View>
    </LinearGradient>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  content: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 24,
  },
  iconContainer: {
    marginBottom: 40,
  },
  iconCircle: {
    width: 120,
    height: 120,
    backgroundColor: 'white',
    borderRadius: 60,
    justifyContent: 'center',
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 15,
    },
    shadowOpacity: 0.2,
    shadowRadius: 30,
    elevation: 30,
  },
  textContainer: {
    alignItems: 'center',
    marginBottom: 60,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    color: 'white',
    textAlign: 'center',
    marginBottom: 16,
  },
  message: {
    fontSize: 16,
    color: 'rgba(255, 255, 255, 0.7)',
    textAlign: 'center',
    lineHeight: 24,
  },
  floatingElements: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
  },
  emoji: {
    position: 'absolute',
    fontSize: 20,
  },
  emoji1: {
    top: '20%',
    left: '20%',
  },
  emoji2: {
    top: '15%',
    right: '15%',
  },
  emoji3: {
    bottom: '40%',
    left: '15%',
  },
  emoji4: {
    bottom: '35%',
    right: '20%',
  },
  buttonContainer: {
    width: '100%',
  },
  continueButton: {
    backgroundColor: 'white',
    paddingVertical: 16,
    paddingHorizontal: 24,
    borderRadius: 16,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
  },
  buttonText: {
    color: '#10B981',
    fontSize: 16,
    fontWeight: '600',
    marginRight: 8,
  },
});

export default SuccessScreen;