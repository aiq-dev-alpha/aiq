import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  Animated,
} from 'react-native';
import Icon from 'react-native-vector-icons/MaterialIcons';

const MaintenanceScreen = ({
  title = "Under Maintenance",
  message = "We're currently performing scheduled maintenance to improve your AIQ experience. Thank you for your patience!",
  estimatedEnd,
  onRefresh,
  supportEmail
}) => {
  const [toolsRotation] = useState(new Animated.Value(0));

  useEffect(() => {
    Animated.loop(
      Animated.sequence([
        Animated.timing(toolsRotation, {
          toValue: 15,
          duration: 2000,
          useNativeDriver: true,
        }),
        Animated.timing(toolsRotation, {
          toValue: 0,
          duration: 2000,
          useNativeDriver: true,
        }),
      ])
    ).start();
  }, []);

  const formatEstimatedTime = (date) => {
    if (!date) return null;

    const now = new Date();
    const difference = date.getTime() - now.getTime();

    if (difference <= 0) {
      return "Expected to be resolved soon";
    }

    const hours = Math.floor(difference / (1000 * 60 * 60));
    const minutes = Math.floor((difference % (1000 * 60 * 60)) / (1000 * 60));

    if (hours > 0) {
      return `Expected back in ${hours}h ${minutes}m`;
    } else {
      return `Expected back in ${minutes}m`;
    }
  };

  return (
    <View style={styles.container}>
      <View style={styles.content}>
        {/* Maintenance Illustration */}
        <View style={styles.illustrationContainer}>
          <View style={styles.mainCircle}>
            <Icon name="build" size={60} color="#F59E0B" />

            {/* Animated Tools */}
            <Animated.View
              style={[
                styles.tool1,
                {
                  transform: [{ rotate: toolsRotation.interpolate({
                    inputRange: [0, 15],
                    outputRange: ['0deg', '15deg'],
                  }) }],
                },
              ]}
            >
              <View style={styles.smallTool} />
            </Animated.View>

            <Animated.View
              style={[
                styles.tool2,
                {
                  transform: [{ rotate: toolsRotation.interpolate({
                    inputRange: [0, 15],
                    outputRange: ['0deg', '-9deg'],
                  }) }],
                },
              ]}
            >
              <View style={styles.smallTool} />
            </Animated.View>
          </View>
        </View>

        {/* Content */}
        <Text style={styles.title}>{title}</Text>
        <Text style={styles.message}>{message}</Text>

        {/* Estimated Time */}
        {estimatedEnd && (
          <View style={styles.timeContainer}>
            <View style={styles.timeContent}>
              <Icon name="schedule" size={20} color="#F59E0B" />
              <Text style={styles.timeText}>
                {formatEstimatedTime(estimatedEnd)}
              </Text>
            </View>
          </View>
        )}

        {/* Status Updates */}
        <View style={styles.updatesContainer}>
          <View style={styles.updatesHeader}>
            <Icon name="info" size={20} color="#6366F1" />
            <Text style={styles.updatesTitle}>What we're working on:</Text>
          </View>

          <View style={styles.updatesList}>
            {[
              "Improving quiz loading performance",
              "Adding new AI challenges",
              "Enhancing user experience",
              "Server optimization"
            ].map((item, index) => (
              <View key={index} style={styles.updateItem}>
                <View style={styles.bullet} />
                <Text style={styles.updateText}>{item}</Text>
              </View>
            ))}
          </View>
        </View>

        {/* Action Buttons */}
        <View style={styles.buttonContainer}>
          <TouchableOpacity style={styles.refreshButton} onPress={onRefresh}>
            <Icon name="refresh" size={18} color="white" />
            <Text style={styles.refreshButtonText}>Check Status</Text>
          </TouchableOpacity>

          {supportEmail && (
            <TouchableOpacity style={styles.supportButton}>
              <Icon name="email" size={18} color="#6B7280" />
              <Text style={styles.supportButtonText}>Contact Support</Text>
            </TouchableOpacity>
          )}
        </View>

        <Text style={styles.footerText}>
          Follow us on social media for live updates
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
  illustrationContainer: {
    marginBottom: 40,
  },
  mainCircle: {
    width: 160,
    height: 160,
    backgroundColor: 'rgba(245, 158, 11, 0.1)',
    borderRadius: 80,
    justifyContent: 'center',
    alignItems: 'center',
    position: 'relative',
  },
  tool1: {
    position: 'absolute',
    top: 20,
    right: 30,
  },
  tool2: {
    position: 'absolute',
    bottom: 30,
    left: 25,
  },
  smallTool: {
    width: 20,
    height: 20,
    backgroundColor: 'rgba(245, 158, 11, 0.6)',
    borderRadius: 10,
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
    marginBottom: 24,
  },
  timeContainer: {
    backgroundColor: '#FEF3C7',
    borderWidth: 1,
    borderColor: 'rgba(245, 158, 11, 0.3)',
    borderRadius: 12,
    padding: 16,
    marginBottom: 24,
    width: '100%',
  },
  timeContent: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  timeText: {
    fontSize: 14,
    color: '#92400E',
    fontWeight: '500',
    marginLeft: 12,
  },
  updatesContainer: {
    backgroundColor: '#F9FAFB',
    borderWidth: 1,
    borderColor: '#E5E7EB',
    borderRadius: 16,
    padding: 20,
    marginBottom: 24,
    width: '100%',
  },
  updatesHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
  },
  updatesTitle: {
    fontSize: 14,
    fontWeight: '600',
    color: '#374151',
    marginLeft: 8,
  },
  updatesList: {
    marginTop: 8,
  },
  updateItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 4,
  },
  bullet: {
    width: 4,
    height: 4,
    backgroundColor: '#6366F1',
    borderRadius: 2,
    marginRight: 8,
  },
  updateText: {
    fontSize: 14,
    color: '#6B7280',
    lineHeight: 20,
  },
  buttonContainer: {
    width: '100%',
    marginBottom: 16,
  },
  refreshButton: {
    backgroundColor: '#6366F1',
    paddingVertical: 12,
    paddingHorizontal: 24,
    borderRadius: 12,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 12,
  },
  refreshButtonText: {
    color: 'white',
    fontSize: 14,
    fontWeight: '600',
    marginLeft: 8,
  },
  supportButton: {
    borderWidth: 1,
    borderColor: '#E5E7EB',
    paddingVertical: 12,
    paddingHorizontal: 24,
    borderRadius: 12,
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
  },
  supportButtonText: {
    color: '#6B7280',
    fontSize: 14,
    fontWeight: '500',
    marginLeft: 8,
  },
  footerText: {
    fontSize: 12,
    color: '#9CA3AF',
    textAlign: 'center',
  },
});

export default MaintenanceScreen;