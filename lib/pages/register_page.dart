import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclops/components/my_button.dart';
import 'package:cyclops/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  // final VoidCallback showLoginPage;
  const RegisterPage({
    super.key,
    //  required this.showLoginPage
  });

  // Initial dropdown value
  static const String dropdownValue = 'Select Role';

  //List of dropdown values
  static const List<String> dropdownValues = <String>[
    'admin',
    'guard',
  ];

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _roleController = TextEditingController();
  final _phoneContactController = TextEditingController();
  final _officialIdController = TextEditingController();

  // Error text
  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _roleError;
  String? _phoneContactError;
  String? _officialIdError;

  // bool _loading = false;

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      // print('Passwords do not match');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match'),
          duration: Duration(seconds: 3),
        ),
      );

      return false;
    }
  }

  Future addUserDetails(
    String firstName,
    String lastName,
    String email,
    String role,
    String phoneContact,
    String officialId,
    String uid,
  ) async {
    final db = FirebaseFirestore.instance;
    final userRef = db.collection('users').doc();
    // add timestamp
    final createdAt = FieldValue.serverTimestamp();

    // final data payload
    final userData = {
      'userId': userRef.id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'phoneContact': phoneContact,
      'officialId': officialId,
      'createdAt': createdAt,
      'uid': uid,
    };

    try {
      await userRef.set(userData);
      print('---------User added to firestore------');

      // await FirebaseFunctions.instance.httpsCallable('setCustomClaims')({});
      // print('-----------------Custom claims set---------');
    } catch (e) {
      print(e);
    }
  }

  // Future signUp() async {
  //   // check if passwords match

  //   // print(_roleController.text.trim());

  //   // setState(() {
  //   //   _loading = true;
  //   // });
  //   //capture context
  //   // BuildContext currentContext = context;

  //   showDialog(
  //     context: context,
  //     builder: ((context) {
  //       return const Center(child: CircularProgressIndicator());
  //     }),
  //   );

  //   if (passwordConfirmed()) {
  //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: _emailController.text.trim(),
  //       password: _passwordController.text.trim(),
  //     );
  //   }
  //   try {
  //     // add user details to firestore
  //     // Obtain user details after user creation
  //     User? user = FirebaseAuth.instance.currentUser;
  //     String UserUid = user!.uid.toString().trim();
  //     print('User UID: $UserUid');
  //     // if (user != null)
  //       // Pass user.uid to addUserDetails
  //       await addUserDetails(
  //         _firstNameController.text.trim(),
  //         _lastNameController.text.trim(),
  //         _emailController.text.trim(),
  //         _roleController.text.trim(),
  //         _phoneContactController.text.trim(),
  //         _officialIdController.text.trim(),
  //         UserUid,
  //       );

  //   } on Exception catch (e) {
  //     // TODO
  //     print("Registration Error: $e");
  //   } finally {
  //     // ignore: use_build_context_synchronously
  //     Navigator.of(context).pop();
  //   }

  //   // setState(() {
  //   //   _loading = false;
  //   // });

  //   // if (context.mounted && _loading) Navigator.of(context).pop();

  //   // Builder(
  //   //   builder: (BuildContext context) {
  //   //     Navigator.of(context).pop();
  //   //     return Container();
  //   //   },
  //   // );
  // }
  Future signUp() async {
    // check if passwords match

    // print(_roleController.text.trim());

    // setState(() {
    //   _loading = true;
    // });
    //capture context
    // BuildContext currentContext = context;

    showDialog(
      context: context,
      builder: ((context) {
        return const Center(child: CircularProgressIndicator());
      }),
    );

    try {
      if (passwordConfirmed()) {
        if (_firstNameController.text.trim().isEmpty ||
            _lastNameController.text.trim().isEmpty ||
            _emailController.text.trim().isEmpty ||
            _passwordController.text.trim().isEmpty ||
            _confirmPasswordController.text.trim().isEmpty ||
            _roleController.text.trim().isEmpty ||
            _phoneContactController.text.trim().isEmpty ||
            _officialIdController.text.trim().isEmpty) {
          // Set error text for the corresponding fields
          setState(() {
            _firstNameController.text.isEmpty
                ? _firstNameError = 'First name is required'
                : _firstNameError = null;

            _lastNameController.text.isEmpty
                ? _lastNameError = 'Last name is required'
                : _lastNameError = null;

            _emailController.text.isEmpty
                ? _emailError = 'Email is required'
                : _emailError = null;

            _passwordController.text.isEmpty
                ? _passwordError = 'Password is required'
                : _passwordError = null;

            _confirmPasswordController.text.isEmpty
                ? _confirmPasswordError = 'Confirm password is required'
                : _confirmPasswordError = null;

            _roleController.text.isEmpty
                ? _roleError = 'Role is required'
                : _roleError = null;

            _phoneContactController.text.isEmpty
                ? _phoneContactError = 'Phone contact is required'
                : _phoneContactError = null;

            _officialIdController.text.isEmpty
                ? _officialIdError = 'Official ID is required'
                : _officialIdError = null;
          });
          print('Please fill in all fields');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              // backgroundColor: Colors.pink[400],
              content: Text('Please fill in all fields'),
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        // Create user with email and password
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Obtain user details after user creation
        User? user = FirebaseAuth.instance.currentUser;
        String UserUid = user!.uid.toString().trim();
        print('User UID: $UserUid');

        // Pass user.uid to addUserDetails
        await addUserDetails(
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          _emailController.text.trim(),
          _roleController.text.trim(),
          _phoneContactController.text.trim(),
          _officialIdController.text.trim(),
          UserUid,
        );

        // Reset the form fields
        _firstNameController.clear();
        _lastNameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _confirmPasswordController.clear();
        _roleController.clear();
        _phoneContactController.clear();
        _officialIdController.clear();

        // Show success message or navigate to another screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful!'),
            duration: Duration(seconds: 3),
          ),
        );

        // Navigate to another screen if needed
        // Navigator.of(context).pushReplacement('/admin');
        Navigator.pushNamed(context, '/admin');
      }
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuth exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: ${e.message}'),
          duration: Duration(seconds: 3),
        ),
      );
      print("FirebaseAuthException: ${e.message}");
    } on Exception catch (e) {
      // Handle other exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          duration: Duration(seconds: 3),
        ),
      );
      print("Registration Error: $e");
    } finally {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff1A73E8),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
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
                'Register your details below',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MyTextField(
                controller: _firstNameController,
                hintText: 'First Name',
                obscureText: false,
                errorText: _firstNameError,
              ),

              MyTextField(
                  controller: _lastNameController,
                  hintText: 'Last Name',
                  obscureText: false,
                  errorText: _lastNameError),
              MyTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  obscureText: false,
                  errorText: _emailError),
              MyTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  errorText: _passwordError),
              MyTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                  errorText: _confirmPasswordError),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownMenu(
                    controller: _roleController,
                    hintText: 'Role',
                    errorText: _roleError,
                    width: 300,
                    inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xFFFB38A3),
                        ),
                      ),
                    ),
                    dropdownMenuEntries: RegisterPage.dropdownValues.map(
                      (String value) {
                        return DropdownMenuEntry<String>(
                          label: value,
                          value: value,
                        );
                      },
                    ).toList()),
              ),
              MyTextField(
                  controller: _phoneContactController,
                  hintText: 'Phone Contact',
                  obscureText: false,
                  errorText: _phoneContactError),
              MyTextField(
                  controller: _officialIdController,
                  hintText: 'Official ID',
                  obscureText: false,
                  errorText: _officialIdError),
              SizedBox(height: 20),
              MyButton(
                onPressed: signUp,
                btnText: 'Register',
              ),
              SizedBox(height: 20),
              // GestureDetector(
              //   onTap: widget.showLoginPage,
              //   child: Text(
              //     'Login here',
              //     style: TextStyle(
              //         color: Color(0xFFFB38A3),
              //         fontSize: 18,
              //         fontWeight: FontWeight.bold),
              //   ),
              // ),
              SizedBox(height: 20),
            ]),
          ),
        ));
  }
}
