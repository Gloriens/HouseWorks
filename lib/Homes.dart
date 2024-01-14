import 'package:flutter/material.dart';


class Homes extends StatefulWidget {
  String evIsmi;
  List<String> insanListesi;
  int? id;

  Homes({required this.evIsmi, required this.insanListesi, this.id});

  @override
  State<Homes> createState() => _HomesState();
}

class _HomesState extends State<Homes> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


