import 'package:copa_do_mundo_2022/Widgets/home_page.dart';
import 'package:copa_do_mundo_2022/Widgets/jogos_page.dart';
import 'package:copa_do_mundo_2022/Widgets/perfil_page.dart';
import 'package:copa_do_mundo_2022/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Copa do Mundo 2022',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const List<Widget> _telas = <Widget>[
    HomePage(),
    JogosPage(),
    PerfilPage()
  ];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: ()=> mostrarAjuda(),
              child: const Icon(
                Icons.info,
                color: Colors.amber,
              ),
            ),
          ),
        ],
      ),
      body: _telas.elementAt(_index),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Jogos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.play_circle), label: 'Resultados'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil')
        ],
        currentIndex: _index,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.black,
        onTap: _MudarTela,
        backgroundColor: Colors.green,
      ),
    );
  }

  void _MudarTela(int index) {
    setState(() {
      _index = index;
    });
  }

  mostrarAjuda() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('AlertDialog Title'),
        content: const Text('AlertDialog description'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
