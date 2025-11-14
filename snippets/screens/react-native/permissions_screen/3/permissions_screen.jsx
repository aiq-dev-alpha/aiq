import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  ScrollView,
} from 'react-native';
import Icon from 'react-native-vector-icons/MaterialIcons';

const PermissionsScreen = ({ onContinue, onSkip }) => {
  const [permissions, setPermissions] = useState([
    {
      id: 'notifications',
      icon: 'notifications',
      title: 'Notifications',
      description: 'Get notified about new challenges and your progress',
      isRequired: false,
      isGranted: false
    },
    {
      id: 'camera',
      icon: 'camera-alt',
      title: 'Camera',
      description: 'Take photos for your profile and share achievements',
      isRequired: false,
      isGranted: false
    },
    {
      id: 'microphone',
      icon: 'mic',
      title: 'Microphone',
      description: 'Use voice commands for hands-free navigation',
      isRequired: false,
      isGranted: false
    },
    {
      id: 'location',
      icon: 'location-on',
      title: 'Location',
      description: 'Find nearby users and location-based challenges',
      isRequired: false,
      isGranted: false
    }
  ]);

  const togglePermission = (id) => {
    setPermissions(perms =>
      perms.map(perm =>
        perm.id === id ? { ...perm, isGranted: !perm.isGranted } : perm
      )
    );
  };

  return (
    <View style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <View style={styles.headerContent}>
          <View style={styles.iconContainer}>
            <Icon name="security" size={24} color="#6366F1" />
          </View>
          <View style={styles.headerText}>
            <Text style={styles.title}>Permissions</Text>
            <Text style={styles.subtitle}>Help us personalize your experience</Text>
          </View>
        </View>

        <Text style={styles.description}>
          We'd like your permission to access the following features to enhance your AIQ experience:
        </Text>

        {/* Info Banner */}
        <View style={styles.infoBanner}>
          <Icon name="info" size={16} color="#6B7280" />
          <Text style={styles.infoBannerText}>
            Select permissions to enable enhanced features
          </Text>
        </View>
      </View>

      {/* Permissions List */}
      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        {permissions.map(permission => (
          <View key={permission.id} style={styles.permissionCard}>
            <View style={styles.permissionContent}>
              <View style={[
                styles.permissionIcon,
                {
                  backgroundColor: permission.isGranted
                    ? 'rgba(16, 185, 129, 0.1)'
                    : 'rgba(107, 114, 128, 0.1)',
                }
              ]}>
                <Icon
                  name={permission.icon}
                  size={24}
                  color={permission.isGranted ? '#10B981' : '#6B7280'}
                />
              </View>

              <View style={styles.permissionInfo}>
                <View style={styles.titleRow}>
                  <Text style={styles.permissionTitle}>{permission.title}</Text>
                  {permission.isRequired && (
                    <View style={styles.requiredBadge}>
                      <Text style={styles.requiredText}>Required</Text>
                    </View>
                  )}
                </View>
                <Text style={styles.permissionDescription}>
                  {permission.description}
                </Text>
              </View>

              <TouchableOpacity
                style={[
                  styles.permissionButton,
                  {
                    backgroundColor: permission.isGranted ? '#10B981' : '#6366F1',
                  }
                ]}
                onPress={() => togglePermission(permission.id)}
              >
                <Text style={styles.permissionButtonText}>
                  {permission.isGranted ? 'Granted' : 'Allow'}
                </Text>
              </TouchableOpacity>
            </View>
          </View>
        ))}
      </ScrollView>

      {/* Action Buttons */}
      <View style={styles.buttonContainer}>
        <TouchableOpacity style={styles.continueButton} onPress={onContinue}>
          <Text style={styles.continueButtonText}>Continue</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.skipButton} onPress={onSkip}>
          <Text style={styles.skipButtonText}>Skip for now</Text>
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
  description: {
    fontSize: 16,
    color: '#6B7280',
    lineHeight: 24,
    marginBottom: 16,
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
  permissionCard: {
    backgroundColor: 'white',
    borderWidth: 1,
    borderColor: '#E5E7EB',
    borderRadius: 16,
    marginBottom: 16,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.05,
    shadowRadius: 10,
    elevation: 2,
  },
  permissionContent: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 16,
  },
  permissionIcon: {
    width: 48,
    height: 48,
    borderRadius: 12,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 16,
  },
  permissionInfo: {
    flex: 1,
  },
  titleRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 4,
  },
  permissionTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: '#1F2937',
  },
  requiredBadge: {
    backgroundColor: '#EF4444',
    paddingHorizontal: 6,
    paddingVertical: 2,
    borderRadius: 8,
    marginLeft: 8,
  },
  requiredText: {
    color: 'white',
    fontSize: 10,
    fontWeight: '500',
  },
  permissionDescription: {
    fontSize: 14,
    color: '#6B7280',
    lineHeight: 18,
  },
  permissionButton: {
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: 8,
  },
  permissionButtonText: {
    color: 'white',
    fontSize: 12,
    fontWeight: '600',
  },
  buttonContainer: {
    paddingHorizontal: 24,
    paddingBottom: 40,
    paddingTop: 16,
  },
  continueButton: {
    backgroundColor: '#6366F1',
    paddingVertical: 16,
    borderRadius: 16,
    alignItems: 'center',
    marginBottom: 12,
  },
  continueButtonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: '600',
  },
  skipButton: {
    alignItems: 'center',
    paddingVertical: 12,
  },
  skipButtonText: {
    color: '#6B7280',
    fontSize: 16,
    fontWeight: '500',
  },
});

export default PermissionsScreen;