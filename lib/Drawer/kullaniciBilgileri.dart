import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/data.dart';
import '../modules/mainPage.dart';

TextEditingController tel = TextEditingController();
TextEditingController tel2 = TextEditingController();
TextEditingController kan = TextEditingController();
TextEditingController sosyal = TextEditingController();
TextEditingController knot = TextEditingController();

class KullaniciBilgileri extends StatefulWidget {
  const KullaniciBilgileri({Key? key, required this.name, required this.plaka}) : super(key: key);
  final String name;
  final String plaka;

  @override
  State<KullaniciBilgileri> createState() => _KullaniciBilgileriState();
}

class _KullaniciBilgileriState extends State<KullaniciBilgileri> {
  bool? checkedValue = false;
  bool? checkedValue2 = false;
  bool? checkedTel = false;

  var db = Mysql();

  Future<List<Map<String, dynamic>>> getUserInfo() async{
    MySqlConnection conn = await db.getConnection();

    Results gb = await conn.query("SELECT * FROM kullanicibilgi WHERE USERN = ?", [widget.name]);

    List<Map<String, dynamic>> data = [];

    for (var row in gb) {
      data.add(Map<String, dynamic>.from(row.fields));
    }
    print(data);

    await conn.close();

    return data;
  }

  void update() async {
    MySqlConnection conn = await db.getConnection();

    await conn.query("UPDATE kullanicibilgi SET TELNO = ?, TELNO2 = ?, KAN = ?, SOSYALM = ?, KNOT = ? WHERE USERN = ?", [tel.text, tel2.text, kan.text, sosyal.text, knot.text, widget.name]);

    //mesaj göster ve anasayfaya dön

    Fluttertoast.showToast(
      msg: 'Tebrikler bilgileriniz kaydedildi',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainPage(name: widget.name))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 22, 27),
      body: SafeArea(
        child: SingleChildScrollView(
        child: Theme(
          data: ThemeData(
            inputDecorationTheme: const InputDecorationTheme(
              hintStyle: TextStyle(
                color: Color.fromARGB(255, 206, 199, 191),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 61, 115, 127))
              ),
            ),
          ),
          child: FutureBuilder(
                  future: getUserInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Hata: ${snapshot.error}');
                    } else {
                      List<Map<String, dynamic>> data = snapshot.data as List<Map<String, dynamic>>;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Container(
                                  margin: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      const Text("Kişisel Bilgiler", style: TextStyle(color: Color.fromARGB(255, 206, 199, 191), fontSize: 22),),
                                      TextField(
                                        controller: tel = TextEditingController(text: data[index]['TELNO']),
                                        decoration: InputDecoration(
                                          hintText: "Telefon Numaranız",
                                        ),
                                        cursorColor: Color.fromARGB(255, 61, 115, 127),
                                        style: const TextStyle(color: Color.fromARGB(255, 206, 199, 191)),
                                      ),
                                      CheckboxListTile(
                                        checkColor: const Color.fromARGB(255, 7, 22, 27),
                                        activeColor: const Color.fromARGB(255, 61, 115, 127),
                                        title: const Text("Telefon numaram görünsün", style: TextStyle(
                                            color:  Color.fromARGB(255, 206, 199, 191),
                                          ),),
                                        value: checkedValue,
                                        onChanged: (newValue) {
                                          setState(() {
                                            checkedValue = newValue;
                                          });
                                        },
                                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                      ),

                                      TextField(
                                        controller: tel2 = TextEditingController(text: data[index]['TELNO2']),
                                        decoration: const InputDecoration(
                                          hintText: "2.Telefon"
                                        ),
                                        cursorColor: Color.fromARGB(255, 61, 115, 127),
                                        style: const TextStyle(color: Color.fromARGB(255, 206, 199, 191)),
                                      ),
                                      CheckboxListTile(
                                        checkColor: const Color.fromARGB(255, 7, 22, 27),
                                        activeColor: Color.fromARGB(255, 61, 115, 127),
                                        title: const Text("2. Telefon Gözüksün", style:  TextStyle(
                                            color:  Color.fromARGB(255, 206, 199, 191),
                                          ),),
                                        value: checkedTel,
                                        onChanged: (newValue2) {
                                          setState(() {
                                            checkedTel = newValue2;
                                          });
                                        },
                                        controlAffinity: ListTileControlAffinity.leading,
                                      ),

                                      TextField(
                                        controller: kan = TextEditingController(text: data[index]['KAN']),
                                        decoration: const InputDecoration(
                                          hintText: "Kan Grubunuz"
                                        ),
                                        cursorColor: Color.fromARGB(255, 61, 115, 127),
                                        style: const TextStyle(color: Color.fromARGB(255, 206, 199, 191)),
                                      ),

                                      TextField(
                                        controller: sosyal = TextEditingController(text: data[index]['SOSYALM']),
                                        decoration: const InputDecoration(
                                          hintText: "Sosyal Medya Adresiniz"
                                        ),
                                        cursorColor: Color.fromARGB(255, 61, 115, 127),
                                        style: const TextStyle(color: Color.fromARGB(255, 206, 199, 191)),
                                      ),
                                      CheckboxListTile(
                                        checkColor: const Color.fromARGB(255, 7, 22, 27),
                                        activeColor: Color.fromARGB(255, 61, 115, 127),
                                        title: const Text("Sosyal medya adresim görünsün", style:  TextStyle(
                                            color:  Color.fromARGB(255, 206, 199, 191),
                                          ),),
                                        value: checkedValue2,
                                        onChanged: (newValue2) {
                                          setState(() {
                                            checkedValue2 = newValue2;
                                          });
                                        },
                                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                      ),

                                      TextField(
                                        controller: knot = TextEditingController(text: data[index]['KNOT']),
                                        decoration: const InputDecoration(
                                          hintText: "Not"
                                        ),
                                        cursorColor: Color.fromARGB(255, 61, 115, 127),
                                        style: const TextStyle(color: Color.fromARGB(255, 206, 199, 191)),
                                      ),

                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                                        child: ElevatedButton(
                                          onPressed: (){
                                            getUserInfo();
                                            update();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                            backgroundColor: const Color.fromARGB(255, 206, 199, 191),
                                            foregroundColor: const Color.fromARGB(255, 7, 22, 27),
                                            textStyle: const TextStyle(fontSize: 17),
                                          ),
                                          child: const Text("Kaydet"),
                                        ),
                                      ),

                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                                        child: TextButton(
                                          onPressed: (){
                                            Navigator.push(
                                            context,
                                              MaterialPageRoute(builder: (context) => MainPage(name: widget.name))
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: const Color.fromARGB(255, 206, 199, 191),
                                            textStyle: const TextStyle(fontSize: 17),
                                          ),
                                          child: const Text("Çıkış"),
                                        ),
                                      ),
                                  ]
                                ),
                              );
                        }
                      );
                    }
                  }
                ),
                
            )
          ),
        ),
    );
  }
}