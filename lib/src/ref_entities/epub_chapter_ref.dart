import 'dart:async';

import 'package:epubx/epubx.dart';
import 'package:quiver/core.dart';

import 'epub_text_content_file_ref.dart';

class EpubChapterRef {
  EpubTextContentFileRef? epubTextContentFileRef;

  String? ContentFileName;
  List<EpubNavigationPoint>? Anchor;
  //List<EpubChapterRef>? SubChapters;

  EpubChapterRef(EpubTextContentFileRef? epubTextContentFileRef) {
    this.epubTextContentFileRef = epubTextContentFileRef;
  }

  @override
  int get hashCode {
    var objects = [
      //Title.hashCode,
      ContentFileName.hashCode,
      Anchor.hashCode,
      epubTextContentFileRef.hashCode,
      //...SubChapters?.map((subChapter) => subChapter.hashCode) ?? [0],
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    if (!(other is EpubChapterRef)) {
      return false;
    }
    return //Title == other.Title &&
        ContentFileName == other.ContentFileName &&
            Anchor == other.Anchor &&
            epubTextContentFileRef == other.epubTextContentFileRef;
    //&&collections.listsEqual(SubChapters, other.SubChapters);
  }

  Future<String> readHtmlContent() async {
    return epubTextContentFileRef!.readContentAsText();
  }

  @override
  String toString() {
    return 'Filename: $ContentFileName';
    //return 'Title: $Title';
    //return 'Title: $Title, Subchapter count: ${SubChapters!.length}';
  }
}
