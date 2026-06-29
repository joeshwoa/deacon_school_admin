import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/data/grades_repository.dart';
import '../../../../Core/models/grade.dart';
import '../../../../Core/state/data_state.dart';

class GradesData {
  final List<StudentGrade> grades;
  final List<PointEntry> points;
  const GradesData({required this.grades, required this.points});

  double get totalPoints => points.fold(0, (sum, p) => sum + p.value);
}

class GradesCubit extends Cubit<DataState<GradesData>> {
  final GradesRepository _repo;
  String? _studentId;

  GradesCubit({GradesRepository? repository})
      : _repo = repository ?? GradesRepository(),
        super(const DataInitial());

  Future<void> load(String studentId) async {
    _studentId = studentId;
    emit(const DataLoading());
    try {
      final grades = await _repo.fetchStudentGrades(studentId);
      final points = await _repo.fetchPoints(studentId);
      emit(DataLoaded(GradesData(grades: grades, points: points)));
    } catch (e) {
      emit(DataError.from(e));
    }
  }

  Future<bool> setGrade(String categoryId, double value) async {
    if (_studentId == null) return false;
    try {
      await _repo.upsertGrade(
          studentId: _studentId!, categoryId: categoryId, value: value);
      await load(_studentId!);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> addPoint(String title, double value, String? note) async {
    if (_studentId == null) return false;
    try {
      await _repo.addPoint(
          studentId: _studentId!, title: title, value: value, note: note);
      await load(_studentId!);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deletePoint(String id) async {
    if (_studentId == null) return false;
    try {
      await _repo.deletePoint(id);
      await load(_studentId!);
      return true;
    } catch (_) {
      return false;
    }
  }
}
