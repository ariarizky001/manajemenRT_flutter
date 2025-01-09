import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LaporanPengeluaranPage extends StatefulWidget {
  @override
  _LaporanPengeluaranPageState createState() => _LaporanPengeluaranPageState();
}

class _LaporanPengeluaranPageState extends State<LaporanPengeluaranPage> {
  double totalPengeluaran = 0;

  Future<void> simpanTotalPengeluaranKeKoleksiBaru(double total) async {
    await FirebaseFirestore.instance.collection('laporanTotalPengeluaran').add({
      'total_pengeluaran': total,
      'tanggal': DateTime.now(),
    });
  }

  Future<void> hapusPengeluaran(String id, double nominal) async {
    await FirebaseFirestore.instance.collection('laporan_pengeluaran').doc(id).delete();
    setState(() {
      totalPengeluaran -= nominal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Laporan Pengeluaran"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('laporan_pengeluaran')
              .orderBy('tanggal', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("Tidak ada laporan pengeluaran"));
            }

            var laporanData = snapshot.data!.docs;

            totalPengeluaran = laporanData.fold(0, (sum, item) {
              return sum + (item['nominal'] as num).toDouble();
            });

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: laporanData.length,
                    itemBuilder: (context, index) {
                      var data = laporanData[index];
                      var id = data.id;
                      var keterangan = data['keterangan'];
                      var nominal = (data['nominal'] as num).toDouble();
                      var tanggal = data['tanggal'].toDate();

                      String formattedDate =
                          '${tanggal.day}/${tanggal.month}/${tanggal.year}';

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(keterangan),
                          subtitle: Text("Tanggal: $formattedDate"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Rp $nominal"),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  hapusPengeluaran(id, nominal);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Pengeluaran:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rp ${totalPengeluaran.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      simpanTotalPengeluaranKeKoleksiBaru(totalPengeluaran);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Total pengeluaran telah disimpan')),
                      );
                    },
                    child: Text('Simpan Total Pengeluaran'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
