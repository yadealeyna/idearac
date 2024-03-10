import 'package:flutter/material.dart';
import 'package:son/Drawer/aracEkle.dart';
import 'package:son/pdf/pdf.dart';
import 'package:son/pdf/qr.dart';
import 'package:mysql1/mysql1.dart';

import '../modules/loginPage.dart';
import '../models/data.dart';
import '../modules/signupPage.dart';
import 'kullaniciBilgileri.dart';

class drawerMenu extends StatefulWidget {
  const drawerMenu({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  State<drawerMenu> createState() => _drawerMenuState();
}

class _drawerMenuState extends State<drawerMenu> {
  bool _qrPdfMenuOpen = false;
  Mysql db = Mysql();

  Future<int> aracSayi() async{
    MySqlConnection conn = await db.getConnection();

    Results kulId = await conn.query("SELECT KULID FROM girisbilgisi WHERE USERN = ?", [widget.name]);
    print(kulId);

    Results res = await conn.query("SELECT count(PLAKA) FROM plakalar WHERE KULID = ?", [kulId.first['KULID']]);
    print(res);

    print(res.first['count(PLAKA)']);

    return res.first['count(PLAKA)'];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 206, 199, 191),
      child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color.fromARGB(255, 61, 115, 127)))),
                padding: EdgeInsets.only(left: 15, bottom: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.name, style: const TextStyle(fontSize: 24),),
                    Text("widget.plaka")
                  ]
                ),
              ),
              ListTile(
                title: const Text('QR PDF'),
                onTap: () async{
                  aracSayi();

                  var aracSayiData = await aracSayi();

                  for (int i = 0; i < aracSayiData; i++) {
                    
                  }
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QrImage(plaka: widget.plaka,)),
                  );
                  setState(() {
                    _qrPdfMenuOpen = !_qrPdfMenuOpen;
                  });*/
                }
              ),
              /*if (_qrPdfMenuOpen) ...[
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text("Araç"),
                        onTap: () {
                          // Burada yapılacak işlemler
                        },
                      ),
                    ],
                  ),
                ),
              ],*/
              









              
              ListTile(
                title: const Text('Hesap Bilgileri'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => KullaniciBilgileri(name: widget.name, plaka: "1a123",))
                  );
                }
              ),
              ListTile(
                title: const Text('Yeni Araba Ekle'),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AracEkle(kAdi: widget.name,))
                  );
                },
              ),
              ListTile(
                title: const Text('Çıkış'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginForm())
                  );
                  usern.clear();
                  pass.clear();

                  ePostaAdresi.clear();
                  adSoyad.clear();
                  password.clear();
                  passwordControl.clear();
                },
              ),
            ],
          ),
        )
    );
  }
}