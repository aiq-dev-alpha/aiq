import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  ScrollView,
} from 'react-native';
import Icon from 'react-native-vector-icons/MaterialIcons';

const ChooseInterestsScreen = ({ onContinue }) => {
  const [selectedInterests, setSelectedInterests] = useState(new Set());
  const minSelections = 3;

  const categories = [
    {
      name: "AI & Technology",
      interests: ["Machine Learning", "Deep Learning", "Computer Vision", "Natural Language Processing", "Robotics", "Data Science"],
      color: '#6366F1',
      icon: 'memory'
    },
    {
      name: "Science & Research",
      interests: ["Physics", "Mathematics", "Chemistry", "Biology", "Neuroscience", "Psychology"],
      color: '#8B5CF6',
      icon: 'science'
    },
    {
      name: "Programming",
      interests: ["Python", "JavaScript", "Flutter/Dart", "Swift", "Java", "React"],
      color: '#06B6D4',
      icon: 'code'
    },
    {
      name: "Business & Innovation",
      interests: ["Entrepreneurship", "Product Management", "Digital Marketing", "Strategy", "Finance", "Leadership"],
      color: '#10B981',
      icon: 'business'
    }
  ];

  const toggleInterest = (interest) => {
    const newSelected = new Set(selectedInterests);
    if (newSelected.has(interest)) {
      newSelected.delete(interest);
    } else {
      newSelected.add(interest);
    }
    setSelectedInterests(newSelected);
  };

  const isFormValid = selectedInterests.size >= minSelections;

  return (
    <View style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <View style={styles.headerContent}>
          <View style={styles.iconContainer}>
            <Icon name="favorite" size={24} color="#6366F1" />
          </View>
          <View style={styles.headerText}>
            <Text style={styles.title}>Choose Your Interests</Text>
            <Text style={styles.subtitle}>Help us personalize your experience</Text>
          </View>
        </View>

        {/* Info Banner */}
        <View style={styles.infoBanner}>
          <Icon name="info" size={16} color="#6B7280" />
          <Text style={styles.infoBannerText}>
            Select at least {minSelections} interests ({selectedInterests.size} selected)
          </Text>
        </View>
      </View>

      {/* Categories */}
      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        {categories.map(category => (
          <View key={category.name} style={styles.categorySection}>
            {/* Category Header */}
            <View style={styles.categoryHeader}>
              <View style={[styles.categoryIcon, { backgroundColor: `${category.color}1A` }]}>
                <Icon name={category.icon} size={18} color={category.color} />
              </View>
              <Text style={styles.categoryName}>{category.name}</Text>
            </View>

            {/* Interest Chips */}
            <View style={styles.chipsContainer}>
              {category.interests.map(interest => {
                const isSelected = selectedInterests.has(interest);
                return (
                  <TouchableOpacity
                    key={interest}
                    style={[
                      styles.chip,
                      {
                        backgroundColor: isSelected ? category.color : 'white',
                        borderColor: isSelected ? category.color : '#E5E7EB',
                      }
                    ]}
                    onPress={() => toggleInterest(interest)}
                  >
                    <View style={styles.chipContent}>
                      {isSelected && (
                        <Text style={styles.checkMark}>✓</Text>
                      )}
                      <Text
                        style={[
                          styles.chipText,
                          { color: isSelected ? 'white' : '#6B7280' }
                        ]}
                      >
                        {interest}
                      </Text>
                    </View>
                  </TouchableOpacity>
                );
              })}
            </View>
          </View>
        ))}
      </ScrollView>

      {/* Continue Button */}
      <View style={styles.buttonContainer}>
        <TouchableOpacity
          style={[
            styles.continueButton,
            { backgroundColor: isFormValid ? '#6366F1' : '#E5E7EB' }
          ]}
          onPress={onContinue}
          disabled={!isFormValid}
        >
          <View style={styles.buttonContent}>
            <Text
              style={[
                styles.continueButtonText,
                { color: isFormValid ? 'white' : '#9CA3AF' }
              ]}
            >
              Continue with {selectedInterests.size} interests
            </Text>
            {isFormValid && (
              <Icon name="arrow-forward" size={20} color="white" />
            )}
          </View>
        </TouchableOpacity>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'white',
  },
  header: {
    paddingHorizontal: 24,
    paddingTop: 60,
    paddingBottom: 20,
  },
  headerContent: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 16,
  },
  iconContainer: {
    width: 48,
    height: 48,
    backgroundColor: 'rgba(99, 102, 241, 0.1)',
    borderRadius: 12,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 16,
  },
  headerText: {
    flex: 1,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#1F2937',
  },
  subtitle: {
    fontSize: 14,
    color: '#6B7280',
  },
  infoBanner: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#F9FAFB',
    padding: 12,
    borderRadius: 12,
  },
  infoBannerText: {
    fontSize: 12,
    color: '#6B7280',
    marginLeft: 8,
  },
  scrollView: {
    flex: 1,
    paddingHorizontal: 24,
  },
  categorySection: {
    marginBottom: 24,
  },
  categoryHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
  },
  categoryIcon: {
    width: 32,
    height: 32,
    borderRadius: 8,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  categoryName: {
    fontSize: 18,
    fontWeight: '600',
    color: '#1F2937',
  },
  chipsContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
  },
  chip: {
    borderWidth: 2,
    borderRadius: 20,
    paddingHorizontal: 16,
    paddingVertical: 10,
    marginRight: 8,
    marginBottom: 8,
  },
  chipContent: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  checkMark: {
    fontSize: 12,
    fontWeight: '600',
    color: 'white',
    marginRight: 6,
  },
  chipText: {
    fontSize: 14,
    fontWeight: '500',
  },
  buttonContainer: {
    paddingHorizontal: 24,
    paddingBottom: 40,
    paddingTop: 16,
  },
  continueButton: {
    paddingVertical: 16,
    borderRadius: 16,
    alignItems: 'center',
  },
  buttonContent: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  continueButtonText: {
    fontSize: 16,
    fontWeight: '600',
    marginRight: 8,
  },
});

export default ChooseInterestsScreen;