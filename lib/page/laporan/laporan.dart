import 'package:aplikasiku/page/laporan/laporanPemasukan.dart';
import 'package:aplikasiku/page/laporan/laporanPengeluaran.dart';
import 'package:aplikasiku/page/laporan/saldoakhir.dart';
import 'package:flutter/material.dart';

class LaporanMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu Laporan"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul
            Text(
              "Laporan Keuangan",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Row untuk menampilkan menu secara horizontal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Menu Laporan Pemasukan
                FeatureButton(
                  icon: Icons.attach_money,
                  label: 'Laporan Pemasukan',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LaporanPemasukanPage(),
                      ),
                    );
                  },
                ),

                // Menu Laporan Pengeluaran
                FeatureButton(
                  icon: Icons.money_off,
                  label: 'Laporan Pengeluaran',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            LaporanPengeluaranPage(), // Ganti dengan halaman pengeluaran
                      ),
                    );
                  },
                ),

                // Menu Sub Total Akhir
                FeatureButton(
                  icon: Icons.account_balance_wallet,
                  label: 'Sub Total Akhir',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubTotalAkhirPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget untuk tombol menu fitur
class FeatureButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  FeatureButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100, // Menyesuaikan lebar tombol
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 40, color: const Color.fromARGB(255, 33, 150, 243)),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
