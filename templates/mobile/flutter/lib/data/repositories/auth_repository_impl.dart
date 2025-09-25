import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/local_storage.dart';
import '../../core/constants/app_constants.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;
  final LocalStorage localStorage;

  AuthRepositoryImpl({
    required this.apiClient,
    required this.localStorage,
  });

  @override
  Future<User> login(String email, String password) async {
    final response = await apiClient.post(
      '/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    final userData = response.data['user'] ?? response.data;
    final token = response.data['token'] ?? response.data['access_token'];

    if (token != null) {
      await saveAuthToken(token);
    }

    final user = UserModel.fromJson(userData);
    await _saveUserData(user);

    return user;
  }

  @override
  Future<User> register(String email, String password, String name) async {
    final response = await apiClient.post(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'name': name,
      },
    );

    final userData = response.data['user'] ?? response.data;
    final token = response.data['token'] ?? response.data['access_token'];

    if (token != null) {
      await saveAuthToken(token);
    }

    final user = UserModel.fromJson(userData);
    await _saveUserData(user);

    return user;
  }

  @override
  Future<void> logout() async {
    try {
      // Call logout endpoint if available
      await apiClient.post('/auth/logout');
    } catch (e) {
      // Continue with local cleanup even if server logout fails
    }

    // Clear local data
    await clearAuthToken();
    await _clearUserData();
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      // First try to get user from local storage
      final userData = await localStorage.getObject(AppConstants.userDataKey);
      if (userData != null) {
        return UserModel.fromJson(userData);
      }

      // If not available locally and we have a token, fetch from server
      final token = await getAuthToken();
      if (token != null) {
        final response = await apiClient.get('/auth/me');
        final user = UserModel.fromJson(response.data);
        await _saveUserData(user);
        return user;
      }

      return null;
    } catch (e) {
      // If there's an error (like 401), clear local data
      await clearAuthToken();
      await _clearUserData();
      return null;
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    await apiClient.post(
      '/auth/forgot-password',
      data: {'email': email},
    );
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    await apiClient.post(
      '/auth/reset-password',
      data: {
        'token': token,
        'password': newPassword,
      },
    );
  }

  @override
  Future<User> updateProfile(User user) async {
    final userModel = UserModel.fromEntity(user);
    final response = await apiClient.put(
      '/auth/profile',
      data: userModel.toJson(),
    );

    final updatedUser = UserModel.fromJson(response.data);
    await _saveUserData(updatedUser);

    return updatedUser;
  }

  @override
  Future<void> deleteAccount() async {
    await apiClient.delete('/auth/account');
    await clearAuthToken();
    await _clearUserData();
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    return token != null;
  }

  @override
  Future<String?> getAuthToken() async {
    return await localStorage.getString(AppConstants.userTokenKey);
  }

  @override
  Future<void> saveAuthToken(String token) async {
    await localStorage.saveString(AppConstants.userTokenKey, token);
  }

  @override
  Future<void> clearAuthToken() async {
    await localStorage.remove(AppConstants.userTokenKey);
  }

  Future<void> _saveUserData(User user) async {
    final userModel = UserModel.fromEntity(user);
    await localStorage.saveObject(
      AppConstants.userDataKey,
      userModel.toJson(),
    );
  }

  Future<void> _clearUserData() async {
    await localStorage.remove(AppConstants.userDataKey);
  }
}