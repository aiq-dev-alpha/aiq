import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../core/di/service_locator.dart';
import '../../core/errors/api_exception.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  AuthState _state = AuthState.initial;
  User? _currentUser;
  String? _errorMessage;

  late final LoginUseCase _loginUseCase;
  late final LogoutUseCase _logoutUseCase;
  late final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthProvider() {
    _loginUseCase = sl<LoginUseCase>();
    _logoutUseCase = sl<LogoutUseCase>();
    _getCurrentUserUseCase = sl<GetCurrentUserUseCase>();
    _initializeAuth();
  }

  // Getters
  AuthState get state => _state;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == AuthState.loading;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isUnauthenticated => _state == AuthState.unauthenticated;
  bool get hasError => _state == AuthState.error;

  Future<void> _initializeAuth() async {
    try {
      _setState(AuthState.loading);
      _currentUser = await _getCurrentUserUseCase.call();
      if (_currentUser != null) {
        _setState(AuthState.authenticated);
      } else {
        _setState(AuthState.unauthenticated);
      }
    } catch (e) {
      _setState(AuthState.unauthenticated);
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _setState(AuthState.loading);
      _clearError();

      _currentUser = await _loginUseCase.call(
        LoginParams(email: email, password: password),
      );

      _setState(AuthState.authenticated);
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      _setState(AuthState.error);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred. Please try again.');
      _setState(AuthState.error);
      return false;
    }
  }

  Future<void> logout() async {
    try {
      _setState(AuthState.loading);
      await _logoutUseCase.call();
      _currentUser = null;
      _setState(AuthState.unauthenticated);
    } catch (e) {
      // Even if logout fails on server, clear local data
      _currentUser = null;
      _setState(AuthState.unauthenticated);
    }
  }

  void clearError() {
    _clearError();
    if (_state == AuthState.error) {
      _setState(_currentUser != null
          ? AuthState.authenticated
          : AuthState.unauthenticated);
    }
  }

  void _setState(AuthState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  void _setError(String error) {
    _errorMessage = error;
  }

  void _clearError() {
    _errorMessage = null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}