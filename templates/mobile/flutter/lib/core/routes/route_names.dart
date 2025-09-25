class RouteNames {
  // Auth routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main app routes
  static const String home = '/home';
  static const String profile = '/home/profile';
  static const String settings = '/home/settings';

  // Feature routes (add more as needed)
  static const String search = '/search';
  static const String notifications = '/notifications';
  static const String help = '/help';
  static const String about = '/about';

  // Utility methods
  static List<String> get allRoutes => [
        splash,
        login,
        register,
        forgotPassword,
        home,
        profile,
        settings,
        search,
        notifications,
        help,
        about,
      ];

  static bool isValidRoute(String route) {
    return allRoutes.contains(route);
  }
}