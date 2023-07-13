import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kedai_1818/shared/themes.dart';
import 'package:kedai_1818/ui/pages/detail_transaksi.dart';
import 'package:kedai_1818/ui/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import '../../services/api_endpoints.dart';

class Riwayat extends StatefulWidget {
  const Riwayat({Key? key}) : super(key: key);

  @override
  State<Riwayat> createState() => _RiwayatState();
}

class _RiwayatState extends State<Riwayat> {
  List<dynamic> data = [];

  Future fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? id = prefs.getString('id');
    var url = Uri.parse("$endpoints/api/transaksi/$id");
    print(url);
    var header = {'Authorization': 'Bearer $token'};
    try {
      final response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        print(response.body);
        final jsonData = jsonDecode(response.body);
        setState(() {
          data = jsonData;
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
  initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Riwayat Transaksi"),
          backgroundColor: yellowColor,
          elevation: 0,
        ),
        body: (data.isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                          shape: ShapeBorder.lerp(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              10),
                          child: ListTile(
                            title: Text(data[index]['nama_pembeli']),
                            subtitle: Text(data[index]['no_transaksi']),
                            trailing: Text(data[index]['status']),
                            onTap: (() {
                              Navigator.push(
                                  context,
                                  (MaterialPageRoute(builder: (context) {
                                    return DetailTransaksi(
                                      data[index]['no_order'],
                                      data[index]['qr_code'],
                                      data[index]['total_harga'],
                                    );
                                  })));
                            }),
                          ));
                    },
                    itemCount: data.length),
              )
            : const Center(child: Text("Tidak ada riwayat transaksi")));
  }
}
