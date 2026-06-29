import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/data/levels_repository.dart';
import '../../../../Core/models/level.dart';
import '../../../../Core/state/data_state.dart';

class LevelsCubit extends Cubit<DataState<List<Level>>> {
  final LevelsRepository _repo;

  LevelsCubit({LevelsRepository? repository})
      : _repo = repository ?? LevelsRepository(),
        super(const DataInitial());

  Future<void> load() async {
    emit(const DataLoading());
    try {
      emit(DataLoaded(await _repo.fetchLevels()));
    } catch (e) {
      emit(DataError.from(e));
    }
  }

  Future<bool> save(Level level) async {
    try {
      level.id.isEmpty ? await _repo.create(level) : await _repo.update(level);
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
