import 'dart:async';
import 'package:bloc/bloc.dart';

/// Debounces incoming events by the given duration.
EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) {
    return events.debounceTime(duration).asyncExpand(mapper);
  };
}

extension _DebounceExtension<T> on Stream<T> {
  Stream<T> debounceTime(Duration duration) {
    return transform(_DebounceStreamTransformer(duration));
  }
}

class _DebounceStreamTransformer<T> extends StreamTransformerBase<T, T> {
  final Duration duration;

  _DebounceStreamTransformer(this.duration);

  @override
  Stream<T> bind(Stream<T> stream) {
    late StreamController<T> controller;
    Timer? debounceTimer;
    late StreamSubscription<T> subscription;

    controller = StreamController<T>(
      onListen: () {
        subscription = stream.listen(
          (event) {
            debounceTimer?.cancel();
            debounceTimer = Timer(duration, () {
              controller.add(event);
            });
          },
          onError: controller.addError,
          onDone: () {
            debounceTimer?.cancel();
            controller.close();
          },
          cancelOnError: false,
        );
      },
      onPause: () => subscription.pause(),
      onResume: () => subscription.resume(),
      onCancel: () async {
        debounceTimer?.cancel();
        await subscription.cancel();
      },
    );

    return controller.stream;
  }
}
