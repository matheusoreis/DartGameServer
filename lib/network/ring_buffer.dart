import 'dart:typed_data';

class RingBuffer {
  RingBuffer(this.capacity) : _buffer = Uint8List(capacity) {
    if (capacity <= 0) {
      throw ArgumentError('Buffer must have a positive capacity.');
    }
  }

  RingBuffer.fromList(List<int> list)
      : capacity = list.length,
        _buffer = Uint8List.fromList(list) {
    if (list.isEmpty) {
      throw ArgumentError('List must have at least one element.');
    }
    _end = list.length;
    if (_end == capacity) {
      _isFull = true;
    }
  }

  final int capacity;
  final Uint8List _buffer;
  int _start = 0;
  int _end = 0;
  bool _isFull = false;

  int get length => _isFull ? capacity : (_end - _start + capacity) % capacity;

  void reset() {
    _start = 0;
    _end = 0;
    _isFull = false;
  }

  void add(int byte) {
    if (byte < 0 || byte > 255) {
      throw ArgumentError('Byte value must be between 0 and 255.');
    }

    _buffer[_end] = byte;

    if (_isFull) {
      throw Exception('Buffer is full');
    }

    _end = (_end + 1) % capacity;

    _isFull = _end == _start;
  }

  int operator [](int index) {
    if (index < 0 || index >= length) {
      throw RangeError.index(index, this);
    }
    return _buffer[(_start + index) % capacity];
  }

  Uint8List take(int size) {
    if (size <= 0) {
      throw ArgumentError('Size must be positive.');
    }

    if (size > length) {
      throw ArgumentError('Not enough elements in the buffer.');
    }

    final int available = length;

    final int count = size < available ? size : available;

    final Uint8List result = Uint8List(count);

    for (int i = 0; i < count; i++) {
      result[i] = _buffer[(_start + i) % capacity];
    }

    _start = (_start + count) % capacity;
    _isFull = false;

    return result;
  }
}
