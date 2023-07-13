import 'package:flutter/material.dart';
import 'package:kedai_1818/shared/themes.dart';

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
  TextEditingController noHp = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController konfirmasi = TextEditingController();
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
                        "Alamat",
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
                              hintText: 'Alamat',
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
                            controller: konfirmasi,
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
                            // controller: emailController,
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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const Daftar();
                          }));
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(grey1Color),
                            minimumSize: MaterialStateProperty.all(
                                const Size(double.infinity, 50))),
                        child: Text(
                          "Daftar",
                          style: titleTextStyleWhite,
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
