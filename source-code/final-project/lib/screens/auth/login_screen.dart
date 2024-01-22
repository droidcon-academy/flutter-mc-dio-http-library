import "package:flutter/material.dart";
import "./register_screen.dart";
import "../social/social_app.dart";
import "../../services/auth_api.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.all(20.0),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'images/droidcon_logo.png',
                    height: 80.0,
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    'Welcome to Droidio',
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800]),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'The social platform that matters',
                    style: TextStyle(fontSize: 18.0, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    controller: emailController,
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    style: const TextStyle(color: Colors.black),
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    controller: passwordController,
                  ),
                  const SizedBox(height: 20.0),
                   isLoading
                      ? const SizedBox(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                    onPressed: () async {
                      if (emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Both fields are required'),
                          ),
                        );
                        return;
                      }
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        await AuthApi().login(
                            emailController.text, passwordController.text);
                        if (context.mounted) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const SocialApp()));
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("$e"),
                              backgroundColor: Colors.red));
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const RegisterScreen()));
                    },
                    child: const Text(
                      'Don\'t have an account? Register',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
