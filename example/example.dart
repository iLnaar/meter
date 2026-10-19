import 'package:meter/meter.dart';

/// Runs computation with increasing workload for circular buffer demo.
void benchmarkVaryingWorkload(int multiplier) {
  for (int j = 0; j < (100 * multiplier); j++) {
    _doWork(j);
  }
}

void main() {
  final meter = Meter(60);

  print('=== Meter FPS Benchmark ===\n');

  // Benchmark 1: Simple loop
  print('Benchmark 1: Simple for-loop (1000 iterations)');
  for (int i = 0; i < 10; i++) {
    meter.start();
    for (int j = 0; j < 1000; j++) {
      _doWork(j);
    }
    meter.end();
  }
  print('  Average FPS: ${meter.averageFPS.toStringAsFixed(2)}\n');

  // Benchmark 2: String operations
  print('Benchmark 2: String concatenation (500 iterations)');
  String s = '';
  for (int i = 0; i < 10; i++) {
    meter.start();
    for (int j = 0; j < 500; j++) {
      s += 'hello $j ';
    }
    meter.end();
  }
  s = ''; // To suppress the analyzer warning about the unused variable
  print('$s  Average FPS: ${meter.averageFPS.toStringAsFixed(2)}\n');

  // Benchmark 3: List operations
  print('Benchmark 3: List operations (200 iterations)');
  for (int i = 0; i < 10; i++) {
    meter.start();
    final list = <int>[];
    for (int j = 0; j < 200; j++) {
      list.add(j * j);
      list.removeAt(0);
    }
    meter.end();
  }
  print('  Average FPS: ${meter.averageFPS.toStringAsFixed(2)}\n');

  // Benchmark 4: Circular buffer demo with varying workloads
  print('Benchmark 4: Circular buffer demo');
  final smallMeter = Meter(5);

  for (int i = 1; i <= 8; i++) {
    smallMeter.start();
    benchmarkVaryingWorkload(i);
    smallMeter.end();
    print('  Measurement $i: FPS = ${smallMeter.averageFPS.toStringAsFixed(2)}');
  }
  print('  (Only the last 5 measurements are kept in the buffer)\n');

  print('Done!');
}

void _doWork(int value) {
  double result = 0.0;
  for (int i = 0; i < 100; i++) {
    result += (result + value) * 1.0001;
  }
}
