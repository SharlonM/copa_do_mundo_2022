import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copa_do_mundo_2022/api/banco_de_dados.dart';
import 'package:copa_do_mundo_2022/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: FutureBuilder<DocumentSnapshot>(future: BancoDeDados.refJogosReais.doc("1").get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return const Text("Document does not exist");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  debugPrint(snapshot.data!.data().toString());
                  BancoDeDados.jogoRealFromFirestore(snapshot.data as DocumentSnapshot<Map<String, dynamic>> );
                  return const Text("Retorno");
                }

                return const Text("loading");
              }),
        )
    );
  }
}
