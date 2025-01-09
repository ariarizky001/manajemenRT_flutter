import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  Future<User?> _getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> _logout(BuildContext context) async {
    bool confirmLogout = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Logout'),
        content: Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Batal
            child: Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Konfirmasi
            child: Text('Ya'),
          ),
        ],
      ),
    );

    if (confirmLogout == true) {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Pengguna'),
        backgroundColor: const Color.fromARGB(255, 33, 150, 243),
      ),
      body: FutureBuilder<User?>(
        future: _getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          final user = snapshot.data;
          final email = user?.email ?? 'Email tidak tersedia';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              // Memusatkan semua konten di tengah
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Vertikal di tengah
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Horizontal di tengah
                children: [
                  // Logo Profil
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Email
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                      height: 20), // Menambahkan jarak sebelum tombol logout

                  // Tombol Logout
                  ElevatedButton.icon(
                    onPressed: () => _logout(context),
                    icon: Icon(Icons.exit_to_app),
                    label: Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      iconColor: Colors.red, // Warna tombol
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
