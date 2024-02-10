import 'package:collection/collection.dart';

import '../ref_entities/epub_book_ref.dart';
import '../ref_entities/epub_chapter_ref.dart';
import '../ref_entities/epub_text_content_file_ref.dart';

class ChapterReader {
  static List<EpubChapterRef> getChapters(EpubBookRef bookRef) {
    if (bookRef.Schema!.Navigation == null) {
      return <EpubChapterRef>[];
    }
    return getChaptersImpl(bookRef);
  }

  static List<EpubChapterRef> getChaptersImpl(EpubBookRef bookRef) {
    var result = <EpubChapterRef>[];

    var spineItems = bookRef.Schema!.Package!.Spine!.Items;
    var manifest = bookRef.Schema!.Package!.Manifest!.Items;

    if (spineItems == null) {
      throw Exception('Incorrect EPUB schema: spine is missing.');
    }

    if (manifest == null) {
      throw Exception('Incorrect EPUB schema: manifest is missing.');
    }

    for (var spineItem in spineItems) {
      String? contentFileName;

      if (spineItem.IdRef == null) {}

      var manifestItem =
          manifest.firstWhereOrNull((element) => element.Id == spineItem.IdRef);

      if (manifestItem == null) {
        throw Exception(
            'Incorrect EPUB schema: spine item missing for Id:${spineItem.IdRef}.');
      }

      contentFileName = manifestItem.Href;

      if (contentFileName == null) {
        throw Exception(
            'Incorrect EPUB manifest: manifest entry missing for Id:${spineItem.IdRef}.');
      }

      contentFileName = Uri.decodeFull(contentFileName);
      EpubTextContentFileRef? htmlContentFileRef;
      if (!bookRef.Content!.Html!.containsKey(contentFileName)) {
        if (contentFileName.toLowerCase().startsWith('oebps/')) {
          contentFileName = contentFileName.substring('oebps/'.length);
          if (!bookRef.Content!.Html!.containsKey(contentFileName)) {
            throw Exception(
                'Incorrect EPUB manifest: item with href = \"$contentFileName\" is missing.');
          }
        } else {
          throw Exception(
              'Incorrect EPUB manifest: item with href = \"$contentFileName\" is missing.');
        }
      }

      htmlContentFileRef = bookRef.Content!.Html![contentFileName];
      var chapterRef = EpubChapterRef(htmlContentFileRef);
      chapterRef.ContentFileName = contentFileName;

      result.add(chapterRef);
    }
    return result;
  }
}
