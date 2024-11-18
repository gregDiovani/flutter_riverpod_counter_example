import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'counter_state.g.dart';

class CounterState {
  final int count;
  final String error;

  CounterState({required this.count, this.error = ''});

  CounterState copyWith({int? count, String? error}) {
    return CounterState(
      count: count ?? this.count,
      error: error ?? this.error,
    );
  }
}

@riverpod
class CounterNotifier extends _$CounterNotifier {
  Future<CounterState> build() async {
    return CounterState(count: 0);
  }

  Future<void> fetchCount() async {
    state = const AsyncLoading();
    try {
      state = AsyncData(CounterState(count: 1));
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  void increment() {
    state = state.whenData((state) => state.copyWith(count: state.count + 1));
  }
}
