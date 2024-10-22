import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controller = TextEditingController();

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
      queryParameters: {'body': Uri.encodeComponent('Hola, Bienvenido a VilloMAx')},
    );
    await launchUrl(launchUri);
  }

  void _launchGitHub() async {
    const url = 'https://github.com/AngelMerlinO/app-movil-C2';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo lanzar $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MyTextWidget(controller: _controller),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.github, color: Colors.white),
              onPressed: _launchGitHub,
              tooltip: 'GitHub',
            ),
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
          image: AssetImage('assets/images/imgUno.jpeg'),
          width: 350,
          height: 350,
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 2,
                blurRadius: 10,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Jose Angel Ortega Merlin',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Desarrollador de Software\n'
                  '221255\n'
                  'Universidad Politécnica de Chiapas',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.phone, color: Colors.green),
                      onPressed: () => _launchCaller('9515271070'),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.message, color: Colors.blue),
                      onPressed: () => _launchSMS('9515271070'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}