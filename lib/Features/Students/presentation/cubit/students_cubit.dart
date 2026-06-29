import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/data/students_repository.dart';
import '../../../../Core/models/student.dart';
import '../../../../Core/state/data_state.dart';

class StudentsCubit extends Cubit<DataState<List<Student>>> {
  final StudentsRepository _repo;
  String? _levelId;

  StudentsCubit({StudentsRepository? repository})
      : _repo = repository ?? StudentsRepository(),
        super(const DataInitial());

  Future<void> loadByLevel(String levelId) async {
    _levelId = levelId;
    emit(const DataLoading());
    try {
      emit(DataLoaded(await _repo.fetchByLevel(levelId)));
    } catch (e) {
      emit(DataError.from(e));
    }
  }

  Future<bool> save(Student student, {String? accessCode}) async {
    try {
      if (student.id.isEmpty) {
        await _repo.create(student, accessCode: accessCode ?? '');
      } else {
        await _repo.update(student, accessCode: accessCode);
      }
      if (_levelId != null) await loadByLevel(_levelId!);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> remove(String id) async {
    try {
      await _repo.delete(id);
      if (_levelId != null) await loadByLevel(_levelId!);
      return true;
    } catch (_) {
      return false;
    }
  }
}
