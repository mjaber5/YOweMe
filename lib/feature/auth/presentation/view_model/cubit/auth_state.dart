// lib/features/auth/presentation/view_model/cubit/auth_state.dart
part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class PhoneValidationState extends AuthState {
  final String completePhoneNumber;
  final bool isValid;
  
  const PhoneValidationState({
    required this.completePhoneNumber,
    required this.isValid,
  });
  
  @override
  List<Object?> get props => [completePhoneNumber, isValid];
}

class OtpSentState extends AuthState {
  final String phoneNumber;
  final bool canResendOtp;
  final int resendCountdown;
  
  const OtpSentState({
    required this.phoneNumber,
    required this.canResendOtp,
    required this.resendCountdown,
  });
  
  @override
  List<Object?> get props => [phoneNumber, canResendOtp, resendCountdown];
}

class OtpUpdatedState extends AuthState {
  final String otp;
  final String phoneNumber;
  final bool canResendOtp;
  final int resendCountdown;
  
  const OtpUpdatedState({
    required this.otp,
    required this.phoneNumber,
    required this.canResendOtp,
    required this.resendCountdown,
  });
  
  @override
  List<Object?> get props => [otp, phoneNumber, canResendOtp, resendCountdown];
}

class OtpResentState extends AuthState {
  final String phoneNumber;
  final bool canResendOtp;
  final int resendCountdown;
  
  const OtpResentState({
    required this.phoneNumber,
    required this.canResendOtp,
    required this.resendCountdown,
  });
  
  @override
  List<Object?> get props => [phoneNumber, canResendOtp, resendCountdown];
}

class OtpTimerUpdateState extends AuthState {
  final String phoneNumber;
  final String otp;
  final bool canResendOtp;
  final int resendCountdown;
  
  const OtpTimerUpdateState({
    required this.phoneNumber,
    required this.otp,
    required this.canResendOtp,
    required this.resendCountdown,
  });
  
  @override
  List<Object?> get props => [phoneNumber, otp, canResendOtp, resendCountdown];
}

// New state for name collection
class NameRequiredState extends AuthState {
  final String phoneNumber;
  
  const NameRequiredState({
    required this.phoneNumber,
  });
  
  @override
  List<Object?> get props => [phoneNumber];
}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;
  
  const AuthError({required this.message});
  
  @override
  List<Object?> get props => [message];
}

// Auth Steps
enum AuthStep {
  phone,
  otp,
  name, // New step for name collection
}