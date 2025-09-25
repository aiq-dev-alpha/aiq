import '../network/api_client.dart';
import '../storage/local_storage.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  final Map<Type, dynamic> _services = {};

  // Register a service
  void registerSingleton<T>(T service) {
    _services[T] = service;
  }

  // Register a factory (creates new instance each time)
  void registerFactory<T>(T Function() factory) {
    _services[T] = factory;
  }

  // Get a service
  T get<T>() {
    final service = _services[T];
    if (service == null) {
      throw Exception('Service of type $T is not registered');
    }

    if (service is Function) {
      return service() as T;
    }

    return service as T;
  }

  // Check if service is registered
  bool isRegistered<T>() {
    return _services.containsKey(T);
  }

  // Remove a service
  void unregister<T>() {
    _services.remove(T);
  }

  // Clear all services
  void clear() {
    _services.clear();
  }

  // Initialize all dependencies
  static Future<void> init() async {
    final sl = ServiceLocator();

    // Core services
    sl.registerSingleton<ApiClient>(ApiClient());
    sl.registerSingleton<LocalStorage>(SharedPreferencesStorage());

    // Repositories
    sl.registerSingleton<AuthRepository>(
      AuthRepositoryImpl(
        apiClient: sl.get<ApiClient>(),
        localStorage: sl.get<LocalStorage>(),
      ),
    );

    // Use cases
    sl.registerSingleton<LoginUseCase>(
      LoginUseCase(sl.get<AuthRepository>()),
    );
    sl.registerSingleton<LogoutUseCase>(
      LogoutUseCase(sl.get<AuthRepository>()),
    );
    sl.registerSingleton<GetCurrentUserUseCase>(
      GetCurrentUserUseCase(sl.get<AuthRepository>()),
    );
  }
}

// Extension to make it easier to use
extension ServiceLocatorExtension on ServiceLocator {
  T call<T>() => get<T>();
}

// Global getter for easier access
ServiceLocator get sl => ServiceLocator();