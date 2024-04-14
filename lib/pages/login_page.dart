// import 'package:cyclops/components/my_button.dart';
// import 'package:cyclops/components/my_textfield.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class LoginPage extends StatefulWidget {
//   final VoidCallback showRegisterPage;

//   const LoginPage({super.key, required this.showRegisterPage});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   //controllers
//   final _emailController = TextEditingController();

//   final _passwordController = TextEditingController();


//   Future signUserIn() async {
//   // BuildContext currContext = context;
//     showDialog(
//       context: context,
//       builder: ((context) {
//         return const Center(child: CircularProgressIndicator());
//       }),
//     );

//     try {
//     await FirebaseAuth.instance.signInWithEmailAndPassword(
//       email: _emailController.text.trim(),
//       password: _passwordController.text.trim(),
//     );
    
    

//     print(_emailController.text);
//     print(_passwordController.text);
//   } catch (e) {
//     // Handle the authentication error
//     print("Authentication error: $e");
//   } finally {
//    // ignore: use_build_context_synchronously
//     Navigator.of(context).pop();
//   }
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Color(0xff1A73E8),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(children: [
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(100),
//                 ),
//                 margin: EdgeInsets.only(top: 100),
//                 child: Center(
//                   child: ClipOval(
//                     child: Image.asset(
//                       'assets/images/splash_logo.png',
//                       width: 200,
//                       height: 200,
//                     ),
//                   ),

                  
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               const Text(
//                 'Welcome to\n Checkpoint',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 'Login to continue',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               MyTextField(
//                   controller: _emailController,
//                   hintText: 'Email',
//                   obscureText: false),
//               MyTextField(
//                   controller: _passwordController,
//                   hintText: 'Password',
//                   obscureText: true),
//               SizedBox(height: 20),
//               MyButton(
//                 onPressed: signUserIn,
//                 btnText: 'Login',
//               ),
//               SizedBox(height: 20),
//               GestureDetector(
//                 onTap: widget.showRegisterPage,
//                 child: Text(
//                   'Register here',
//                   style: TextStyle(
//                       color: Color(0xFFFB38A3),
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ]),
//           ),
//         ));
//   }
// }

import 'package:cyclops/components/my_button.dart';
import 'package:cyclops/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  // final VoidCallback showRegisterPage;

  const LoginPage({super.key,
  //  required this.showRegisterPage
   });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // error messages
  String? _emailError;
  String? _passwordError;
    // variable to track widget's mounted status
  bool _mounted = false;

   @override
  void initState() {
    super.initState();
    // Set _mounted to true when the widget is mounted
    _mounted = true;
  }

  Future signUserIn() async {
    showDialog(
      context: context,
      builder: ((context) {
        return const Center(child: CircularProgressIndicator());
      }),
    );

    try {
// check if email or password is empty
      if (_emailController.text.trim().isEmpty ) {
        setState(() {
          _emailError = 'Please enter your email';

        });
        return;
      } else {
        setState(() {
          _emailError = null;
        });
      } 

      // check if password is empty
      if (_passwordController.text.trim().isEmpty) {
        setState(() {
          _passwordError = 'Please enter your password';
        });
        return;
      } else {
        setState(() {
          _passwordError = null;
        });
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Successfully signed in
      print('User signed in: ${FirebaseAuth.instance.currentUser?.email}');
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuth exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: ${e.message}'),
          duration: Duration(seconds: 3),
        ),
      );
      print("FirebaseAuthException: ${e.message}");
    } catch (e) {
      // Handle other exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          duration: Duration(seconds: 3),
        ),
      );
      print("Login Error: $e");
    } finally {
     // Check if the widget is still mounted before calling pop
      if (_mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _mounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1A73E8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
                margin: EdgeInsets.only(top: 100),
                child: Center(
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/splash_logo.png',
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Welcome to\n Checkpoint',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Login to continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MyTextField(
                controller: _emailController,
                hintText: 'Email',
                obscureText: false,
                errorText: _emailError,
              ),
              MyTextField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: true,
                errorText: _passwordError,
              ),
              SizedBox(height: 20),
              MyButton(
                onPressed: signUserIn,
                btnText: 'Login',
              ),
              SizedBox(height: 20),
              // GestureDetector(
              //   onTap: widget.showRegisterPage,
              //   child: Text(
              //     'Register here',
              //     style: TextStyle(
              //       color: Color(0xFFFB38A3),
              //       fontSize: 18,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
