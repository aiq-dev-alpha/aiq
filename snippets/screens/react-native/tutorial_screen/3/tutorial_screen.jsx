import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import Icon from 'react-native-vector-icons/MaterialIcons';

const TutorialScreen = ({ onComplete }) => {
  const [currentStep, setCurrentStep] = useState(0);
  const [showOverlay, setShowOverlay] = useState(true);

  const tutorialSteps = [
    {
      title: "Navigation Menu",
      description: "Tap the menu icon to access different sections of the app.",
    },
    {
      title: "Start a Quiz",
      description: "Tap here to begin your AI intelligence assessment.",
    },
    {
      title: "View Your Progress",
      description: "Check your scores and track improvement over time.",
    },
    {
      title: "Settings & Profile",
      description: "Customize your experience and manage your profile.",
    }
  ];

  const nextStep = () => {
    if (currentStep < tutorialSteps.length - 1) {
      setCurrentStep(currentStep + 1);
    } else {
      completeTutorial();
    }
  };

  const previousStep = () => {
    if (currentStep > 0) {
      setCurrentStep(currentStep - 1);
    }
  };

  const completeTutorial = () => {
    setShowOverlay(false);
    onComplete?.();
  };

  const currentStepData = tutorialSteps[currentStep];

  return (
    <View style={styles.container}>
      {/* Mock App Interface */}
      <LinearGradient
        colors={['#6366F1', '#8B5CF6']}
        style={styles.mockInterface}
      >
        <View style={styles.appBar}>
          <Icon name="menu" size={28} color="white" />
          <Text style={styles.appTitle}>AIQ</Text>
          <Icon name="person" size={28} color="white" />
        </View>

        <View style={styles.mainContent}>
          <View style={styles.playButton}>
            <Icon name="play-arrow" size={60} color="white" />
          </View>

          <Text style={styles.mainTitle}>Start Your AIQ Test</Text>

          <View style={styles.progressCard}>
            <Icon name="trending-up" size={24} color="#6366F1" />
            <Text style={styles.progressText}>View Progress</Text>
          </View>
        </View>
      </LinearGradient>

      {/* Tutorial Overlay */}
      {showOverlay && (
        <View style={styles.overlay}>
          <View style={styles.spotlight} />

          <View style={styles.tutorialCard}>
            <View style={styles.cardHeader}>
              <View style={styles.stepBadge}>
                <Text style={styles.stepText}>
                  {currentStep + 1}/{tutorialSteps.length}
                </Text>
              </View>

              <TouchableOpacity onPress={completeTutorial}>
                <Icon name="close" size={20} color="#6B7280" />
              </TouchableOpacity>
            </View>

            <Text style={styles.cardTitle}>{currentStepData.title}</Text>
            <Text style={styles.cardDescription}>
              {currentStepData.description}
            </Text>

            <View style={styles.navigationButtons}>
              {currentStep > 0 && (
                <TouchableOpacity
                  style={styles.previousButton}
                  onPress={previousStep}
                >
                  <Text style={styles.previousButtonText}>Previous</Text>
                </TouchableOpacity>
              )}

              <TouchableOpacity
                style={[
                  styles.nextButton,
                  { flex: currentStep === 0 ? 1 : 0.5 }
                ]}
                onPress={nextStep}
              >
                <Text style={styles.nextButtonText}>
                  {currentStep === tutorialSteps.length - 1 ? 'Finish' : 'Next'}
                </Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  mockInterface: {
    flex: 1,
  },
  appBar: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingTop: 60,
    paddingBottom: 20,
  },
  appTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    color: 'white',
  },
  mainContent: {
    flex: 1,
    backgroundColor: 'white',
    margin: 16,
    borderRadius: 24,
    justifyContent: 'center',
    alignItems: 'center',
  },
  playButton: {
    width: 120,
    height: 120,
    backgroundColor: '#6366F1',
    borderRadius: 60,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 24,
  },
  mainTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#1F2937',
    textAlign: 'center',
    marginBottom: 40,
  },
  progressCard: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#F3F4F6',
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderRadius: 16,
  },
  progressText: {
    fontSize: 16,
    fontWeight: '500',
    color: '#1F2937',
    marginLeft: 12,
  },
  overlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(0, 0, 0, 0.8)',
    justifyContent: 'flex-end',
  },
  spotlight: {
    position: 'absolute',
    top: '40%',
    left: '50%',
    width: 80,
    height: 80,
    backgroundColor: 'rgba(255, 255, 255, 0.2)',
    borderRadius: 40,
    marginLeft: -40,
    marginTop: -40,
  },
  tutorialCard: {
    backgroundColor: 'white',
    borderTopLeftRadius: 24,
    borderTopRightRadius: 24,
    padding: 24,
  },
  cardHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 16,
  },
  stepBadge: {
    backgroundColor: '#6366F1',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 12,
  },
  stepText: {
    color: 'white',
    fontSize: 12,
    fontWeight: '600',
  },
  cardTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#1F2937',
    marginBottom: 8,
  },
  cardDescription: {
    fontSize: 16,
    color: '#6B7280',
    lineHeight: 22,
    marginBottom: 24,
  },
  navigationButtons: {
    flexDirection: 'row',
    gap: 12,
  },
  previousButton: {
    flex: 0.5,
    borderWidth: 2,
    borderColor: '#E5E7EB',
    paddingVertical: 12,
    borderRadius: 12,
    alignItems: 'center',
  },
  previousButtonText: {
    color: '#6B7280',
    fontSize: 14,
    fontWeight: '500',
  },
  nextButton: {
    backgroundColor: '#6366F1',
    paddingVertical: 12,
    borderRadius: 12,
    alignItems: 'center',
  },
  nextButtonText: {
    color: 'white',
    fontSize: 14,
    fontWeight: '600',
  },
});

export default TutorialScreen;