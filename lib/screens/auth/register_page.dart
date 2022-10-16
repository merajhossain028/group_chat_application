import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tt_group_chat/screens/auth/login_page.dart';
import 'package:tt_group_chat/screens/home_page.dart';
import 'package:tt_group_chat/service/auth_service.dart';

import '../../helper/helper_function.dart';
import '../../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String fullName = '';
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Tecognize Training Group Chat',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Sign Up and Say Hi! to Your New Team Mates',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                              height: 250,
                              width: 250,
                              child: Image.asset('assets/images/register.jpg')),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            decoration: textInputDecoration.copyWith(
                                labelText: 'Full Name',
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.blue,
                                )),
                            onChanged: (val) {
                              setState(() {
                                fullName = val;
                              });
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            decoration: textInputDecoration.copyWith(
                                labelText: 'Email',
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Colors.blue,
                                )),
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : 'Please provide a valid email';
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.done,
                            obscureText: true,
                            decoration: textInputDecoration.copyWith(
                                labelText: 'Password',
                                prefixIcon: const Icon(
                                  Icons.password,
                                  color: Colors.blue,
                                )),
                            validator: (val) {
                              return val!.length > 6
                                  ? null
                                  : 'Please provide password 6+ characters';
                            },
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                register();
                              },
                              child: const Text('Sign Up')),
                          const SizedBox(
                            height: 20,
                          ),
                          Text.rich(
                            TextSpan(
                              text: 'Have an account? ',
                              children: [
                                TextSpan(
                                  text: 'Login Now',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      nextScreen(context, const LoginPage());
                                    },
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          //saving the shared preference state
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserNameSF(fullName);
          await HelperFunction.saveUserEmailSF(email);
          nextScreenReplace(context, const HomePage());

        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
