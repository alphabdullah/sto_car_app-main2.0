import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../state/auth_state.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/api/api_client.dart' as api;

/// Signup controller (MVC pattern - Controller layer)
class SignupController extends GetxController {
  final AuthState _authState = AuthState();

  final _email = ''.obs;
  final _password = ''.obs;
  final _confirmPassword = ''.obs;
  final _name = ''.obs;
  final _phone = ''.obs;
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final _isPasswordVisible = false.obs;
  final _isConfirmPasswordVisible = false.obs;
  final _registrationImageFront = Rxn<Uint8List>();
  final _registrationImageBack = Rxn<Uint8List>();
  final ImagePicker _imagePicker = ImagePicker();

  String get email => _email.value;
  String get password => _password.value;
  String get confirmPassword => _confirmPassword.value;
  String get name => _name.value;
  String get phone => _phone.value;
  bool get isLoading => _isLoading.value;
  bool get isPasswordVisible => _isPasswordVisible.value;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible.value;
  String? get errorMessage => _errorMessage.value.isEmpty ? null : _errorMessage.value;
  Uint8List? get registrationImageFront => _registrationImageFront.value;
  Uint8List? get registrationImageBack => _registrationImageBack.value;

  void setEmail(String value) => _email.value = value;
  void setPassword(String value) => _password.value = value;
  void setConfirmPassword(String value) => _confirmPassword.value = value;
  void setName(String value) => _name.value = value;
  void setPhone(String value) => _phone.value = value;
  void togglePasswordVisibility() => _isPasswordVisible.value = !_isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() => _isConfirmPasswordVisible.value = !_isConfirmPasswordVisible.value;
  Future<void> pickRegistrationImageFront() async =>
      await _pickRegistrationImage(_registrationImageFront);
  Future<void> pickRegistrationImageBack() async =>
      await _pickRegistrationImage(_registrationImageBack);

  Future<void> _pickRegistrationImage(Rxn<Uint8List> target) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 1600,
      );
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      target.value = bytes;
    } catch (e) {
      _errorMessage.value = 'Failed to pick image. Please try again.';
    }
  }

  Future<void> signup(BuildContext context) async {
    if (!_validateInputs()) return;

    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      if (_registrationImageFront.value == null || _registrationImageBack.value == null) {
        _errorMessage.value = 'Please upload both sides of your Emirates ID';
        _isLoading.value = false;
        return;
      }

      await _authState.register(
        name: _name.value,
        email: _email.value,
        password: _password.value,
        passwordConfirmation: _confirmPassword.value,
        phone: _phone.value,
        registrationImageFront: _registrationImageFront.value,
        registrationImageBack: _registrationImageBack.value,
      );

      // Navigate using GoRouter
      if (!context.mounted) return;
      context.go(AppConstants.routeHomeFeature);
    } on api.ApiException catch (e) {
      _errorMessage.value = e.message;
    } catch (e) {
      _errorMessage.value = 'Signup failed. Please try again.';
    } finally {
      _isLoading.value = false;
    }
  }

  bool _validateInputs() {
    if (_name.value.isEmpty) {
      _errorMessage.value = 'Please enter your name';
      return false;
    }
    if (_email.value.isEmpty) {
      _errorMessage.value = 'Please enter your email';
      return false;
    }
    if (!_email.value.contains('@')) {
      _errorMessage.value = 'Please enter a valid email';
      return false;
    }
    if (_phone.value.isEmpty) {
      _errorMessage.value = 'Please enter your phone number';
      return false;
    }
    if (_password.value.isEmpty) {
      _errorMessage.value = 'Please enter your password';
      return false;
    }
    if (_password.value.length < 6) {
      _errorMessage.value = 'Password must be at least 6 characters';
      return false;
    }
    if (_password.value != _confirmPassword.value) {
      _errorMessage.value = 'Passwords do not match';
      return false;
    }
    return true;
  }
}

