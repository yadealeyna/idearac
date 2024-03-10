import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/data.dart';
import 'loginPage.dart';
import '../models/plakalar.dart';

TextEditingController ePostaAdresi = TextEditingController();
TextEditingController plaka = TextEditingController();
TextEditingController adSoyad = TextEditingController();
TextEditingController kAdi = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController passwordControl = TextEditingController();


class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool _obscureText = true;
  bool _obscureText2 = true;

  var db = Mysql();

  void signup() async{
    MySqlConnection conn = await db.getConnection();
    
    Results res = await conn.query('INSERT INTO girisbilgisi (EMAIL, NAME, USERN, PASS, TIME) VALUES(?,?,?,?,?)', [ePostaAdresi.text, adSoyad.text, kAdi.text, password.text, DateTime.now().toUtc()]);
    Results kulId = await conn.query('SELECT * FROM girisbilgisi where USERN = ?', [kAdi.text]);
    for(var row in kulId){
      plakaEkle(plaka.text, row[0]);
      //Results plate = await conn.query('INSERT INTO plakalar (PLAKA, KULID, GIRIS, SON) VALUES(?,?,?,?)', [plaka.text, row[0], DateTime.now().toUtc(), DateTime.now().toUtc()]);

      Results kullanici = await conn.query("INSERT INTO kullanicibilgi (USERN, ADSOY, KULID) VALUES(?,?,?)", [row[3], row[2], row[0]]);
    }
    
    plakalar.add(plaka.text);

    Fluttertoast.showToast(
      msg: 'Tebrikler Kaydınız Başarılı',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    conn.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 22, 27),
      body: SingleChildScrollView(
        child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 25.0),
            height: 100.0,
            child: Image.asset('assets/images/idekodMainLogo.png'),
          ),
          Container(
            margin: const EdgeInsets.all(25.0),
            child: TextField(
              controller: plaka,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 61, 115, 127))
                ),
                border: UnderlineInputBorder(),
                hintText: "Plaka",
                hintStyle: TextStyle(color: Color.fromARGB(255, 206, 199, 191)),
              ),
              cursorColor: const Color.fromARGB(255, 61, 115, 127),
              style: const TextStyle(color: Color.fromARGB(255, 206, 199, 191)),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(25.0),
            child: TextField(
              controller: ePostaAdresi,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 61, 115, 127))
                ),
                border: UnderlineInputBorder(),
                hintText: "E-Posta Adresi",
                hintStyle: TextStyle(color: Color.fromARGB(255, 206, 199, 191)),
              ),
              cursorColor: const Color.fromARGB(255, 61, 115, 127),
              style: const TextStyle(color: Color.fromARGB(255, 206, 199, 191)),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(25.0),
            child: TextField(
              controller: adSoyad,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 61, 115, 127))
                ),
                border: UnderlineInputBorder(),
                hintText: "Ad Soyad",
                hintStyle: TextStyle(color: Color.fromARGB(255, 206, 199, 191)),
              ),
              cursorColor: const Color.fromARGB(255, 61, 115, 127),
              style: const TextStyle(color: Color.fromARGB(255, 206, 199, 191)),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(25.0),
            child: TextField(
              controller: kAdi,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 61, 115, 127))
                ),
                border: UnderlineInputBorder(),
                hintText: "Kullanıcı Adı",
                hintStyle: TextStyle(color: Color.fromARGB(255, 206, 199, 191)),
              ),
              cursorColor: const Color.fromARGB(255, 61, 115, 127),
              style: const TextStyle(color: Color.fromARGB(255, 206, 199, 191)),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(25.0),
            child: TextField(
              controller: password,
              obscureText: _obscureText,
              decoration:  InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 61, 115, 127))
                ),
                border: UnderlineInputBorder(),
                hintText: "Şifre",
                hintStyle: TextStyle(color: Color.fromARGB(255, 206, 199, 191)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
              cursorColor: const Color.fromARGB(255, 61, 115, 127),
              style: const TextStyle(color: Color.fromARGB(255, 206, 199, 191)),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(25.0),
            child: TextField(
              controller: passwordControl,
              obscureText: _obscureText2,
              decoration: InputDecoration(
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 61, 115, 127))
                ),
                border: UnderlineInputBorder(),
                hintText: "Şifre Kontrol",
                hintStyle: TextStyle(color: Color.fromARGB(255, 206, 199, 191)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText2 ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText2 = !_obscureText2;
                    });
                  },
                ),
              ),
              cursorColor: const Color.fromARGB(255, 61, 115, 127),
              style: const TextStyle(color: Color.fromARGB(255, 206, 199, 191)),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: ElevatedButton(
              onPressed: (){
                if (password.text == passwordControl.text) {
                  signup();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginForm())
                  );
                }
                else{
                  final scaffold = ScaffoldMessenger.of(context);
                  scaffold.showSnackBar(
                    const SnackBar(
                      content: Text('Şifreler uyuşmuyor'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: const Color.fromARGB(255, 206, 199, 191),
                foregroundColor: const Color.fromARGB(255, 7, 22, 27),
                textStyle: const TextStyle(fontSize: 17),
              ),
              child: const Text("Kayıt Ol"),
            ),
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 15.0),
                child: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginForm())
                    );
                  },
                  style: TextButton.styleFrom(foregroundColor: const Color.fromARGB(255, 206, 199, 191)),
                  child: const Text("Geri Dön"),
                ),
              )
            ],
          )
        ],
      ),
      ),
    );
  }
}