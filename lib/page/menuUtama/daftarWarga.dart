import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aplikasiku/page/menuUtama/tambahPage.dart';

class DaftarWargaPage extends StatefulWidget {
  @override
  _DaftarWargaPageState createState() => _DaftarWargaPageState();
}

class _DaftarWargaPageState extends State<DaftarWargaPage> {
  List<Map<String, dynamic>> wargaList = [];

  // Fungsi untuk mengambil data dari Firestore
  void getWarga() async {
    try {
      // Ambil data dari Firestore
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('warga').get();

      setState(() {
        // Menyimpan data yang diambil ke dalam list
        wargaList = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'nama': doc['nama'],
            'status': doc['status'],
          };
        }).toList();
      });
    } catch (e) {
      print('Gagal mengambil data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getWarga(); // Ambil data saat halaman pertama kali ditampilkan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Warga')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tabel Header
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text('No',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 3,
                    child: Text('Nama',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 3,
                    child: Text('Status',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            Divider(),
            // Daftar warga
            Expanded(
              child: ListView.builder(
                itemCount: wargaList.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(flex: 1, child: Text('${index + 1}')),
                      Expanded(flex: 3, child: Text(wargaList[index]['nama'])),
                      Expanded(
                          flex: 3, child: Text(wargaList[index]['status'])),
                    ],
                  );
                },
              ),
            ),
            // Tombol untuk tambah warga di bawah kolom
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TambahWargaPage()),
                    );
                  },
                  child: Text("Tambah Warga"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
