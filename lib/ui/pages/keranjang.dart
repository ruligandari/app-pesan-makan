import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kedai_1818/services/api_endpoints.dart';
import 'package:kedai_1818/shared/themes.dart';
import 'package:kedai_1818/ui/pages/detail_keranjang.dart';
import 'package:kedai_1818/ui/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void checkout() {
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
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.storefront),
                  title: Text(
                    "Dine In",
                    style: titleTextStyle.copyWith(fontSize: 14),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.storefront),
                  title: Text(
                    "Take Away",
                    style: titleTextStyle.copyWith(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void detail(id, nama_produk, kuantitas, id_keranjang) {
    Navigator.push(
        context,
        (MaterialPageRoute(
            builder: (context) =>
                DetailKeranjang(id, nama_produk, kuantitas, id_keranjang))));
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
                child: Text("Total : Rp. $total",
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
                      checkout();
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
                              Text("Rp. " + data[index]['harga'],
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
