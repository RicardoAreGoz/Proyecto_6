import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Map<String, String>> items = [];
  TextEditingController claveController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  String unidadMedida = 'Piezas';
  List<String> unidadesMedida = ['Piezas', 'Kilogramos', 'Paquetes', 'Cajas', 'Gramos', 'Bolsas', 'Litros'];
  String marca = 'SaborNatural';
  List<String> marcas = ['SaborNatural', 'DeliciasVerdes', 'CocinaConPasión', 'FrutoExótico', 'DulceMomento'];
  String proveedor = 'Proveedor 1';
  List<String> proveedores = ['Proveedor 1', 'Proveedor 2', 'Proveedor 3', 'Proveedor 4', 'Proveedor 5'];
  int? selectedIndex;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        sharedPreferences = prefs;
        List<String>? storedItems = sharedPreferences.getStringList('items');
        if (storedItems != null) {
          items = storedItems.map((e) => Map<String, String>.from(Uri.splitQueryString(e))).toList();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de Administrador'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _supabase.auth.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          buildForm(),
          buildActionButtons(),
          Expanded(child: buildItemList()),
        ],
      ),
    );
  }

  Widget buildForm() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: claveController,
            decoration: InputDecoration(labelText: 'Clave del producto'),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,10}$'))],
            maxLength: 10,
          ),
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Nombre'),
            maxLength: 15,
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Descripción'),
            maxLength: 250,
          ),
        ],
      ),
    );
  }

  Widget buildActionButtons() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            // Crear
            if (claveController.text.isNotEmpty && nameController.text.isNotEmpty && quantityController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
              setState(() {
                items.add({
                  'clave': claveController.text,
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'quantity': quantityController.text,
                  'unidadMedida': unidadMedida,
                  'marca': marca,
                  'proveedor': proveedor,
                });
                clearFields();
                saveData();
              });
            }
          },
          child: Text('Añadir'),
        ),
        SizedBox(width: 16.0),
        ElevatedButton(
          onPressed: () {
            // Actualizar
            if (selectedIndex != null) {
              setState(() {
                items[selectedIndex!] = {
                  'clave': claveController.text,
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'quantity': quantityController.text,
                  'unidadMedida': unidadMedida,
                  'marca': marca,
                  'proveedor': proveedor,
                };
                clearFields();
                selectedIndex = null;
                saveData();
              });
            }
          },
          child: Text('Actualizar'),
        ),
        SizedBox(width: 16.0),
        ElevatedButton(
          onPressed: () {
            // Eliminar
            if (selectedIndex != null && selectedIndex! < items.length) {
              setState(() {
                items.removeAt(selectedIndex!);
                clearFields();
                selectedIndex = null;
                saveData();
              });
            }
          },
          child: Text('Eliminar'),
        ),
      ],
    );
  }

  Widget buildItemList() {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(items[index]['name']!),
          subtitle: Text('Descripción: ${items[index]['description']}, Cantidad: ${items[index]['quantity']}, Marca: ${items[index]['marca']}, Proveedor: ${items[index]['proveedor']}'),
          onTap: () {
            // Leer y seleccionar para actualizar/eliminar
            setState(() {
              claveController.text = items[index]['clave']!;
              nameController.text = items[index]['name']!;
              descriptionController.text = items[index]['description']!;
              quantityController.text = items[index]['quantity']!;
              unidadMedida = items[index]['unidadMedida']!;
              marca = items[index]['marca']!;
              proveedor = items[index]['proveedor']!;
              selectedIndex = index;
            });
          },
        );
      },
    );
  }

  void clearFields() {
    claveController.clear();
    nameController.clear();
    descriptionController.clear();
    quantityController.clear();
  }

  void saveData() {
    List<String> stringItems = items.map((item) => Uri(queryParameters: item).query).toList();
    sharedPreferences.setStringList('items', stringItems);
  }
}