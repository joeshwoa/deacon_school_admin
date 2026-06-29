import '../services/supabase_service.dart';

/// Generic async state used by data cubits to drive loading / loaded / error /
/// empty UI consistently across the app.
sealed class DataState<T> {
  const DataState();
}

class DataInitial<T> extends DataState<T> {
  const DataInitial();
}

class DataLoading<T> extends DataState<T> {
  const DataLoading();
}

class DataLoaded<T> extends DataState<T> {
  final T data;
  const DataLoaded(this.data);
}

class DataError<T> extends DataState<T> {
  final String message;
  final bool notConnected;
  const DataError(this.message, {this.notConnected = false});

  factory DataError.from(Object error) {
    if (error is BackendNotConnected) {
      return const DataError('backendNotConnected', notConnected: true);
    }
    return DataError(error.toString());
  }
}
