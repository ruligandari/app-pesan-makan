import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kedai_1818/services/api_endpoints.dart';
import 'package:kedai_1818/shared/themes.dart';
import 'package:kedai_1818/ui/pages/detail_keranjang.dart';
import 'package:kedai_1818/ui/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail_transaksi.dart';
import 'dilevery.dart';

class Keranjang extends StatefulWidget {
  const Keranjang({Key? key}) : super(key: key);

  @override
  State<Keranjang> createState() => _KeranjangState();
}

class _KeranjangState extends State<Keranjang> {
  List<dynamic> data = [];

  Future fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? id = prefs.getString('id');
    var url = Uri.parse("$endpoints/api/keranjang/$id");
    var header = {'Authorization': 'Bearer $token'};
    try {
      final response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        print(response.body);
        final jsonData = jsonDecode(response.body);

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

  Future deleteItem(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = Uri.parse("$endpoints/api/keranjang/$id");
    var header = {'Authorization': 'Bearer $token'};
    try {
      final response = await http.delete(url, headers: header);
      if (response.statusCode == 200) {
        print(response.body);

        return true;
      }
    } catch (e) {
      print(e);
    }
  }

  void checkout(total) {
    // menampilkan alert
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Pilih Metode Pembayaran",
            style: subTitleTextStyle,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                child: ListTile(
                    leading: const Icon(Icons.house),
                    title: Text(
                      "Dilevery",
                      style: titleTextStyle.copyWith(fontSize: 14),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Dilevery('1', total);
                      }));
                    }),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.storefront),
                  title: Text(
                    "Dine In",
                    style: titleTextStyle.copyWith(fontSize: 14),
                  ),
                  onTap: () {
                    transaksi("2", total);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.storefront),
                  title: Text(
                    "Take Away",
                    style: titleTextStyle.copyWith(fontSize: 14),
                  ),
                  onTap: () {
                    transaksi("3", total);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
        var idTransaksi = jsonData['no_order'];
        var encode = jsonData['encode'];
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
                      "Berhasil Melakukan Transaksi, Pesanan akan segera diproses",
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
                  ],
                ),
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
                            style: titleTextStyle.copyWith(fontSize: 14),
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
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const Login();
        }));
      }
    } catch (e) {
      print(e);
    }
  }

  void detail(id, nama_produk, kuantitas, id_keranjang) {
    Navigator.push(
        context,
        (MaterialPageRoute(
            builder: (context) =>
                DetailKeranjang(id, nama_produk, kuantitas, id_keranjang))));
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
    var total = 0;
    for (var i = 0; i < data.length; i++) {
      var harga = data[i]['harga'];
      var kuantitas = data[i]['kuantitas'];
      total += int.parse(harga) * int.parse(kuantitas);
    }
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
                margin: const EdgeInsets.only(left: 10),
                child: Text("Total : Rp. ${formatUang(total)}",
                    style: titleTextStyle.copyWith(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      checkout(total.toString());
                    },
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
                            "Checkout",
                            style: titleTextStyle.copyWith(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(
            "Keranjang",
            style: titleTextStyle.copyWith(color: whiteColor),
          ),
          backgroundColor: yellowColor,
          elevation: 0,
        ),
        body: (data.isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          onTap: () {
                            detail(
                                data[index]['id'],
                                data[index]['nama_produk'],
                                data[index]['kuantitas'],
                                data[index]['id_keranjang']);
                          },
                          leading: Image.network(
                              "$endpoints/foto/${data[index]['foto']}"),
                          title: Text(
                            data[index]['nama_produk'],
                            style: subTitleTextStyle.copyWith(fontSize: 15),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "x " + data[index]['kuantitas'],
                                style: subTitleTextStyle.copyWith(fontSize: 13),
                              ),
                              Text(
                                  "Rp. " +
                                      formatUang(
                                          int.parse(data[index]['harga'])),
                                  style: subTitleTextStyle.copyWith(
                                      fontSize: 13, color: orangeColor)),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              deleteItem(data[index]['id_keranjang'])
                                  .then((value) {
                                // menampilkan snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.green,
                                        content: Text("Berhasil dihapus")));
                                return Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const Keranjang();
                                }));
                              });
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      );
                    },
                    itemCount: data.length),
              )
            : Center(
                child: Text("Belum ada keranjang"),
              ));
  }
}
