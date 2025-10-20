import 'package:flutter/material.dart';
import '../../../../core/network/network_service_impl.dart';
import '../repository/login_repository.dart';

class LoginProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  late final LoginRepository _repository;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  LoginProvider({NetworkServiceImpl? networkService}) {
    // Allow injection for testing; default to a real instance
    final service = networkService ?? NetworkServiceImpl();
    _repository = LoginRepository(networkService: service);
  }

  Future<void> login({
    required String driverId,
    required String password,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.login(
        driverId: driverId,
        password: password,
      );

      if (result['success'] == true) {
        _isLoading = false;
        notifyListeners();
        onSuccess();
      } else {
        _errorMessage = (result['message'] as String?) ?? 'Invalid credentials';
        _isLoading = false;
        notifyListeners();
        onError(_errorMessage!);
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      onError(_errorMessage!);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> forgotPassword({
    required String driverId,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call - replace with actual API call later
      await Future.delayed(const Duration(seconds: 1));

      if (driverId.isNotEmpty) {
        _isLoading = false;
        notifyListeners();
        onSuccess('Password reset instructions sent to your registered email');
      } else {
        _errorMessage = 'Please enter a valid Driver ID';
        _isLoading = false;
        notifyListeners();
        onError(_errorMessage!);
      }
    } catch (e) {
      _errorMessage = 'Failed to send reset instructions. Please try again.';
      _isLoading = false;
      notifyListeners();
      onError(_errorMessage!);
    }
  }
}
