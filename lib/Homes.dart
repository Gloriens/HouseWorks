import 'package:flutter/material.dart';
import 'package:house/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: (){

            },
                child:
                Text('Create Home'),
            ),
            ElevatedButton(onPressed: (){
              
            },
                child: Text(
                  'MyHomes'
                ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateHome extends StatefulWidget {
  const CreateHome({super.key});

  @override
  State<CreateHome> createState() => _CreateHomeState();
}

class _CreateHomeState extends State<CreateHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Color(0xFF8a2be2),
      ),
      floatingActionButton: Container(
        width: 65,
        height: 65,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => MyHomePage(title: ('Home Page')),
              ),
            );
          },
          backgroundColor: Color(0xFF8a2be2),
          elevation: 0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF8a2be2),
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ),
    );
  }
}

class MyHomes extends StatefulWidget {
  const MyHomes({super.key});

  @override
  State<MyHomes> createState() => _MyHomesState();
}

class _MyHomesState extends State<MyHomes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );

  }
}


