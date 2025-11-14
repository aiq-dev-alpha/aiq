import React from 'react';
import { View, Text, StyleSheet, ScrollView, Switch } from 'react-native';
import { SafeContainer, Card, Button } from '@/components';
import { useAppDispatch, useAppSelector } from '@/hooks';
import {
  setTheme,
  setNotificationEnabled,
  clearNotifications,
} from '@/store/slices/appSlice';

export const SettingsScreen: React.FC = () => {
  const dispatch = useAppDispatch();
  const { theme, notifications } = useAppSelector(state => state.app);

  const toggleTheme = () => {
    dispatch(setTheme(theme === 'light' ? 'dark' : 'light'));
  };

  const toggleNotifications = () => {
    dispatch(setNotificationEnabled(!notifications.enabled));
  };

  const handleClearNotifications = () => {
    dispatch(clearNotifications());
  };

  return (
    <SafeContainer>
      <ScrollView style={styles.container} showsVerticalScrollIndicator={false}>
        <Card style={styles.card}>
          <Text style={styles.cardTitle}>Appearance</Text>
          <View style={styles.settingRow}>
            <View style={styles.settingInfo}>
              <Text style={styles.settingLabel}>Dark Mode</Text>
              <Text style={styles.settingDescription}>
                Toggle between light and dark theme
              </Text>
            </View>
            <Switch
              value={theme === 'dark'}
              onValueChange={toggleTheme}
              trackColor={{ false: '#E5E5EA', true: '#007AFF' }}
              thumbColor={theme === 'dark' ? '#FFFFFF' : '#F4F3F4'}
            />
          </View>
        </Card>

        <Card style={styles.card}>
          <Text style={styles.cardTitle}>Notifications</Text>
          <View style={styles.settingRow}>
            <View style={styles.settingInfo}>
              <Text style={styles.settingLabel}>Push Notifications</Text>
              <Text style={styles.settingDescription}>
                Receive notifications from the app
              </Text>
            </View>
            <Switch
              value={notifications.enabled}
              onValueChange={toggleNotifications}
              trackColor={{ false: '#E5E5EA', true: '#007AFF' }}
              thumbColor={notifications.enabled ? '#FFFFFF' : '#F4F3F4'}
            />
          </View>

          <View style={styles.notificationActions}>
            <View style={styles.notificationCount}>
              <Text style={styles.countLabel}>Notification Count:</Text>
              <Text style={styles.countValue}>{notifications.count}</Text>
            </View>
            <Button
              title="Clear All"
              onPress={handleClearNotifications}
              variant="outline"
              size="small"
              disabled={notifications.count === 0}
            />
          </View>
        </Card>

        <Card style={styles.card}>
          <Text style={styles.cardTitle}>About</Text>
          <View style={styles.infoRow}>
            <Text style={styles.infoLabel}>App Version</Text>
            <Text style={styles.infoValue}>1.0.0</Text>
          </View>
          <View style={styles.infoRow}>
            <Text style={styles.infoLabel}>Build Number</Text>
            <Text style={styles.infoValue}>1</Text>
          </View>
        </Card>

        <Card style={styles.card}>
          <Text style={styles.cardTitle}>Support</Text>
          <Button
            title="Contact Support"
            onPress={() => console.log('Contact support')}
            variant="outline"
            style={styles.supportButton}
          />
          <Button
            title="Rate App"
            onPress={() => console.log('Rate app')}
            variant="outline"
            style={styles.supportButton}
          />
          <Button
            title="Privacy Policy"
            onPress={() => console.log('Privacy policy')}
            variant="outline"
            style={styles.supportButton}
          />
        </Card>
      </ScrollView>
    </SafeContainer>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F8F9FA',
  },
  card: {
    margin: 16,
    marginBottom: 8,
  },
  cardTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: '#1C1C1E',
    marginBottom: 16,
  },
  settingRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: 8,
  },
  settingInfo: {
    flex: 1,
    marginRight: 16,
  },
  settingLabel: {
    fontSize: 16,
    fontWeight: '500',
    color: '#1C1C1E',
    marginBottom: 4,
  },
  settingDescription: {
    fontSize: 14,
    color: '#8E8E93',
  },
  notificationActions: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    marginTop: 16,
    paddingTop: 16,
    borderTopWidth: 1,
    borderTopColor: '#E5E5EA',
  },
  notificationCount: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  countLabel: {
    fontSize: 16,
    color: '#1C1C1E',
    marginRight: 8,
  },
  countValue: {
    fontSize: 16,
    fontWeight: '600',
    color: '#007AFF',
  },
  infoRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: 12,
  },
  infoLabel: {
    fontSize: 16,
    color: '#1C1C1E',
  },
  infoValue: {
    fontSize: 16,
    color: '#8E8E93',
  },
  supportButton: {
    marginBottom: 12,
  },
});