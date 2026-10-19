# Meter

A lightweight Dart utility for measuring the execution speed of code blocks in **FPS** (frames per second).

Uses a **fixed-capacity circular buffer** to store recent FPS measurements, enabling efficient calculation of average performance over a sliding window.

## Features

- Measure code block execution speed in FPS
- Configurable circular buffer capacity (overwrites oldest values automatically)
- Fast average FPS calculation using incremental sum tracking
- Zero-allocations after construction (reuses internal buffer)
- Simple, chainable `start()` / `end()` API

## Getting started

### Install

Add `meter` to your `pubspec.yaml`:

```yaml
dependencies:
  meter: ^1.0.0
```

Or install via CLI:

```bash
dart pub add meter
```

### Usage

```dart
import 'package:meter/meter.dart';

void main() {
  final meter = Meter(60); // buffer for 60 measurements

  meter.start();
  // ... code for measure ...
  meter.end();

  print(meter.averageFPS); // => average FPS over all measurements
}
```

## API

| Member | Type | Description |
|--------|------|-------------|
| `Meter(capacity)` | constructor | Creates a meter with a buffer of the given capacity. |
| `start()` | void | Starts timing. Throws if already running. |
| `end()` | void | Ends timing, records FPS to buffer. Throws if not running. |
| `averageFPS` | double | Average FPS across all measurements in the buffer. Returns `0.0` if no measurements taken. |
| `capacity` | int | Maximum number of measurements stored in the buffer. |

## Example

See the [`example/example.dart`](example/example.dart) file for a complete benchmark with multiple workloads.

Run it:

```bash
dart run example/example.dart
```

## Circular Buffer Behavior

When the number of measurements exceeds `capacity`, the oldest FPS values are automatically overwritten by new ones. This ensures constant memory usage regardless of how many measurements are taken.

```dart
final meter = Meter(3); // keep only last 3 measurements

meter.start(); /* ... */ meter.end(); // #1
meter.start(); /* ... */ meter.end(); // #2
meter.start(); /* ... */ meter.end(); // #3
meter.start(); /* ... */ meter.end(); // #4 → overwrites #1

print(meter.averageFPS); // average of #2, #3, #4 only
```

## Additional information

- [CHANGELOG](CHANGELOG.md) — version history
- Report issues and suggestions on GitHub
