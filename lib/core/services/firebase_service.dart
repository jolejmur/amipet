import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Getters
  static User? get currentUser => _auth.currentUser;
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Google Sign In
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.message}');
      throw e;
    } catch (e) {
      print('Google Sign In Error: $e');
      throw e;
    }
  }

  // Apple Sign In
  static Future<UserCredential?> signInWithApple() async {
    try {
      // Generate a random nonce
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase
      final UserCredential userCredential =
          await _auth.signInWithCredential(oauthCredential);

      // Update display name if it's not set and we have it from Apple
      if (userCredential.user != null &&
          userCredential.user!.displayName == null &&
          appleCredential.givenName != null) {
        await userCredential.user!.updateDisplayName(
            '${appleCredential.givenName} ${appleCredential.familyName ?? ''}'
                .trim());
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.message}');
      throw e;
    } on SignInWithAppleAuthorizationException catch (e) {
      print('Apple Sign In Error: ${e.message}');
      throw e;
    } catch (e) {
      print('Apple Sign In Error: $e');
      throw e;
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      print('Sign out error: $e');
      throw e;
    }
  }

  // Check if user is signed in
  static bool get isSignedIn => currentUser != null;

  // Get user display name
  static String get userDisplayName => currentUser?.displayName ?? 'Usuario';

  // Get user email
  static String get userEmail => currentUser?.email ?? '';

  // Get user photo URL
  static String get userPhotoURL => currentUser?.photoURL ?? '';

  // Helper method to generate nonce for Apple Sign In
  static String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  // Helper method to create SHA256 hash
  static String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Delete user account
  static Future<void> deleteAccount() async {
    try {
      await currentUser?.delete();
    } catch (e) {
      print('Delete account error: $e');
      throw e;
    }
  }

  // Update user profile
  static Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      await currentUser?.updateDisplayName(displayName);
      await currentUser?.updatePhotoURL(photoURL);
    } catch (e) {
      print('Update profile error: $e');
      throw e;
    }
  }
}
