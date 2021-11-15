import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:passkeeper/services/auth.dart';
import 'package:passkeeper/shared/constants.dart';
import 'package:passkeeper/shared/loading.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.toggleView}) : super(key: key);
  final Function toggleView;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  var controlEmail = TextEditingController();
  var controlPassword = TextEditingController();
  bool loading = false;
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Constants.lightGrey,
            body: Column(
              children: [
                SizedBox(height: 100),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: controlEmail,
                          decoration: Constants.textInputDecoration.copyWith(
                            hintText: 'email',
                            suffixIcon: email.isNotEmpty
                                ? IconButton(
                                    onPressed: () => setState(() {
                                      controlEmail.clear();
                                      email = '';
                                    }),
                                    icon: Icon(Icons.close, color: Colors.grey),
                                  )
                                : null,
                          ),
                          validator: (val) => val!.isEmpty ? 'Enter email' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: controlPassword,
                          decoration: Constants.textInputDecoration.copyWith(
                            hintText: 'password',
                            suffixIcon: password.isNotEmpty
                                ? IconButton(
                                    onPressed: () => setState(() {
                                      controlPassword.clear();
                                      password = '';
                                    }),
                                    icon: Icon(Icons.close, color: Colors.grey),
                                  )
                                : null,
                          ),
                          validator: (val) => val!.isEmpty ? 'Enter password' : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        SizedBox(height: 30),
                        TextButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.black87),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Constants.cornRad),
                              ),
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = false);
                              Constants.withGoogle = true;
                              dynamic result = await _auth.signIn(email, password);
                              if (result == null) {
                                setState(() {
                                  error = "Couldn't sign in with those credentials";
                                  loading = false;
                                });
                              }
                            }
                          },
                        ),
                        SizedBox(height: 12),
                        Text(error, style: TextStyle(color: Colors.red, fontSize: 14)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextButton.icon(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Constants.cornRad),
                      ),
                    ),
                  ),
                  label: Text(
                    'Sign in with Google',
                    style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'default'),
                  ),
                  icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
                  onPressed: () async {
                    await _auth.signInWithGoogle();
                    Constants.withGoogle = true;
                  },
                ),
                SizedBox(height: 60),
                Text("Don't have an account yet?", style: TextStyle(fontSize: 17)),
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 20)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.black87, width: 2),
                      ),
                    ),
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.black87, fontSize: 19, fontStyle: FontStyle.italic),
                  ),
                  onPressed: () => widget.toggleView(),
                ),
              ],
            ),
          );
  }
}
