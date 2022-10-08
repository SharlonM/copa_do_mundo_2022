import 'package:cloud_firestore/cloud_firestore.dart';

class JogoRealModel{

  final Timestamp? data;
  final int? golsFora;
  final String? casa;
  final String? ganhador;
  final String? fora;
  final int? golsCasa;

  JogoRealModel(this.data, this.golsFora, this.casa, this.ganhador, this.fora,
      this.golsCasa);
}