// Common types used throughout the application

export interface User {
  id: string;
  email: string;
  name: string;
  avatar?: string;
  createdAt: string;
  updatedAt: string;
}

export interface ApiResponse<T> {
  data: T;
  message: string;
  status: 'success' | 'error';
}

export interface ApiError {
  message: string;
  code: string;
  details?: Record<string, any>;
}

export interface LoadingState {
  isLoading: boolean;
  error: string | null;
}

// Navigation types
export type RootStackParamList = {
  Home: undefined;
  Profile: { userId: string };
  Settings: undefined;
};

export type TabParamList = {
  HomeTab: undefined;
  ProfileTab: undefined;
  SettingsTab: undefined;
};

// Common component props
export interface BaseComponentProps {
  testID?: string;
  style?: any;
}

// Storage keys
export enum StorageKeys {
  USER_TOKEN = '@user_token',
  USER_PROFILE = '@user_profile',
  APP_SETTINGS = '@app_settings',
}