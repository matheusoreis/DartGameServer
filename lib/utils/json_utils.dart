class JsonUtils {
  static List<T> fromJsonList<T>(List<dynamic> jsonList, T Function(Map<String, dynamic>) fromJson) {
    return jsonList.map<T>((item) => fromJson(item as Map<String, dynamic>)).toList();
  }

  static List<Map<String, dynamic>> toJsonList<T>(List<T> list, Map<String, dynamic> Function(T) toJson) {
    return list.map((item) => toJson(item)).toList();
  }

  static List<Map<String, dynamic>> toMapList<T>(List<T> list, Map<String, dynamic> Function(T) toMap) {
    return list.map((item) => toMap(item)).toList();
  }
}
