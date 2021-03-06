import 'package:flutter/material.dart';
import 'package:notkaydet/model/kategori.dart';
import 'package:notkaydet/utils/database_helper.dart';

class Kategoriler extends StatefulWidget {
  const Kategoriler({Key key}) : super(key: key);

  @override
  _KategorilerState createState() => _KategorilerState();
}

class _KategorilerState extends State<Kategoriler> {
  List<Kategori> tumKategoriler;
  DatabaseHelper databaseHelper;
  var _scalffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // kategoriler = List<Kategori>();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    if (tumKategoriler == null) {
      tumKategoriler = List<Kategori>();
      kategoriListesiGuncelle();
    }
    return Scaffold(
      key: _scalffoldKey,
      appBar: AppBar(
        title: Text("Kategoriler"),
      ),
      body: ListView.builder(
          itemCount: tumKategoriler.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () => _kategoriDuzenle(context, tumKategoriler[index]),
              title: Text(
                tumKategoriler[index].kategoriBaslik,
              ),
              trailing: tumKategoriler[index].kategoriID == 1
                  ? GestureDetector(child: Icon(Icons.admin_panel_settings))
                  : GestureDetector(
                      onTap: () => _kategoriSil(tumKategoriler[index].kategoriID,
                          tumKategoriler[index].kategoriBaslik),
                      child: Icon(Icons.delete)),
              leading: Icon(Icons.category),
            );
          }),
    );
  }

  void kategoriListesiGuncelle() {
    databaseHelper.kategoriListesiniGetir().then((gelenKategoriler) {
      setState(() {
        tumKategoriler = gelenKategoriler;
      });
    });
  }

  _kategoriSil(int kategoriID, String kategoriBaslik) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(kategoriBaslik),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('"' +
                  kategoriBaslik +
                  '" kategorisini silmek istedi??inize emin misiniz? Bu i??lem geri al??namaz, ve kategoriye ait  t??m notlar silinir...'),
              ButtonBar(
                children: [
                  RaisedButton(
                    color: Colors.green.shade500,
                    child: Text("??ptal"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                    color: Colors.red,
                    child: Text("Sil"),
                    onPressed: () {
                      databaseHelper.kategoriSil(kategoriID).then((silmeBasarili) {
                        if (silmeBasarili != 0) {
                          setState(() {
                            kategoriListesiGuncelle();
                            Navigator.pop(context);
                          });
                          // _scalffoldKey.currentState.showSnackBar(
                          //   SnackBar(
                          //     content: Text("Kategori Silindi"),
                          //     duration: Duration(seconds: 1),
                          //   ),
                          // );
                        }
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  // _kategoriDuzenle(Kategori guncellenecekKategori) {
  //   kategoriDuzenleModal(context, guncellenecekKategori);
  // }

  _kategoriDuzenle(BuildContext context, Kategori guncellenecekKategori) {
    var _formKey = GlobalKey<FormState>();
    var _guncellenenKategori;
    showDialog(
      //Bo??lu??a t??klay??nca a????l??r pencere kapanm??yor.!!!!
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Kategori G??ncelle",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Kategori Ad??",
                    border: OutlineInputBorder(),
                  ),
                  initialValue: guncellenecekKategori.kategoriBaslik,
                  validator: (kategori) {
                    if (kategori.length < 3) {
                      return "En az 3 karakter giriniz.";
                    } else
                      return null;
                  },
                  onSaved: (val) {
                    setState(() {
                      _guncellenenKategori = val;
                    });
                  },
                ),
              ),
            ),
            ButtonBar(
              children: [
                RaisedButton(
                  color: Colors.red.shade500,
                  child: Text("Vazge??"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                RaisedButton(
                  color: Colors.green,
                  child: Text("G??ncelle"),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();

                      databaseHelper
                          .kategoriGuncelle(Kategori.withID(
                              guncellenecekKategori.kategoriID, _guncellenenKategori))
                          .then((kategoriID) {
                        if (kategoriID > 0) {
                          _scalffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text("Kategori G??ncellendi"),
                              duration: Duration(seconds: 1),
                            ),
                          );
                          kategoriListesiGuncelle();
                          Navigator.pop(context);
                        }
                      });

                      // databaseHelper.kategoriEkle(Kategori(_guncellenenKategori)).then((kategoriID) {
                      //   if (kategoriID > 0) {
                      //     _scalffoldKey.currentState.showSnackBar(
                      //       SnackBar(
                      //         content: Text("Kategori Eklendi"),
                      //         duration: Duration(seconds: 1),
                      //       ),
                      //     );
                      //     Navigator.pop(context);
                      //   }
                      // });
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
}
