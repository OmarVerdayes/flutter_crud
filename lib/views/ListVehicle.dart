import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'addVehiclePage.dart';
import 'detailsPage.dart';

class Listvehicle extends StatefulWidget {
  const Listvehicle({super.key});

  @override
  State<Listvehicle> createState() => _ListvehicleState();
}

class _ListvehicleState extends State<Listvehicle> {
  Future<List<dynamic>> getData() async {
    final response = await http.get(Uri.parse("https://7j6rqe8mkd.execute-api.us-east-1.amazonaws.com/Prod/lambda/"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load vehicles');
    }
  }

  _navigateAddVehicle(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddVehiclePage()),
    );
    if (result != null && result) {
      setState(() {}); // Recarga los datos si se ha agregado un nuevo vehículo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de vehículos'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: Icon(Icons.add),
            onPressed: () => _navigateAddVehicle(context),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ItemList(
            list: snapshot.data!,
            onUpdate: () => setState(() {}), // Callback para recargar datos
          );
        },
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List<dynamic> list;
  final VoidCallback onUpdate; // Callback para actualizar

  const ItemList({required this.list, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, i) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => Details(
                        list: list,
                        index: i,
                      ),
                    ),
                  );
                  if (result != null && result) {
                    onUpdate(); // Llama al callback para actualizar la lista
                  }
                },
                child: Container(
                  width: double.infinity, // Hace el contenedor tan ancho como sea posible
                  child: Card(
                    color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Marca: ${list[i]['marca'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          child: Text(
                            'Modelo: ${list[i]['modelo'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          child: Text(
                            'Tipo: ${list[i]['tipo'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          child: Text(
                            'Material: ${list[i]['material'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
