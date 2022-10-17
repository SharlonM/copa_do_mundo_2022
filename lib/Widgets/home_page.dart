import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copa_do_mundo_2022/modelos/model_jogo_real.dart';
import 'package:flutter/material.dart';
import '../api/banco_de_dados.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static DateTime ultimaAtt = DateTime.now().subtract(const Duration(hours: 1));
  int rodadaSelecionada = 0;
  static List<String> rodadas = [
    "1 Rodada",
    "2 Rodada",
    "3 Rodada",
    "Oitavas",
    "Quartas",
    "Semi",
    "Terceiro Lugar",
    "Final"
  ];

  @override
  void initState() {
    super.initState();
    ultimaAtt = DateTime.now().subtract(const Duration(hours: 24));
    debugPrint("Init");
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(ultimaAtt.toString());
    debugPrint(rodadaSelecionada.toString());
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 2),
          widgetRodada(rodadas.elementAt(rodadaSelecionada)),
          buscarDadosBanco(),
        ],
      ),
    );
  }

  Widget buscarDadosBanco() {
    if (DateTime.now().isAfter(ultimaAtt.add(const Duration(minutes: 1)))) {
      String get =
      rodadas.elementAt(rodadaSelecionada).replaceAll("Rodada", "").trim();
      debugPrint(get);
      return FutureBuilder<DocumentSnapshot>(
          future: BancoDeDados.refJogosReais.doc(get).get(),
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

            return const Center(
              child: CircularProgressIndicator(),
            );
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
              Row(children: <Widget>[
                const Expanded(
                    child: Divider(
                      color: Color.fromRGBO(158, 158, 158, 100),
                    )),
                Text(
                  dataBR,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic),
                ),
                const Expanded(
                    child: Divider(
                      color: Color.fromRGBO(158, 158, 158, 100),
                    )),
              ]),
              Card(
                margin: const EdgeInsets.all(10),
                elevation: 20,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: const Color.fromRGBO(238, 238, 238, 100),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                            const SizedBox(
                              width: 20,
                            ),
                            const Text("X"),
                            const SizedBox(
                              width: 20,
                            ),
                            const SizedBox(
                              height: 35,
                              width: 45,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    fillColor: Colors.white),
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
                            botaoConfirmacao(jogo)
                          ],
                        ),
                        Row(children: const <Widget>[
                          Expanded(
                              child: Divider(
                                color: Color.fromRGBO(158, 158, 158, 100),
                              )),
                          Text(
                            "3 Pontos",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.italic),
                          ),
                          Expanded(
                              child: Divider(
                                color: Color.fromRGBO(158, 158, 158, 100),
                              )),
                        ])
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

  void mudarRodada(int x) {
    setState(() {
      if (x == 2) {
        rodadaSelecionada++;
      } else {
        rodadaSelecionada--;
      }
      ultimaAtt = DateTime.now().subtract(const Duration(hours: 24));
    });
  }

  widgetRodada(String text) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              width: 1, style: BorderStyle.solid, color: Colors.grey)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          condicaoDeBotao(text, 1, Icons.arrow_left),
          Center(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          condicaoDeBotao(text, 2, Icons.arrow_right)
        ],
      ),
    );
  }

  condicaoDeBotao(String text, int x, icone) {
    if (text == "Final" && x == 2) {
      return const SizedBox(width: 50);
    } else if (text == "1 Rodada" && x == 1) {
      return const SizedBox(width: 50);
    } else {
      return GestureDetector(
        onTap: () {
          mudarRodada(x);
        },
        child: Icon(
          icone,
          size: 55,
        ),
      );
    }
  }

  botaoConfirmacao(JogoRealModel jogo) {
    bool confirmado = false; // receber o objeto de jogo com a variavel jogo.confirmado
    Timestamp data = jogo.data as Timestamp;
    bool podeConfirmar = data.compareTo(Timestamp.now()) >= 0;

    if (!confirmado) {
      return IconButton(
        onPressed: podeConfirmar ? (){debugPrint("Pressed confirmar");} : null,
        icon: const Icon(Icons.check_box_outline_blank),
        tooltip: "Confirmar",
      );
    } else {
      return IconButton(
        onPressed: () {},
        icon: const Icon(Icons.check_box, color: Colors.green,),
        tooltip: "Cancelar",
      );
    }
  }

}
