import 'dart:async';
import 'package:bloc/bloc.dart';

/// Throttles incoming events by the given duration.
EventTransformer<T> throttle<T>(Duration duration) {
  return (events, mapper) {
    return events.throttleTime(duration).asyncExpand(mapper);
  };
}

extension _ThrottleExtension<T> on Stream<T> {
  Stream<T> throttleTime(Duration duration) {
    return transform(_ThrottleStreamTransformer(duration));
  }
}

class _ThrottleStreamTransformer<T> extends StreamTransformerBase<T, T> {
  final Duration duration;

  _ThrottleStreamTransformer(this.duration);

  @override
  Stream<T> bind(Stream<T> stream) {
    late StreamController<T> controller;
    Timer? timer;
    bool ready = true;
    late StreamSubscription<T> subscription;

    controller = StreamController<T>(
      onListen: () {
        subscription = stream.listen(
          (event) {
            if (ready) {
              controller.add(event);
              ready = false;
              timer = Timer(duration, () {
                ready = true;
              });
            }
          },
          onError: controller.addError,
          onDone: () {
            timer?.cancel();
            controller.close();
          },
          cancelOnError: false,
        );
      },
      onPause: () => subscription.pause(),
      onResume: () => subscription.resume(),
      onCancel: () async {
        timer?.cancel();
        await subscription.cancel();
      },
    );

    return controller.stream;
  }
}
