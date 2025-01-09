import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubTotalAkhirPage extends StatelessWidget {
  Future<Map<String, double>> _ambilTotalPemasukanDanPengeluaran() async {
    double totalPemasukan = 0;
    double totalPengeluaran = 0;

    var pemasukanDoc = await FirebaseFirestore.instance.collection('laporanTotalPemasukan').doc('total').get();
    var pengeluaranDoc = await FirebaseFirestore.instance.collection('laporanTotalPengeluaran').doc('total_pengeluaran').get();

    if (pemasukanDoc.exists) {
      totalPemasukan = (pemasukanDoc['total_pemasukan'] as num).toDouble();
    }

    if (pengeluaranDoc.exists) {
      totalPengeluaran = (pengeluaranDoc['total_pengeluaran'] as num).toDouble();
    }

    return {'pemasukan': totalPemasukan, 'pengeluaran': totalPengeluaran};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sub Total Akhir"),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, double>>(
        future: _ambilTotalPemasukanDanPengeluaran(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("Tidak ada data pemasukan atau pengeluaran"));
          }

          double totalPemasukan = snapshot.data!['pemasukan']!;
          double totalPengeluaran = snapshot.data!['pengeluaran']!;
          double saldoTotalAkhir = totalPemasukan - totalPengeluaran;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total Pemasukan: Rp ${totalPemasukan.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Total Pengeluaran: Rp ${totalPengeluaran.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Saldo Total Akhir: Rp ${saldoTotalAkhir.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
