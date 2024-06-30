import 'package:locale_chat/mixin/error_holder.dart';
import 'package:locale_chat/model/async_change_notifier.dart';
import 'package:locale_chat/model/error_model.dart';
import 'package:locale_chat/model/user_model.dart';
import 'package:locale_chat/service/auth_service.dart';

class AuthChangeNotifier extends AsyncChangeNotifier with ErrorHolder {
  @override
  AsyncChangeNotifierState state = AsyncChangeNotifierState.idle;
  final AuthService _authService = AuthService();
  UserModel? user;

//Listens to sign in
  Future<UserModel?> signIn(
      {required String email, required String password}) async {
    await wrapAsync(() async {
      user = await _authService.signIn(email: email, password: password);
      errors.clear();
    }, ErrorModel(id: user!.userName, message: 'Failed to sign in'));
    return user;
  }

//Listens to register new users
  Future<UserModel?> register(
      {required String email, required String password}) async {
    await wrapAsync(() async {
      user = await _authService.register(email: email, password: password);
      errors.clear();
    }, ErrorModel(id: user!.userName, message: 'Failed to register'));
    return user;
  }

//Listens to logout from account
  Future<void> signOut() async {
    await wrapAsync(() async {
      _authService.signOut();
      errors.clear();
    }, ErrorModel(id: user!.userName, message: 'Failed to sign out'));
  }

//Listens to if the user's email is verified
  Future<void> autehntiacate() async {
    await wrapAsync(() async {
      _authService.autehntiacate();
      errors.clear();
    }, ErrorModel(id: user!.userName, message: 'Failed to verify control'));
  }

//Listens for the link emailed to the user to reset password
  Future<void> forgotPassword({required String email}) async {
    await wrapAsync(
      () async {
        _authService.forgotPassword(email: email);
        errors.clear();
      },
      ErrorModel(id: user!.userName, message: 'Failed to send a restart link'),
    );
  }

//Listens Google authenticate
  Future<UserModel?> authWithGoogle() async {
    await wrapAsync(
      () async {
        user = await _authService.authWithGoogle();
        errors.clear();
      },
      ErrorModel(
          id: user!.userName, message: 'Failed to connection google account'),
    );
    return user;
  }

//Listens Facebook authenticate
  Future<UserModel?> authWithFacebook() async {
    await wrapAsync(
      () async {
        user = await _authService.authWithFacebook();
        errors.clear();
      },
      ErrorModel(
          id: user!.userName, message: 'Failed to connection facebook account'),
    );
    return user;
  }

//Listens to is there any user or not
  UserModel? authStateChanges() {
    wrap(
      () {
        user = _authService.authStateChanges();
        errors.clear();
      },
      ErrorModel(
          id: user!.userName,
          message: 'Failed to authentication state changes'),
    );
    return user;
  }
}
