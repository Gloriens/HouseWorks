import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:house/Homes.dart';

class Housework {
  String housework = '';
  String whoDidIt = '';
}

class InteractiveTablePage extends StatefulWidget {
  final Homes home;

  const InteractiveTablePage({Key? key, required this.home}) : super(key: key);

  @override
  _InteractiveTablePageState createState() => _InteractiveTablePageState();
}

class _InteractiveTablePageState extends State<InteractiveTablePage> {
  // List of houseworks for each day
  List<List<Housework>> houseworksByDay = List.generate(7, (index) => []);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.home.evIsmi} HouseWorks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Table of HouseWorks'),
            SizedBox(height: 16),
            buildInteractiveTable(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Call the function to save houseworks to Firebase
          saveHouseworksToFirebase();
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.blue, // Customize the color if needed
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget buildInteractiveTable() {
    return Table(
      border: TableBorder.all(),
      children: [
        // Table header
        TableRow(
          children: List.generate(
            7,
                (index) => TableCell(
              child: Center(
                child: Text('Day ${index + 1}'),
              ),
            ),
          ),
        ),
        TableRow(
          children: List.generate(
            7,
                (index) => TableCell(
              child: Center(
                child: buildHouseworkSection(index),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHouseworkSection(int dayIndex) {
    return Column(
      children: [
        ...houseworksByDay[dayIndex].map((housework) {
          return Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Housework'),
                controller: TextEditingController(text: housework.housework),
                onChanged: (value) {
                  housework.housework = value;
                },
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(labelText: 'Who did it?'),
                controller: TextEditingController(text: housework.whoDidIt),
                onChanged: (value) {
                  housework.whoDidIt = value;
                },
              ),
              SizedBox(height: 8),
            ],
          );
        }).toList(),
        ElevatedButton(
          onPressed: () {
            setState(() {
              houseworksByDay[dayIndex].add(Housework());
            });
          },
          child: Text('+ Add Housework'),
        ),
      ],
    );
  }

  void saveHouseworksToFirebase() async {
    final CollectionReference houseworksCollection =
    FirebaseFirestore.instance.collection('Houseworks');

    for (int dayIndex = 0; dayIndex < houseworksByDay.length; dayIndex++) {
      for (int houseworkIndex = 0;
      houseworkIndex < houseworksByDay[dayIndex].length;
      houseworkIndex++) {
        Housework housework = houseworksByDay[dayIndex][houseworkIndex];

        // Save housework to Firebase
        await houseworksCollection.add({
          'dayIndex': dayIndex,
          'housework': housework.housework,
          'whoDidIt': housework.whoDidIt,
        });
      }
    }

    // After saving, navigate back to the home page
    Navigator.pop(context);
  }

}
