import 'package:flutter/foundation.dart';

enum PDFDocumentSource { file, url, asset, memory }

class PDFDocumentInfo {
  final String title;
  final String? author;
  final String? subject;
  final String? keywords;
  final String? creator;
  final String? producer;
  final DateTime? creationDate;
  final DateTime? modificationDate;

  PDFDocumentInfo({
    required this.title,
    this.author,
    this.subject,
    this.keywords,
    this.creator,
    this.producer,
    this.creationDate,
    this.modificationDate,
  });

  factory PDFDocumentInfo.empty() {
    return PDFDocumentInfo(title: 'Untitled Document');
  }

  @override
  String toString() {
    return 'PDFDocumentInfo{title: $title, author: $author, subject: $subject}';
  }
}

class PDFBookmark {
  final String title;
  final int pageIndex;
  final List<PDFBookmark> children;

  PDFBookmark({
    required this.title,
    required this.pageIndex,
    this.children = const [],
  });
}

class PDFDocumentModel extends ChangeNotifier {
  final String id;
  final String? filePath;
  final String? url;
  final PDFDocumentSource source;
  PDFDocumentInfo? _info;
  int _lastReadPage = 0;
  DateTime _lastOpened = DateTime.now();
  bool _isFavorite = false;
  List<PDFBookmark>? _bookmarks;

  PDFDocumentModel({
    required this.id,
    this.filePath,
    this.url,
    required this.source,
    PDFDocumentInfo? info,
    int lastReadPage = 0,
    DateTime? lastOpened,
    bool isFavorite = false,
    List<PDFBookmark>? bookmarks,
  })  : _info = info ?? PDFDocumentInfo.empty(),
        _lastReadPage = lastReadPage,
        _lastOpened = lastOpened ?? DateTime.now(),
        _isFavorite = isFavorite,
        _bookmarks = bookmarks;

  PDFDocumentInfo? get info => _info;
  int get lastReadPage => _lastReadPage;
  DateTime get lastOpened => _lastOpened;
  bool get isFavorite => _isFavorite;
  List<PDFBookmark>? get bookmarks => _bookmarks;

  void updateLastReadPage(int page) {
    _lastReadPage = page;
    _lastOpened = DateTime.now();
    notifyListeners();
  }

  void setInfo(PDFDocumentInfo info) {
    _info = info;
    notifyListeners();
  }

  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }

  void addBookmark(PDFBookmark bookmark) {
    _bookmarks ??= [];
    _bookmarks!.add(bookmark);
    notifyListeners();
  }

  void removeBookmark(PDFBookmark bookmark) {
    if (_bookmarks != null) {
      _bookmarks!.remove(bookmark);
      notifyListeners();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
      'url': url,
      'source': source.toString(),
      'lastReadPage': _lastReadPage,
      'lastOpened': _lastOpened.toIso8601String(),
      'isFavorite': _isFavorite,
    };
  }

  factory PDFDocumentModel.fromJson(Map<String, dynamic> json) {
    return PDFDocumentModel(
      id: json['id'],
      filePath: json['filePath'],
      url: json['url'],
      source: PDFDocumentSource.values.firstWhere(
        (e) => e.toString() == json['source'],
        orElse: () => PDFDocumentSource.file,
      ),
      lastReadPage: json['lastReadPage'] ?? 0,
      lastOpened: json['lastOpened'] != null
          ? DateTime.parse(json['lastOpened'])
          : null,
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
