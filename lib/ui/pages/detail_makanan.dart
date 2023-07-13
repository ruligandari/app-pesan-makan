import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kedai_1818/services/api_endpoints.dart';
import 'package:kedai_1818/shared/themes.dart';
import 'package:kedai_1818/ui/pages/keranjang.dart';
import 'package:kedai_1818/ui/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Detail extends StatefulWidget {
  String id;
  String nama_produk;
  Detail(this.id, this.nama_produk);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Map<String, dynamic> data = {};
  var kuantitas = 1;

  Future fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = Uri.parse("$endpoints/api/makanan/" + widget.id);
    var header = {'Authorization': 'Bearer $token'};
    try {
      final response = await http.get(url, headers: header);
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

  Future insertKeranjang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? id = prefs.getString('id');
    var url = Uri.parse("$endpoints/api/keranjang");
    var header = {'Authorization': 'Bearer $token'};
    try {
      final response = await http.post(url, headers: header, body: {
        "id_user": id,
        "id_makanan": widget.id,
        "kuantitas": kuantitas.toString(),
      });
      if (response.statusCode == 200) {
        print(response.body);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Berhasil Menambahkan Keranjang'),
              backgroundColor: Colors.green,
              action: SnackBarAction(
                textColor: Colors.white,
                label: 'Lihat Keranjang',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const Keranjang();
                  }));
                },
              )),
        );
      } else if (response.statusCode == 401) {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  void tambah() {
    setState(() {
      kuantitas++;
    });
  }

  void kurang() {
    setState(() {
      if (kuantitas > 1) {
        kuantitas--;
      }
    });
  }

  @override
  initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          height: 80,
          width: double.infinity,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  insertKeranjang();
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
                        "+ Tambah Keranjang",
                        style: titleTextStyle.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const Keranjang();
                  }));
                },
              )
            ],
            title: Text(
              widget.nama_produk,
              style: titleTextStyle,
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: (data.isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 88),
                child: ListView(
                  children: [
                    ClipRRect(
                      child: Image.network("$endpoints/foto/" + data['foto']),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  data['nama_produk'],
                                  style: titleTextStyle.copyWith(fontSize: 18),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 8, right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Rp. " + data['harga'],
                                  style: titleTextStyle.copyWith(
                                      fontSize: 18, color: Colors.red),
                                  textAlign: TextAlign.start,
                                ),
                                Container(
                                  width: 120,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: yellowColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(0),
                                          minimumSize: const Size(0, 0),
                                        ),
                                        onPressed: () {
                                          kurang();
                                        },
                                        child: const Icon(
                                          Icons.remove,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                      ),
                                      Text(kuantitas.toString(),
                                          style: titleTextStyle.copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.all(0),
                                          minimumSize: const Size(0, 0),
                                        ),
                                        onPressed: () {
                                          tambah();
                                        },
                                        child: const Icon(Icons.add,
                                            color: Colors.black, size: 20),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(left: 8),
                              child: Text(
                                "Stok Tersedia: " + data['stok'],
                                style: titleTextStyle.copyWith(fontSize: 14),
                                textAlign: TextAlign.start,
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            child: Text(
                              "Deskripsi",
                              style: titleTextStyle.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            child: Text(
                              data['deskripsi'],
                              style: titleTextStyle.copyWith(
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
