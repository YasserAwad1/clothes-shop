import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../widgets/my_textformfield.dart';

enum AuthMode { login, signUp }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth-screen';

  @override
  Widget build(BuildContext context) {
    Color gold = Theme.of(context).colorScheme.secondary;
    final deviceSize = MediaQuery.of(context).size;
    AuthMode _authMode = AuthMode.login;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    gold,
                    gold.withOpacity(0.2),
                    Colors.black,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.2, 0.5, 1],
                ),
              ),
            ),
            SingleChildScrollView(
              child: SizedBox(
                height: deviceSize.height,
                width: deviceSize.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      child: SizedBox(
                        width: double.infinity,
                        // height: deviceSize.height * ,
                        child: Text(
                          'welcome to the clothes shop!',
                          maxLines: 3,
                          softWrap: true,
                          style: TextStyle(fontFamily: 'PORKYS_', fontSize: 48),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(13),
                      child: AuthCard(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  var isLoading = false;
  var _authMode = AuthMode.login;
  var formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();

  final Map<String, String> _authData = {
    'userName': '',
    'Email': '',
    'password': '',
  };

  void switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  Future<void> _saveForm() async {
    final auth = Provider.of<Auth>(context, listen: false);
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      formKey.currentState!.save();
      try {
        if (_authMode == AuthMode.login) {
          //login user
          await auth.login(
            _authData['Email']!,
            _authData['password']!,
          );
        } else {
          //signup user
          await auth.signup(
            _authData['Email']!,
            _authData['password']!,
            _authData['userName']!,
          );
          await auth.storeUserName(_authData['userName']!).then((_) {
            _authData.clear();
          });
        }
      } catch (error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('something went wrong'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'okay',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      setState(() {
        isLoading = false;
      });
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color gold = Theme.of(context).colorScheme.secondary;
    final deviceHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: _authMode == AuthMode.login
          ? deviceHeight * 0.46
          : deviceHeight * 0.67,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: gold,
        elevation: 5,
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                _authMode == AuthMode.login
                    ? RichText(
                        text: TextSpan(
                            text: 'Login ',
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'PORKYS_',
                              fontSize: 17,
                            ),
                            children: [
                              TextSpan(
                                text: 'to your account',
                                style: TextStyle(
                                    color: gold, fontFamily: 'PORKYS_'),
                              ),
                            ]),
                      )
                    : RichText(
                        text: TextSpan(
                            text: 'create ',
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'PORKYS_',
                              fontSize: 17,
                            ),
                            children: [
                              TextSpan(
                                text: 'a new account',
                                style: TextStyle(
                                    color: gold, fontFamily: 'PORKYS_'),
                              ),
                            ]),
                      ),
                if (_authMode == AuthMode.signUp)
                  MyTextFormField(
                    context: context,
                    labelText: 'Username',
                    hintText: 'Enter your userName',
                    inputAction: TextInputAction.next,
                    myKeyboardType: TextInputType.text,
                    myOnSaved: (value) {
                      _authData['userName'] = value!.trim();
                    },
                    myValidator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a username';
                      } else if (value.length < 2) {
                        return 'Username must be atleast 3 characters long';
                      }
                      return null;
                    },
                    myController: null,
                    isTextObscure: false,
                  ),
                MyTextFormField(
                    context: context,
                    labelText: 'E-Mail',
                    hintText: 'Enter your Email',
                    inputAction: TextInputAction.next,
                    myKeyboardType: TextInputType.emailAddress,
                    myOnSaved: (value) {
                      _authData['Email'] = value!.trim();
                    },
                    myValidator: (value) {
                      if (value!.isEmpty) {
                        return 'please provide an Email';
                      } else if (!value.contains('@')) {
                        return 'please provide a valid Email';
                      }
                      return null;
                    },
                    myController: null,
                    isTextObscure: false),
                MyTextFormField(
                    context: context,
                    labelText: 'Password',
                    hintText: 'Enter your Password',
                    inputAction: _authMode == AuthMode.login
                        ? TextInputAction.done
                        : TextInputAction.next,
                    myKeyboardType: TextInputType.text,
                    myOnSaved: (value) {
                      _authData['password'] = value!.trim();
                    },
                    myValidator: (value) {
                      if (value!.isEmpty) {
                        return 'please provider a password';
                      } else if (value.length < 5) {
                        'password too short';
                      }
                      return null;
                    },
                    myController: passwordController,
                    isTextObscure: true),
                if (_authMode == AuthMode.signUp)
                  MyTextFormField(
                    context: context,
                    labelText: 'confirm Password',
                    hintText: 'confirm your password',
                    inputAction: TextInputAction.done,
                    myKeyboardType: TextInputType.text,
                    myOnSaved: null,
                    myValidator: (value) {
                      if (value!.trim() != passwordController.text) {
                        return 'passwords do not match!';
                      }
                      return null;
                    },
                    myController: null,
                    isTextObscure: true,
                  ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    !isLoading
                        ? ElevatedButton(
                            style: TextButton.styleFrom(
                                backgroundColor: gold,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            onPressed: _saveForm,
                            child: Text(
                              _authMode == AuthMode.login ? 'Login' : 'signup',
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        : CircularProgressIndicator(
                            color: gold,
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_authMode == AuthMode.login
                            ? 'Don\'t have an account ?'
                            : 'Have an account ?'),
                        TextButton(
                          onPressed: switchAuthMode,
                          child: Text(
                            _authMode == AuthMode.login
                                ? 'Signup instead'
                                : 'Login instead',
                            style: TextStyle(color: gold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
