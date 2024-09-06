import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locale_chat/model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;

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

    await _firestore.collection('Users').doc(user.uid).set(userModel.toJson());

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
  Future<void> updatePassword(
      {required String email, required String newPassword}) async {}

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
        profilePhoto: user.phoneNumber!,
        isOnline: false);

    await _firestore.collection('Users').doc(user.uid).set(userModel.toJson());

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
        profilePhoto: user.photoURL!,
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

  Future<bool> sendOtp(String email) async {
    EmailOTP.config(
        appEmail: 'localechatapp@gmail.com',
        appName: 'Locale Chat',
        otpType: OTPType.numeric,
        otpLength: 6,
        emailTheme: EmailTheme.v2);

    return EmailOTP.sendOTP(email: email);
  }

  Future<bool> verifyOtp(String email) async {
    EmailOTP.config(
        appEmail: 'localechatapp@gmail.com',
        appName: 'Locale Chat',
        otpType: OTPType.numeric,
        otpLength: 6,
        emailTheme: EmailTheme.v2);
    return EmailOTP.verifyOTP(
      otp: email,
    );
  }
}
