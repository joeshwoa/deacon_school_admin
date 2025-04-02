part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class TogglePasswordState extends AuthState {}

final class AnyState extends AuthState {}
