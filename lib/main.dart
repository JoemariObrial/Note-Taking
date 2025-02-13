import 'package:flutter/material.dart';
import './home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/note.png',
                height: MediaQuery.of(context).size.height *
                    0.5, // Responsive height
                width:
                    MediaQuery.of(context).size.width * 0.5, // Responsive width
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sathya & Friends",
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 300, // Set a maximum width for the TextField
                  ),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              // Check if the text field is empty
              if (_usernameController.text.isEmpty) {
                // Show a message or handle the empty case
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter a username')),
                );
                return; // Exit the function if empty
              }
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Home(username: _usernameController.text),
                ),
              );
            },
            child: Text("Start"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.blue,
              padding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
            ),
          ),
        ],
      ),
    );
  }
}
