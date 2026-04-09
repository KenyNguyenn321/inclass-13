import 'package:firebase_auth/firebase_auth.dart';

// auth service handles all firebase authentication actions
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // registers a new user with email and password
  Future<UserCredential> register(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // signs in an existing user with email and password
  Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // signs out the current user
  Future<void> signOut() {
    return _auth.signOut();
  }

  // updates the current user's password
  Future<void> changePassword(String newPassword) async {
    final user = _auth.currentUser;

    if (user != null) {
      await user.updatePassword(newPassword);
    }
  }

  // returns the currently signed in user
  User? get currentUser => _auth.currentUser;
}