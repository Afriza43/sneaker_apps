import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_apps/helper/dbhelper.dart';
import 'package:sneaker_apps/helper/dbhistory.dart';
import 'package:sneaker_apps/models/Cart_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class CheckoutPage extends StatefulWidget {
  final List<Cart> cartItems;

  const CheckoutPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  HistoryDBHelper dbHelper = HistoryDBHelper();
  late String userName = "";

  @override
  void initState() {
    super.initState();
    getLoginData();
  }

  void getLoginData() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      userName = logindata.getString('username') ?? "";
    });
  }

  saveHistory(String nama, int subtotal, String gambar, int quantity,
      String purchaseTime, String userName) async {
    Database db = await dbHelper.historyDatabase;
    var batch = db.batch();
    db.execute(
      'INSERT INTO riwayat_bayar (nama, subtotal, gambar, quantity, purchaseTime, userName) VALUES (?, ?, ?, ?, ?, ?)',
      [nama, subtotal, gambar, quantity, purchaseTime, userName],
    );
    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 10,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Change text color to black
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  var item = widget.cartItems[index];
                  return Card(
                    color: Colors.white,
                    elevation: 3,
                    child: ListTile(
                      tileColor: Colors.white,
                      dense: true,
                      contentPadding: EdgeInsets.all(20.0),
                      title: Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Image.network(
                              item.gambar,
                              height: 110.0,
                              fit: BoxFit.fill,
                            ),
                            SizedBox(width: 25.0),
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      item.nama,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      'Rp. ' +
                                          NumberFormat.currency(
                                            locale: 'ID',
                                            symbol: "",
                                            decimalDigits: 0,
                                          ).format(int.parse(item.harga) *
                                              item.jumlah),
                                      style: GoogleFonts.montserrat(
                                        color: Colors.black54,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          height: 30,
                                          width: 100,
                                          margin: EdgeInsets.only(top: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Text(
                                                "Quantity : " +
                                                    item.jumlah.toString(),
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.black87,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
                "Total Amount : " +
                    NumberFormat.currency(
                            locale: 'ID', symbol: "Rp", decimalDigits: 0)
                        .format(calculateTotal())
                        .toString(),
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    color: Colors.black87,
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black87, // Change button color to black
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(
                onPressed: () async {
                  for (var item in widget.cartItems) {
                    await saveHistory(
                        item.nama,
                        int.parse(item.harga) * item.jumlah,
                        item.gambar,
                        item.jumlah,
                        DateTime.now().toLocal().toString(),
                        item.userName);
                  }
                  await clearCart();

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Purchase Successful',
                          style: GoogleFonts.poppins(color: Colors.black),
                        ),
                        content: Text(
                          'Thank you for your purchase!',
                          style: GoogleFonts.poppins(color: Colors.black),
                        ),
                        backgroundColor: Colors.white,
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.popUntil(
                                context,
                                (route) => route.isFirst,
                              );
                            },
                            child: Text(
                              'OK',
                              style: GoogleFonts.poppins(color: Colors.black),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  'Complete Purchase',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Back to Cart',
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int calculateTotal() {
    int total = 0;
    for (var item in widget.cartItems) {
      total += int.parse(item.harga) * item.jumlah;
    }
    return total;
  }

  Future<void> clearCart() async {
    DBHelper dbHelper = DBHelper();
    Database db = await dbHelper.database;
    var batch = db.batch();
    for (var item in widget.cartItems) {
      batch.delete('sneaker',
          where: 'id = ? AND userName = ?',
          whereArgs: [item.id, item.userName]);
    }
    await batch.commit();
  }
}
