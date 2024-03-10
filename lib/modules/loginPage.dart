import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

import 'signupPage.dart';
import '../models/data.dart';
import '../pdf/qr.dart';
import 'mainPage.dart';
import '../models/plakalar.dart';

TextEditingController usern = TextEditingController();
TextEditingController pass = TextEditingController();

class LoginForm extends StatefulWidget {
  LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscureText = true;

  var db = Mysql();

  void login() async{
    MySqlConnection conn = await db.getConnection();
    Results res = await conn.query('SELECT * FROM girisbilgisi where USERN = ? and PASS = ?', [usern.text, pass.text]);

    for(var row in res){
      Results plaka = await conn.query('SELECT PLAKA FROM plakalar WHERE KULID = ?', [row['KULID']]);
      print(plaka);
      for(var a in plaka){
        print(a);
        plakalar.add(a[0]);
        print(plakalar.toList());
      }

      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPage(name: usern.text),)
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 22, 27),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 60.0),
            height: 100.0,
            child: Image.asset('assets/images/idekodMainLogo.png'),
          ),
          Container(
            margin: const EdgeInsets.all(25.0),
            child: TextField(
              controller: usern,
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
              controller: pass,
              obscureText: _obscureText,
              decoration: InputDecoration(               
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
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (){
                login();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: const Color.fromARGB(255, 206, 199, 191),
                foregroundColor: const Color.fromARGB(255, 7, 22, 27),
                textStyle: const TextStyle(fontSize: 17),
              ),
              child: const Text("Giriş"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupForm()),
                    );
                  },
                  style: TextButton.styleFrom(foregroundColor: const Color.fromARGB(255, 206, 199, 191)),
                  child: const Text("Şifrenizi mi unuttunuz?"),
                ),
                TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupForm()),
                    );
                  },
                  style: TextButton.styleFrom(foregroundColor: const Color.fromARGB(255, 206, 199, 191)),
                  child: const Text("Kayıt Ol"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}