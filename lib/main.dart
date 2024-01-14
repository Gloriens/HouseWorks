import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:house/Homes.dart';
import 'package:house/homes/home_cards_list.dart';
import 'package:house/after_add_home_screen.dart';
import 'package:house/interactive_table_page.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Homes> homesList = [];

  /*
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
   */

  Future<dynamic> RetrieveHome() async {
    final CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('Homes');

    QuerySnapshot querySnapshot =
    await usersCollection.get();

    // Her belgeyi gez ve veri eklemeyi gerçekleştir
    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      // Belge ID'sini al
      String documentId = documentSnapshot.id;

      // Belge içeriğini al
      Map<String, dynamic> existingData =
      documentSnapshot.data() as Map<String, dynamic>;

      print(existingData['evIsmi']);
      // print(existingData['HouseWork']);
      print(existingData['insanListesi']);

      // existingData['evIsmi'] = 'House of JC';

      // Belgeyi güncelle
      await usersCollection.doc(documentId).set(existingData);
    }
  }

  Future<void> fetchHomesFromFirebase() async {
    final CollectionReference homesCollection =
    FirebaseFirestore.instance.collection('Homes');

    QuerySnapshot querySnapshot = await homesCollection.get();

    homesList.clear();

    int currentId = 1;

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> homeData =
      documentSnapshot.data() as Map<String, dynamic>;

      List<String> peopleList =
      List<String>.from(homeData['insanListesi'] ?? []);

      Homes home = Homes(
        evIsmi: homeData['evIsmi'] ?? '',
        insanListesi: peopleList,
        id: currentId,
      );

      homesList.add(home);
      currentId++;
    }

    setState(() {});

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AfterAddHomeScreen(list: homesList),
      ),
    );
  }

  Future<void> addHomeToFirestore(Homes home) async {
    try {
      final CollectionReference homesCollection =
      FirebaseFirestore.instance.collection('Homes');

      // Add a new document to the 'Homes' collection
      await homesCollection.add({
        'evIsmi': home.evIsmi,
        'insanListesi': home.insanListesi,
      });

      print('A new home is added to Firestore successfully.');
    } catch (e) {
      print('Error adding home to Firestore: $e');
    }
  }

  Future<List<Housework>> fetchHouseworksForInteractiveTable(String homeId) async {
    final CollectionReference houseworksCollection =
    FirebaseFirestore.instance.collection('Houseworks');

    QuerySnapshot querySnapshot = await houseworksCollection
        .where('homeId', isEqualTo: homeId)
        .get();

    List<Housework> houseworks = [];

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> houseworkData =
      documentSnapshot.data() as Map<String, dynamic>;

      Housework housework = Housework(
        housework: houseworkData['housework'] ?? '',
        whoDidIt: houseworkData['whoDidIt'] ?? '',
        id: null,
      );

      houseworks.add(housework);
    }

    return houseworks;
  }

  Future<void> deleteHome(String homeId) async {
    final CollectionReference homesCollection =
    FirebaseFirestore.instance.collection('Homes');

    // Delete home from the database
    await homesCollection.doc(homeId).delete();

    // Remove home from the app (local list of homes)
    homesList.removeWhere((home) => home.id == homeId);

    // Update the state to trigger a rebuild
    setState(() {});
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    RetrieveHome();
    fetchHomesFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Color(0xFF8a2be2),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 180.0), // İstediğiniz miktarda yukarı çekmek için yukarı boşluk ekledik
          child: HomeCardsList(homesList: homesList),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddHomeScreen(
                    homes: [],
                  )
              )
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Sağ alt köşede görünecek
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomAppBar(
        height: 40.0,
        color: Color(0xFF8a2be2),
        shape: CircularNotchedRectangle(),
      ),
    );
  }

}

class AddHomeScreen extends StatefulWidget {
  final List<Homes> homes;
  AddHomeScreen({required this.homes});

  @override
  _AddHomeScreenState createState() => _AddHomeScreenState();
}

class _AddHomeScreenState extends State<AddHomeScreen> {
  TextEditingController homnametext = TextEditingController();
  TextEditingController peoplecounttext = TextEditingController();
  List<Widget> additionalTextFields = [];
  List<TextEditingController> personTextControllers = [];
  List<Homes> homes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Home'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Give a name to your home", textAlign: TextAlign.start),
            TextField(
              controller: homnametext,
              maxLength: 30,
            ),
            Text("Enter the total number of people you will do housework with, including yourself."),
            TextField(
              keyboardType: TextInputType.number,
              controller: peoplecounttext,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                int peopleCount = int.tryParse(peoplecounttext.text) ?? 0;
                personTextControllers = List.generate(peopleCount, (index) => TextEditingController());
                //personTextControllers diye texteditingcontroller dan oluşan bir list yarattık. Şimdi ise o liste
                //peoplecount kadar indexsine => texteditingController ekliyoruz

                List<Widget> newTextFields = List.generate(
                  peopleCount,
                      (index) => TextField(
                    decoration: InputDecoration(labelText: 'Person ${index + 1}'),
                    controller: personTextControllers[index],
                  ),
                );

                setState(() {
                  additionalTextFields = newTextFields;
                });
              },
              child: Text("OK"),
            ),
            ...additionalTextFields,

            ElevatedButton(onPressed: () async {
              int peopleCount = int.tryParse(peoplecounttext.text) ?? 0;
              List<String> people = [];
              for(int i =0;i<peopleCount;i++){
                people.add(personTextControllers[i].text);
              }

              String homname = homnametext.text;
              Homes newHome = Homes(evIsmi: homname, insanListesi: people);

              // add a new home to the database
              await _MyHomePageState().addHomeToFirestore(newHome);

              // fetch the updated home list from the database
              await _MyHomePageState().fetchHomesFromFirebase();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AfterAddHomeScreen(list: _MyHomePageState().homesList),
                ),
              );
            },
                child: Text("Print"))
          ],
        ),
      ),
    );
  }
}
