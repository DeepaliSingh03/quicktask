import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:quicktask/main.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              child: Image(image: AssetImage('images/home.png')),
            ),
            Center(
              child: const Text('User Registeration',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 40,
            ),
            TextField(
              controller: controllerUsername,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.none,
              autocorrect: false,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black)),
                  labelText: 'Username'),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: controllerEmail,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              autocorrect: false,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black)),
                  labelText: 'E-mail'),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: controllerPassword,
              obscureText: true,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.none,
              autocorrect: false,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black)),
                  labelText: 'Password'),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: const Text('Sign Up'),
                onPressed: () => doUserRegistration(),
              ),
            )
          ],
        ),
      ),
    ));
  }

  void showSuccess() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!"),
          content: const Text("User was successfully created!"),
          actions: <Widget>[
            new TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => MyApp()));
              },
            ),
          ],
        );
      },
    );
  }

  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(errorMessage),
          actions: <Widget>[
            new TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void doUserRegistration() async {
    final username = controllerUsername.text.trim();
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();

    final user = ParseUser.createUser(username, password, email);

    var response = await user.signUp();

    if (response.success) {
      showSuccess();
    } else {
      showError(response.error!.message);
    }
  }
}
