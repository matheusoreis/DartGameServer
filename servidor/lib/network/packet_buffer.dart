import 'dart:convert';
import 'dart:typed_data';

class ByteBuffer {
  Uint8List _buffer = Uint8List(0);
  int _bufferSize = 0;
  int _writeHead = 0;
  int _readHead = 0;

  void allocate(int additionalSize) {
    _bufferSize += additionalSize;
    final Uint8List newBuffer = Uint8List(_bufferSize)..setRange(0, _writeHead, _buffer);
    _buffer = newBuffer;
  }

  void revertRead(int bytes) {
    _readHead -= bytes;
  }

  void flush() {
    _writeHead = 0;
    _readHead = 0;
    _bufferSize = 0;
    _buffer = Uint8List(0);
  }

  void trim() {
    if (_readHead >= _writeHead) flush();
  }

  int get count {
    return _bufferSize;
  }

  int get length {
    return _writeHead - _readHead;
  }

  void incrementReadHead(int increment) {
    _readHead += increment;
  }

  void incrementWriteHead(int increment) {
    _writeHead += increment;
  }

  Uint8List getArray() {
    return _buffer;
  }
}

class ByteReader {
  ByteReader(this._buffer, {bool useUtf8 = true, Endian endian = Endian.little}) : _endian = endian {
    _useUtf8 = useUtf8;
  }

  final ByteBuffer _buffer;
  late bool _useUtf8;
  final Endian _endian;

  int get8({bool moveReadHead = true}) {
    final int value = _buffer.getArray()[_buffer._readHead];
    if (moveReadHead) _buffer.incrementReadHead(1);
    return value;
  }

  int get16() {
    final ByteData byteData = ByteData.view(Uint8List.fromList(_readValue(2)).buffer);
    return byteData.getUint16(0, _endian);
  }

  int get32() {
    final ByteData byteData = ByteData.view(Uint8List.fromList(_readValue(4)).buffer);
    return byteData.getUint32(0, _endian);
  }

  int get64() {
    final ByteData byteData = ByteData.view(Uint8List.fromList(_readValue(8)).buffer);
    return byteData.getUint64(0, _endian);
  }

  List<int> _readValue(int length) {
    final List<int> result = _buffer.getArray().sublist(_buffer._readHead, _buffer._readHead + length);
    _buffer.incrementReadHead(length);
    return result;
  }

  List<int> getBytes({required int length, bool moveReadHead = true}) {
    final List<int> result = _readValue(length);
    if (!moveReadHead) _buffer.revertRead(length);
    return result;
  }

  String getString({bool moveReadHead = true}) {
    final int stringLength = get32();
    if (stringLength <= 0) {
      return '';
    }

    if (_buffer.count < _buffer._readHead + stringLength) {
      throw Exception('Not enough bytes in buffer');
    }

    final List<int> stringBytes = _readValue(stringLength);
    final String result = (_useUtf8 ? utf8 : ascii).decode(stringBytes);
    if (!moveReadHead) _buffer.revertRead(stringLength);

    return result;
  }
}

class ByteWriter {
  ByteWriter(this._buffer, {bool useUtf8 = true, Endian endian = Endian.little}) : _endian = endian {
    _useUtf8 = useUtf8;
  }

  final ByteBuffer _buffer;
  late bool _useUtf8;
  final Endian _endian;

  void _writeValue(ByteData data) {
    final int length = data.lengthInBytes;
    if (_buffer._writeHead + length > _buffer.count) _buffer.allocate(length);
    _buffer.getArray().setRange(_buffer._writeHead, _buffer._writeHead + length, data.buffer.asUint8List());
    _buffer.incrementWriteHead(length);
  }

  void put8(int value) {
    if (_buffer._writeHead >= _buffer.count) _buffer.allocate(1);
    _buffer.getArray()[_buffer._writeHead] = value;
    _buffer.incrementWriteHead(1);
  }

  void put16(int value) {
    final ByteData byteData = ByteData(2)..setInt16(0, value, _endian);
    _writeValue(byteData);
  }

  void put32(int value) {
    final ByteData byteData = ByteData(4)..setInt32(0, value, _endian);
    _writeValue(byteData);
  }

  void put64(int value) {
    final ByteData byteData = ByteData(8)..setInt64(0, value, _endian);
    _writeValue(byteData);
  }

  void putBytes(List<int> values) {
    if (_buffer._writeHead + values.length > _buffer.count) _buffer.allocate(values.length);
    _buffer.getArray().setRange(_buffer._writeHead, _buffer._writeHead + values.length, values);
    _buffer.incrementWriteHead(values.length);
  }

  void putString(String value) {
    final List<int> stringBytes = (_useUtf8 ? utf8 : ascii).encode(value);
    final int stringLength = stringBytes.length;

    put32(stringLength);

    if (stringLength > 0) {
      putBytes(stringBytes);
    }
  }
}

class PacketBuffer {
  factory PacketBuffer({bool useUtf8 = true, Endian endian = Endian.little}) {
    final ByteBuffer buffer = ByteBuffer();
    return PacketBuffer._(
      buffer,
      ByteReader(buffer, useUtf8: useUtf8, endian: endian),
      ByteWriter(buffer, useUtf8: useUtf8, endian: endian),
    );
  }

  PacketBuffer._(this._buffer, this._reader, this._writer);

  final ByteBuffer _buffer;
  final ByteReader _reader;
  final ByteWriter _writer;

  ByteReader get reader => _reader;
  ByteWriter get writer => _writer;
  Uint8List get bufferArray => _buffer.getArray();
  int get writeHead => _buffer._writeHead;
  int get readHead => _buffer._readHead;
  int get length => _buffer.length;

  void trim() {
    _buffer.trim();
  }
}
