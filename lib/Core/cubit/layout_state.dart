part of 'layout_cubit.dart';

@immutable
sealed class LayoutState {}

final class LayoutInitial extends LayoutState {}

final class ChangePageState extends LayoutState {}
final class ToggleSearchBoxState extends LayoutState {}
final class ToggleNotificationsBoxState extends LayoutState {}

final class AnyState extends LayoutState {}
