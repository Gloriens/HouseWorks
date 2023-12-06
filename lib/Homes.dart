import 'package:flutter/material.dart';


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


