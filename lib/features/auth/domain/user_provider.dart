import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

/// Streams the currently signed-in [User] (or null if signed out).
@riverpod
Stream<User?> currentUser(Ref ref) {
  return FirebaseAuth.instance.authStateChanges();
}
