import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:kedai_1818/shared/themes.dart';
import 'package:kedai_1818/ui/pages/detail_transaksi.dart';
import 'package:kedai_1818/ui/pages/riwayat.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/api_endpoints.dart';
import '../widgets/bottom_navigation.dart';
import 'login.dart';

class Dilevery extends StatefulWidget {
  final status;
  final total;
  Dilevery(this.status, this.total);

  @override
  State<Dilevery> createState() => _DileveryState();
}

class _DileveryState extends State<Dilevery> {
  Map<String, dynamic> data = {};
  String ongkir = "";
  String hasilBayar = "";
  String hargaOngkir = "";
  String totalPesanan = "";
  String alamat = "";
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
        var encode = jsonData['encode'];
        var idTransaksi = jsonData['no_order'];
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
                    const SizedBox(
                      height: 10,
                    ),
                    // tampilkan saldo
                    Text(
                      "Saldo Anda Saat Ini",
                      style: titleTextStyle.copyWith(fontSize: 14),
                    ),
                    Text(
                      "Rp. ${jsonData['saldo'] ?? "0"}",
                      style: titleTextStyle.copyWith(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                // tambahkan tombol oke direct ke home
                actions: [
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
                            "Lihat Transaksi",
                            style: titleTextStyle.copyWith(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: ((context) {
                          return DetailTransaksi(
                              idTransaksi, qrCode, total, encode);
                        })),
                      );
                    },
                  )
                ],
              );
            });
      } else if (response.statusCode == 401) {
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: ((context) {
          return const Login();
        })), (route) => false);
      }
    } catch (e) {
      print(e);
    }
  }

  Future fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? id = prefs.getString('id');
    var url = Uri.parse("$endpoints/api/bank/$id");
    var header = {'Authorization': 'Bearer $token'};
    try {
      final response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        print(response.body);
        final jsonData = jsonDecode(response.body);

        setState(() {
          data = jsonData['data'];
          ongkir = jsonData['ongkir'];
          alamat = jsonData['alamat'];

          int totalBayar = int.parse(widget.total) + int.parse(ongkir);
          hasilBayar = formatUang(totalBayar);
          hargaOngkir = formatUang(int.parse(ongkir));
          totalPesanan = formatUang(int.parse(widget.total));
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

  String formatUang(int nilai) {
    final f = NumberFormat("#,###", "id_ID");

    return f.format(nilai);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          height: 160,
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Pesanan ",
                            style: titleTextStyle.copyWith(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("Rp. $totalPesanan",
                            style: titleTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: orangeColor)),
                      ],
                    ),
                    // buat garis horizontal
                    const Divider(
                      height: 10,
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Ongkir ",
                            style: titleTextStyle.copyWith(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("Rp. $hargaOngkir",
                            style: titleTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: orangeColor)),
                      ],
                    ),
                    // buat garis horizontal
                    const Divider(
                      height: 10,
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Pembayaran ",
                            style: titleTextStyle.copyWith(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("Rp. ${hasilBayar}",
                            style: titleTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: orangeColor)),
                      ],
                    ),
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
                      transaksi(widget.status, hasilBayar);
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
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Alamat Rumah",
                              style: titleTextStyle.copyWith(fontSize: 16),
                            ),
                            Text(
                              alamat,
                              style: titleTextStyle.copyWith(fontSize: 14),
                              softWrap: true,
                            ),
                          ],
                        ),
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
                            "Rek: ${data['no_rekening'] ?? "-"}",
                            style: titleTextStyle.copyWith(fontSize: 16),
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
                    "Catatan",
                    style: titleTextStyle.copyWith(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    "Saat ini kami hanya melayani pengiriman untuk 3 Kecamatan (Cigasong, Majalengka, Jatiwangi)\n\nTarif Ongkos Kirim:\nCigasong : Rp. 10.000\nMajalengka : Rp. 12.000\nJatiwangi : Rp. 15.000",
                    style: subTitleTextStyle.copyWith(fontSize: 12),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
