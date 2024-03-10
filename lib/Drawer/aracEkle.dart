import 'package:flutter/material.dart';
import 'package:son/models/plakalar.dart';
import 'package:son/modules/mainPage.dart';
import 'package:son/modules/signupPage.dart';

TextEditingController plaka = TextEditingController();

class AracEkle extends StatefulWidget {
  const AracEkle({Key? key, required this.kAdi}) : super(key:key);
  final String kAdi;

  @override
  State<AracEkle> createState() => _AracEkleState();
}

class _AracEkleState extends State<AracEkle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 22, 27),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(15),
          child:  Column(
            children: [
              const Text(
                "Yeni Araç Ekle",
                style: TextStyle(
                  color: Color.fromARGB(255, 206, 199, 191),
                  fontSize: 20.0
                ),
              ),
              TextField(
                controller: plaka,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 61, 115, 127))
                  ),
                  border: UnderlineInputBorder(),
                  hintText: "Plaka",
                  hintStyle: TextStyle(color: Color.fromARGB(255, 206, 199, 191)),
                ),
                cursorColor:Color.fromARGB(255, 61, 115, 127),
                style: TextStyle(color: Color.fromARGB(255, 206, 199, 191)),
              ),
              ElevatedButton(
                
              onPressed: (){
                plakalar.add(plaka.text);
                plakaEkle(plaka.text, widget.kAdi);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage(name: widget.kAdi))
                );
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
            ],
          )
        ),
      ),
    );
  }
}