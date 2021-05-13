import 'package:flutter/material.dart';
import 'package:notkaydet/model/kategori.dart';
import 'package:notkaydet/pages/kategoriler.dart';
import 'package:notkaydet/utils/database_helper.dart';

import 'not_detay.dart';
import 'notlari_listele.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  var _scalffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scalffoldKey,
      appBar: AppBar(
        title: Text("Notlarım"),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(
                  child: ListTile(
                leading: Icon(Icons.category),
                title: Text("Kategoriler"),
                onTap: () {
                  Navigator.pop(context);
                  _kategorilereGit(context);
                },
              )),
            ];
          }),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "Kategori Ekle",
            tooltip: "Kategori Ekle",
            child: Icon(Icons.add_circle_outline),
            mini: true,
            onPressed: () {
              kategoriEkleModal(context);
            },
          ),
          FloatingActionButton(
            heroTag: "Not Ekle",
            tooltip: "Not Ekle",
            child: Icon(Icons.add),
            onPressed: () {
              _NotDetaySayfasinaGit(context);
            },
          ),
        ],
      ),
      body: NotlariListele(),
    );
  }

  void kategoriEkleModal(BuildContext context) {
    var _formKey = GlobalKey<FormState>();
    var _yeniKategori;
    showDialog(
      //Boşluğa tıklayınca açılır pencere kapanmıyor.!!!!
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Kategori Ekle",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Kategori Adı",
                    border: OutlineInputBorder(),
                  ),
                  validator: (kategori) {
                    if (kategori.length < 3) {
                      return "En az 3 karakter giriniz.";
                    } else
                      return null;
                  },
                  onSaved: (val) {
                    setState(() {
                      _yeniKategori = val;
                    });
                  },
                ),
              ),
            ),
            ButtonBar(
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
                  child: Text("Ekle"),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      databaseHelper.kategoriEkle(Kategori(_yeniKategori)).then((kategoriID) {
                        if (kategoriID > 0) {
                          _scalffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text("Kategori Eklendi"),
                              duration: Duration(seconds: 1),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      });
                    }
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _NotDetaySayfasinaGit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => NotDetay(baslik: "Yeni Not")),
    ).then((value) => setState(() {}));
  }

  _kategorilereGit(BuildContext context) {
    Navigator.push(
            context, MaterialPageRoute(builder: (BuildContext context) => Kategoriler()))
        .then((value) => setState(() {}));
  }
}
