import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CatatPengeluaranPage extends StatefulWidget {
  @override
  _CatatPengeluaranPageState createState() => _CatatPengeluaranPageState();
}

class _CatatPengeluaranPageState extends State<CatatPengeluaranPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _keteranganController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();

  Future<void> _simpanPengeluaran() async {
    if (_formKey.currentState!.validate()) {
      // Data yang akan disimpan ke Firestore
      final pengeluaranData = {
        'keterangan': _keteranganController.text,
        'nominal': int.parse(_nominalController.text),
        'tanggal': Timestamp.now(),
      };

      try {
        // Simpan data ke Firestore
        await FirebaseFirestore.instance
            .collection('laporan_pengeluaran')
            .add(pengeluaranData);

        // Tampilkan notifikasi sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pengeluaran berhasil disimpan!')),
        );

        // Bersihkan form setelah berhasil disimpan
        _keteranganController.clear();
        _nominalController.clear();
      } catch (e) {
        // Tampilkan notifikasi jika ada error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan pengeluaran: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catat Pengeluaran'),
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input Keterangan
              TextFormField(
                controller: _keteranganController,
                decoration: InputDecoration(
                  labelText: 'Keterangan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Keterangan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Input Nominal
              TextFormField(
                controller: _nominalController,
                decoration: InputDecoration(
                  labelText: 'Nominal',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nominal tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Nominal harus berupa angka';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpanPengeluaran,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 33, 150, 243),
                  ),
                  child: Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
