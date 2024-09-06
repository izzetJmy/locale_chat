import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locale_chat/mixin/error_holder.dart';
import 'package:locale_chat/model/async_change_notifier.dart';
import 'package:locale_chat/model/error_model.dart';
import 'package:locale_chat/model/user_model.dart';
import 'package:locale_chat/service/auth_service.dart';

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
          errors.clear();
          addError(ErrorModel(id: 'firebaseAuth', message: errorMessage));
          errors.clear();

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
          addError(ErrorModel(id: 'firebaseAuth', message: errorMessage));
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
      notifyListeners();

      errors.clear();
      user = null;
    },
        ErrorModel(
            id: user?.userName ?? 'Anonymous', message: 'Failed to sign out'));
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
          addError(ErrorModel(id: 'firebaseAuth', message: errorMessage));
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
          addError(ErrorModel(id: 'firebaseAuth', message: errorMessage));
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
          addError(ErrorModel(id: 'firebaseAuth', message: errorMessage));
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
        user = _authService.authStateChanges();
        errors.clear();
        notifyListeners();
      },
      ErrorModel(
          id: user?.userName ?? 'Anonymous',
          message: 'Failed to authentication state changes'),
    );
    return user;
  }

  List<ErrorModel> getFirebaseAuthErrors() {
    return errors.where((error) => error.id == 'firebaseAuth').toList();
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
            addError(ErrorModel(id: 'firebaseAuth', message: errorMessages));
            notifyListeners();
          }
        } catch (e) {
          errorMessages = e.toString();
          addError(ErrorModel(id: 'firebaseAuth', message: errorMessages));
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
}
