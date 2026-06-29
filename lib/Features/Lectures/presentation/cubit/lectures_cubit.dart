import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/data/lectures_repository.dart';
import '../../../../Core/models/lecture.dart';
import '../../../../Core/state/data_state.dart';

class LecturesCubit extends Cubit<DataState<List<Lecture>>> {
  final LecturesRepository _repo;

  LecturesCubit({LecturesRepository? repository})
      : _repo = repository ?? LecturesRepository(),
        super(const DataInitial());

  Future<void> load() async {
    emit(const DataLoading());
    try {
      emit(DataLoaded(await _repo.fetchAll()));
    } catch (e) {
      emit(DataError.from(e));
    }
  }

  Future<bool> save(Lecture lecture) async {
    try {
      lecture.id.isEmpty
          ? await _repo.create(lecture)
          : await _repo.update(lecture);
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
