import 'package:flutter/material.dart';
import 'package:flutter_storage_dersleri/models/ogrenci.dart';
import 'package:flutter_storage_dersleri/shared_preferences_kullanimi.dart';
import 'package:flutter_storage_dersleri/sqflite_kullanimi.dart';
import 'package:flutter_storage_dersleri/utils/database_helper.dart';

import 'dosya_islemleri.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SqfliteIslemleri(),
    );
  }
}
