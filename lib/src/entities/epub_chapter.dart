import 'package:quiver/core.dart';
import 'dart:math';

class EpubChapter {
  //String? Title;
  String? ContentFileName;
  //List<EpubNavigationPoint>? Anchor;
  String? HtmlContent;
  int startPage = 0;
  int endPage = 0;
  int indexOfChapter = 0;

  int pagesLeft(int index) => endPage - index;
  int get length => max(endPage - startPage, 0);
  String? get ContentFileNameWithoutPath => ContentFileName?.split('/').last;

  @override
  int get hashCode {
    var objects = [
      //Title.hashCode,
      ContentFileName.hashCode,
      //Anchor.hashCode,
      HtmlContent.hashCode,
      //...SubChapters?.map((subChapter) => subChapter.hashCode) ?? [0],
    ];
    return hashObjects(objects);
  }

  @override
  bool operator ==(other) {
    if (!(other is EpubChapter)) {
      return false;
    }
    return //Title == other.Title &&
        ContentFileName == other.ContentFileName &&
            //Anchor == other.Anchor &&
            HtmlContent == other.HtmlContent;
    //&& collections.listsEqual(SubChapters, other.SubChapters);
  }

  @override
  String toString() {
    return 'Filename: $ContentFileName';
    //return 'Title: $Title'; //, Subchapter count: ${SubChapters!.length}';
  }
}
