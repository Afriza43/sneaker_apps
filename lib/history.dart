import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_apps/helper/dbhistory.dart';
import 'package:sneaker_apps/models/HistoryModel.dart';
import 'package:sqflite/sqflite.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  HistoryDBHelper dbHelper = HistoryDBHelper();
  List<History> historyList = [];
  late String userName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getLoginData();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getLoginData() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    setState(() {
      userName = logindata.getString('username') ?? "";
    });
    getHistory();
  }

  Future<List<History>> getHistory() async {
    final Future<Database> dbHistoryFuture = dbHelper.initHistoryDb();
    dbHistoryFuture.then((historyDatabase) {
      final Future<List<History>> historyListFuture =
          dbHelper.getHistory(userName);
      historyListFuture.then((_historyList) {
        if (mounted) {
          setState(() {
            historyList = _historyList;
          });
        }
      });
    });
    return historyList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Purchase History',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : historyList.isEmpty
              ? _emptyHistory()
              : _historyItem(),
      backgroundColor: Colors.white,
    );
  }

  Widget _historyItem() {
    return SafeArea(
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder<List<History>>(
                future: getHistory(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  return ListView.builder(
                    itemCount: historyList.length,
                    itemBuilder: (context, index) {
                      History history = historyList[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 10),
                        child: Card(
                          color: Colors.white,
                          elevation: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black87.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                            child: ListTile(
                              tileColor: Colors.white,
                              dense: true,
                              contentPadding: EdgeInsets.all(10.0),
                              title: Container(
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Image.network(
                                          history.gambar,
                                          height: 110.0,
                                          fit: BoxFit.fill,
                                        ),
                                        SizedBox(width: 25.0),
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  history.nama,
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  'Rp ' +
                                                      NumberFormat.currency(
                                                              locale: 'ID',
                                                              symbol: "",
                                                              decimalDigits: 0)
                                                          .format(
                                                              history.subtotal)
                                                          .toString(),
                                                  style: GoogleFonts.montserrat(
                                                      color: Colors.black54,
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                      height: 30,
                                                      width: 100,
                                                      margin: EdgeInsets.only(
                                                          top: 10.0),
                                                      child: Text(
                                                        "Quantity : " +
                                                            history.quantity
                                                                .toString(),
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                color: Colors
                                                                    .black87,
                                                                fontSize: 14.0),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                          right: 10.0,
                                                          top: 5.0,
                                                        ),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: InkWell(
                                                            onTap: () {
                                                              _deleteHistory(
                                                                  history.id);
                                                            },
                                                            child: Container(
                                                              height: 25,
                                                              child: Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.grey,
                                                                size: 28,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  _formatDateTime(
                                                      history.purchaseTime),
                                                  style: GoogleFonts.montserrat(
                                                      color: Colors.teal,
                                                      fontSize: 14.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyHistory() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/no_history.json',
                    width: 330,
                    height: 280,
                  ),
                  Text(
                    'No History',
                    style: GoogleFonts.poppins(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(String dateTime) {
    DateTime parsedDateTime = DateTime.parse(dateTime);
    return "${parsedDateTime.day}-${parsedDateTime.month}-${parsedDateTime.year}";
  }

  _deleteHistory(int id) async {
    Database db = await dbHelper.historyDatabase;
    var batch = db.batch();
    db.execute('DELETE FROM riwayat_bayar WHERE id=?', [id]);
    await batch.commit();
  }
}
