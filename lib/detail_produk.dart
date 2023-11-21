import 'package:sneaker_apps/helper/dbhelper.dart';
import 'package:sneaker_apps/models/Cart_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sneaker_apps/models/SneakerModel.dart';
import 'package:sqflite/sqflite.dart';

class DetailSneakers extends StatefulWidget {
  final Sneaker sepatu;
  const DetailSneakers({Key? key, required this.sepatu}) : super(key: key);

  @override
  State<DetailSneakers> createState() => _DetailSneakersState();
}

class _DetailSneakersState extends State<DetailSneakers> {
  int quantity = 1;
  String selectedCurrency = 'IDR';
  double exchangeRate = 1.0;
  late double _harga;

  DBHelper dbHelper = DBHelper();

  Future<bool> saveOrUpdateCart(Cart cartItem) async {
    try {
      Database db = await dbHelper.database;

      List<Map<String, dynamic>> result = await db.query(
        'sneaker',
        where: 'id = ?',
        whereArgs: [cartItem.id],
      );

      if (result.isNotEmpty) {
        // If the item is in the cart, update the quantity
        await db.update(
          'sneaker',
          {'jumlah': cartItem.jumlah},
          where: 'id = ?',
          whereArgs: [cartItem.id],
        );
      } else {
        // If the item is not in the cart, insert a new record
        await db.insert(
          'sneaker',
          {
            'id': cartItem.id,
            'nama': cartItem.nama,
            'harga': cartItem.harga,
            'gambar': cartItem.gambar,
            'tipe': cartItem.tipe,
            'deskripsi': cartItem.deskripsi,
            'jumlah': cartItem.jumlah,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      return true; // Success
    } catch (e) {
      print('Error saving/updating cart: $e');
      return false; // Failure
    }
  }

  @override
  Widget build(BuildContext context) {
    _harga = double.parse(widget.sepatu.harga);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product Detail",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                    child: Image.network(
                      widget.sepatu.gambar,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Product Name
              Text(
                widget.sepatu.nama,
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              // Product Type

              Row(
                children: [
                  Icon(
                    Icons.tag,
                    color: Colors.black,
                    size: 20,
                  ),
                  Text(
                    '${widget.sepatu.tipe}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),

              Text(
                widget.sepatu.deskripsi,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.money),
                      SizedBox(width: 8),
                      Text(
                        selectedCurrency == 'IDR'
                            ? NumberFormat.currency(
                                    locale: 'ID',
                                    symbol: "Rp ",
                                    decimalDigits: 0)
                                .format(_harga)
                                .toString()
                            : selectedCurrency == 'USD'
                                ? NumberFormat.currency(
                                        locale: 'en_US',
                                        symbol: "\u0024",
                                        decimalDigits: 0)
                                    .format(_harga * 0.000064)
                                    .toString()
                                : selectedCurrency == 'GBP'
                                    ? NumberFormat.currency(
                                            locale: 'en_US',
                                            symbol: "€",
                                            decimalDigits: 0)
                                        .format(_harga * 0.000052)
                                        .toString()
                                    : "",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: selectedCurrency,
                      focusColor: Colors.white,
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      items: ['IDR', 'USD', 'GBP']
                          .map((currency) => DropdownMenuItem<String>(
                                value: currency,
                                child: Text(
                                  currency,
                                  style: GoogleFonts.poppins(),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCurrency = value!;
                          if (selectedCurrency == 'USD') {
                            exchangeRate = 15.658;
                          } else if (selectedCurrency == 'GBP') {
                            exchangeRate = 19.255;
                          } else {
                            exchangeRate = 1.0;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (quantity > 1) {
                          quantity--;
                        }
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      quantity.toString(),
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        quantity++;
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  Cart cartItem = Cart(
                    id: widget.sepatu.id,
                    nama: widget.sepatu.nama,
                    harga: widget.sepatu.harga,
                    gambar: widget.sepatu.gambar,
                    tipe: widget.sepatu.tipe,
                    deskripsi: widget.sepatu.deskripsi,
                    jumlah: quantity,
                  );

                  // Save or update cart based on item existence
                  bool success = await saveOrUpdateCart(cartItem);

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Item added/updated in cart successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to add/update item in cart'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_shopping_cart,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Add to Cart',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
