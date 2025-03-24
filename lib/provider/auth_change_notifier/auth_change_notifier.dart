import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:locale_chat/mixin/error_holder.dart';
import 'package:locale_chat/model/async_change_notifier.dart';
import 'package:locale_chat/model/error_model.dart';
import 'package:locale_chat/model/user_model.dart';
import 'package:locale_chat/service/auth_service.dart';
import 'package:flutter/foundation.dart';

class AuthChangeNotifier extends AsyncChangeNotifier with ErrorHolder {
  UserModel? _user;
  UserModel? get user => _user;
  set user(UserModel? value) {
    _user = value;
    notifyListeners();
  }

  bool _isOtpVerified = false;
  bool get isOtpVerified => _isOtpVerified;
  set isOtpVerified(bool value) {
    _isOtpVerified = value;
    notifyListeners();
  }

  String _otpEmailController = '';
  String get otpEmailController => _otpEmailController;
  set otpEmailController(String value) {
    _otpEmailController = value;
    notifyListeners();
  }

  String _otpEmailVerifyController = '';
  String get otpEmailVerifyController => _otpEmailVerifyController;
  set otpEmailVerifyController(String value) {
    _otpEmailVerifyController = value;
    notifyListeners();
  }

  @override
  AsyncChangeNotifierState state = AsyncChangeNotifierState.idle;
  final AuthService _authService = AuthService();

//Listens to sign in in firebase
  Future<UserModel?> signIn(
      {required String email, required String password}) async {
    await wrapAsync(
      () async {
        try {
          errors.clear();

          user = await _authService.signIn(email: email, password: password);
          notifyListeners();
        } on FirebaseAuthException catch (error) {
          String errorMessage;
          if (error.code == 'user-not-found') {
            errorMessage = 'User not found for that email';
          } else if (error.code == 'invalid-email') {
            errorMessage = 'This email is invalid';
          } else if (error.code == 'wrong-password') {
            errorMessage = 'Wrong password. Please try again';
          } else if (error.code == 'invalid-credential') {
            errorMessage = 'Wrong email or password';
          } else {
            errorMessage = 'Something went wrong, try again';
          }

          addError(ErrorModel(id: 'firebaseAuthLogin', message: errorMessage));
          notifyListeners();
        }
      },
      ErrorModel(
          id: user?.userName ?? 'Anonymous', message: 'Failed to sign in'),
    );
    return user;
  }

//Listens to register new users in firebase
  Future<UserModel?> register(
      {required String email, required String password}) async {
    await wrapAsync(
      () async {
        try {
          user = await _authService.register(email: email, password: password);
          notifyListeners();
        } on FirebaseAuthException catch (error) {
          String errorMessage;
          if (error.code == 'email-already-in-use') {
            errorMessage = 'This email is already in use';
          } else if (error.code == 'invalid-email') {
            errorMessage = 'This email is invalid';
          } else if (error.code == 'weak-password') {
            errorMessage = 'The password provided is too weak';
          } else {
            errorMessage = 'Something went wrong, try again';
          }
          errors.clear();
          addError(
              ErrorModel(id: 'firebaseAuthRegister', message: errorMessage));
        }
      },
      ErrorModel(
          id: user?.userName ?? 'Anonymous', message: 'Failed to register'),
    );
    return user;
  }

//Listens to logout from account in firebase
  Future<void> signOut() async {
    await wrapAsync(() async {
      await _authService.signOut();
      user = null;
      errors.clear();
      notifyListeners();
    },
        ErrorModel(
            id: user?.userName ?? 'Anonymous', message: 'Failed to sign out'));
  }

