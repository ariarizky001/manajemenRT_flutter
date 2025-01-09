import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LaporanPemasukanPage extends StatefulWidget {
  const LaporanPemasukanPage({super.key});

  @override
  State<LaporanPemasukanPage> createState() => _LaporanPemasukanPageState();
}

class _LaporanPemasukanPageState extends State<LaporanPemasukanPage> {
  String? _selectedPertemuan;
  double kasTotal = 0.0;
  double sampahTotal = 0.0;
  double keamananTotal = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Pemasukan"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _resetTotals(); 
              });
            },
          ),
        ],
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
                  _resetTotals(); 
                });
              },
            ),
            const SizedBox(height: 16.0),
            
            if (_selectedPertemuan != null)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedPertemuan = null; 
                    _resetTotals();
                  });
                },
                child: const Text("Kembali ke Halaman Awal"),
              ),
            const SizedBox(height: 16.0),

           
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('laporan_subtotal')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Data belum tersedia."));
                }

                double totalKas = 0.0;
                double totalSampah = 0.0;
                double totalKeamanan = 0.0;

                // Sum totals from all meetings
                for (var doc in snapshot.data!.docs) {
                  totalKas += doc['kas_total'] ?? 0.0;
                  totalSampah += doc['sampah_total'] ?? 0.0;
                  totalKeamanan += doc['keamanan_total'] ?? 0.0;
                }

                return Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.blue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Saldo Akhir (Total Semua Pertemuan):",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Kas:",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            totalKas.toStringAsFixed(2),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Sampah:",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            totalSampah.toStringAsFixed(2),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Keamanan:",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            totalKeamanan.toStringAsFixed(2),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16.0),

            if (_selectedPertemuan != null)
              Expanded(
                child: SingleChildScrollView(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('laporan_keuangan')
                        .where('pertemuan', isEqualTo: _selectedPertemuan)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("Tidak ada data."));
                      }

                      final laporanList = snapshot.data!.docs;
                      _calculateTotals(laporanList); 
                      _saveSubtotalsToFirestore(); 

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          double tableWidth = constraints.maxWidth;

                          return Column(
                            children: [
                              // Table Header
                              DataTable(
                                columnSpacing: 12.0, 
                                columns: [
                                  DataColumn(label: Text('Nama', style: TextStyle(fontSize: 14))),
                                  DataColumn(
                                    label: Container(
                                      width: tableWidth * 0.2,
                                      child: const Text('Kas', style: TextStyle(fontSize: 14)),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Container(
                                      width: tableWidth * 0.2,
                                      child: const Text('Sampah', style: TextStyle(fontSize: 14)),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Container(
                                      width: tableWidth * 0.2,
                                      child: const Text('Keamanan', style: TextStyle(fontSize: 14)),
                                    ),
                                  ),
                                ],
                                rows: laporanList.map((doc) {
                                  bool isKasPaid = doc['kas'] == 10000;
                                  bool isSampahPaid = doc['uang_sampah'] == 5000;
                                  bool isKeamananPaid = doc['uang_keamanan'] == 5000;

                                  return DataRow(
                                    cells: [
                                      DataCell(Text(doc['nama_warga'], style: TextStyle(fontSize: 14))),
                                      DataCell(
                                        Checkbox(
                                          value: isKasPaid,
                                          onChanged: null, 
                                        ),
                                      ),
                                      DataCell(
                                        Checkbox(
                                          value: isSampahPaid,
                                          onChanged: null, 
                                        ),
                                      ),
                                      DataCell(
                                        Checkbox(
                                          value: isKeamananPaid,
                                          onChanged: null, 
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16.0),
                              // Subtotal Section
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Subtotal Kas:", style: TextStyle(fontSize: 14)),
                                  Text(kasTotal.toStringAsFixed(2), style: TextStyle(fontSize: 14)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Subtotal Sampah:", style: TextStyle(fontSize: 14)),
                                  Text(sampahTotal.toStringAsFixed(2), style: TextStyle(fontSize: 14)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Subtotal Keamanan:", style: TextStyle(fontSize: 14)),
                                  Text(keamananTotal.toStringAsFixed(2), style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // untuk memuat ulang
  void _resetTotals() {
    kasTotal = 0.0;
    sampahTotal = 0.0;
    keamananTotal = 0.0;
  }

  // funsi untuk menghitung sub total
  void _calculateTotals(List<QueryDocumentSnapshot> laporanList) {
    kasTotal = 0.0;
    sampahTotal = 0.0;
    keamananTotal = 0.0;

    for (var doc in laporanList) {
      kasTotal += doc['kas'] as double;
      sampahTotal += doc['uang_sampah'] as double;
      keamananTotal += doc['uang_keamanan'] as double;
    }
  }

  // Function to save the subtotals to Firestore
  Future<void> _saveSubtotalsToFirestore() async {
    if (_selectedPertemuan != null) {
      try {
    //  simpan sub total 
        await FirebaseFirestore.instance.collection('laporan_subtotal').doc(_selectedPertemuan).set({
          'kas_total': kasTotal,
          'sampah_total': sampahTotal,
          'keamanan_total': keamananTotal,
        });
        print("Subtotal successfully saved to Firestore.");
      } catch (e) {
        print("Error saving subtotal: $e");
      }
    }
  }
}
