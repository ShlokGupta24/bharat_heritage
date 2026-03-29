
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:bharat_heritage/presentation/screens/login_screen.dart';
import 'package:bharat_heritage/presentation/screens/sign_up_screen.dart';
import '../../features/auth/domain/auth_provider.dart';
import '../../presentation/screens/home_screen.dart';
import 'package:bharat_heritage/presentation/screens/heritage_atlas_screen.dart';
import 'package:bharat_heritage/presentation/screens/passport_screen.dart';
import 'package:bharat_heritage/presentation/screens/monument_detail_screen.dart';
import 'package:bharat_heritage/presentation/screens/bookmarks_screen.dart';
part 'app_router.g.dart';

T? listFirstWhere<T>(Iterable<T> list, bool Function(T) test) {
  for (var element in list) {
    if (test(element)) return element;
  }
  return null;
}

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuth = authState.value ?? false;
      final isGoingToLogin = state.matchedLocation == '/login';
      final isGoingToSignup = state.matchedLocation == '/signup';

      if (authState.isLoading) return null;

      // Force redirect to login if not authenticated and not already on auth pages
      if (!isAuth && !isGoingToLogin && !isGoingToSignup) {
        return '/login';
      }

      // If logged in, redirect away from auth pages
      if (isAuth && (isGoingToLogin || isGoingToSignup)) return '/';

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/map',
        builder: (context, state) => const HeritageAtlasScreen(),
      ),
      GoRoute(
        path: '/passport',
        builder: (context, state) => const PassportScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          final from = state.uri.queryParameters['from'];
          return LoginScreen(from: from);
        },
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/monument/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return MonumentDetailScreen(monumentId: id);
        },
      ),
      GoRoute(
        path: '/bookmarks',
        builder: (context, state) => const BookmarksScreen(),
      ),
    ],
  );
}
