import 'dart:io';
import 'package:flutter/material.dart';
import 'package:notkaydet/model/notlar.dart';
import 'package:notkaydet/utils/database_helper.dart';
import 'not_detay.dart';

class NotlariListele extends StatefulWidget {
  const NotlariListele({Key key}) : super(key: key);

  @override
  _NotlariListeleState createState() => _NotlariListeleState();
}

class _NotlariListeleState extends State<NotlariListele> {
  List<Notlar> tumNotlar;
  DatabaseHelper databaseHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumNotlar = List<Notlar>();
    databaseHelper = DatabaseHelper();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: databaseHelper.notListesiniGetir(),
      builder: (context, AsyncSnapshot<List<Notlar>> snapShot) {
        // Liste getirme işlemi tamamlandı ise
        if (snapShot.connectionState == ConnectionState.done) {
          tumNotlar = snapShot.data;
          sleep(Duration(microseconds: 500));
          return ListView.builder(
            itemCount: tumNotlar.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                leading: _oncelikIcon(tumNotlar[index].notOncelik),
                title: Text(tumNotlar[index].notBaslik),
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 30, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "KATEGORİ:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(tumNotlar[index].kategoriBaslik),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Oluşturulma Tarihi:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(databaseHelper
                                .dateFormat(DateTime.parse(tumNotlar[index].notTarih))),
                          ],
                        ),
                        Text(
                          "İçerik:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          tumNotlar[index].notIcerik != ""
                              ? tumNotlar[index].notIcerik
                              : "Herhangi Bir İçerik Eklenmedi...",
                        ),
                        ButtonBar(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            FlatButton(
                              child: Text(
                                "SİL",
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                _notSil(tumNotlar[index].notID);
                              },
                            ),
                            FlatButton(
                              child: Text(
                                "GÜNCELLE",
                                style: TextStyle(color: Colors.green),
                              ),
                              onPressed: () {
                                _detaySayfasinaGit(context, tumNotlar[index]);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          return Center(
            child: Text("Yükleniyor..."),
          );
        }
      },
    );
  }

  _oncelikIcon(int notOncelik) {
    switch (notOncelik) {
      case 0:
        return CircleAvatar(
          child: Text(
            "AZ",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent.shade200,
        );
        break;
      case 1:
        return CircleAvatar(
          child: Text("ORTA", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.redAccent.shade400,
        );
        break;
      case 2:
        return CircleAvatar(
          child: Text(
            "ACİL",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        );
        break;
    }
  }

  void _notSil(int notID) {
    databaseHelper.notSil(notID).then((silinenID) {
      if (silinenID != 0) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Not Silindi"),
          duration: Duration(seconds: 1),
        ));
        setState(() {});
      }
    });
  }

  void _detaySayfasinaGit(BuildContext context, Notlar not) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) =>
              NotDetay(baslik: "Notu Düzenle", duzenlenecekNot: not)),
    ).then((value) => setState(() {}));
  }
}
