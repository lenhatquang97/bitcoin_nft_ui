import 'dart:convert';
import 'dart:io';

import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

class FileRendererWidget extends StatelessWidget {
  final String hexStr;
  final String mimeType;
  final String txId;
  const FileRendererWidget(
      {super.key, required this.hexStr, required this.mimeType, required this.txId});

  //Convert hex string to text
  Widget textRenderer() {
    final bytes = hex.decode(hexStr);
    final text = utf8.decode(bytes);
    return Text(text);
  }

  Widget unknownDisplay(BuildContext context) {
    return Column(
      children: [
        const Align(
            alignment: Alignment.center, child: Icon(Icons.close, size: 120)),
        Text(
          "Unknown format with type: $mimeType",
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: () {
          final fileExtension = extensionFromMime(mimeType);
          writeToFile(context,'$txId.$fileExtension');
        }, child: const Text("Export file"))
      ],
    );
  }


  //Write bytes into file
  void writeToFile(BuildContext context, String fileName) async {
    final bytes = hex.decode(hexStr);
    final directory = await getDownloadsDirectory();
    final path = directory?.path;
    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes);
    final snackBar = SnackBar(content: Text('File saved to $path/$fileName'));
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget fileRenderer(BuildContext context) {
    if (mimeType.startsWith("image")) {
      return Image.memory(Uint8List.fromList(hex.decode(hexStr)));
    } else if (mimeType.startsWith("text/plain")) {
      return textRenderer();
    } else {
      return unknownDisplay(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: fileRenderer(context));
  }
}
