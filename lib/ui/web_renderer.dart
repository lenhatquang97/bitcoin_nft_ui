import 'package:flutter/material.dart';
import 'package:http/http.dart';

class WebRendererWidget extends StatelessWidget {
  final String url;
  const WebRendererWidget({super.key, required this.url});

  Widget webRenderer(BuildContext context, String mimeType) {
    if (mimeType.startsWith("image")) {
      return Expanded(child: Image.network(url));
    } else {
      return unknownDisplay(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getUrlMimeType(url),
      builder: (context, snapshot) {
      if(snapshot.hasData && snapshot.data != null) {
        return webRenderer(context, snapshot.data!);
      } else if(snapshot.hasError) {
        return errorExceptionWidget(context);
      }
      return const CircularProgressIndicator();
    },);
  }

  Widget errorExceptionWidget(BuildContext context) {
    return const Column(
      children: [
        Align(
            alignment: Alignment.center, child: Icon(Icons.close, size: 120)),
        Text(
          "Sorry but cannot load your assets",
          style:  TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget unknownDisplay(BuildContext context) {
    return const Column(
      children: [
        Align(
            alignment: Alignment.center, child: Icon(Icons.close, size: 80)),
        Text(
          "We now only support image format",
          style:  TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Future<String?> getUrlMimeType(String url) async {
    final response = await head(Uri.parse(url));
    return response.headers['content-type'];
  }
}