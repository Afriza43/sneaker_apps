import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SaranKesan extends StatelessWidget {
  const SaranKesan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Text(
                "Saran",
                style: GoogleFonts.poppins(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Card(
                color: Colors.white,
                elevation: 3,
                child: ListTile(
                  title: Text(
                    "Karena matakuliah Pemrograman Aplikasi Mobile ini membutuhkan pemahaman yang lebih mendalam dan tergolong sulit (apalagi teori nya, haduh), Saran saya agar lebih banyak poin keaktifan, sesekali praktek selain materi di praktikum dan mohon dipermudah mahasiswa nya dalam mendapatkan nilai yang maksimal",
                    style: GoogleFonts.poppins(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "Kesan",
                style: GoogleFonts.poppins(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Card(
                color: Colors.white,
                elevation: 3,
                child: ListTile(
                  title: Text(
                    "Kelasnya tidak membosankan, tapi kadang bikin panik (contoh: ujian UAS di kelas kemarin). Seru tiap sesi presentasi, bisa lihat orang panik :D",
                    style: GoogleFonts.poppins(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
