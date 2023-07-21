import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:http/http.dart' as http;
import 'package:kedai_1818/services/api_endpoints.dart';
import 'package:kedai_1818/shared/themes.dart';
import 'package:kedai_1818/ui/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  size(double value) => MediaQuery.of(context).size.width * value / 100;

  Map<String, dynamic> dataUser = {};

  Future fetchDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? id = prefs.getString('id');
    var url = Uri.parse("$endpoints/api/user/$id");
    var header = {'Authorization': 'Bearer $token'};
    try {
      final response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        print(response.body);
        final jsonData = jsonDecode(response.body);

        setState(() {
          dataUser = jsonData['data'];
        });
      } else if (response.statusCode == 401) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const Login();
        }));
      }
    } catch (e) {
      print(e);
    }
  }

  Future logout() async {
    // membuat alert dialog
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Konfirmasi",
              style: titleTextStyle,
            ),
            content: Text(
              "Apakah anda yakin ingin keluar?",
              style: subTitleTextStyle,
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('token');
                    prefs.remove('id');

                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return const Login();
                    }));
                  },
                  child: const Text("Ya")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Tidak")),
            ],
          );
        });
  }

  @override
  initState() {
    super.initState();
    fetchDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile",
            style: titleTextStyleWhite,
          ),
          backgroundColor: yellowColor,
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              height: 130,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: yellowColor),
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: whiteColor, width: 2),
                          color: whiteColor),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 60,
                        height: 60,
                      )),
                  Text(dataUser['nama'] ?? " ", style: titleTextStyleWhite),
                  Text(
                    dataUser['no_hp'] ?? " ",
                    style: subTitleTextStyle.copyWith(color: whiteColor),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  "Edit Profile",
                  style: subTitleTextStyle,
                ),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: Icon(Icons.local_shipping),
                title: Text(
                  "Alamat",
                  style: subTitleTextStyle,
                ),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  "Logout",
                  style: subTitleTextStyle,
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  logout();
                },
              ),
            )
          ],
        ));
  }
}
