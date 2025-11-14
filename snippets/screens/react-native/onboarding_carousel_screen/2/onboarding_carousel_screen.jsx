import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  ScrollView,
  Dimensions,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import Icon from 'react-native-vector-icons/MaterialIcons';

const { width } = Dimensions.get('window');

const OnboardingCarouselScreen = ({ onComplete, onSkip }) => {
  const [currentIndex, setCurrentIndex] = useState(0);

  const pages = [
    {
      icon: 'psychology',
      title: 'Discover Your AI Potential',
      description: 'Explore the fascinating world of artificial intelligence and discover how smart you really are.',
      colors: ['#6366F1', 'rgba(99, 102, 241, 0.8)'],
    },
    {
      icon: 'quiz',
      title: 'Take Smart Challenges',
      description: 'Engage with carefully crafted questions designed to test your AI knowledge and reasoning skills.',
      colors: ['#8B5CF6', 'rgba(139, 92, 246, 0.8)'],
    },
    {
      icon: 'trending-up',
      title: 'Track Your Progress',
      description: 'Monitor your improvement over time and compete with friends to see who has the highest AIQ score.',
      colors: ['#06B6D4', 'rgba(6, 182, 212, 0.8)'],
    },
  ];

  const currentPage = pages[currentIndex];

  const nextPage = () => {
    if (currentIndex < pages.length - 1) {
      setCurrentIndex(currentIndex + 1);
    } else {
      onComplete?.();
    }
  };

  const onScroll = (event) => {
    const slideSize = event.nativeEvent.layoutMeasurement.width;
    const index = event.nativeEvent.contentOffset.x / slideSize;
    setCurrentIndex(Math.round(index));
  };

  return (
    <LinearGradient colors={currentPage.colors} style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity onPress={onSkip} style={styles.skipButton}>
          <Text style={styles.skipText}>Skip</Text>
        </TouchableOpacity>
      </View>

      <ScrollView
        horizontal
        pagingEnabled
        showsHorizontalScrollIndicator={false}
        onScroll={onScroll}
        scrollEventThrottle={16}
        style={styles.scrollView}
      >
        {pages.map((page, index) => (
          <View key={index} style={[styles.page, { width }]}>
            <View style={styles.pageContent}>
              {/* Icon */}
              <View style={styles.iconContainer}>
                <Icon name={page.icon} size={60} color="white" />
              </View>

              {/* Content */}
              <Text style={styles.title}>{page.title}</Text>
              <Text style={styles.description}>{page.description}</Text>
            </View>
          </View>
        ))}
      </ScrollView>

      {/* Navigation */}
      <View style={styles.navigation}>
        {/* Page indicators */}
        <View style={styles.indicators}>
          {pages.map((_, index) => (
            <View
              key={index}
              style={[
                styles.indicator,
                {
                  width: index === currentIndex ? 24 : 8,
                  backgroundColor:
                    index === currentIndex
                      ? 'white'
                      : 'rgba(255, 255, 255, 0.4)',
                },
              ]}
            />
          ))}
        </View>

        {/* Next button */}
        <TouchableOpacity style={styles.nextButton} onPress={nextPage}>
          <Text style={[styles.nextText, { color: currentPage.colors[0] }]}>
            {currentIndex === pages.length - 1 ? 'Get Started' : 'Next'}
          </Text>
          {currentIndex < pages.length - 1 && (
            <Icon
              name="arrow-forward"
              size={20}
              color={currentPage.colors[0]}
              style={styles.nextIcon}
            />
          )}
        </TouchableOpacity>
      </View>
    </LinearGradient>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  header: {
    paddingTop: 50,
    paddingHorizontal: 16,
    alignItems: 'flex-end',
  },
  skipButton: {
    padding: 8,
  },
  skipText: {
    color: 'white',
    fontSize: 16,
    fontWeight: '500',
  },
  scrollView: {
    flex: 1,
  },
  page: {
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 24,
  },
  pageContent: {
    alignItems: 'center',
  },
  iconContainer: {
    width: 120,
    height: 120,
    backgroundColor: 'rgba(255, 255, 255, 0.2)',
    borderRadius: 60,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 48,
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: 'white',
    textAlign: 'center',
    marginBottom: 24,
    lineHeight: 34,
  },
  description: {
    fontSize: 16,
    color: 'rgba(255, 255, 255, 0.7)',
    textAlign: 'center',
    lineHeight: 24,
    paddingHorizontal: 16,
  },
  navigation: {
    paddingHorizontal: 24,
    paddingBottom: 40,
  },
  indicators: {
    flexDirection: 'row',
    justifyContent: 'center',
    marginBottom: 32,
  },
  indicator: {
    height: 8,
    borderRadius: 4,
    marginHorizontal: 4,
  },
  nextButton: {
    backgroundColor: 'white',
    paddingVertical: 16,
    paddingHorizontal: 24,
    borderRadius: 16,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
  },
  nextText: {
    fontSize: 16,
    fontWeight: '600',
  },
  nextIcon: {
    marginLeft: 8,
  },
});

export default OnboardingCarouselScreen;