import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signInWithGoogle() async {
    // Step 1: Google login popup
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) throw Exception("Login cancelled");

    // Step 2: Get tokens
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Step 3: Convert to Firebase credential
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    // Step 4: Login to Firebase
    return await _auth.signInWithCredential(credential);
  }
}
