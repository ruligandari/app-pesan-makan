import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kedai_1818/ui/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../../services/api_endpoints.dart';
import '../../shared/themes.dart';

class DetailTransaksi extends StatefulWidget {
  String id;
  String qr;
  String total;
  String encode;
  DetailTransaksi(this.id, this.qr, this.total, this.encode);

  @override
  State<DetailTransaksi> createState() => _DetailTransaksiState();
}

class _DetailTransaksiState extends State<DetailTransaksi> {
  List<dynamic> data = [];

  Future fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = Uri.parse("$endpoints/api/order");
    var header = {'Authorization': 'Bearer $token'};
    try {
      final response = await http.post(url, headers: header, body: {
        "no_order": widget.id,
      });
      if (response.statusCode == 200) {
        print(response.body);
        final jsonData = jsonDecode(response.body);
        print(jsonData['data']);
        setState(() {
          data = jsonData['data'];
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

  // update status pesanan
  Future updatePesanan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = Uri.parse("$endpoints/api/transaksi/update");
    var header = {'Authorization': 'Bearer $token'};
    try {
      final response = await http.post(url, headers: header, body: {
        "no_transaksi": widget.encode,
      });
      if (response.statusCode == 200) {
        // ignore: prefer_const_constructors
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: const Text('Pesanan Berhasil Diterima'),
          backgroundColor: Colors.green,
        ));
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
  initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    String qrCode = widget.qr.split(",").last;
    Uint8List bytes = base64Decode(qrCode);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail Transaksi",
        ),
        elevation: 0,
        backgroundColor: yellowColor,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: (data.isNotEmpty)
            ? Column(
                children: [
                  Center(
                      child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 200, width: 200, child: Image.memory(bytes)),
                    ),
                  )),
                  // card menampilkan encode
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(widget.encode,
                              style: subTitleTextStyle.copyWith(fontSize: 15)),
                        ],
                      ),
                    ),
                  ),
                  // membuat expansion tile desain button
                  ExpansionTile(
                    title: Text("Detail Transaksi",
                        style: subTitleTextStyle.copyWith(fontSize: 15)),
                    trailing: Text("Lihat Detail",
                        style: subTitleTextStyle.copyWith(
                            fontSize: 15, color: Colors.blue)),
                    children: [
                      cardDetail(data: data, widget: widget),
                      const SizedBox(
                        height: 10,
                      ),
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
                                "Pesanan Diterima",
                                style: titleTextStyle.copyWith(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          updatePesanan();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      )),
    );
  }
}

class cardDetail extends StatelessWidget {
  const cardDetail({
    Key? key,
    required this.data,
    required this.widget,
  }) : super(key: key);

  final List data;
  final DetailTransaksi widget;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Produk", style: subTitleTextStyle.copyWith(fontSize: 15)),
                Text("Kuantitas",
                    style: subTitleTextStyle.copyWith(fontSize: 15)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      data[index]['nama_produk'],
                      style: subTitleTextStyle,
                    ),
                    subtitle: Text(
                      "Rp. " + data[index]['harga_produk'],
                      style: subTitleTextStyle,
                    ),
                    trailing: Text(
                      "x " + data[index]['kuantitas_produk'],
                      style: subTitleTextStyle,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Subtotal : ",
                    style: subTitleTextStyle.copyWith(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                Text(
                  "Rp. " + widget.total,
                  style: subTitleTextStyle.copyWith(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
