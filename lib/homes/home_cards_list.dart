import 'package:flutter/material.dart';
import 'package:house/Homes.dart';
import 'home_cards.dart';

class HomeCardsList extends StatelessWidget {
  final List<Homes> homesList;

  const HomeCardsList({Key? key, required this.homesList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: homesList.length,
        itemBuilder: (context, index) => HomesCard(homesList[index]),
      ),
    );
  }
}
