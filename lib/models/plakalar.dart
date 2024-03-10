import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

import 'data.dart';

List<String> plakalar = [];

void plakaEkle(plaka, kAdi) async{
  var db = Mysql();
  MySqlConnection conn = await db.getConnection();

  var sonDate = DateTime.now().toUtc().year + 5;
  Results plate = await conn.query('INSERT INTO plakalar (PLAKA, KULID, GIRIS, SON) VALUES(?,?,?,?)', [plaka, kAdi, DateTime.now().toUtc(), sonDate]);
}