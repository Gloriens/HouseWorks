import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:house/Homes.dart';

class Housework {
  String housework = '';
  String whoDidIt = '';
  int? id;
  Housework({required this.id, required this.housework, required this.whoDidIt});
}

class InteractiveTablePage extends StatefulWidget {
  final Homes home;
  const InteractiveTablePage({super.key, required this.home});

  @override
  _InteractiveTablePageState createState() => _InteractiveTablePageState();
}

class _InteractiveTablePageState extends State<InteractiveTablePage> {
  // list of houseworks for each day
  List<List<Housework>> houseworksByDay = List.generate(7, (index) => []);

  @override
  void initState() {
    super.initState();
    if (widget.home.id != null) {
      checkAndClearTableForNewWeek();
      fetchHouseworksForHome(widget.home.id);
    }
  }

  Future<void> checkAndClearTableForNewWeek() async {
    bool isNewWeek = await isNewWeekStarted();

    if (isNewWeek) {
      // clear the table
      clearTable();
    }
  }

  void clearTable() {
    setState(() {
      // clear the houseworksByDay list
      houseworksByDay = List.generate(7, (index) => []);
    });
  }

  Future<bool> isNewWeekStarted() async {
    final CollectionReference houseworksCollection =
    FirebaseFirestore.instance.collection('Houseworks');

    QuerySnapshot querySnapshot = await houseworksCollection
        .where('homeId', isEqualTo: widget.home.id)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DateTime lastEntryDate =
      DateTime.fromMillisecondsSinceEpoch(querySnapshot.docs.first['timestamp']);
      DateTime currentDate = DateTime.now();

      // check if the current date is after the last entry date (which means if a new week has started)
      return currentDate.isAfter(lastEntryDate);
    }

    // if there is no previous entries, consider it as a new week
    return true;
  }

  Future<void> fetchHouseworksForHome(int? id) async {
    final CollectionReference houseworksCollection =
    FirebaseFirestore.instance.collection('Houseworks');

    QuerySnapshot querySnapshot = await houseworksCollection
        .where('homeId', isEqualTo: widget.home.id)
        .get();

    if (houseworksByDay.isEmpty) {
      houseworksByDay = List.generate(7, (index) => []);
    }

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> houseworkData =
      documentSnapshot.data() as Map<String, dynamic>;

      Housework housework = Housework(
        housework: houseworkData['housework'] ?? '',
        whoDidIt: houseworkData['whoDidIt'] ?? '',
        id: null,
      );

      int dayIndex = houseworkData['day'] - 1; // subtract 1 to match the day indexing
      houseworksByDay[dayIndex].add(housework);
    }

    setState(() {});
  }

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
          // Save houseworks to Firebase
          saveHouseworksToFirebase();

          Navigator.pop(context);
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.blue,
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
    List<String> peopleList = widget.home.insanListesi;

    return Column(
      children: [
        ...houseworksByDay[dayIndex].asMap().entries.map((entry) {
          int index = entry.key;
          Housework housework = entry.value;

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
              DropdownButtonFormField<String>(
                value: housework.whoDidIt,
                onChanged: (newValue) {
                  setState(() {
                    housework.whoDidIt = newValue!;
                  });
                },
                items: peopleList.map((person) {
                  return DropdownMenuItem(
                    value: person,
                    child: Text(person),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Who did it?'),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    houseworksByDay[dayIndex].removeAt(index);
                  });
                },
                child: Text('- Remove Housework'),
              ),
              SizedBox(height: 8),
            ],
          );
        }).toList(),
        ElevatedButton(
          onPressed: () {
            setState(() {
              houseworksByDay[dayIndex].add(Housework(
                id: DateTime.now().millisecondsSinceEpoch,
                housework: '',
                whoDidIt: peopleList.isNotEmpty ? peopleList[0] : '',
              ));
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
          'homeId': widget.home.id,
          'day': dayIndex+1, // we add plus 1 to make it look like day 1 instead of day 0
          'housework': housework.housework,
          'whoDidIt': housework.whoDidIt,
        });
      }
    }
  }
}
