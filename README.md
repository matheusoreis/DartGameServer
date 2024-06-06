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

### O DataSender e o Data Receiver

### DataSender

A classe DataSender é responsável pelo envio de dados aos clientes conectados ao servidor. Ela fornece métodos para enviar dados a um cliente específico, a todos os clientes conectados, ou a todos os clientes exceto um específico.

```Dart
class DataSender {
  sendDataTo(ConnectionModel client, List<int> data);
  sendDataToAll(List<int> data);
  sendDataToAllExcept(ConnectionModel client, List<int> data);
}
```

- `sendDataTo(ConnectionModel client, List<int> data)`: Envia os dados especificados para um cliente específico identificado pelo ConnectionModel.
- `sendDataToAll(List<int> data)`: Envia os dados especificados para todos os clientes conectados ao servidor.
- `sendDataToAllExcept(ConnectionModel client, List<int> data)`: Envia os dados especificados para todos os clientes conectados, exceto para o cliente identificado pelo ConnectionModel.


### DataReceiver

A classe DataReceiver é responsável por receber e processar dados enviados pelos clientes conectados ao servidor. Ela utiliza uma lista de mensagens receptoras para tratar diferentes tipos de pacotes recebidos.

```Dart
class DataReceiver {
  DataReceiver();

  _processMessages();
  receiverData(ConnectionModel client, List<int> data);
}
```

- `DataReceiver()`: Construtor da classe que inicializa a lista de mensagens e chama o método _processMessages para configurar as mensagens específicas.
- `_processMessages()`: Método que inicializa a lista _receiverDataMessage com as mensagens apropriadas.
- `receiverData(ConnectionModel client, List<int> data)`: Método que recebe os dados do cliente, identifica o tipo de mensagem e chama o método receiver da mensagem correspondente.

Em resumo, a classe DataReceiver permite o processamento eficiente de dados recebidos dos clientes, associando diferentes tipos de pacotes a mensagens específicas.

## O SlotManager e o ServerMemory

### SlotManager

A classe SlotManager é uma estrutura genérica que gerencia uma coleção de slots, onde cada slot pode conter um elemento ou estar vazio. É útil para casos onde você precisa gerenciar um número fixo de posições, como inventários em jogos, reservas em sistemas de fila, etc.

```Dart
class SlotManager<Element> {
  SlotManager(int size);

  late List<Element?> _slots;

  Element? operator [](int index);
  void operator []=(int index, Element? value);
  bool isSlotEmpty(int index);
  Iterable<int> getFilledSlots();
  Iterable<int> getEmptySlots();
  void remove(int index);
  int add(Element value);
  int? getFirstEmptySlot();
  Iterable<int> countEmptySlots();
  Iterable<int> countFilledSlots();
  Iterable<int> find({required Element element});
  void clear();
  bool _checkIndex(int index);
  void update(int index, Element value);
  void removeWhere(bool Function(Element?) test);
  List<Element?> getFilledSlotsAsList();
  bool any(bool Function(Element?) test);
}
```

- `SlotManager(int size):` Construtor que inicializa a lista de slots com o tamanho especificado.
- `Element? operator [](int index)`: Retorna o elemento no slot especificado ou null se o índice for inválido.
- `void operator []=(int index, Element? value)`: Define o elemento no slot especificado.
- `bool isSlotEmpty(int index)`: Verifica se o slot no índice especificado está vazio.
- `Iterable<int> getFilledSlots()`: Retorna um iterador com os índices dos slots preenchidos.
- `Iterable<int> getEmptySlots()`: Retorna um iterador com os índices dos slots vazios.
- `void remove(int index)`: Remove o elemento no slot especificado.
- `int add(Element value)`: Adiciona um elemento ao primeiro slot vazio encontrado, retornando o índice do slot.
- `int? getFirstEmptySlot()`: Retorna o índice do primeiro slot vazio encontrado ou null se todos os slots estiverem preenchidos.
- `Iterable<int> countEmptySlots()`: Retorna um iterador que conta os índices dos slots vazios.
- `Iterable<int> countFilledSlots()`: Retorna um iterador que conta os índices dos slots preenchidos.
- `Iterable<int> find({required Element element})`: Retorna um iterador com os índices dos slots que contêm o elemento especificado.
- `void clear()`: Limpa todos os slots.
- `bool _checkIndex(int index)`: Verifica se o índice é válido.
- `void update(int index, Element value)`: Atualiza o elemento no slot especificado.
- `void removeWhere(bool Function(Element?) test)`: Remove os elementos que correspondem ao critério de teste especificado.
- `List<Element?> getFilledSlotsAsList()`: Retorna uma lista de todos os slots preenchidos.
- `bool any(bool Function(Element?) test)`: Verifica se algum slot corresponde ao critério de teste especificado.

Em resumo, a classe SlotManager oferece uma maneira flexível e eficiente de gerenciar uma coleção de slots, fornecendo métodos para adicionar, remover, atualizar e consultar os elementos nos slots.

### ServerMemory

A classe ServerMemory gerencia a memória do servidor. Esta classe é implementada como um singleton para garantir que haja apenas uma instância dela ao longo de todo o ciclo de vida do servidor.

```Dart
class ServerMemory {
  factory ServerMemory() {
    return _singletonInstance;
  }

  ServerMemory._();
  static final ServerMemory _singletonInstance = ServerMemory._();

  SlotManager<ConnectionModel> clientConnections = SlotManager(ServerConstants.maxPlayers);
}
```

- `factory ServerMemory()`: Retorna a instância singleton de ServerMemory.
- `ServerMemory._()`: Construtor privado para garantir que a classe só possa ser instanciada internamente.
- `SlotManager<ConnectionModel> clientConnections`: Gerencia as conexões dos clientes utilizando um SlotManager para armazenar até ServerConstants.maxPlayers conexões.

Em resumo, a classe ServerMemory implementa um padrão de design Singleton para gerenciar a memória do servidor. Ela possui uma única instância _singletonInstance que é acessível através de um método factory ServerMemory().

## Envio e Recebimento de pacotes

### SenderMessage
TODO

### ReceiverMessage
TODO

## Licença

Este projeto está licenciado sob a Licença Pública Mozilla, Versão 2.0 - consulte o arquivo [LICENSE](LICENSE) para obter detalhes.
