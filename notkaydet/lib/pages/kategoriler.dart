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
              onTap: () => _kategoriDuzenle(tumKategoriler[index].kategoriID),
              title: Text(tumKategoriler[index].kategoriBaslik),
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
                  '" kategorisini silmek istediğinize emin misiniz? Bu işlem geri alınamaz, ve kategoriye ait  tüm notlar silinir...'),
              ButtonBar(
                children: [
                  RaisedButton(
                    color: Colors.green.shade500,
                    child: Text("İptal"),
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

  _kategoriDuzenle(int kategoriID) {}
}
