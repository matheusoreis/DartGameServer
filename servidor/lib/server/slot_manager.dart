/// Classe responsável por gerenciar slots para armazenamento de elementos.
///
/// Esta classe fornece métodos para acessar, adicionar, remover e manipular elementos em slots,
/// garantindo um controle eficiente sobre a disponibilidade de slots e a integridade dos dados armazenados.
class SlotManager<Element> {
  /// Cria um novo gerenciador de slots com um tamanho específico.
  ///
  /// Todos os slots são inicialmente vazios.
  ///
  /// Parâmetros:
  ///   - size: O número de slots a serem gerenciados.
  SlotManager(int size) {
    _slots = List<Element?>.filled(size, null);
  }

  late List<Element?> _slots;

  /// Retorna o elemento no slot de índice especificado.
  /// Retorna null se o índice estiver fora do intervalo ou se o slot estiver vazio.
  ///
  /// Parâmetros:
  ///   - index: O índice do slot a ser acessado.
  Element? operator [](int index) {
    return _checkIndex(index) ? _slots[index] : null;
  }

  /// Define o valor do slot no índice especificado.
  /// Se o índice estiver fora do intervalo, a operação é ignorada.
  ///
  /// Parâmetros:
  ///   - index: O índice do slot a ser preenchido.
  ///   - value: O valor a ser colocado no slot.
  void operator []=(int index, Element? value) {
    if (_checkIndex(index)) {
      _slots[index] = value;
    }
  }

  /// Verifica se o slot no índice especificado está vazio.
  /// Retorna false se o índice estiver fora do intervalo.
  ///
  /// Parâmetros:
  ///   - index: O índice do slot a ser verificado.
  bool isSlotEmpty(int index) {
    if (_checkIndex(index)) {
      return _slots[index] == null;
    } else {
      return false;
    }
  }

  /// Retorna um iterador dos índices de todos os slots preenchidos.
  Iterable<int> getFilledSlots() sync* {
    for (var i = 0; i < _slots.length; i++) {
      if (_slots[i] != null) {
        yield i;
      }
    }
  }

  /// Retorna um iterador dos índices de todos os slots vazios.
  Iterable<int> getEmptySlots() sync* {
    for (var i = 0; i < _slots.length; i++) {
      if (_slots[i] == null) {
        yield i;
      }
    }
  }

  /// Remove o elemento no slot de índice especificado.
  /// Se o índice estiver fora do intervalo, a operação é ignorada.
  ///
  /// Parâmetros:
  ///   - index: O índice do slot a ser esvaziado.
  void remove(int index) {
    if (_checkIndex(index)) {
      _slots[index] = null;
    }
  }

  /// Adiciona um elemento ao primeiro slot vazio encontrado.
  /// Lança um erro se não houver slots vazios disponíveis.
  ///
  /// Parâmetros:
  ///   - value: O valor a ser adicionado.
  /// Retorna o índice do slot onde o elemento foi adicionado.
  int add(Element value) {
    for (var i = 0; i < _slots.length; i++) {
      if (_slots[i] == null) {
        _slots[i] = value;
        return i;
      }
    }
    throw StateError('No empty slots available');
  }

  /// Retorna o índice do primeiro slot vazio encontrado.
  /// Retorna null se não houver slots vazios.
  int? getFirstEmptySlot() {
    final index = _slots.indexWhere((slot) => slot == null);
    return index != -1 ? index : null;
  }

  /// Retorna o número de slots vazios.
  Iterable<int> countEmptySlots() sync* {
    for (int i = 0; i < _slots.length; i++) {
      if (_slots[i] == null) {
        yield i;
      }
    }
  }

  /// Retorna o número de slots preenchidos.
  Iterable<int> countFilledSlots() sync* {
    for (int i = 0; i < _slots.length; i++) {
      if (_slots[i] != null) {
        yield i;
      }
    }
  }

  /// Retorna o índice do primeiro slot que contém o elemento especificado.
  /// Retorna -1 se o elemento não for encontrado.
  ///
  /// Parâmetros:
  ///   - element: O elemento a ser procurado.
  Iterable<int> find({required Element element}) sync* {
    for (int i = 0; i < _slots.length; i++) {
      if (_slots[i] == element) {
        yield i;
      }
    }
  }

  /// Esvazia todos os slots.
  void clear() {
    for (int i = 0; i < _slots.length; i++) {
      _slots[i] = null;
    }
  }

  /// Verifica se o índice está dentro do intervalo válido.
  /// Lança um erro se o índice estiver fora do intervalo.
  ///
  /// Parâmetros:
  ///   - index: O índice a ser verificado.
  bool _checkIndex(int index) {
    if (index < 0 || index >= _slots.length) {
      throw RangeError.index(index, _slots);
    }
    return true;
  }
}
