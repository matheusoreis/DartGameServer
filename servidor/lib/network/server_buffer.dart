import 'dart:convert';
import 'dart:typed_data';

class ServerBuffer {
  ServerBuffer({bool useUtf8 = false}) {
    _useUtf8 = useUtf8;
    flush();
  }

  List<int> _buffer = [];
  int _bufferSize = 0;
  int _writeHead = 0;
  int _readHead = 0;
  late bool _useUtf8;

  void _preAllocate({required int initialSize}) {
    _writeHead = 0;
    _readHead = 0;
    _bufferSize = initialSize;
    _buffer = List.filled(_bufferSize, 0);
  }

  void _allocate({required int additionalSize}) {
    _bufferSize += additionalSize;
    _buffer = List.from(_buffer);
    _buffer.addAll(List.filled(additionalSize, 0));
  }

  void flush() {
    _writeHead = 0;
    _readHead = 0;
    _bufferSize = 0;
    _buffer = [];
  }

  void trim() {
    if (_readHead >= count) flush();
  }

  void writeByte({required int value}) {
    if (_writeHead >= _bufferSize) _allocate(additionalSize: 1);
    _buffer[_writeHead] = value;
    _writeHead++;
  }

  void writeBytes({required List<int> values}) {
    if (_writeHead + values.length > _bufferSize) _allocate(additionalSize: values.length);
    _buffer.setRange(_writeHead, _writeHead + values.length, values);
    _writeHead += values.length;
  }

  void writeInteger({required int value}) {
    final ByteData byteData = ByteData(4)..setInt32(0, value, Endian.little);
    writeBytes(values: byteData.buffer.asUint8List());
  }

  void writeString({required String value}) {
    final List<int> stringBytes = (_useUtf8 ? utf8 : ascii).encode(value);
    final int stringLength = stringBytes.length;

    writeInteger(value: stringLength);

    if (stringLength <= 0) return;

    if (_writeHead + stringLength - 1 > _bufferSize) _allocate(additionalSize: stringLength);

    _buffer.setRange(_writeHead, _writeHead + stringLength, stringBytes);
    _writeHead += stringLength;
  }

  int readByte() {
    return _buffer[_readHead++];
  }

  List<int> readBytes({required int length, bool moveReadHead = true}) {
    final List<int> result = _buffer.sublist(_readHead, _readHead + length);
    if (moveReadHead) _readHead += length;
    return result;
  }

  int readInteger() {
    final ByteData byteData = ByteData.view(Uint8List.fromList(readBytes(length: 4)).buffer);
    return byteData.getInt32(0, Endian.little);
  }

  String readString({bool moveReadHead = true}) {
    final int stringLength = readInteger();
    if (stringLength <= 0) {
      return '';
    }

    if (_buffer.length < _readHead + stringLength) {
      throw Exception('Not enough bytes in buffer');
    }

    final List<int> stringBytes = readBytes(length: stringLength, moveReadHead: false);

    final String result = (_useUtf8 ? utf8 : ascii).decode(stringBytes);
    if (moveReadHead) _readHead += stringLength;

    return result;
  }

  int get count {
    return _buffer.length;
  }

  int get length {
    return count - _readHead;
  }

  List<int> getArray() {
    return _buffer;
  }

  String getString() {
    return (_useUtf8 ? utf8 : ascii).decode(_buffer);
  }
}
