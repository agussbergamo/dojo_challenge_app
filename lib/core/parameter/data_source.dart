enum DataSource {
  api,
  local,
  firestore;

  String get value {
    switch (this) {
      case DataSource.api:
        return 'API';
      case DataSource.local:
        return 'Local DB';
      case DataSource.firestore:
        return 'Firestore';
    }
  }
}
