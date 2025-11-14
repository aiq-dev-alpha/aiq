import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TextInput,
  TouchableOpacity,
  ScrollView,
  Alert,
} from 'react-native';
import Icon from 'react-native-vector-icons/MaterialIcons';

const SetupProfileScreen = ({ onComplete }) => {
  const [formData, setFormData] = useState({
    fullName: '',
    selectedAvatar: '👤',
    ageRange: 0,
    occupation: '',
    bio: ''
  });
  const [isLoading, setIsLoading] = useState(false);

  const avatars = ['👤', '👨', '👩', '🧑', '👴', '👵', '🤵', '👩‍💼'];
  const ageRanges = ['18-24', '25-34', '35-44', '45-54', '55-64', '65+'];
  const occupations = ['Student', 'Software Developer', 'Data Scientist', 'Researcher', 'Teacher/Professor', 'Business Analyst', 'Product Manager', 'Designer', 'Entrepreneur', 'Other'];

  const handleSubmit = async () => {
    if (!formData.fullName.trim()) {
      Alert.alert('Error', 'Please enter your full name');
      return;
    }

    setIsLoading(true);
    // Simulate API call
    setTimeout(() => {
      setIsLoading(false);
      onComplete?.();
    }, 2000);
  };

  const isFormValid = formData.fullName.trim().length > 0;

  return (
    <View style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <View style={styles.headerContent}>
          <View style={styles.iconContainer}>
            <Icon name="person-add" size={24} color="#6366F1" />
          </View>
          <View style={styles.headerText}>
            <Text style={styles.title}>Create Your Profile</Text>
            <Text style={styles.subtitle}>Tell us about yourself</Text>
          </View>
        </View>
      </View>

      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        {/* Avatar Selection */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Choose Avatar</Text>
          <ScrollView
            horizontal
            showsHorizontalScrollIndicator={false}
            style={styles.avatarScroll}
          >
            {avatars.map(avatar => (
              <TouchableOpacity
                key={avatar}
                style={[
                  styles.avatarButton,
                  {
                    backgroundColor: formData.selectedAvatar === avatar
                      ? 'rgba(99, 102, 241, 0.1)'
                      : '#F9FAFB',
                    borderColor: formData.selectedAvatar === avatar
                      ? '#6366F1'
                      : '#E5E7EB',
                  }
                ]}
                onPress={() => setFormData(prev => ({ ...prev, selectedAvatar: avatar }))}
              >
                <Text style={styles.avatarEmoji}>{avatar}</Text>
              </TouchableOpacity>
            ))}
          </ScrollView>
        </View>

        {/* Full Name */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Full Name</Text>
          <View style={styles.inputContainer}>
            <Icon name="person" size={20} color="#9CA3AF" style={styles.inputIcon} />
            <TextInput
              style={styles.input}
              value={formData.fullName}
              onChangeText={(text) => setFormData(prev => ({ ...prev, fullName: text }))}
              placeholder="Enter your full name"
              placeholderTextColor="#9CA3AF"
            />
          </View>
        </View>

        {/* Age Range */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Age Range</Text>
          <View style={styles.pickerContainer}>
            <Text style={styles.pickerValue}>{ageRanges[formData.ageRange]}</Text>
            <Icon name="expand-more" size={20} color="#9CA3AF" />
          </View>
        </View>

        {/* Occupation */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Occupation</Text>
          <View style={styles.pickerContainer}>
            <Text style={[styles.pickerValue, { color: formData.occupation ? '#1F2937' : '#9CA3AF' }]}>
              {formData.occupation || 'Select your occupation'}
            </Text>
            <Icon name="expand-more" size={20} color="#9CA3AF" />
          </View>
        </View>

        {/* Bio */}
        <View style={styles.section}>
          <View style={styles.bioHeader}>
            <Text style={styles.sectionTitle}>Bio (Optional)</Text>
            <Text style={styles.bioCounter}>{formData.bio.length}/150</Text>
          </View>
          <TextInput
            style={styles.bioInput}
            value={formData.bio}
            onChangeText={(text) => {
              if (text.length <= 150) {
                setFormData(prev => ({ ...prev, bio: text }));
              }
            }}
            placeholder="Tell us something about yourself..."
            placeholderTextColor="#9CA3AF"
            multiline
            numberOfLines={3}
            textAlignVertical="top"
          />
        </View>
      </ScrollView>

      {/* Submit Button */}
      <View style={styles.buttonContainer}>
        <TouchableOpacity
          style={[
            styles.submitButton,
            { backgroundColor: isFormValid && !isLoading ? '#6366F1' : '#E5E7EB' }
          ]}
          onPress={handleSubmit}
          disabled={!isFormValid || isLoading}
        >
          <View style={styles.buttonContent}>
            {isLoading ? (
              <View style={styles.spinner} />
            ) : (
              <>
                <Text
                  style={[
                    styles.submitButtonText,
                    { color: isFormValid ? 'white' : '#9CA3AF' }
                  ]}
                >
                  Create Profile
                </Text>
                <Icon
                  name="check"
                  size={20}
                  color={isFormValid ? 'white' : '#9CA3AF'}
                />
              </>
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
  scrollView: {
    flex: 1,
    paddingHorizontal: 24,
  },
  section: {
    marginBottom: 24,
  },
  sectionTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: '#1F2937',
    marginBottom: 12,
  },
  avatarScroll: {
    flexDirection: 'row',
  },
  avatarButton: {
    width: 60,
    height: 60,
    borderRadius: 30,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
    borderWidth: 2,
  },
  avatarEmoji: {
    fontSize: 24,
  },
  inputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#E5E7EB',
    borderRadius: 12,
    paddingHorizontal: 16,
    paddingVertical: 12,
  },
  inputIcon: {
    marginRight: 12,
  },
  input: {
    flex: 1,
    fontSize: 16,
    color: '#1F2937',
  },
  pickerContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    borderWidth: 1,
    borderColor: '#E5E7EB',
    borderRadius: 12,
    paddingHorizontal: 16,
    paddingVertical: 12,
    backgroundColor: 'white',
  },
  pickerValue: {
    fontSize: 16,
    color: '#1F2937',
  },
  bioHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 12,
  },
  bioCounter: {
    fontSize: 12,
    color: '#9CA3AF',
  },
  bioInput: {
    borderWidth: 1,
    borderColor: '#E5E7EB',
    borderRadius: 12,
    paddingHorizontal: 16,
    paddingVertical: 12,
    fontSize: 16,
    color: '#1F2937',
    height: 80,
  },
  buttonContainer: {
    paddingHorizontal: 24,
    paddingBottom: 40,
    paddingTop: 16,
  },
  submitButton: {
    paddingVertical: 16,
    borderRadius: 16,
    alignItems: 'center',
  },
  buttonContent: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  submitButtonText: {
    fontSize: 16,
    fontWeight: '600',
    marginRight: 8,
  },
  spinner: {
    width: 24,
    height: 24,
    borderWidth: 2,
    borderColor: '#E5E7EB',
    borderTopColor: 'white',
    borderRadius: 12,
  },
});

export default SetupProfileScreen;