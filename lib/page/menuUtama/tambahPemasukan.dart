import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InputPemasukanPage extends StatefulWidget {
  const InputPemasukanPage({super.key});

  @override
  State<InputPemasukanPage> createState() => _InputPemasukanPageState();
}

class _InputPemasukanPageState extends State<InputPemasukanPage> {
  String? _selectedWarga;
  String? _selectedPertemuan;

  bool _kasChecked = false;
  bool _uangSampahChecked = false;
  bool _uangKeamananChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Pemasukan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Pertemuan:",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _selectedPertemuan,
              isExpanded: true,
              hint: const Text("Pilih pertemuan"),
              items: ["Pertemuan 1", "Pertemuan 2", "Pertemuan 3"]
                  .map((pertemuan) {
                return DropdownMenuItem<String>(
                  value: pertemuan,
                  child: Text(pertemuan),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPertemuan = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Pilih Nama Warga:",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('warga').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text("Tidak ada data warga.");
                }

                final wargaList = snapshot.data!.docs;
                final uniqueWargaList = <String>{};
                for (var doc in wargaList) {
                  final nama = doc['nama'] as String;
                  uniqueWargaList.add(nama);
                }

                return DropdownButton<String>(
                  value: _selectedWarga,
                  isExpanded: true,
                  hint: const Text("Pilih nama warga"),
                  items: uniqueWargaList.map((nama) {
                    return DropdownMenuItem<String>(
                      value: nama,
                      child: Text(nama),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedWarga = value;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16.0),

            // Kas Checkbox
            CheckboxListTile(
              title: const Text("Kas (Rp 10.000)"),
              value: _kasChecked,
              onChanged: (bool? value) {
                setState(() {
                  _kasChecked = value!;
                });
              },
            ),

            // Sampah Checkbox
            CheckboxListTile(
              title: const Text("Uang Sampah (Rp 5.000)"),
              value: _uangSampahChecked,
              onChanged: (bool? value) {
                setState(() {
                  _uangSampahChecked = value!;
                });
              },
            ),

            // Keamanan Checkbox
            CheckboxListTile(
              title: const Text("Uang Keamanan (Rp 5.000)"),
              value: _uangKeamananChecked,
              onChanged: (bool? value) {
                setState(() {
                  _uangKeamananChecked = value!;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addIncome,
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }

  void _addIncome() {
    if (_selectedWarga == null ||
        _selectedPertemuan == null ||
        (!_kasChecked && !_uangSampahChecked && !_uangKeamananChecked)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap lengkapi semua data")),
      );
      return;
    }

    // Menyimpan data pemasukan dengan nominal tetap
    double kasAmount = _kasChecked ? 10000 : 0.0;
    double uangSampahAmount = _uangSampahChecked ? 5000 : 0.0;
    double uangKeamananAmount = _uangKeamananChecked ? 5000 : 0.0;

    // Konfirmasi penyimpanan data
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Apakah Anda yakin ingin menyimpan data ini?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Menutup dialog
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('laporan_keuangan').add({
                  'nama_warga': _selectedWarga,
                  'pertemuan': _selectedPertemuan,
                  'kas': kasAmount,
                  'uang_sampah': uangSampahAmount,
                  'uang_keamanan': uangKeamananAmount,
                  'tanggal': DateTime.now(),
                }).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Data berhasil disimpan")),
                  );
                  _resetForm();
                  Navigator.pop(context); // Menutup dialog konfirmasi
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Terjadi kesalahan saat menyimpan data")),
                  );
                  Navigator.pop(context); // Menutup dialog konfirmasi
                });
              },
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );
  }

  void _resetForm() {
    _kasChecked = false;
    _uangSampahChecked = false;
    _uangKeamananChecked = false;
    _selectedWarga = null;
    _selectedPertemuan = null;
  }
}
