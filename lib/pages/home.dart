import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controller = TextEditingController();

  // ignore: unused_element
  void _launchCaller(String number) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    await launchUrl(launchUri);
  }


  // ignore: unused_element
  void _launchSMS(String number) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: number,
      queryParameters: {'body': Uri.encodeComponent('Hola, Bienvenido a VilloMAx')},
    );
    await launchUrl(launchUri);
  }

  void _launchGitHub() async {
    const url = 'https://github.com/Villo29/appmovilutils.git';
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'No se pudo lanzar $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.code),
              onPressed: _launchGitHub,
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MyTextWidget(controller: _controller),
          ],
        ),
      ),
    );
  }
}

class MyTextWidget extends StatefulWidget {
  final TextEditingController controller;

  const MyTextWidget({super.key, required this.controller});

  @override
  // ignore: library_private_types_in_public_api
  _MyTextWidgetState createState() => _MyTextWidgetState();
}

class _MyTextWidgetState extends State<MyTextWidget> {
  void _launchCaller(String number) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: number,
    );
    await launchUrl(launchUri);
  }

  void _launchSMS(String number) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: number,
      queryParameters: {'body': Uri.encodeComponent(widget.controller.text)},
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Image(
          image: AssetImage('assets/images/villoimg.jpg'),
          width: 350,
          height: 350,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Expanded(child: Text('221263 Jesus David Ruiz Garcia')),
            IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () => _launchCaller('9612835436'),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.message),
              onPressed: () => _launchSMS('9612835436'),
            ),
          ],
        ),
      ],
    );
  }
}