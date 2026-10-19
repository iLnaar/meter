/// Measures the execution speed of code blocks in FPS (frames per second).
///
/// Uses a fixed-capacity circular buffer for storing
/// the last measured FPS values. Allows calculating the average FPS
/// over the last measurement period.
///
/// Usage example:
/// ```dart
/// final meter = Meter(60); // buffer for 60 measurements
///
/// meter.start();
/// // ... код для замерa ...
/// meter.end();
///
/// print(meter.averageFPS);
/// ```
class Meter {
  /// Maximum number of measurements in the buffer.
  final int capacity;

  /// Circular buffer for storing FPS values.
  final List<double> _buffer;

  /// Index of the current write position in the buffer.
  int _head = 0;

  /// Current number of filled cells in the buffer.
  int _count = 0;

  /// Sum of all values in the buffer (for fast average calculation).
  double _sum = 0.0;

  /// Flag indicating that measurement is active (`start()` was called).
  bool _isRunning = false;

  /// Stopwatch for measuring the duration of a code block.
  final Stopwatch _stopwatch = Stopwatch();

  /// Creates an instance with the specified buffer capacity.
  ///
  /// [capacity] — maximum number of measurements that will be
  /// stored in the buffer. When capacity is exceeded, the oldest values
  /// are automatically replaced by new ones.
  Meter(this.capacity) : _buffer = List.filled(capacity, 0.0);

  /// Starts timing.
  ///
  /// Throws [AssertionError] if measurement is already active
  /// (`start()` was called without an intervening `end()`).
  void start() {
    assert(
      !_isRunning,
      'Error: Repeated call to start() without previous end().',
    );
    _isRunning = true;
    _stopwatch.start();
  }

  /// Ends measurement and records the result to the buffer.
  ///
  /// Calculates FPS based on elapsed time between [start] and [end],
  /// stores the value in the circular buffer and updates the sum for
  /// subsequent average calculation.
  ///
  /// Throws [AssertionError] if measurement was not started
  /// (`end()` was called without a prior `start()`).
  void end() {
    assert(_isRunning, 'Error: end() called without start().');

    _stopwatch.stop();
    final durationMs = _stopwatch.elapsedMicroseconds / 1000.0;
    final fps = durationMs > 0 ? 1000.0 / durationMs : 0.0;

    if (_count == capacity) {
      _sum -= _buffer[_head];
    } else {
      _count++;
    }

    _buffer[_head] = fps;
    _sum += fps;
    _head = (_head + 1) % capacity;

    _stopwatch.reset();
    _isRunning = false;
  }

  /// Average FPS value over all completed measurements.
  ///
  /// Returns `0.0` if no measurements have been taken yet.
  double get averageFPS => _count > 0 ? _sum / _count.toDouble() : 0.0;
}
