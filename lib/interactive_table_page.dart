import 'package:flutter/material.dart';
import 'package:house/Homes.dart';

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
        // Table rows for housework input
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
        // Add necessary logic for handling housework input
        ...houseworksByDay[dayIndex].map((housework) {
          return Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Housework'),
                controller: TextEditingController(text: housework.housework),
                onChanged: (value) {
                  // Update the housework value in the list
                  housework.housework = value;
                },
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(labelText: 'Who did it?'),
                controller: TextEditingController(text: housework.whoDidIt),
                onChanged: (value) {
                  // Update the whoDidIt value in the list
                  housework.whoDidIt = value;
                },
              ),
              SizedBox(height: 8),
            ],
          );
        }).toList(),
        // Button to add more houseworks for the day
        ElevatedButton(
          onPressed: () {
            // Add a new empty housework section to the list
            setState(() {
              houseworksByDay[dayIndex].add(Housework());
            });
          },
          child: Text('+ Add Housework'),
        ),
      ],
    );
  }
}

class Housework {
  String housework = '';
  String whoDidIt = '';
}
