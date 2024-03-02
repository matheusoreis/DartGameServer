class SlotManager<Element> {
  SlotManager(int size) {
    _slots = List<Element?>.filled(size, null);
  }

  late List<Element?> _slots;

  Element? operator [](int index) {
    return _checkIndex(index) ? _slots[index] : null;
  }

  void operator []=(int index, Element? value) {
    if (_checkIndex(index)) {
      _slots[index] = value;
    }
  }

  bool isSlotEmpty(int index) {
    if (_checkIndex(index)) {
      return _slots[index] == null;
    } else {
      return false;
    }
  }

  Iterable<int> getFilledSlots() sync* {
    for (var i = 0; i < _slots.length; i++) {
      if (_slots[i] != null) {
        yield i;
      }
    }
  }

  Iterable<int> getEmptySlots() sync* {
    for (var i = 0; i < _slots.length; i++) {
      if (_slots[i] == null) {
        yield i;
      }
    }
  }

  void remove(int index) {
    if (_checkIndex(index)) {
      _slots[index] = null;
    }
  }

  int add(Element value) {
    for (var i = 0; i < _slots.length; i++) {
      if (_slots[i] == null) {
        _slots[i] = value;
        return i;
      }
    }
    throw StateError('No empty slots available');
  }

  int? getFirstEmptySlot() {
    final index = _slots.indexWhere((slot) => slot == null);
    return index != -1 ? index : null;
  }

  Iterable<int> countEmptySlots() sync* {
    for (int i = 0; i < _slots.length; i++) {
      if (_slots[i] == null) {
        yield i;
      }
    }
  }

  Iterable<int> countFilledSlots() sync* {
    for (int i = 0; i < _slots.length; i++) {
      if (_slots[i] != null) {
        yield i;
      }
    }
  }

  Iterable<int> find({required Element element}) sync* {
    for (int i = 0; i < _slots.length; i++) {
      if (_slots[i] == element) {
        yield i;
      }
    }
  }

  void clear() {
    for (int i = 0; i < _slots.length; i++) {
      _slots[i] = null;
    }
  }

  bool _checkIndex(int index) {
    if (index < 0 || index >= _slots.length) {
      throw RangeError.index(index, _slots);
    }
    return true;
  }
}
