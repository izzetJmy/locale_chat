import 'dart:io';

import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

    try {
      // Firestore'dan kullanıcı verilerini al
      DocumentSnapshot userDoc =
          await _firestore.collection('Users').doc(user.uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        return UserModel(
          id: user.uid,
          userName: userData['userName'] ?? 'Anonymous',
          isAnonymousName: userData['isAnonymousName'] ?? user.isAnonymous,
          email: userData['email'] ?? user.email!,
          createdAt:
              userData['createdAt'] ?? user.metadata.creationTime.toString(),
          profilePhoto: userData['profilePhoto'] ?? '',
          isOnline: userData['isOnline'] ?? false,
        );
      }
    } catch (e) {
      debugPrint('Error fetching user data during sign in: $e');
    }

    // Firestore'dan veri alınamazsa veya hata oluşursa, temel model döndür
    UserModel userModel = UserModel(
        id: user.uid,
        userName: 'Anonymous',
        isAnonymousName: user.isAnonymous,
        email: user.email!,
        createdAt: user.metadata.creationTime.toString(),
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
        userName: '',
        isAnonymousName: user.isAnonymous,
        email: user.email!,
        createdAt: user.metadata.creationTime.toString(),
        profilePhoto: "",
        isOnline: false);

    await _firestore.collection('Users').doc(user.uid).set(userModel.toJson());

    return userModel;
  }

//Logout from account
  Future<void> signOut() async {
    await _auth.signOut();
  }

  //Get user info from firestore
  Future<UserModel?> getUserInfo(String userId) async {
    final user = await _firestore.collection('Users').doc(userId).get();
    return UserModel.fromJson(user.data() as Map<String, dynamic>);
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
        userName: '',
        isAnonymousName: user.isAnonymous,
        email: user.email!,
        createdAt: user.metadata.creationTime.toString(),
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
        userName: '',
        isAnonymousName: user.isAnonymous,
        email: user.email!,
        createdAt: user.metadata.creationTime.toString(),
        profilePhoto: user.photoURL!,
        isOnline: false);

    return userModel;
  }

//Follow is there any user or not
  Future<UserModel?> authStateChanges() async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        // Firestore'dan kullanıcı verilerini al
        DocumentSnapshot userDoc =
            await _firestore.collection('Users').doc(currentUser.uid).get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;

          UserModel userModel = UserModel(
            id: currentUser.uid,
            userName: userData['userName'] ?? '',
            isAnonymousName:
                userData['isAnonymousName'] ?? currentUser.isAnonymous,
            email: userData['email'] ?? currentUser.email ?? '',
            createdAt: userData['createdAt'] ??
                currentUser.metadata.creationTime.toString(),
            profilePhoto: userData['profilePhoto'] ?? '',
            isOnline: userData['isOnline'] ?? false,
          );
          return userModel;
        } else {
          // Firestore'da kullanıcı belgesi yoksa, temel bilgilerle oluştur
          UserModel userModel = UserModel(
            id: currentUser.uid,
            userName: '',
            isAnonymousName: currentUser.isAnonymous,
            email: currentUser.email ?? '',
            createdAt: currentUser.metadata.creationTime.toString(),
            profilePhoto: currentUser.photoURL ?? '',
            isOnline: false,
          );

          // Yeni kullanıcı belgesini Firestore'a ekle
          await _firestore
              .collection('Users')
              .doc(currentUser.uid)
              .set(userModel.toJson());
          return userModel;
        }
      } catch (e) {
        debugPrint('Error fetching user data from Firestore: $e');
        // Hata durumunda temel kullanıcı bilgileriyle devam et
        return UserModel(
          id: currentUser.uid,
          userName: '',
          isAnonymousName: currentUser.isAnonymous,
          email: currentUser.email ?? '',
          createdAt: currentUser.metadata.creationTime.toString(),
          profilePhoto: currentUser.photoURL ?? '',
          isOnline: false,
        );
      }
    }
    debugPrint('No authenticated user found');
    return null;
  }

//Send otp to user email
  Future<bool> sendOtp(String email) async {
    EmailOTP.config(
        appEmail: 'localechatapp@gmail.com',
        appName: 'Locale Chat',
        otpType: OTPType.numeric,
        otpLength: 6,
        emailTheme: EmailTheme.v2);

    return EmailOTP.sendOTP(email: email);
  }

//Verify otp from user email
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

//Update user name
  Future<UserModel?> updateUserName(String newUserName) async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No authenticated user found');
    }

    // Kullanıcı verilerini Firestore'dan al
    DocumentSnapshot userDoc =
        await _firestore.collection('Users').doc(currentUser.uid).get();

    // Firestore'da kullanıcı adını güncelle
    await _firestore.collection('Users').doc(currentUser.uid).update({
      'userName': newUserName,
    });

    // Kullanıcı modeli oluştur
    UserModel userModel;

    if (userDoc.exists) {
      // Eğer belge varsa, mevcut verileri kullan
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      userModel = UserModel(
        id: currentUser.uid,
        userName: newUserName,
        isAnonymousName: userData['isAnonymousName'] ?? currentUser.isAnonymous,
        email: userData['email'] ?? currentUser.email ?? '',
        createdAt: userData['createdAt'] ??
            currentUser.metadata.creationTime.toString(),
        profilePhoto:
            userData['profilePhoto'] ?? '', // Mevcut profil fotoğrafını koru
        isOnline: userData['isOnline'] ?? false,
      );
    } else {
      // Eğer belge yoksa, temel bir model oluştur
      userModel = UserModel(
        id: currentUser.uid,
        userName: newUserName,
        isAnonymousName: currentUser.isAnonymous,
        email: currentUser.email ?? '',
        createdAt: currentUser.metadata.creationTime.toString(),
        profilePhoto: '', // Profil fotoğrafı yok
        isOnline: false,
      );
    }

    return userModel;
  }

//Upload user profile photo to firebase storage
  Future<String?> uploadImage(File imageFile) async {
    var imageName = DateTime.now().millisecondsSinceEpoch.toString();
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child('profilePhotos/$imageName');
    final uploadTask = imageRef.putFile(imageFile);
    final TaskSnapshot taskSnapshot = await uploadTask;
    final String downloadURL = await taskSnapshot.ref.getDownloadURL();

    await _firestore
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'profilePhoto': downloadURL,
    });
    return downloadURL;
  }

//Get image from user device
  Future<File?> getImage(ImageSource source) async {
    debugPrint(_auth.currentUser?.email);
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
          source: source, maxWidth: 800, maxHeight: 800, imageQuality: 80);

      if (pickedFile == null) {
        debugPrint('Resim seçilmedi veya seçim iptal edildi');
        return null;
      }

      debugPrint('pickedFile: ${pickedFile.path}');
      return File(pickedFile.path);
    } catch (e) {
      debugPrint("Error picking image: $e");
      return null;
    }
  }
}
