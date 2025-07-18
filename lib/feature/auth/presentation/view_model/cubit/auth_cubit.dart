// lib/features/auth/presentation/view_model/cubit/auth_cubit.dart
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fawtara/core/services/api_service.dart';
import 'package:fawtara/core/services/user_storage_service.dart';
import 'package:fawtara/features/user/data/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final ApiService _apiService = ApiService();
  Timer? _resendTimer;

  AuthCubit() : super(AuthInitial());

  // Private fields
  AuthStep _currentStep = AuthStep.phone;
  String _phoneNumber = '';
  String _completePhoneNumber = '';
  String _otp = '';
  String _serverOtp = ''; 
  bool _isPhoneValid = false;
  int _resendCountdown = 0;
  bool _canResendOtp = true;
  FawtoraUser? _currentUser;

  // Getters
  AuthStep get currentStep => _currentStep;
  String get phoneNumber => _phoneNumber;
  String get completePhoneNumber => _completePhoneNumber;
  String get otp => _otp;
  bool get isPhoneValid => _isPhoneValid;
  int get resendCountdown => _resendCountdown;
  bool get canResendOtp => _canResendOtp;
  FawtoraUser? get currentUser => _currentUser;

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    return super.close();
  }

  // Phone number validation
  void validatePhoneNumber(String phoneNumber) {
    _completePhoneNumber = phoneNumber;
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digitsOnly.length >= 3) {
      final nationalPart = digitsOnly.substring(3);
      _isPhoneValid = nationalPart.length == 9;
    } else {
      _isPhoneValid = false;
    }
    
    emit(PhoneValidationState(
      completePhoneNumber: _completePhoneNumber,
      isValid: _isPhoneValid,
    ));
  }

  // Send OTP to phone number via API
  Future<void> sendOtp() async {
    if (!_isPhoneValid) {
      emit(const AuthError(message: 'Please enter a valid phone number'));
      return;
    }

    emit(AuthLoading());
    
    try {
      final otpResponse = await _apiService.sendOtp(_completePhoneNumber);
      
      if (otpResponse.isSuccess) {
        _phoneNumber = _completePhoneNumber;
        _serverOtp = otpResponse.otp ?? ''; // Store server OTP
        _currentStep = AuthStep.otp;
        
        // Start the resend timer
        _startResendTimer();
        
        emit(OtpSentState(
          phoneNumber: _phoneNumber,
          canResendOtp: _canResendOtp,
          resendCountdown: _resendCountdown,
        ));
      } else {
        emit(AuthError(message: otpResponse.message ?? 'Failed to send OTP'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // Update OTP
  void updateOtp(String otp) {
    _otp = otp;
    emit(OtpUpdatedState(
      otp: _otp, 
      phoneNumber: _phoneNumber,
      canResendOtp: _canResendOtp,
      resendCountdown: _resendCountdown,
    ));
  }

  // Verify OTP and check user
  Future<void> verifyOtp() async {
    if (_otp.length != 4) {
      emit(const AuthError(message: 'Please enter complete OTP'));
      return;
    }

    emit(AuthLoading());
    
    try {
      // Add a small delay to simulate processing
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Compare entered OTP with server OTP
      if (_otp == _serverOtp) {
        // OTP is correct, now check if user exists
        await _checkUserExistence();
      } else {
        emit(const AuthError(message: 'Invalid OTP. Please try again.'));
      }
    } catch (e) {
      emit(const AuthError(message: 'Verification failed. Please try again.'));
    }
  }

  // Check if user exists in the system
  Future<void> _checkUserExistence() async {
    try {
      final userCheckResponse = await _apiService.checkUser(_phoneNumber);
      
      if (userCheckResponse.isSuccess && userCheckResponse.isUserFound) {
        // User exists, save user data and proceed to main screen
        _currentUser = userCheckResponse.user;
        if (_currentUser != null) {
          await UserStorageService.saveUser(_currentUser!);
          
          // Verify user was saved
          final savedUser = await UserStorageService.getUser();
          final isLoggedIn = await UserStorageService.isLoggedIn();
          print('🔍 User saved verification:');
          print('  - Saved User: ${savedUser?.name}');
          print('  - Is Logged In: $isLoggedIn');
        }
        
        // Clear sensitive data
        _clearSensitiveData();
        
        emit(AuthSuccess());
      } else if (userCheckResponse.requiresName) {
        // User doesn't exist, need to collect name
        _currentStep = AuthStep.name;
        emit(NameRequiredState(phoneNumber: _phoneNumber));
      } else {
        emit(AuthError(message: userCheckResponse.message ?? 'User verification failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // Create new user with name
  Future<void> createUser(String name) async {
    if (name.trim().isEmpty) {
      emit(const AuthError(message: 'Please enter your name'));
      return;
    }

    emit(AuthLoading());
    
    try {
      final createResponse = await _apiService.createUser(_phoneNumber, name.trim());
      
      if (createResponse.isSuccess && createResponse.isUserCreated) {
        // User created successfully, save user data and proceed to main screen
        _currentUser = createResponse.user;
        if (_currentUser != null) {
          await UserStorageService.saveUser(_currentUser!);
          
          // Verify user was saved
          final savedUser = await UserStorageService.getUser();
          final isLoggedIn = await UserStorageService.isLoggedIn();
          print('🔍 New user saved verification:');
          print('  - Saved User: ${savedUser?.name}');
          print('  - Is Logged In: $isLoggedIn');
        }
        
        // Clear sensitive data
        _clearSensitiveData();
        
        emit(AuthSuccess());
      } else {
        emit(AuthError(message: createResponse.message ?? 'Failed to create user'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // Clear sensitive data after successful auth
  void _clearSensitiveData() {
    _serverOtp = '';
    _otp = '';
    _resendTimer?.cancel();
  }

  // Resend OTP
  Future<void> resendOtp() async {
    if (!_canResendOtp) return;

    emit(AuthLoading());
    try {
      final otpResponse = await _apiService.sendOtp(_phoneNumber);
      if (otpResponse.isSuccess) {
        _serverOtp = otpResponse.otp ?? ''; 
        _otp = ''; 
        
        // Start the resend timer again
        _startResendTimer();
        
        emit(OtpResentState(
          phoneNumber: _phoneNumber,
          canResendOtp: _canResendOtp,
          resendCountdown: _resendCountdown,
        ));
      } else {
        emit(AuthError(message: otpResponse.message ?? 'Failed to resend OTP'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // Start the resend timer (60 seconds)
  void _startResendTimer() {
    _resendTimer?.cancel();
    _resendCountdown = 60;
    _canResendOtp = false;

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _resendCountdown--;
      
      if (_resendCountdown <= 0) {
        _canResendOtp = true;
        timer.cancel();
        _resendTimer = null;
      }

      // Emit state with updated countdown
      if (_currentStep == AuthStep.otp) {
        emit(OtpTimerUpdateState(
          phoneNumber: _phoneNumber,
          otp: _otp,
          canResendOtp: _canResendOtp,
          resendCountdown: _resendCountdown,
        ));
      }
    });
  }

  // Go back to phone step
  void goBackToPhone() {
    _currentStep = AuthStep.phone;
    _otp = '';
    _serverOtp = '';
    _resendTimer?.cancel();
    _canResendOtp = true;
    _resendCountdown = 0;
    
    emit(PhoneValidationState(
      completePhoneNumber: _completePhoneNumber,
      isValid: _isPhoneValid,
    ));
  }

  // Go back to OTP step from name step
  void goBackToOtp() {
    _currentStep = AuthStep.otp;
    emit(OtpUpdatedState(
      otp: _otp,
      phoneNumber: _phoneNumber,
      canResendOtp: _canResendOtp,
      resendCountdown: _resendCountdown,
    ));
  }

  // Clear error and return to previous state
  void clearError() {
    if (_currentStep == AuthStep.phone) {
      emit(PhoneValidationState(
        completePhoneNumber: _completePhoneNumber,
        isValid: _isPhoneValid,
      ));
    } else if (_currentStep == AuthStep.otp) {
      emit(OtpUpdatedState(
        otp: _otp, 
        phoneNumber: _phoneNumber,
        canResendOtp: _canResendOtp,
        resendCountdown: _resendCountdown,
      ));
    } else if (_currentStep == AuthStep.name) {
      emit(NameRequiredState(phoneNumber: _phoneNumber));
    }
  }

  // Reset the entire auth state
  void reset() {
    _currentStep = AuthStep.phone;
    _phoneNumber = '';
    _completePhoneNumber = '';
    _otp = '';
    _serverOtp = '';
    _isPhoneValid = false;
    _resendTimer?.cancel();
    _canResendOtp = true;
    _resendCountdown = 0;
    _currentUser = null;
    emit(AuthInitial());
  }
}