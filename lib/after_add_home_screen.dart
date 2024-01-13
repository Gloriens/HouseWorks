import 'package:flutter/material.dart';
import 'package:house/Homes.dart';
import 'package:house/homes/home_cards_list.dart';
import 'package:house/main.dart';
import 'package:house/homes/home_cards.dart';

class AfterAddHomeScreen extends StatefulWidget {
  final List<Homes> list;
  const AfterAddHomeScreen({super.key, required this.list});

  @override
  State<AfterAddHomeScreen> createState() =>
      _AfterAddHomeScreenState();
}

class _AfterAddHomeScreenState extends State<AfterAddHomeScreen> {
  final List<Homes> homesList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Your Homes",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: HomeCardsList(homesList: widget.list),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () async {
                            final newHomes = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddHomeScreen()),
                            );
                            if (newHomes != null && newHomes is List<Homes>) {
                              setState(() {
                                homesList.addAll(newHomes);
                              });
                            }
                          },
                          child: const Text("Add Home"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Add other sections in here if needed in the future
          ],
        ),
      ),
    );
  }
}