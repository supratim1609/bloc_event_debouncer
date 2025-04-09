# bloc_event_debouncer 🚀

[![pub version](https://img.shields.io/pub/v/bloc_event_debouncer.svg)](https://pub.dev/packages/bloc_event_debouncer)
[![likes](https://badges.bar/bloc_event_debouncer/likes)](https://pub.dev/packages/bloc_event_debouncer/score)
[![popularity](https://badges.bar/bloc_event_debouncer/popularity)](https://pub.dev/packages/bloc_event_debouncer/score)

A tiny but powerful package to debounce and throttle BLoC events using clean `EventTransformer`s. Perfect for search boxes, scroll listeners, rapid taps, and everything in between.

---

## 💡 Why?

By default, BLoC fires events instantly and continuously — which can flood your app with state updates.  
That's *fine* until you:

- build a **search box** that sends 50 API requests per second 🤕
- need to **rate-limit a scroll listener**
- want to **ignore accidental rapid taps**

**Enter: `bloc_event_debouncer`** — adds `debounce` and `throttle` transformers to your BLoC like a boss 💼

---

## ✨ Features

- ✅ Easy-to-use `debounceTransformer(duration)`
- ✅ Clean `throttleTransformer(duration)`
- ✅ Built on top of `rxdart` & `bloc`
- ✅ Lightweight, no overhead
- ✅ Null-safe, production-ready

---

## 🚀 Installation

```bash
flutter pub add bloc_event_debouncer

## Usage

Debounce (for search inputs, etc.)

on<SearchQueryChanged>(
  _onSearchChanged,
  transformer: debounceTransformer(const Duration(milliseconds: 300)),
);

Throttle (for scroll or rapid tap control)

on<ScrollEvent>(
  _onScroll,
  transformer: throttleTransformer(const Duration(seconds: 1)),
);

## Real world example

class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc() : super(MyInitial()) {
    on<MyDebouncedEvent>(
      _onDebouncedEvent,
      transformer: debounceTransformer(const Duration(milliseconds: 400)),
    );

    on<MyThrottledEvent>(
      _onThrottledEvent,
      transformer: throttleTransformer(const Duration(seconds: 2)),
    );
  }

  void _onDebouncedEvent(MyDebouncedEvent event, Emitter<MyState> emit) {
    // Debounced logic here
  }

  void _onThrottledEvent(MyThrottledEvent event, Emitter<MyState> emit) {
    // Throttled logic here
  }
}

## Author
Made with ❤️ by Supratim Dhara
