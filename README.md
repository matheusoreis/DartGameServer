# Dart Game Server

[![Desenvolvido com - Dart](https://img.shields.io/badge/Desenvolvido_com-Dart-0175c2)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MPL-blue)](#license)

## Objetivo

O **Dart Game Server (DGS)** foi projetado principalmente para **Servidores de jogos MMO** e **ORPG**.
O objetivo do **DGS** é fornecer uma maneira fácil de lidar com conexões MMO a um servidor, abstraindo a complexidade da camada de rede.

## Requisitos

O **Dart Game Server (DGS)** é uma solução totalmente desenvolvida em [Dart](https://dart.dev), sem depender de outras bibliotecas ou tecnologias externas. O projeto utiliza apenas dois packages do [pub.dev](https://pub.dev/packages), sendo eles:

- [Ansicolor](https://pub.dev/packages/ansicolor): Adiciona suporte a cores no terminal.
- [Http](https://pub.dev/packages/http): Facilita a realização de requisições HTTP.

Para utilizar este projeto, é necessário conhecimento em [Dart](https://dart.dev) e do pacote [Http](https://pub.dev/packages/http) para poder realizar requisições HTTP.

## O PacketBuffer e o RingBuffer

### PacketBuffer
O PacketBuffer é uma classe que oferece uma interface simples para manipular dados binários em um buffer. Ela utiliza internamente um ByteBuffer para gerenciar a alocação e manipulação de bytes, e combina um ByteReader e um ByteWriter para leitura e escrita de dados de forma eficiente.

#### ByteBuffer
O ByteBuffer gerencia a alocação de memória e o rastreamento das posições de leitura e escrita:

```Dart
class ByteBuffer {
  Uint8List _buffer = Uint8List(0);
  int _bufferSize = 0;
  int _writeHead = 0;
  int _readHead = 0;

  void allocate(int additionalSize);
  void revertRead(int bytes);
  void flush();
  void trim();
  int get count;
  int get length;
  void incrementReadHead(int increment);
  void incrementWriteHead(int increment);
  Uint8List getArray();
}
```

- `allocate(int additionalSize)`: Aloca espaço adicional no buffer.
- `revertRead(int bytes)`: Reverte a posição de leitura.
- `flush()`: Reseta o buffer.
- `trim()`: Remove dados lidos.
- `count`: Retorna o tamanho total do buffer.
- `length`: Retorna o tamanho dos dados disponíveis.
- `incrementReadHead(int increment)`: Avança a posição de leitura.
- `incrementWriteHead(int increment)`: Avança a posição de escrita.
- `getArray()`: Retorna o buffer interno.

#### ByteReader
O ByteReader é usado para ler dados binários do buffer:

```Dart
class ByteReader {
  ByteReader(this._buffer, {bool useUtf8 = true, Endian endian = Endian.little});

  int get8({bool moveReadHead = true});
  int get16();
  int get32();
  int get64();
  List<int> getBytes({required int length, bool moveReadHead = true});
  String getString({bool moveReadHead = true});
}
```

- `get8({bool moveReadHead = true})`: Lê um byte.
- `get16()`: Lê um inteiro de 16 bits.
- `get32()`: Lê um inteiro de 32 bits.
- `get64()`: Lê um inteiro de 64 bits.
- `getBytes({required int length, bool moveReadHead = true})`: Lê um array de bytes.
- `getString({bool moveReadHead = true})`: Lê uma string.

#### ByteWriter
O ByteWriter é usado para escrever dados binários no buffer:

```Dart
class ByteWriter {
  ByteWriter(this._buffer, {bool useUtf8 = true, Endian endian = Endian.little});

  void put8(int value);
  void put16(int value);
  void put32(int value);
  void put64(int value);
  void putBytes(List<int> values);
  void putString(String value);
}
```

- `put8(int value)`: Escreve um byte.
- `put16(int value)`: Escreve um inteiro de 16 bits.
- `put32(int value)`: Escreve um inteiro de 32 bits.
- `put64(int value)`: Escreve um inteiro de 64 bits.
- `putBytes(List<int> values)`: Escreve um array de bytes.
- `putString(String value)`: Escreve uma string.

#### PacketBuffer
O PacketBuffer combina as funcionalidades de ByteReader e ByteWriter com ByteBuffer:

```Dart
class PacketBuffer {
  factory PacketBuffer({bool useUtf8 = true, Endian endian = Endian.little});
  PacketBuffer._(this._buffer, this._reader, this._writer);

  ByteReader get reader;
  ByteWriter get writer;
  Uint8List get bufferArray;
  int get writeHead;
  int get readHead;
  int get length;
  void trim();
}
```

- `reader`: Retorna o ByteReader para leitura.
- `writer`: Retorna o ByteWriter para escrita.
- `bufferArray`: Retorna o array de bytes do buffer.
- `writeHead`: Retorna a posição de escrita.
- `readHead`: Retorna a posição de leitura.
- `length`: Retorna o comprimento dos dados disponíveis.
- `trim()`: Remove dados lidos.

### RingBuffer
O RingBuffer é uma estrutura de dados circular eficiente para armazenamento de bytes. Ele permite adicionar e remover bytes de forma circular, aproveitando ao máximo a capacidade do buffer.

```Dart
class RingBuffer {
  final int capacity;
  final Uint8List _buffer;
  int _start = 0;
  int _end = 0;
  bool _isFull = false;

  RingBuffer(this.capacity);
  RingBuffer.fromList(List<int> list);

  int get length;
  void reset();
  void add(int byte);
  int operator [](int index);
  Uint8List take(int size);
}
```

- `RingBuffer(int capacity)`: Construtor que cria um buffer com a capacidade especificada.
- `RingBuffer.fromList(List<int> list)`: Construtor que inicializa o buffer a partir de uma lista.
- `length`: Retorna o número de elementos no buffer.
- `reset()`: Reseta o buffer.
- `add(int byte)`: Adiciona um byte ao buffer.
- `operator [](int index)`: Acessa um byte no índice especificado.
- `take(int size)`: Retira um número especificado de bytes do buffer.

Em resumo o `PacketBuffer` oferece uma interface para leitura e escrita de dados binários, enquanto o `RingBuffer` fornece um buffer circular eficiente para armazenamento temporário dos bytes.

### DataSender

A classe DataSender é responsável pelo envio de dados aos clientes conectados ao servidor. Ela fornece métodos para enviar dados a um cliente específico, a todos os clientes conectados, ou a todos os clientes exceto um específico.

```Dart
class DataSender {
  sendDataTo(ConnectionModel client, List<int> data);
  sendDataToAll(List<int> data);
  sendDataToAllExcept(ConnectionModel client, List<int> data);
}
```

- `sendDataTo(ConnectionModel client, List<int> data)`: 
- `sendDataToAll(List<int> data)`: 
- `sendDataToAllExcept(ConnectionModel client, List<int> data)`: 