  Future<UserModel?> getUserInfo(String userId) async {
    await wrapAsync(() async {
      user = await _authService.getUserInfo(userId);
      notifyListeners();
    },
        ErrorModel(
            id: user?.userName ?? 'Anonymous',
            message: 'Failed to get user info'));
    return null;
  }

//Listens to if the user's email is verified
  Future<void> autehntiacate() async {
    await wrapAsync(() async {
      await _authService.autehntiacate();
      errors.clear();
    },
        ErrorModel(
            id: user?.userName ?? 'Anonymous',
            message: 'Failed to verify control'));
  }

//Listens for the link emailed to the user to reset password
  Future<void> updatePassword(
      {required String email, required String password}) async {
    String errorMessage;
    await wrapAsync(
      () async {
        try {
          await _authService.updatePassword(
              email: email, newPassword: password);

          notifyListeners();
        } on FirebaseAuthException catch (error) {
          if (error.code == 'wrong-password') {
            errorMessage = 'Current password is incorrect.';
          } else {
            errorMessage = 'Failed to change password';
          }
          errors.clear();
          addError(ErrorModel(
              id: 'firebaseAuthUpdatePassword', message: errorMessage));
          notifyListeners();
          throw Exception(errorMessage);
        }
      },
      ErrorModel(
          id: user?.userName ?? 'Anonymous',
          message: 'Failed to send a restart link'),
    );
  }

//Listens Google authenticate in firebase
  Future<UserModel?> authWithGoogle() async {
    await wrapAsync(
      () async {
        try {
          user = await _authService.authWithGoogle();
          notifyListeners();
        } on FirebaseAuthException catch (error) {
          String errorMessage;
          if (error.code == 'account-exists-with-different-credential') {
            errorMessage = 'Account already exists with different credentials';
          } else if (error.code == 'invalid-credential') {
            errorMessage = 'Invalid credentials';
          } else {
            errorMessage = 'Error signing in with Google: ${error.message}';
          }

          errors.clear();
          addError(ErrorModel(id: 'firebaseAuthGoogle', message: errorMessage));
          notifyListeners();
        }
      },
      ErrorModel(
          id: user?.userName ?? 'Anonymous',
          message: 'Failed to connection google account'),
    );
    return user;
  }

//Listens Facebook authenticate in firebase
  Future<UserModel?> authWithFacebook() async {
    await wrapAsync(
      () async {
        try {
          user = await _authService.authWithFacebook();
          notifyListeners();
        } on FirebaseAuthException catch (error) {
          String errorMessage;
          if (error.code == 'account-exists-with-different-credential') {
            errorMessage = 'Account already exists with different credentials';
          } else if (error.code == 'invalid-credential') {
            errorMessage = 'Invalid credentials';
          } else {
            errorMessage = 'Error signing in with Facebook: ${error.message}';
          }
          errors.clear();
          addError(
              ErrorModel(id: 'firebaseAuthFacebook', message: errorMessage));
          notifyListeners();
        }
      },
      ErrorModel(
          id: user?.userName ?? 'Anonymous',
          message: 'Failed to connection facebook account'),
    );
    return user;
  }

//Listens to is there any user or not in firebase
  Future<UserModel?> authStateChanges() async {
    await wrapAsync(
      () async {
        try {
          // Kullanıcı bilgilerini auth_service üzerinden al
          UserModel? userModel = await _authService.authStateChanges();
          if (userModel != null) {
            user = userModel;
          } else {
            user = null;
          }
          errors.clear();
          notifyListeners();
        } catch (e) {
          debugPrint('Error in authStateChanges: $e');
          // Hata durumunda mevcut kullanıcı bilgilerini koruyalım
          errors.clear();
          addError(ErrorModel(
              id: 'authStateChanges', message: 'Failed to load user data'));
          notifyListeners();
        }
      },
      ErrorModel(
          id: user?.userName ?? 'Anonymous',
          message: 'Failed to authentication state changes'),
    );
    return user;
  }

  Future<void> sendOtp() async {
    String errorMessages;

    await wrapAsync(
      () async {
        try {
          final QuerySnapshot result = await FirebaseFirestore.instance
              .collection('Users')
              .where('email', isEqualTo: otpEmailController)
              .limit(1)
              .get();
          final List<DocumentSnapshot> document = result.docs;
          if (document.isNotEmpty) {
            await _authService.sendOtp(otpEmailController);
          } else {
            errorMessages = 'Email not found';
            addError(ErrorModel(id: 'firebaseAuthOTP', message: errorMessages));
            notifyListeners();
          }
        } catch (e) {
          errorMessages = e.toString();
          addError(ErrorModel(id: 'firebaseAuthOTP', message: errorMessages));
          notifyListeners();
        }
      },
      ErrorModel(id: 'otp', message: 'Failed to send OTP'),
    );
  }

  Future<void> verifyOtp() async {
    await wrapAsync(
      () async {
        try {
          isOtpVerified =
              await _authService.verifyOtp(otpEmailVerifyController);
          notifyListeners();
        } catch (e) {
          addError(
              ErrorModel(id: 'firebaseAuth', message: 'Failed to verify OTP'));
          notifyListeners();
        }
      },
      ErrorModel(id: 'otp', message: 'Failed to verify OTP'),
    );
  }

  // Mevcut getFirebaseAuthErrors metodu
  List<ErrorModel> getFirebaseAuthErrors(String errorName) {
    notifyListeners();
    return errors.where((error) => error.id == errorName).toList();
  }

  //Clear error list
  void errorListClean() {
    errors.clear();
    notifyListeners();
  }

  //Update user name
  Future<void> updateUserName(String newUserName) async {
    await wrapAsync(
      () async {
        try {
          // Service katmanında username güncelleme işlemini yap
          UserModel? updatedUser =
              await _authService.updateUserName(newUserName);

          if (updatedUser != null) {
            user = updatedUser;
          }
          notifyListeners();
        } catch (e) {
          debugPrint('Error updating username: $e');
          rethrow;
        }
      },
      ErrorModel(
          id: user?.userName ?? 'Anonymous',
          message: 'Failed to update user name'),
    );
  }

  //Upload user profile photo to firebase storage
  Future<void> uploadImage(File imageFile) async {
    await wrapAsync(
      () async {
        try {
          String? imageUrl = await _authService.uploadImage(imageFile);
          if (imageUrl != null && imageUrl.isNotEmpty) {
            UserModel? updatedUser = await _authService.authStateChanges();
            if (updatedUser != null) {
              user = updatedUser;
            }
          }
          notifyListeners();
        } catch (e) {
          debugPrint('Error in AuthChangeNotifier.uploadImage: $e');
          rethrow; // Rethrow to allow the UI to handle the error
        }
      },
      ErrorModel(
          id: user?.userName ?? 'Anonymous', message: 'Failed to upload image'),
    );
  }

  //Get image from user device
  Future<File?> getImage(ImageSource source) async {
    File? imagePath;
    await wrapAsync(
      () async {
        imagePath = await _authService.getImage(source);
        notifyListeners();
      },
      ErrorModel(id: "getImage", message: "Resim seçme işlemi başarısız oldu"),
    );

    return imagePath;
  }
}
