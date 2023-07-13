import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kedai_1818/services/api_endpoints.dart';
import 'package:kedai_1818/ui/pages/daftar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kedai_1818/ui/widgets/bottom_navigation.dart';
import '../../shared/themes.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    bool _isloading = false;

    Future login() async {
      setState(() {
        _isloading = true;
      });
      try {
        var url = Uri.parse('$endpoints/auth/login');
        Map<String, String> data = {
          'email': emailController.text,
          'password': passwordController.text
        };
        http.Response response = await http.post(url, body: data);
        if (response.statusCode == 200) {
          setState(() {
            _isloading = false;
          });
          Map<String, dynamic> result = jsonDecode(response.body);
          var token = result['token'];
          var idUser = result['data']['user_id'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token', token);
          prefs.setString('id', idUser);

          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const BottomNavigation();
          }));
        } else if (response.statusCode == 400) {
          setState(() {
            _isloading = false;
          });
          // tampilkan snackbar
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email atau password salah'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isloading = false;
        });
        print(e);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Login', style: titleTextStyle),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              child: Image.asset('assets/images/logo.png'),
            ),
            const SizedBox(
              height: 8,
            ),
            Center(
              child: Text(
                "Silahkan Login\n Untuk Melanjutkan!",
                style: titleTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: subTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 50,
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Email',
                              hintStyle: subTitleTextStyle.copyWith(
                                  color: grey2Color, fontSize: 12)),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Password",
                        style: subTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 50,
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Password',
                              hintStyle: subTitleTextStyle.copyWith(
                                  color: grey2Color, fontSize: 12)),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          _isloading ? null : await login();
                        },
                        // ignore: sort_child_properties_last
                        child: (_isloading == false)
                            ? Text(
                                "Login",
                                style: titleTextStyle,
                              )
                            : const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.grey,
                                ),
                              ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(yellowColor),
                            minimumSize: MaterialStateProperty.all(
                                Size(double.infinity, 50))),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const Daftar();
                          }));
                        },
                        child: Text(
                          "Daftar",
                          style: titleTextStyleWhite,
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(grey1Color),
                            minimumSize: MaterialStateProperty.all(
                                Size(double.infinity, 50))),
                      ),
                    ],
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
