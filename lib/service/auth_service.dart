import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locale_chat/model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

//Sign In function
  Future<UserModel?> signIn(
      {required String email, required String password}) async {
    var userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = userCredential.user!;
    UserModel userModel = UserModel(
        id: user.uid,
        userName: user.uid,
        isAnonymousName: user.isAnonymous,
        email: user.email!,
        profilePhoto: '',
        isOnline: false);

    return userModel;
  }

//Register new user
  Future<UserModel?> register(
      {required String email, required String password}) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = userCredential.user!;
    UserModel? userModel = UserModel(
        id: user.uid,
        userName: user.uid,
        isAnonymousName: user.isAnonymous,
        email: user.email!,
        profilePhoto: "",
        isOnline: false);

    await _firestore.collection('Users').doc(user.uid).set(userModel.toMap());

    return userModel;
  }

//Logout from account
  Future<void> signOut() async {
    await _auth.signOut();
  }

//Is user's email verified control it
  Future<void> autehntiacate() async {
    if (_auth.currentUser != null && !_auth.currentUser!.emailVerified) {
      await _auth.currentUser!.sendEmailVerification();
    }
  }

//Send to user email a link to reset password
  Future<void> forgotPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

//Provide Google authenticate
  Future<UserModel?> authWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    User user = userCredential.user!;

    UserModel userModel = UserModel(
        id: user.uid,
        userName: "",
        isAnonymousName: user.isAnonymous,
        email: user.email!,
        profilePhoto: "",
        isOnline: false);

    return userModel;
  }

//Provide facebook autheantication
  Future<UserModel?> authWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    UserCredential userCredential =
        await _auth.signInWithCredential(facebookAuthCredential);
    User user = userCredential.user!;

    UserModel userModel = UserModel(
        id: user.uid,
        userName: "",
        isAnonymousName: user.isAnonymous,
        email: user.email!,
        profilePhoto: "",
        isOnline: false);

    return userModel;
  }

//Follow is there any user or not
  UserModel? authStateChanges() {
    var userc = _auth.authStateChanges();
    UserModel? userModel1;
    userc.map((event) {
      if (event != null) {
        UserModel userModel = UserModel(
            id: event.uid,
            userName: event.uid,
            isAnonymousName: event.isAnonymous,
            email: event.email!,
            profilePhoto: "",
            isOnline: false);
        userModel1 = userModel;
      } else {
        userModel1 = null;
      }
    });
    return userModel1;
  }
}
