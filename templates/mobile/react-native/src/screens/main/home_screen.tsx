import React, { useEffect } from 'react';
import { View, Text, StyleSheet, ScrollView } from 'react-native';
import { SafeContainer, Card, Button } from '@/components';
import { useAppDispatch, useAppSelector } from '@/hooks';
import { incrementNotificationCount } from '@/store/slices/appSlice';

export const HomeScreen: React.FC = () => {
  const dispatch = useAppDispatch();
  const { user } = useAppSelector(state => state.auth);
  const { notifications } = useAppSelector(state => state.app);

  const handleTestNotification = () => {
    dispatch(incrementNotificationCount());
  };

  return (
    <SafeContainer>
      <ScrollView style={styles.container} showsVerticalScrollIndicator={false}>
        <View style={styles.header}>
          <Text style={styles.welcomeText}>Welcome back!</Text>
          <Text style={styles.nameText}>{user?.name || 'User'}</Text>
        </View>

        <Card style={styles.card}>
          <Text style={styles.cardTitle}>App Status</Text>
          <Text style={styles.cardSubtitle}>Your app is running smoothly</Text>
          <View style={styles.statusRow}>
            <Text style={styles.statusLabel}>Notifications:</Text>
            <Text style={styles.statusValue}>{notifications.count}</Text>
          </View>
        </Card>

        <Card style={styles.card}>
          <Text style={styles.cardTitle}>Quick Actions</Text>
          <Button
            title="Test Notification"
            onPress={handleTestNotification}
            style={styles.actionButton}
          />
          <Button
            title="Refresh Data"
            onPress={() => console.log('Refresh data')}
            variant="outline"
            style={styles.actionButton}
          />
        </Card>

        <Card style={styles.card}>
          <Text style={styles.cardTitle}>Recent Activity</Text>
          <Text style={styles.cardContent}>No recent activity to show</Text>
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
  header: {
    padding: 20,
    backgroundColor: '#007AFF',
    borderBottomLeftRadius: 24,
    borderBottomRightRadius: 24,
    marginBottom: 20,
  },
  welcomeText: {
    fontSize: 16,
    color: 'rgba(255, 255, 255, 0.8)',
    marginBottom: 4,
  },
  nameText: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#FFFFFF',
  },
  card: {
    margin: 16,
    marginBottom: 8,
  },
  cardTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: '#1C1C1E',
    marginBottom: 8,
  },
  cardSubtitle: {
    fontSize: 14,
    color: '#8E8E93',
    marginBottom: 16,
  },
  cardContent: {
    fontSize: 14,
    color: '#8E8E93',
  },
  statusRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: 8,
  },
  statusLabel: {
    fontSize: 16,
    color: '#1C1C1E',
  },
  statusValue: {
    fontSize: 16,
    fontWeight: '600',
    color: '#007AFF',
  },
  actionButton: {
    marginBottom: 12,
  },
});