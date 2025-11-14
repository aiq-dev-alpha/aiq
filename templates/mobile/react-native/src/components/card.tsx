import React from 'react';
import { View, StyleSheet, ViewStyle } from 'react-native';
import { BaseComponentProps } from '@/types';

interface CardProps extends BaseComponentProps {
  children: React.ReactNode;
  elevation?: number;
  padding?: number;
  margin?: number;
  borderRadius?: number;
}

export const Card: React.FC<CardProps> = ({
  children,
  elevation = 2,
  padding = 16,
  margin = 0,
  borderRadius = 12,
  style,
  testID,
}) => {
  const cardStyle: ViewStyle = {
    backgroundColor: '#FFFFFF',
    borderRadius,
    padding,
    margin,
    shadowColor: '#000000',
    shadowOffset: {
      width: 0,
      height: elevation,
    },
    shadowOpacity: 0.1,
    shadowRadius: elevation * 2,
    elevation: elevation * 2, // Android elevation
  };

  return (
    <View style={[cardStyle, style]} testID={testID}>
      {children}
    </View>
  );
};

const styles = StyleSheet.create({
  // Additional predefined styles can go here if needed
});