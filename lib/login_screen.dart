import 'package:flutter/material.dart';
import 'package:greenhouse/home_screen.dart';
import 'package:greenhouse/sign_up.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true; // Control the visibility of the password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String username = "username";
  final database = FirebaseDatabase.instance.ref().child("Users");
  String? errorMassage = '';
  Future<void> signInWithEmailAndPassword() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        errorMassage = "Email and password cannot be empty.";
      });
      return;
    }

    try {
      await Auth().signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(username: _emailController.text),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMassage = e.message;
      });
    }
  }

  Widget _leaf ()
  {
    return Image.asset(
      'assets/green_leaf.png',
      height: 150,
    );
  }
  
  Widget _logo()
  {
    return const Text(
      'Greenhouse',
      style: TextStyle(
        fontSize: 40,
        color: Colors.white,
      ),
    );

  }

  Widget _entry_field ()
  {
    return TextFormField(
      controller: _emailController,
      cursorColor: Colors.green,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF508D4E),
        labelText: 'Email',
        prefixIcon:
            const Icon(Icons.person, color: Colors.white),
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xFF80AF81),
          ),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }

  Widget _login_button ()
  {
    return ElevatedButton(
      onPressed: signInWithEmailAndPassword,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF80AF81),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
            horizontal: 80, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(
            color: Color(0xFF80AF81),
            width: 2,
          ),
        ),
      ),
      child: const Text(
        'Log In',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _create_account_button()
  {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const SignUp()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF80AF81),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
            horizontal: 80, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(
            color: Color(0xFF80AF81),
            width: 2,
          ),
        ),
      ),
      child: const Text(
        'Create New Account',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _error_massage() {
    return Text(
      errorMassage == '' ? '' : 'Error: $errorMassage',
      style: const TextStyle(color: Colors.red),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF80AF81), Color(0xFF508D4E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.5, 1.0],
          ),
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                _leaf(),
                const SizedBox(height: 20),
                _logo(),
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    children: [
                      _entry_field(),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        cursorColor: Colors.green,
                        obscureText:
                            _obscureText, // Use the state variable to control visibility
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF508D4E),
                          labelText: 'Password',
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.white),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.remove_red_eye
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText =
                                    !_obscureText; // Toggle password visibility
                              });
                            },
                          ),
                          labelStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Color(0xFF80AF81),
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _error_massage(),
                      SizedBox(
                        width: double.infinity,
                        child: 
                        _login_button(),
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: double.infinity,
                        child: 
                        _create_account_button(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
