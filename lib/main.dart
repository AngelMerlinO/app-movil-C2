import 'package:flutter/material.dart';
import 'package:appmovilutils/pages/home.dart';
import 'package:appmovilutils/pages/geolocator.dart';
import 'package:appmovilutils/pages/qrflutter.dart';
import 'package:appmovilutils/pages/sensorplus.dart';
import 'package:appmovilutils/pages/speech.dart';
import 'package:appmovilutils/pages/text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const Home(title: 'Home Page'),
    const LocationStatusScreen(),
    QrCodeScanner(),
    SensorPlusPage(),
    SpeechToTextView(),
    TextToSpeechView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,  // Asegura que el fondo sea visible
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_location),
            label: 'Geolocalización',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'QR',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sensors),
            label: 'Sensores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Habla',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.audiotrack),
            label: 'Sonido',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 50, 15, 225), // Color del ícono seleccionado
        unselectedItemColor: Colors.grey, // Color de los íconos no seleccionados
        onTap: _onItemTapped,
      ),
    );
  }
}
