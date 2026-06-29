import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/data/notifications_repository.dart';
import '../../../../Core/models/app_notification.dart';
import '../../../../Core/state/data_state.dart';

class NotificationsCubit extends Cubit<DataState<List<AppNotification>>> {
  final NotificationsRepository _repo;

  NotificationsCubit({NotificationsRepository? repository})
      : _repo = repository ?? NotificationsRepository(),
        super(const DataInitial());

  Future<void> load() async {
    emit(const DataLoading());
    try {
      emit(DataLoaded(await _repo.fetchAll()));
    } catch (e) {
      emit(DataError.from(e));
    }
  }

  Future<bool> create(AppNotification notification) async {
    try {
      await _repo.create(notification);
      await load();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> remove(String id) async {
    try {
      await _repo.delete(id);
      await load();
      return true;
    } catch (_) {
      return false;
    }
  }
}
