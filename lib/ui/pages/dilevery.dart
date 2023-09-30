import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:kedai_1818/shared/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/api_endpoints.dart';
import 'login.dart';

class Dilevery extends StatefulWidget {
  String status;
  String total;
  Dilevery(this.status, this.total);

  @override
  State<Dilevery> createState() => _DileveryState();
}

class _DileveryState extends State<Dilevery> {
  Future transaksi(status, total) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? id = prefs.getString('id');
    var url = Uri.parse("$endpoints/api/transaksi");
    var header = {'Authorization': 'Bearer $token'};
    var body = {'id_user': id, 'status': status, 'total': total};
    try {
      final response = await http.post(url, headers: header, body: body);
      if (response.statusCode == 200) {
        print(response.body);
        final jsonData = jsonDecode(response.body);
        var qrCode = jsonData['qrcode'].split(",").last;
        Uint8List bytes = base64Decode(qrCode);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Sukses",
                  style: subTitleTextStyle,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Berhasil Melakukan Pembayaran",
                      style: titleTextStyle.copyWith(fontSize: 14),
                    ),
                    const SizedBox(
                        height: 200,
                        width: 200,
                        child: Icon(
                          Icons.check_circle,
                          size: 150,
                          color: Colors.green,
                        )),
                    Text(
                      "Tinggal Duduk Manis dan Tunggu Pesanan Anda",
                      style: titleTextStyle.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          height: 100,
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Pembayaran ",
                        style: titleTextStyle.copyWith(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("Rp. ${widget.total}",
                        style: titleTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: orangeColor)),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                        color: yellowColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Bayar Sekarang",
                            style: titleTextStyle.copyWith(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      transaksi(widget.status, widget.total);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text('Dilevery'),
          backgroundColor: yellowColor,
        ),
        body: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    "Pilih Alamat",
                    style: titleTextStyle.copyWith(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, top: 10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: grey1Color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.home,
                            color: Colors.white,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Alamat Rumah",
                            style: titleTextStyle.copyWith(fontSize: 16),
                          ),
                          Text(
                            "Jl. Cigasong No. 20, Cigasong",
                            style: titleTextStyle.copyWith(fontSize: 14),
                          ),
                          Text(
                            "Kec. Cigasong, Kab. Majalengka",
                            style: titleTextStyle.copyWith(
                                fontSize: 14, overflow: TextOverflow.fade),
                          ),
                        ],
                      ),
                      // radio button
                      const Spacer(),
                      Radio(
                        value: 1,
                        groupValue: 1,
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    "Pilih Pembayaran",
                    style: titleTextStyle.copyWith(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            // card bank mandiri
            Container(
              margin: const EdgeInsets.only(left: 10, top: 10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: grey1Color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.wallet,
                            color: whiteColor,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Virtual Akun Bank Mandiri",
                            style: titleTextStyle.copyWith(fontSize: 16),
                          ),
                          Text(
                            "86607085433",
                            style: titleTextStyle.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                      // radio button
                      const Spacer(),
                      Radio(
                        value: 1,
                        groupValue: 1,
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    "Cara Pembayaran",
                    style: titleTextStyle.copyWith(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            // cara pembayaran
            Container(
              margin: const EdgeInsets.only(left: 10, top: 10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Buka Aplikasi Mandiri",
                            style: titleTextStyle.copyWith(fontSize: 16),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "1. Pilih menu Virtual Akun,",
                            style: titleTextStyle.copyWith(fontSize: 14),
                          ),
                          Text(
                            "2. Masukan kode Virtual Akun diatas,",
                            style: titleTextStyle.copyWith(fontSize: 14),
                          ),
                          Text(
                            "3. Masukan jumlah  total pembayaran,",
                            style: titleTextStyle.copyWith(fontSize: 14),
                          ),
                          Text(
                            "4. Pilih Selesaikan Pembayaran.",
                            style: titleTextStyle.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
