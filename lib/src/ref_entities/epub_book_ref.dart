import 'dart:async';

import 'package:archive/archive.dart';
import 'package:epubx/epubx.dart';
import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import '../readers/book_cover_reader.dart';
import '../readers/chapter_reader.dart';
import 'epub_content_ref.dart';

class EpubBookRef {
  Archive? _epubArchive;

  String? Title;
  String? Author;
  List<String?>? AuthorList;
  EpubSchema? Schema;
  EpubContentRef? Content;
  EpubBookRef(Archive epubArchive) {
    _epubArchive = epubArchive;
  }

  List<EpubNavigationPoint> get flattenedTOC {
    final toc = <EpubNavigationPoint>[];
    final pointRef = Schema?.Navigation?.NavMap?.Points ?? [];
    toc.addAll(parseNavPointList(pointRef, 0));
    return toc;
  }

  List<EpubNavigationPoint> parseNavPointList(
      List<EpubNavigationPoint> list, int level) {
    final toReturn = <EpubNavigationPoint>[];
    for (final point in list) {
      point.nestLevel = level;
      toReturn.add(point);
      toReturn.addAll(
          parseNavPointList(point.ChildNavigationPoints ?? [], level + 1));
    }
    return toReturn;
  }

  @override
  int get hashCode {
    var objects = [
      Title.hashCode,
      Author.hashCode,
      Schema.hashCode,
      Content.hashCode,
      ...AuthorList?.map((author) => author.hashCode) ?? [0],
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    if (!(other is EpubBookRef)) {
      return false;
    }

    return Title == other.Title &&
        Author == other.Author &&
        Schema == other.Schema &&
        Content == other.Content &&
        collections.listsEqual(AuthorList, other.AuthorList);
  }

  Archive? EpubArchive() {
    return _epubArchive;
  }

  Future<List<EpubChapterRef>> getChapters() async {
    return ChapterReader.getChapters(this);
  }

  Future<Image?> readCover() async {
    return await BookCoverReader.readBookCover(this);
  }
}
