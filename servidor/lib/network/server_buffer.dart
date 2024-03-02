// ignore_for_file: unused_element

import 'dart:convert';
import 'dart:typed_data';

/// Classe para manipulação de buffer de dados.
///
/// Esta classe permite a escrita e leitura de dados em um buffer de bytes.
class ServerBuffer {
  /// Cria uma instância de `ServerBuffer`.
  ///
  /// O argumento `useUtf8` indica se o buffer deve ser usado para escrita e leitura
  /// dos dados em codificação UTF-8.
  ServerBuffer({bool useUtf8 = false}) {
    _useUtf8 = useUtf8;
    flush();
  }

  List<int> _buffer = [];
  int _bufferSize = 0;
  int _writeHead = 0;
  int _readHead = 0;
  late bool _useUtf8;

  /// Método para alocar espaço adicional no buffer.
  ///
  /// Parâmetros:
  ///   - additionalSize: O tamanho adicional a ser alocado no buffer.
  void _allocate(int additionalSize) {
    _bufferSize += additionalSize;
    _buffer = List.from(_buffer);
    _buffer.addAll(List.filled(additionalSize, 0));
  }

  /// Método para pré-alocar espaço no buffer.
  ///
  /// Parâmetros:
  ///   - initialSize: O tamanho inicial do buffer.
  void _preAllocate(int initialSize) {
    _writeHead = 0;
    _readHead = 0;
    _bufferSize = initialSize;
    _buffer = List.filled(_bufferSize, 0);
  }

  /// Remove os dados antigos do buffer até o cabeçalho de leitura.
  void flush() {
    _writeHead = 0;
    _readHead = 0;
    _bufferSize = 0;
    _buffer = [];
  }

  /// Escreve um byte no buffer.
  ///
  /// Parâmetros:
  ///   - value: O valor do byte a ser escrito.
  void trim() {
    if (_readHead >= count) flush();
  }

  /// Escreve uma lista de bytes no buffer.
  ///
  /// Parâmetros:
  ///   - values: A lista de bytes a ser escrita.
  void writeByte(int value) {
    if (_writeHead >= _bufferSize) _allocate(1);
    _buffer[_writeHead] = value;
    _writeHead++;
  }

  /// Escreve uma lista de bytes no buffer.
  ///
  /// Parâmetros:
  ///   - values: A lista de bytes a ser escrita.
  void writeBytes(List<int> values) {
    if (_writeHead + values.length > _bufferSize) _allocate(values.length);
    _buffer.setRange(_writeHead, _writeHead + values.length, values);
    _writeHead += values.length;
  }

  /// Escreve um inteiro no buffer.
  ///
  /// Parâmetros:
  ///   - value: O valor do inteiro a ser escrito.
  void writeInteger(int value) {
    final ByteData byteData = ByteData(4)..setInt32(0, value, Endian.little);
    writeBytes(byteData.buffer.asUint8List());
  }

  /// Escreve uma string no buffer.
  ///
  /// Parâmetros:
  ///   - value: A string a ser escrita.
  void writeString(String value) {
    final List<int> stringBytes = (_useUtf8 ? utf8 : ascii).encode(value);
    final int stringLength = stringBytes.length;

    writeInteger(stringLength);

    if (stringLength <= 0) return;

    if (_writeHead + stringLength - 1 > _bufferSize) _allocate(stringLength);

    _buffer.setRange(_writeHead, _writeHead + stringLength, stringBytes);
    _writeHead += stringLength;
  }

  /// Lê um byte do buffer.
  ///
  /// Retorna o byte lido.
  int readByte() {
    return _buffer[_readHead++];
  }

  /// Lê uma lista de bytes do buffer.
  ///
  /// Parâmetros:
  ///   - length: O comprimento da lista a ser lida.
  ///   - moveReadHead: Indica se o cabeçalho de leitura deve ser movido após a leitura.
  ///
  /// Retorna a lista de bytes lida.
  List<int> readBytes({required int length, bool moveReadHead = true}) {
    final List<int> result = _buffer.sublist(_readHead, _readHead + length);
    if (moveReadHead) _readHead += length;
    return result;
  }

  /// Lê um inteiro do buffer.
  ///
  /// Retorna o inteiro lido.
  int readInteger() {
    final ByteData byteData = ByteData.view(Uint8List.fromList(readBytes(length: 4)).buffer);
    return byteData.getInt32(0, Endian.little);
  }

  /// Lê uma string do buffer.
  ///
  /// Parâmetros:
  ///   - moveReadHead: Indica se o cabeçalho de leitura deve ser movido após a leitura.
  ///
  /// Retorna a string lida.
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

  /// Obtém o número total de bytes no buffer.
  ///
  /// Retorna o número total de bytes no buffer.
  int get count {
    return _buffer.length;
  }

  /// Obtém o comprimento restante de dados no buffer.
  ///
  /// Retorna o comprimento restante de dados no buffer.
  int get length {
    return count - _readHead;
  }

  /// Obtém uma lista contendo os bytes do buffer.
  ///
  /// Retorna uma lista contendo os bytes do buffer.
  List<int> getArray() {
    return _buffer;
  }

  /// Obtém uma string contendo os bytes do buffer.
  ///
  /// Retorna uma string contendo os bytes do buffer.
  String getString() {
    return (_useUtf8 ? utf8 : ascii).decode(_buffer);
  }
}
