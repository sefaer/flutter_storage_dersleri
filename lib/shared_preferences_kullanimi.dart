import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SharedPreferencesKullanimi extends StatefulWidget {
  @override
  _SharedPreferencesKullanimiState createState() =>
      _SharedPreferencesKullanimiState();
}

class _SharedPreferencesKullanimiState
    extends State<SharedPreferencesKullanimi> {
  String isim;
  int id;
  bool cinsiyet;
  var formKey = GlobalKey<FormState>();
  var mySharedPreferences;

  @override
  void initState() {
    // TODO: implement initState
    //SharedPreferences.getInstance().then((sf) => mySharedPreferences=sf);
    SharedPreferences.getInstance().then((sf) {
      mySharedPreferences = sf;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    mySharedPreferences.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shared Pref Kullanımi"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (deger) {
                    isim = deger;
                  },
                  decoration: InputDecoration(
                    labelText: "İsminizi giriniz",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (deger) {
                    id = int.parse(deger);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "ID giriniz",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RadioListTile(
                    value: true,
                    groupValue: cinsiyet,
                    onChanged: (secildi) {
                      setState(() {
                        cinsiyet = secildi;
                      });
                    },
                    title: Text("Erkek"),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioListTile(
                  value: false,
                  groupValue: cinsiyet,
                  onChanged: (secildi) {
                    setState(() {
                      cinsiyet = secildi;
                    });
                  },
                  title: Text("Kadın"),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    onPressed: _ekle,
                    child: Text("Kaydet"),
                    color: Colors.green,
                  ),
                  RaisedButton(
                    onPressed: _goster,
                    child: Text("Göster"),
                    color: Colors.blue,
                  ),
                  RaisedButton(
                    onPressed: _sil,
                    child: Text("Sil"),
                    color: Colors.red,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _ekle() async {
    formKey.currentState.save();
    await (mySharedPreferences as SharedPreferences).setString("myIsim", isim);
    await (mySharedPreferences as SharedPreferences).setInt("myId", id);
    await (mySharedPreferences as SharedPreferences)
        .setBool("myCinsiyet", cinsiyet);
  }

  void _goster() {
    debugPrint("Okunan isim: "+ (mySharedPreferences as SharedPreferences).getString("myIsim")?? "NULL");
    debugPrint("Okunan id: "+ (mySharedPreferences as SharedPreferences).getInt("myId").toString()?? "NULL");
    debugPrint("Cinsiyet erkek mi:  "+ (mySharedPreferences as SharedPreferences).getBool("myCinsiyet").toString()?? "NULL");
  }

  void _sil() {
    (mySharedPreferences as SharedPreferences).remove("myIsim");
    (mySharedPreferences as SharedPreferences).remove("myId");
    (mySharedPreferences as SharedPreferences).remove("myCinsiyet");
  }
}
