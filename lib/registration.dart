import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _key = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  late FirebaseAuth _auth;
  bool isObscure = true;
  bool _isValid = true;

  @override
  Widget build(BuildContext context) {
    _auth = FirebaseAuth.instance;

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(30),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Регистрация",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              Padding(
                padding: EdgeInsets.only(left: 100, right: 100, top: 15),
                child: TextFormField(
                  controller: _loginController,
                  validator: (value) {
                    if (!_isValid) {
                      return null;
                    }
                    if (value!.isEmpty) {
                      return 'Поле логин пустое';
                    }
                    if (value.length < 2) {
                      return 'Логин должен содержать не менее 2 символов';
                    }

                    return null;
                  },
                  maxLength: 16,
                  decoration: const InputDecoration(
                    labelText: 'Логин',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 100, right: 100, top: 15),
                child: TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (!_isValid) {
                      return null;
                    }
                    if (value!.isEmpty) {
                      return 'Поле пароль пустое';
                    }
                    if (value.length < 2) {
                      return 'Пароль должен содержать не менее 2 символов';
                    }
                    return null;
                  },
                  maxLength: 10,
                  decoration: const InputDecoration(
                    labelText: 'Пароль',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 350, right: 350, top: 50),
                  child: Container(
                    width: 50,
                    child: ElevatedButton(
                      child: Text("Зарегистрироваться"),
                      onPressed: () => {
                        _isValid = true,
                        if (_key.currentState!.validate()) {register()}
                      },
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(left: 350, right: 350, top: 50),
                  child: ElevatedButton(
                    child: Text("Авторизация"),
                    onPressed: () => {
                      _loginController.clear(),
                      _passwordController.clear(),
                      _isValid = false,
                      _key.currentState!.validate(),
                      Navigator.pushNamed(context, 'auth'),
                    },
                  ))
            ],
          ),
        ),
      )),
    );
  }

  register() async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: _loginController.text, password: _passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Успешная регистрация"),
        ),
      );
      Navigator.pushNamed(context, 'auth');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Пароль слишком слабый"),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
