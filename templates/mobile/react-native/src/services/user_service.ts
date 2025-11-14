import { apiClient } from './api';
import { User } from '@/types';

export class UserService {
  async getCurrentUser(): Promise<User> {
    const response = await apiClient.get<User>('/users/me');
    return response.data;
  }

  async getUserById(userId: string): Promise<User> {
    const response = await apiClient.get<User>(`/users/${userId}`);
    return response.data;
  }

  async updateProfile(userData: Partial<User>): Promise<User> {
    const response = await apiClient.put<User>('/users/profile', userData);
    return response.data;
  }

  async updatePassword(currentPassword: string, newPassword: string): Promise<{ message: string }> {
    const response = await apiClient.put<{ message: string }>('/users/password', {
      currentPassword,
      newPassword,
    });
    return response.data;
  }

  async uploadAvatar(file: any, onProgress?: (progress: number) => void): Promise<{ avatarUrl: string }> {
    const response = await apiClient.uploadFile('/users/avatar', file, onProgress);
    return response.data;
  }

  async deleteAccount(): Promise<{ message: string }> {
    const response = await apiClient.delete<{ message: string }>('/users/account');
    return response.data;
  }

  async getUserPreferences(): Promise<Record<string, any>> {
    const response = await apiClient.get<Record<string, any>>('/users/preferences');
    return response.data;
  }

  async updateUserPreferences(preferences: Record<string, any>): Promise<Record<string, any>> {
    const response = await apiClient.put<Record<string, any>>('/users/preferences', preferences);
    return response.data;
  }
}

export const userService = new UserService();