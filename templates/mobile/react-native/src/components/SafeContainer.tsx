import React from 'react';
import { SafeAreaView, StyleSheet, ViewStyle } from 'react-native';
import { BaseComponentProps } from '@/types';

interface SafeContainerProps extends BaseComponentProps {
  children: React.ReactNode;
  edges?: ('top' | 'bottom' | 'left' | 'right')[];
  backgroundColor?: string;
}

export const SafeContainer: React.FC<SafeContainerProps> = ({
  children,
  backgroundColor = '#FFFFFF',
  style,
  testID,
}) => {
  const containerStyle: ViewStyle = {
    flex: 1,
    backgroundColor,
  };

  return (
    <SafeAreaView style={[containerStyle, style]} testID={testID}>
      {children}
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  // Additional styles if needed
});