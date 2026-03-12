import 'package:flutter/foundation.dart';
import 'package:goal_keeper_app/core/utils/screen_state.dart';

/// AuthController owns all login/signup logic.
/// Screen only calls [signIn], [signUp], [signOut].
/// When Riverpod is added: convert to `AsyncNotifier<AuthState>`.
final class AuthController extends ChangeNotifier {
  // inject: final SignInUseCase _signIn;
  // inject: final SignUpUseCase _signUp;
  // inject: final SignOutUseCase _signOut;

  ScreenState<void> _state = const ScreenInitial();
  ScreenState<void> get state => _state;

  String? _emailError;
  String? _passwordError;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<void> signIn({
    required String email,
    required String password,
    required void Function() onSuccess,
  }) async {
    if (!_validateInputs(email: email, password: password)) return;

    _state = const ScreenLoading();
    notifyListeners();

    // TODO: replace with _signIn(SignInParams(email, password))
    await Future.delayed(const Duration(seconds: 1));

    // Simulating success
    _state = const ScreenLoaded(null);
    notifyListeners();
    onSuccess();
  }

  Future<void> signInWithGoogle({
    required void Function() onSuccess,
  }) async {
    _state = const ScreenLoading();
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    _state = const ScreenLoaded(null);
    notifyListeners();
    onSuccess();
  }

  bool _validateInputs({required String email, required String password}) {
    _emailError = null;
    _passwordError = null;

    if (email.isEmpty || !email.contains('@')) {
      _emailError = 'Please enter a valid email address.';
    }
    if (password.length < 6) {
      _passwordError = 'Password must be at least 6 characters.';
    }

    if (_emailError != null || _passwordError != null) {
      notifyListeners();
      return false;
    }
    return true;
  }

  void clearErrors() {
    _emailError = null;
    _passwordError = null;
    notifyListeners();
  }
}

