import { createSlice, PayloadAction } from '@reduxjs/toolkit';

interface AppState {
  theme: 'light' | 'dark';
  language: string;
  isConnected: boolean;
  notifications: {
    enabled: boolean;
    count: number;
  };
}

const initialState: AppState = {
  theme: 'light',
  language: 'en',
  isConnected: true,
  notifications: {
    enabled: true,
    count: 0,
  },
};

const appSlice = createSlice({
  name: 'app',
  initialState,
  reducers: {
    setTheme: (state, action: PayloadAction<'light' | 'dark'>) => {
      state.theme = action.payload;
    },
    setLanguage: (state, action: PayloadAction<string>) => {
      state.language = action.payload;
    },
    setConnectedStatus: (state, action: PayloadAction<boolean>) => {
      state.isConnected = action.payload;
    },
    setNotificationEnabled: (state, action: PayloadAction<boolean>) => {
      state.notifications.enabled = action.payload;
    },
    setNotificationCount: (state, action: PayloadAction<number>) => {
      state.notifications.count = action.payload;
    },
    incrementNotificationCount: (state) => {
      state.notifications.count += 1;
    },
    clearNotifications: (state) => {
      state.notifications.count = 0;
    },
  },
});

export const {
  setTheme,
  setLanguage,
  setConnectedStatus,
  setNotificationEnabled,
  setNotificationCount,
  incrementNotificationCount,
  clearNotifications,
} = appSlice.actions;

export default appSlice.reducer;