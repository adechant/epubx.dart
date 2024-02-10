import 'package:quiver/core.dart';

class EpubNavigationContent {
  String? Id;
  String? Source;
  String? get SourceWithoutPath => Source?.split('/').last.split('#').first;

  @override
  int get hashCode => hash2(Id.hashCode, Source.hashCode);

  @override
  bool operator ==(other) {
    if (!(other is EpubNavigationContent)) {
      return false;
    }
    return Id == other.Id && Source == other.Source;
  }

  @override
  String toString() {
    return 'Source: $Source';
  }
}
