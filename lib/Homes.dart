import 'package:flutter/material.dart';
import 'package:house/Homes.dart';
import 'package:house/homes/home_cards_list.dart';
import 'package:house/main.dart';



class Homes extends StatefulWidget {
  String evIsmi;
  List<String> insanListesi;

  Homes({Key? key, required this.evIsmi, required this.insanListesi}) : super(key: key);

  @override
  State<Homes> createState() => _HomesState();
}

class _HomesState extends State<Homes> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


