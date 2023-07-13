import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:kedai_1818/services/api_endpoints.dart';
import 'package:kedai_1818/shared/themes.dart';
import 'package:kedai_1818/ui/pages/keranjang.dart';
import 'package:kedai_1818/ui/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'detail_makanan.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> data = [];
  Map<String, dynamic> dataUser = {};

  TextEditingController cariController = TextEditingController();

  Future fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = Uri.parse("$endpoints/api/makanan");
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

  @override
  initState() {
    super.initState();
    fetchData();
    fetchDataUser();
  }

  @override
  Widget build(BuildContext context) {
    var nama = dataUser['nama'];
    return Scaffold(
        appBar: AppBar(
          title: Text(
            nama ?? "Selamat Datang !",
            style: titleTextStyle.copyWith(color: whiteColor),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const Keranjang();
                  }));
                },
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: whiteColor,
                  size: 30,
                ),
              ),
            ),
          ],
          backgroundColor: yellowColor,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    color: yellowColor),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                          ),
                          child: Text(
                            "Menu Pilihan Terbaik\nHanya Untukmu !",
                            style: titleTextStyle.copyWith(
                                color: whiteColor, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: whiteColor),
                        padding: const EdgeInsets.all(10),
                        child: TextField(
                          controller: cariController,
                          style: subTitleTextStyle.copyWith(fontSize: 14),
                          decoration: InputDecoration(
                            hintStyle: subTitleTextStyle.copyWith(
                              fontSize: 14,
                              color: grey2Color,
                            ),
                            hintText: 'Cari Makanan Kesukaanmu',
                            isCollapsed: true,
                            prefixIcon: Icon(
                              Icons.search,
                              size: 25,
                              color: grey2Color,
                            ),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.dashboard_customize_outlined,
                    color: grey1Color,
                    size: 25,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Menu",
                    style: subTitleTextStyle.copyWith(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            (data.isNotEmpty)
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // Jumlah kolom dalam grid
                                childAspectRatio: 1.0,
                                mainAxisExtent:
                                    280 // Rasio lebar-tinggi setiap item
                                ),
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Detail(data[index]['id'],
                                      data[index]['nama_produk']);
                                }));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "$endpoints/foto/${data[index]['foto']}"),
                                            fit: BoxFit.cover),
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10))),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data[index]['nama_produk'],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: subTitleTextStyle.copyWith(
                                              fontSize: 16),
                                        ),
                                        Text(
                                          "Rp. " + data[index]['harga'],
                                          style: subTitleTextStyle.copyWith(
                                              fontSize: 16, color: orangeColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                : const Center(child: CircularProgressIndicator()),
          ]),
        ));
  }
}
