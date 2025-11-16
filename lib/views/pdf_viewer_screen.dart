import 'dart:io'; // Add this import for File class
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatelessWidget {
  final String filePath;
  final String fileName;

  const PdfViewerScreen({
    Key? key,
    required this.filePath,
    required this.fileName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a File object from the string path
    final File pdfFile = File(filePath);

    return Scaffold(
      appBar: AppBar(
        title: Text(fileName),
        backgroundColor: const Color(0xFF252526),
      ),
      body: SfPdfViewer.file(
        pdfFile, // Pass the File object instead of the string
        canShowScrollHead: true,
        canShowScrollStatus: true,
        enableDoubleTapZooming: true,
        enableTextSelection: true,
      ),
    );
  }
}
