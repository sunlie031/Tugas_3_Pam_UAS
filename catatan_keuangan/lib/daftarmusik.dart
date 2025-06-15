import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Daftarmusik extends StatefulWidget {
  const Daftarmusik({super.key});

  @override
  State<Daftarmusik> createState() => _DaftarmusikState();
}

class _DaftarmusikState extends State<Daftarmusik> {
  TextEditingController judulController = TextEditingController();
  TextEditingController penyanyiController = TextEditingController();

  Future<dynamic> getData() async {
    Dio dio = Dio();
    var response = await dio.get(
      "https://68425a0be1347494c31c85b7.mockapi.io/api/v1/DaftarLagu",
    );
    if (response.statusCode == 200) {
      final data = response.data;
      return data;
    } else {
      print("gagal");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Lagu"),
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            var data = snapshot.data;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data[index]["Judullagu"]),
                  subtitle: Text(data[index]["NamaPenyanyi"]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color:
                              data[index]["completed"] == true
                                  ? Colors.red
                                  : Colors.grey,
                        ),
                        onPressed: () async {
                          Dio dio = Dio();
                          var id = data[index]["id"];
                          bool newValue = !(data[index]["completed"] ?? false);
                          await dio.put(
                            "https://68425a0be1347494c31c85b7.mockapi.io/api/v1/DaftarLagu/$id",
                            data: {
                              "Judullagu": data[index]["Judullagu"],
                              "NamaPenyanyi": data[index]["NamaPenyanyi"],
                              "completed": newValue,
                            },
                          );
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          Dio dio = Dio();
                          var id = data[index]["id"];
                          await dio.delete(
                            "https://68425a0be1347494c31c85b7.mockapi.io/api/v1/DaftarLagu/$id",
                          );
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Tambah Lagu"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: judulController,
                      decoration: InputDecoration(labelText: "Judul Lagu"),
                    ),
                    TextField(
                      controller: penyanyiController,
                      decoration: InputDecoration(labelText: "Nama Penyanyi"),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () async {
                      Dio dio = Dio();
                      var response = await dio.post(
                        "https://68425a0be1347494c31c85b7.mockapi.io/api/v1/DaftarLagu",
                        data: {
                          "Judullagu": judulController.text,
                          "NamaPenyanyi": penyanyiController.text,
                          "completed": false,
                        },
                      );

                      if (response.statusCode == 201) {
                        print("Data berhasil ditambahkan");
                      }
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    child: Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
    );
  }
}
