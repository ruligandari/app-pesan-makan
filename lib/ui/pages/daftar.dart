import 'package:flutter/material.dart';
import 'package:kedai_1818/shared/themes.dart';
import 'package:kedai_1818/services/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:kedai_1818/ui/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Daftar extends StatefulWidget {
  const Daftar({Key? key}) : super(key: key);

  @override
  State<Daftar> createState() => _DaftarState();
}

class _DaftarState extends State<Daftar> {
  size(double value) => MediaQuery.of(context).size.width * value / 100;
  TextEditingController namaLengkap = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController kecamatan = TextEditingController();
  TextEditingController kabupaten = TextEditingController();
  TextEditingController noHp = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController konfirmasi = TextEditingController();

  bool isLoading = false;
  Future register() async {
    setState(() {
      isLoading = true;
    });
    try {
      var url = Uri.parse('$endpoints/auth/register');
      Map<String, String> data = {
        'nama': namaLengkap.text,
        'email': email.text,
        'password': password.text,
        'confirm_password': konfirmasi.text,
        'alamat': alamat.text,
        'kecamatan': kecamatan.text,
        'kabupaten': kabupaten.text,
        'no_telp': noHp.text,
      };
      http.Response response = await http.post(url, body: data);
      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(response.body);
        print(result);
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              behavior: SnackBarBehavior.floating,
              content: const Text('Berhasil Mendaftar, Silahkan Login'),
              backgroundColor: Colors.green,
              action: SnackBarAction(
                textColor: Colors.white,
                label: 'Login Sekarang',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const Login();
                  }));
                },
              )),
        );
      } else if (response.statusCode == 400) {
        // tampilkan snackbar
        setState(() {
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data Tidak Lengkap'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registrasi Akun',
          style: titleTextStyle,
        ),
        foregroundColor: grey1Color,
        backgroundColor: whiteColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              width: 110,
              height: 110,
              child: Image.asset('assets/images/logo.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Silahkan Isi Data Diri Anda\n Untuk Melanjutkan!",
                            style: subTitleTextStyle.copyWith(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Nama Lengkap",
                        style: subTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 50,
                        child: TextField(
                            controller: namaLengkap,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Nama Lengkap',
                              hintStyle: subTitleTextStyle.copyWith(
                                  fontSize: 12, color: grey2Color),
                            )),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
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
                            controller: email,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Email',
                              hintStyle: subTitleTextStyle.copyWith(
                                  fontSize: 12, color: grey2Color),
                            )),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Kabupaten/Kota",
                        style: subTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 50,
                        child: TextField(
                            controller: kabupaten,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Majalengka',
                              hintStyle: subTitleTextStyle.copyWith(
                                  fontSize: 12, color: grey2Color),
                            )),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Kecamatan",
                        style: subTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 50,
                        child: TextField(
                            controller: kecamatan,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Cigasong',
                              hintStyle: subTitleTextStyle.copyWith(
                                  fontSize: 12, color: grey2Color),
                            )),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Alamat Lengkap",
                        style: subTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 50,
                        child: TextField(
                            controller: alamat,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Jl. Kebagusan no 50',
                              hintStyle: subTitleTextStyle.copyWith(
                                  fontSize: 12, color: grey2Color),
                            )),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "No. HP",
                        style: subTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 50,
                        child: TextField(
                            controller: noHp,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'No. HP',
                              hintStyle: subTitleTextStyle.copyWith(
                                  fontSize: 12, color: grey2Color),
                            )),
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
                            controller: password,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Password',
                              hintStyle: subTitleTextStyle.copyWith(
                                  fontSize: 12, color: grey2Color),
                            )),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        "Konfirmasi Password",
                        style: subTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 50,
                        child: TextField(
                            controller: konfirmasi,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: 'Konfirmasi Password',
                              hintStyle: subTitleTextStyle.copyWith(
                                  fontSize: 12, color: grey2Color),
                            )),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          register();
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(grey1Color),
                            minimumSize: MaterialStateProperty.all(
                                const Size(double.infinity, 50))),
                        child: (isLoading == false)
                            ? Text(
                                "Daftar",
                                style: titleTextStyleWhite,
                              )
                            : SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  color: grey1Color,
                                ),
                              ),
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
