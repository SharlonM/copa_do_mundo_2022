import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copa_do_mundo_2022/modelos/model_jogo_real.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../api/banco_de_dados.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static DateTime ultimaAtt = DateTime.now().subtract(const Duration(hours: 1));
  String rodadaSelecionada = "1";

  @override
  Widget build(BuildContext context) {
    debugPrint(ultimaAtt.toString());
    debugPrint(rodadaSelecionada);
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 50,
            color: Colors.grey,
            child: Center(
              child: ListView(
                padding: const EdgeInsets.all(5),
                scrollDirection: Axis.horizontal,
                children: [
                  botaoRodada("1 Rodada"),
                  const SizedBox(width: 30),
                  botaoRodada("2 Rodada"),
                  const SizedBox(width: 30),
                  botaoRodada("3 Rodada"),
                  const SizedBox(width: 30),
                  botaoRodada("Oitavas"),
                  const SizedBox(width: 30),
                  botaoRodada("Quartas"),
                  const SizedBox(width: 30),
                  botaoRodada("Semi"),
                  const SizedBox(width: 30),
                  botaoRodada("3 Lugar"),
                  const SizedBox(width: 30),
                  botaoRodada("Final"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 2),
          buscarDadosBanco(),
        ],
      ),
    );
  }

  Widget buscarDadosBanco() {
    if (DateTime.now().isAfter(ultimaAtt.add(const Duration(minutes: 1)))) {
      return FutureBuilder<DocumentSnapshot>(
          future: BancoDeDados.refJogosReais.doc(rodadaSelecionada).get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return const Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              debugPrint(snapshot.data!.data().toString());
              ultimaAtt = DateTime.now();
              BancoDeDados.jogoRealFromFirestore(
                  snapshot.data as DocumentSnapshot<Map<String, dynamic>>);
              return criarCards();
            }

            return const Text("loading");
          });
    } else {
      return criarCards(); // cria usando os dados existente atualmente
    }
  }

  Widget criarCards() {
    return ListView.builder(
        padding: const EdgeInsets.all(10),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: BancoDeDados.jogosReais.length,
        itemBuilder: (context, int index) {
          JogoRealModel jogo = BancoDeDados.jogosReais.elementAt(index);
          DateTime? data = jogo.data?.toDate().toLocal();
          String dataBR = DateFormat("dd/MM/yyyy  HH:mm").format(data!);

          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(10),
                elevation: 20,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          dataBR,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'lib/images/${jogo.casa}.png',
                                      fit: BoxFit.cover,
                                      height: 30,
                                      width: 50,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      jogo.casa.toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                            const SizedBox(
                              height: 35,
                              width: 45,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20,),
                            const Text("X"),
                            const SizedBox(width: 20,),
                            const SizedBox(
                              height: 35,
                              width: 45,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Colors.white
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'lib/images/${jogo.fora}.png',
                                      fit: BoxFit.cover,
                                      height: 30,
                                      width: 50,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      jogo.fora.toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text('Confirmar'),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
            ],
          );
        });
  }

  Widget botaoRodada(String text) {
    return ElevatedButton(
      style: TextButton.styleFrom(
          backgroundColor:
              text.replaceAll("Rodada", "").trim() == rodadaSelecionada
                  ? Colors.white
                  : Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      onPressed: () {
        mudarRodada(text);
      },
      child: Text(
        text,
        overflow: TextOverflow.clip,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  void mudarRodada(String text) {
    setState(() {
      switch (text) {
        case "1 Rodada":
          rodadaSelecionada = "1";
          break;
        case "2 Rodada":
          rodadaSelecionada = "2";
          break;
        case "3 Rodada":
          rodadaSelecionada = "3";
          break;
        default:
          rodadaSelecionada = text;
      }
      ultimaAtt = DateTime.now().subtract(const Duration(hours: 24));
    });
  }
}
