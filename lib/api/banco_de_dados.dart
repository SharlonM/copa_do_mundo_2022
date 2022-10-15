import 'package:cloud_firestore/cloud_firestore.dart';

import '../modelos/model_jogo_real.dart';

class BancoDeDados {
  static final CollectionReference refJogosReais =
      FirebaseFirestore.instance.collection('JogosReais');
  static List<JogoRealModel> jogosReais = <JogoRealModel>[];

  static List<JogoRealModel>? jogoRealFromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    jogosReais.clear();
    final data = snapshot.data();
    data?.forEach((key, value) {
      jogosReais.add(JogoRealModel(
          value['Data'],
          value['GolsFora'],
          value['Casa'].toString().trim(),
          value['Ganhador'].toString().trim(),
          value['Fora'].toString().trim(),
          value['GolsCasa']));
    });

    jogosReais.sort((x, y) {
      Timestamp a = x.data!;
      Timestamp b = y.data!;
      return a.compareTo(b);
    });
    return jogosReais;
  }

  static Map<String, Object?> jogoRealToFirestore() {
    int count = 1;
    Map<String, dynamic> convert = <String, dynamic>{};
    for (JogoRealModel jogo in jogosReais) {
      convert.addAll({
        "Jogo " + count.toString(): {
          "Data": jogo.data,
          "GolsFora": jogo.golsFora,
          "Casa": jogo.casa,
          "Ganhador": jogo.ganhador,
          "Fora": jogo.fora,
          "GolsCasa": jogo.golsCasa
        }
      });
      count++;
    }
    return convert;
  }
}
