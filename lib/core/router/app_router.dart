import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Placeholder imports for generated screens
import 'package:bharat_heritage/presentation/screens/login_screen.dart';
import 'package:bharat_heritage/presentation/screens/sign_up_screen.dart';
import '../../features/auth/domain/auth_provider.dart';
import '../../presentation/screens/home_screen.dart';

import '../../features/monuments/domain/monuments_provider.dart';
import '../../features/monuments/data/models/monument.dart';

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
      /*GoRoute(
        path: '/monument/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          final List<Monument> monuments = ref.watch(monumentsProvider).value ?? [];
          final monument = listFirstWhere(monuments, (m) => m.id == id) ?? monuments.first;
          return MonumentDetailScreen(monument: monument);
        },
      ),*/
    ],
  );
}
