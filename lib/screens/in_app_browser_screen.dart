import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InAppBrowserScreen extends StatelessWidget {
  final String url;

  const InAppBrowserScreen({Key? key, required this.url}) : super(key: key);

  Future<void> _launchURL() async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Launch the URL immediately when the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _launchURL();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trivia Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Opening browser...'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _launchURL,
              child: const Text('Open URL again'),
            ),
          ],
        ),
      ),
    );
  }
}