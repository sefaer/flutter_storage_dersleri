import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

class DosyaIslemleri extends StatefulWidget {
  @override
  _DosyaIslemleriState createState() => _DosyaIslemleriState();
}
//  //Olusturulacal dosyanın klasor yolu
class _DosyaIslemleriState extends State<DosyaIslemleri> {
  var mytextController = TextEditingController();
  Future<String> get getKlasyorYolu async{
    Directory klasor= await getApplicationDocumentsDirectory();
    debugPrint("Klasör pathi : "+klasor.path);
    return klasor.path;
  }
  // dosya olustur
  Future<File> get dosyaOlustur async{
    var olusturalacakDosyaninKlasorununYolu= await getKlasyorYolu;

    return File(olusturalacakDosyaninKlasorununYolu + "/myDosya.txt");
  }
  //dosya okuma işlemleri
  Future<String> dosyaOku() async {
    try{
      var myDosya = await dosyaOlustur;
      String dosyaIcerigi = await myDosya.readAsString();
      return dosyaIcerigi;
    }catch(exception) {
      return "Hata çıktı  $exception";
    }
  }
  //dosyaya yaz
  Future<File>dosyayaYaz(String yazilacakString) async {
    var myDosya = await dosyaOlustur;
    return myDosya.writeAsString(yazilacakString);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dosya İşlemleri"),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: mytextController,
              maxLines: 4,
              decoration: InputDecoration(
                  hintText: "Buraya yazılacak değeler dosyaya kaydedilir."),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(onPressed: _dosyaYaz,color: Colors.green,child: Text("Dosyaya Yaz "),),
              RaisedButton(onPressed: _dosyaOku,color: Colors.blue,child: Text("Dosyadan Oku"),),
            ],
          )
        ],
      )),
    );
  }

  void _dosyaOku() async{
    // debugPrint(await dosyaOku());
   dosyaOku().then((icerik) {
      debugPrint(icerik);
    });
  }

  void _dosyaYaz() {
    dosyayaYaz(mytextController.text.toString());
  }
}
