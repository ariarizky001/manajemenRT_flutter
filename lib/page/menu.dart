import 'package:aplikasiku/page/menuUtama/daftarWarga.dart';
import 'package:aplikasiku/page/laporan/laporan.dart';
import 'package:aplikasiku/page/menuUtama/pengeluaran.dart';
import 'package:aplikasiku/page/menuUtama/profil.dart';
import 'package:aplikasiku/page/menuUtama/tambahPemasukan.dart';
import 'package:flutter/material.dart';
import 'package:aplikasiku/page/menuUtama/tambahPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Tambahkan import untuk halaman baru jika diperlukan
class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
        title: Text(
          "Manajemen Kas Rt",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian Selamat Datang
              Text(
                "Hi, Admin",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "Selamat Datang ",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 20),

              // Kotak Pencarian
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search ...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Grid Tombol Fitur
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  // Tombol Tambah Warga
                  FeatureButton(
                    icon: Icons.person_add,
                    label: 'Tambah Warga',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TambahWargaPage()),
                      );
                    },
                  ),

                  // Tombol Daftar Warga
                  FeatureButton(
                    icon: Icons.list,
                    label: 'Daftar Warga',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DaftarWargaPage()),
                      );
                    },
                  ),

                  // Tombol Catat Pemasukan
                  FeatureButton(
                    icon: Icons.attach_money,
                    label: 'Catat Pemasukan',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InputPemasukanPage()),
                      );
                    },
                  ),
                  // Tombol Catat Pengeluaran
                  FeatureButton(
                    icon: Icons.money_off,
                    label: 'Catat Pengeluaran',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CatatPengeluaranPage()),
                      );
                    },
                  ),

                  // Tombol Laporan Keuangan
                  FeatureButton(
                    icon: Icons.account_balance_wallet,
                    label: 'Laporan Keuangan',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LaporanMenuPage()),
                      );
                    },
                  ),

                  // Tombol Profil
                  FeatureButton(
                    icon: Icons.person,
                    label: 'Profil',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilPage()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 33, 150, 243),
        onPressed: () async {
          // Tampilkan dialog konfirmasi sebelum logout
          bool confirmLogout = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Konfirmasi Logout'),
              content: Text('Apakah Anda yakin ingin keluar?'),
              actions: [
                // Tombol Ya untuk logout
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Mengembalikan nilai true
                  },
                  child: Text('Ya'),
                ),
                // Tombol Tidak untuk batal
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Mengembalikan nilai false
                  },
                  child: Text('Tidak'),
                ),
              ],
            ),
          );

          // Jika pengguna memilih Ya, lakukan logout
          if (confirmLogout == true) {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        child: Icon(Icons.exit_to_app),
        tooltip: 'Logout',
      ),
    );
  }
}

// Widget untuk tombol fitur
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
        padding: EdgeInsets.all(20),
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
                size: 50, color: const Color.fromARGB(255, 33, 150, 243)),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
