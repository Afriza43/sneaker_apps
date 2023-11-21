import 'dart:convert';

List<Sneaker> sneakerFromJson(String str) =>
    List<Sneaker>.from(json.decode(str).map((x) => Sneaker.fromJson(x)));

String sneakerToJson(List<Sneaker> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Sneaker {
  String id;
  String nama;
  String harga;
  String gambar;
  String tipe;
  String deskripsi;

  Sneaker({
    required this.id,
    required this.nama,
    required this.harga,
    required this.gambar,
    required this.tipe,
    required this.deskripsi,
  });

  factory Sneaker.fromJson(Map<String, dynamic> json) => Sneaker(
        id: json["id"],
        nama: json["nama"],
        harga: json["harga"],
        gambar: json["gambar"],
        tipe: json["tipe"],
        deskripsi: json["deskripsi"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "harga": harga,
        "gambar": gambar,
        "tipe": tipe,
        "deskripsi": deskripsi,
      };
}
