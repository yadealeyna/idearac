import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:son/models/plakalar.dart';

import '../models/data.dart';
import '../Drawer/drawerMenu.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key, required this.name}) : super(key:key);
  final String name;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Mysql db = Mysql();

  Stream<List<Map<String, dynamic>>> stateSet() async* {
    MySqlConnection conn = await db.getConnection();

    List<Map<String, dynamic>> data = [];
    
    await Future.wait(plakalar.map((plaka) async {
      Results res = await conn.query('SELECT * FROM bildirim WHERE PLATE = ?', [plaka]);
      for (var row in res) {
        data.add(Map<String, dynamic>.from(row.fields));
      }
    }));
    
    print(data);

    yield data;
  }

  @override
  void initState() {
    super.initState();
    stateSet();
  }

  void bildirimKapat(int index) async{
    List<Map<String, dynamic>> data = await stateSet().first;

    Mysql db = Mysql();
    MySqlConnection conn = await db.getConnection();
    await conn.query("DELETE FROM bildirim WHERE PK = ?", [data[index]['PK']]);

    setState(() {
      data.removeAt(index);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 22, 27),
      endDrawer: drawerMenu(name: widget.name),
      body: SafeArea(
        child: Builder(
         builder: (context) => Column(
          children: [
            //navBar
            Container(
              height: 55.0,
              decoration: const BoxDecoration(
                color:  Color.fromARGB(255, 61, 115, 127),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/images/mainLogo.png', width: 200.0,),
                    ElevatedButton(
                      onPressed: () {
                         Scaffold.of(context).openEndDrawer();
                      },
                      child: Image.asset('assets/images/menu-burger.png', width: 35.0,),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 61, 115, 127),
                      ),
                    )
                  ],
                ),
              ),
            ),

            //bildirimler
            Container(
              width: double.infinity,
              alignment: Alignment.bottomCenter,
             // padding: const EdgeInsets.all(10.0),
             // margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
              ),
              
              child: Container(
                width: double.infinity,
                child: StreamBuilder<List<Map<String, dynamic>>>(
                        stream: stateSet(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator(); // or some loading indicator
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            // You can access the data from snapshot.data
                            List<Map<String, dynamic>> data = snapshot.data ?? [];
                            // Use the data here
                            return ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                            String state1 = "Farlar Açık Kalmış.";
                            String state2 = "Aracınız Kazaya Karıştı."; 
                            String state3 = "Araçtan Kedi Sesi Geliyor.";
                            String state4 = "Araç Camları Açık Kalmış."; 
                            String state5 = "Yanlış Yere Park. Lütfen Çekiniz.";

                            print(data[index]['STATU']);

                            Widget settedState = Text(data[index]['STATU'].toString());                        

                            switch (data[index]['STATU']) {
                              case 1:
                                 settedState = Text(state1);
                                 break;
                              case 2: 
                                 settedState = Text(state2);
                                 break;
                              case 3:
                                 settedState = Text(state3);
                                 break;
                              case 4:
                                 settedState = Text(state4);
                                 break;
                              case 5:
                                 settedState = Text(state5);
                                 break;
                              default:  settedState = Text("Bildiriminiz yok");break;
                            }
                            print(settedState);

                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: const Color.fromARGB(255, 206, 199, 191),
                              ),
                              child: Column(
                                children: [
                                  
                                  Container(
                                    width: 320.0,
                                    alignment: Alignment.bottomCenter,
                                    padding: const EdgeInsets.all(10.0),
                                    margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Colors.white,
                                    ),
                                    child: settedState, //Text('ID: ${data[index]['PK']}, Plaka: ${data[index]['CPLATE']}, Durum: ${data[index]['STATU']}', style: TextStyle(color: Colors.black,)),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text("Araç Plakası:"),
                                        ),
                                        Container(
                                          child: Text(data[index]['PLATE'].toString()),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text("Bildirim Saati:"),
                                        ),
                                        Container(
                                          child: Text(data[index]['TIME'].toString()),
                                        )
                                      ],
                                    ),
                                  ),

                                  Container(
                                    margin: const EdgeInsets.only(right: 20.0),
                                    alignment: Alignment.bottomRight,
                                    child: TextButton(
                                      onPressed: (){
                                        bildirimKapat(index);
                                      },
                                      style: TextButton.styleFrom(foregroundColor: const Color.fromARGB(255, 61, 115, 127)),
                                      child: Text("Bildirimi Kapat"),
                                    ),
                                  
                                  )
                                  
                                ],
                              )          
                            );
                          
                        },
                      );
                    }
              })))
          ]
        )
      )
      ),);}
}