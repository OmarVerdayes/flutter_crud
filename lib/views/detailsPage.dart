import 'package:crud/views/listvehicle.dart'; // Asegúrate de importar la página de la lista
import 'package:crud/views/editPage.dart';
import 'package:flutter/material.dart';
import 'package:crud/controllers/dataHelper.dart';

class Details extends StatefulWidget {
  final List list;
  final int index;

  Details({required this.list, required this.index});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  DataHelper databaseHelper = DataHelper();

  void confirm() {
    AlertDialog alertDialog = AlertDialog(
      content: Text(
        "¿Está seguro de eliminar '${widget.list[widget.index]['id']}'?",
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text(
            "Confirmar",
            style: TextStyle(color: Colors.black),
          ),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () async {
            await databaseHelper.deleteVehicle(widget.list[widget.index]['id'].toString());
            Navigator.pop(context); // Regresa a la página anterior
            Navigator.pop(context, true); // Regresa a la página de lista con un resultado de éxito
          },
        ),
        ElevatedButton(
          child: Text(
            "Cancelar",
            style: TextStyle(color: Colors.black),
          ),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => alertDialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Vehículo'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailText('Marca', widget.list[widget.index]["marca"]),
                  const Divider(),
                  _buildDetailText('Modelo', widget.list[widget.index]["modelo"]),
                  const Divider(),
                  _buildDetailText('Tipo', widget.list[widget.index]["tipo"]),
                  const Divider(),
                  _buildDetailText('Material', widget.list[widget.index]["material"]),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        child: const Text("Editar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        onPressed: () async {
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => EditPage(
                                list: widget.list,
                                index: widget.index,
                              ),
                            ),
                          );
                          if (result != null && result) {
                            Navigator.pop(context, true); // Regresa a la página de lista con un resultado de éxito
                          }
                        },
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        child: const Text("Eliminar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        onPressed: () => confirm(),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailText(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value ?? 'N/A',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
