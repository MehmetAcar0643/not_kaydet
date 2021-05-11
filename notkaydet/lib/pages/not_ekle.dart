import 'package:flutter/material.dart';
import 'package:notkaydet/model/kategori.dart';
import 'package:notkaydet/model/notlar.dart';
import 'package:notkaydet/utils/database_helper.dart';

class NotEkle extends StatefulWidget {
  @override
  _NotEkleState createState() => _NotEkleState();
}

class _NotEkleState extends State<NotEkle> {
  var _formKey = GlobalKey<FormState>();
  List<Kategori> tumKategoriler;
  DatabaseHelper databaseHelper;
  int kategoriID = 1;
  int secilenOncelik = 0;
  static var _oncelik = ["Düşük", "Orta", "Yüksek"];
  String notBaslik;
  String notIcerik;
  var _scalffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumKategoriler = List<Kategori>();
    databaseHelper = DatabaseHelper();
    databaseHelper.kategorileriGetir().then((kategoriMapListesi) {
      for (Map okunanMap in kategoriMapListesi) {
        tumKategoriler.add(Kategori.fromMap(okunanMap));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scalffoldKey,
      //Klavye çıkınca taşmayı önlemek için
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Center(
          child: Text("Not Ekle"),
        ),
      ),
      body: tumKategoriler.length <= 0
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "Kategori",
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                          margin: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: Colors.red, width: 1),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              items: kategoriItemleri(),
                              value: kategoriID,
                              onChanged: (secilenKategoriID) {
                                setState(() {
                                  kategoriID = secilenKategoriID;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Not Başlığını Giriniz",
                        labelText: "Not Başlığı",
                        border: OutlineInputBorder(),
                      ),
                      validator: (text) {
                        if (text.length < 3) {
                          return "En Az 3 Karakter olmalı";
                        } else
                          return null;
                      },
                      onSaved: (text) {
                        notBaslik = text;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Not İçeriğini Giriniz",
                        labelText: "İçerik",
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (text) {
                        notIcerik = text;
                      },
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            "Öncelik",
                            style: TextStyle(fontSize: 24),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                            margin: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: Colors.red, width: 1),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                items: _oncelik.map((oncelik) {
                                  return DropdownMenuItem<int>(
                                    child: Text(
                                      oncelik,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    value: _oncelik.indexOf(oncelik),
                                  );
                                }).toList(),
                                value: secilenOncelik,
                                onChanged: (oncelik) {
                                  setState(() {
                                    secilenOncelik = oncelik;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.end,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        RaisedButton(
                          color: Colors.red.shade500,
                          child: Text("Vazgeç"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        RaisedButton(
                          color: Colors.green,
                          child: Text("Kaydet"),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              var tarihnow = DateTime.now();
                              databaseHelper
                                  .notEkle(Notlar(kategoriID, notBaslik, notIcerik,
                                      tarihnow.toString(), secilenOncelik))
                                  .then((eklemeBasarili) {
                                if (eklemeBasarili > 0) {
                                  Navigator.pop(context);
                                }
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  List<DropdownMenuItem<int>> kategoriItemleri() {
    return tumKategoriler
        .map(
          (kategori) => DropdownMenuItem<int>(
            value: kategori.kategoriID,
            child: Text(
              kategori.kategoriBaslik,
              style: TextStyle(fontSize: 20),
            ),
          ),
        )
        .toList();
  }
}
