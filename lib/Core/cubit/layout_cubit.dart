import 'package:flutter_bloc/flutter_bloc.dart';

/// Tracks the selected tab index of the main app shell.
class LayoutCubit extends Cubit<int> {
  LayoutCubit() : super(0);

  void changePage(int index) => emit(index);
}
