import 'package:flutter/material.dart';
import 'package:flutter_storage_dersleri/models/ogrenci.dart';
import 'package:flutter_storage_dersleri/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteIslemleri extends StatefulWidget {
  @override
  _SqfliteIslemleriState createState() => _SqfliteIslemleriState();
}

class _SqfliteIslemleriState extends State<SqfliteIslemleri> {
  DatabaseHelper _databaseHelper;
  List<Ogrenci> tumOgrencilerListesi;
  bool aktiflik = false;
  var _controller = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  int tiklanilanOgrenciIndexi;
  int tiklanilanOgrenciIdsi;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumOgrencilerListesi = List<Ogrenci>();
    _databaseHelper = DatabaseHelper();
    _databaseHelper.tumOgrenciler().then((tumOgrencileriTutanMapListesi) {
      for (Map okunanOgrenciMapi in tumOgrencileriTutanMapListesi) {
        tumOgrencilerListesi
            .add(Ogrenci.dbdenOkudugunMapiObjeyeDonustur(okunanOgrenciMapi));
      }
      print("dbden gelen ogrenci sayısı: " +
          tumOgrencilerListesi.length.toString());
    }).catchError((hata) => print("hata: " + hata));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("SQFlite kullanımi"),
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    autofocus: false,
                    controller: _controller,
                    validator: (kontrolEdilecekDeger) {
                      if (kontrolEdilecekDeger.length < 3) {
                        return "En az 3 karakter giriniz";
                      } else
                        return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Öğrenci ismini giriniz..",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SwitchListTile(
                    title: Text("Aktif"),
                    value: aktiflik,
                    onChanged: (aktifmi) {
                      setState(() {
                        aktiflik = aktifmi;
                      });
                    })
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: Text("KAYDET"),
                color: Colors.green,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _ogrenciEkle(
                        Ogrenci(_controller.text, aktiflik == true ? 1 : 0));
                  }
                },
              ),
              RaisedButton(
                child: Text("GÜNCELLE"),
                color: Colors.orangeAccent,
                onPressed: tiklanilanOgrenciIdsi == null
                    ? null
                    : () {
                        if (_formKey.currentState.validate()) {
                          _ogrenciGuncelle(Ogrenci.withID(tiklanilanOgrenciIdsi,
                              _controller.text, aktiflik == true ? 1 : 0));
                        }
                      },
              ),
              RaisedButton(
                child: Text("TüM TABLOYU SİL"),
                color: Colors.redAccent,
                onPressed: () {
                  _tumTabloyuTemizle();
                },
              )
            ],
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: tumOgrencilerListesi.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: tumOgrencilerListesi[index].aktif == 1
                          ? Colors.green.shade200
                          : Colors.red.shade200,
                      child: ListTile(
                          onTap: () {
                            setState(() {
                              _controller.text =
                                  tumOgrencilerListesi[index].isim;
                              aktiflik = tumOgrencilerListesi[index].aktif == 1
                                  ? true
                                  : false;
                              tiklanilanOgrenciIndexi = index;
                              tiklanilanOgrenciIdsi =
                                  tumOgrencilerListesi[index].id;
                            });
                          },
                          title: Text(tumOgrencilerListesi[index].isim),
                          subtitle:
                              Text(tumOgrencilerListesi[index].id.toString()),
                          trailing: GestureDetector(
                            onTap: () {
                              _ogrenciSil(
                                  tumOgrencilerListesi[index].id, index);
                            },
                            child: Icon(Icons.delete),
                          )),
                    );
                  }))
        ],
      ),
    );
  }

  void _ogrenciEkle(Ogrenci ogrenci) async {
    var eklenenYeniOgrencininIDsi = await _databaseHelper.ogrenciEkle(ogrenci);
    ogrenci.id = eklenenYeniOgrencininIDsi;
    if (eklenenYeniOgrencininIDsi > 0) {
      setState(() {
        tumOgrencilerListesi.insert(0, ogrenci);
      });
    }
  }

  void _tumTabloyuTemizle() async {
    var silinenElamanSayisi = await _databaseHelper.tumOgrenciTablosunuSil();
    if (silinenElamanSayisi > 0) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text(silinenElamanSayisi.toString() + " kayıt silindi.")));
      setState(() {
        tumOgrencilerListesi.clear();
      });
    }
    tiklanilanOgrenciIdsi=null;

  }

//DB DEN SİLMEYE YARAYACAK İD VE VAR OLAN LİSTEDEN SİLMEYE YARAYAN İNDEX
  void _ogrenciSil(
      int dbdenSilmeyeYarayacakID, int listedenSilmeyeYarayacakIndex) async {
    var sonuc = await _databaseHelper.ogrenciSil(dbdenSilmeyeYarayacakID);
    if (sonuc == 1) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Kayıt Silindi"),
      ));
      setState(() {
        tumOgrencilerListesi.removeAt(listedenSilmeyeYarayacakIndex);
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Silerken bir hata oluştu.")));
    }
    tiklanilanOgrenciIdsi=null;
  }

  void _ogrenciGuncelle(Ogrenci ogrenci) async {
    var sonuc = await _databaseHelper.ogrenciGuncelle(ogrenci);
    if (sonuc == 1) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Kayıt Güncellendi"),
      ));
      setState(() {
        tumOgrencilerListesi[tiklanilanOgrenciIndexi] = ogrenci;
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Güncellerken bir hata oluştu.")));
    }
  }
}
