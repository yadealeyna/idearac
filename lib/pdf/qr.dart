import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:son/pdf/pdf.dart';

QrImageView QrOlustur(plaka) {
  String link = 'https://idekod.com/idearac/index.php?plaka=';
  String plate = plaka;
  String combinedData = '$link\n$plate';

  return QrImageView(
    key: GlobalKey(),
    data: combinedData,
    version: QrVersions.auto,
    //size: 85.0,
  );
}

class QrImage extends StatefulWidget {
  QrImage({Key? key, required this.plaka}) : super(key: key);
  final String plaka;
  
  @override
  State<QrImage> createState() => _QrImageState();
}

class _QrImageState extends State<QrImage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pngSaver();
    });
  }

  Future<void> pngSaver() async {
    final RenderRepaintBoundary boundary = context.findRenderObject() as RenderRepaintBoundary;
    var image;
    var catched = false;
    try {
      image = await boundary.toImage(pixelRatio: 3.0);
      catched = true;
    } catch (exeption) {
      catched = false;
      Timer(Duration(milliseconds: 1), () {
        pngSaver();
      });
    }

    if(catched == true){
      final whitePaint = Paint()..color = Colors.white;
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
      
      canvas.drawImage(image, Offset.zero, Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);
      ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'QR_$timestamp.png';


      String filePath = '${directory.path}/$fileName';
      print("QR"+filePath);

      File file = File(filePath);
      await file.writeAsBytes(pngBytes);
      debugPrint('QR oluşturuldu: ${file.path}');

      if (await File(filePath).exists()) {
        createPDF(widget.plaka, filePath);
      } else {
        debugPrint('Qr bulunamadı');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: GlobalKey(),
      child: QrOlustur(widget.plaka),
    );
  }
}