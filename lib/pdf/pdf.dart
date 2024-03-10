import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'dart:typed_data';

import 'dart:async';

import 'package:flutter/services.dart';

import 'qr.dart';
/*

class PdfGenerate extends StatefulWidget {
  const PdfGenerate({Key? key, required this.plaka}) : super(key: key);
  final String plaka;

  @override
  State<PdfGenerate> createState() => _PdfGenerateState();
}

class _PdfGenerateState extends State<PdfGenerate> {*/

Future<void> createPDF(plaka, filePath) async {
  final pdf = pw.Document();

  final ByteData bytes = await rootBundle.load('assets/images/idearac.jpg');
  final Uint8List byteList = bytes.buffer.asUint8List();

  final Uint8List imageBytes = File(filePath).readAsBytesSync();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Stack(
            children: [
              pw.Container(
                child: pw.Image(
                  pw.MemoryImage(
                    byteList,
                  ),
                  fit: pw.BoxFit.fitHeight
                ),                
              ),
              pw.Positioned(
                top: 112.0,
                right: 40.0,
                child: pw.Container(
                  child: pw.Image(
                    pw.MemoryImage(imageBytes),
                    width: 179.0,
                    height: 179.0,
                  ),
                )
              ),
              pw.Positioned(
                top: 112.0,
                right: 192.65,
                child: pw.Container(
                  child: pw.Image(
                    pw.MemoryImage(imageBytes),
                    width: 179.0,
                    height: 179.0,
                  ),
                )
              ),
              pw.Positioned(
                top: 112.0,
                right: 343.5,
                child: pw.Container(
                  child: pw.Image(
                    pw.MemoryImage(imageBytes),
                    width: 179.0,
                    height: 179.0,
                  ),
                )
              ),
              pw.Positioned(
                top: 403.0,
                right: 273.5,
                child: pw.Container(
                  child: pw.Image(
                    pw.MemoryImage(imageBytes),
                    width: 282.0,
                    height: 282.0,
                  ),
                )
              ),
            ] 
          )
        );
      },
    ),
  );


  //pdf indirme ve görüntüleme
  final directory = await getExternalStorageDirectory();
  if (directory != null) {
    
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'PDF_$timestamp.pdf';

    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    debugPrint('PDF oluşturuldu: ${file.path}');

    final filePath = '${directory.path}/$fileName';
    if (await File(filePath).exists()) {
      OpenFile.open(filePath);
    } else {
      debugPrint('PDF dosyası bulunamadı');
    }

  } else {
    debugPrint('Dış depolama alanı bulunamadı.');
  }
}
/*
  @override
  Widget build(BuildContext context) {
    return Column();
  }
}*/