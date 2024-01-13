import 'package:flutter/material.dart';
import 'package:house/Homes.dart';
import 'package:house/interactive_table_page.dart';

class HomesCard extends StatelessWidget {
  final Homes home;

  const HomesCard(this.home, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to InteractiveTablePage when the card is clicked
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InteractiveTablePage(home: home),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                home.evIsmi,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'People: ${home.insanListesi.join(', ')}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
