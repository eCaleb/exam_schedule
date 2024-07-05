import 'package:exam_schedule/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forgot_password.dart'; // Ensure the correct import path

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String? _role;
  String? _errorMessage;

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text;

      if (_role == 'student' && !email.startsWith('student')) {
        setState(() {
          _errorMessage = 'Choose the right role or email';
        });
        return;
      } else if (_role == 'faculty' && !email.startsWith('faculty')) {
        setState(() {
          _errorMessage = 'Choose the right role or email';
        });
        return;
      } else if (_role == 'admin' && !email.startsWith('admin')) {
        setState(() {
          _errorMessage = 'Choose the right role or email';
        });
        return;
      }

      try {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: _passwordController.text,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(role: _role!),
          ),
        );
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background image in the upper half
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/image.jpg'), // Add your background image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 470,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top:11.0),
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 27,color: const Color.fromARGB(255, 19, 23, 133),fontWeight: FontWeight.w900),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        DropdownButtonFormField(
                          value: _role,
                          onChanged: (value) => setState(() => _role = value as String?),
                          items: [
                            const DropdownMenuItem(child: Text('Admin'), value: 'admin'),
                            const DropdownMenuItem(child: Text('Faculty'), value: 'faculty'),
                            const DropdownMenuItem(child: Text('Student'), value: 'student'),
                          ],
                          decoration: const InputDecoration(labelText: 'Role'),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a role';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 19, 23, 133),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 140),
                          ),
                          onPressed: _login,
                          child: const Text('Login'),
                        ),
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.blue, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
