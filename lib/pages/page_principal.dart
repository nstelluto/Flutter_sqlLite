import 'package:app_sqlite/classes/app_routes.dart';
import 'package:app_sqlite/classes/cliente.dart';
import 'package:app_sqlite/repository/respository_cliente.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class PagePrincipal extends StatefulWidget {
  @override
  _PagePrincipalState createState() => _PagePrincipalState();
}

class _PagePrincipalState extends State<PagePrincipal> {
  var totalClientes = '0';
  TextEditingController _ctrNome = TextEditingController();
  GetStorage box = GetStorage();

  Future gravarNome(String nome) async {
    return await box.write('usuaruo', nome);
  }

  Future lerNome() {
    if (box.hasData('usuario')) {
      _ctrNome.text = box.read('usuario');
    }
  }

  @override
  void initState() {
    lerNome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final repositoryCliente = Provider.of<RepositoryCliente>(context);
    repositoryCliente.countRegistry().then((value) {
      setState(() {
        totalClientes = value;
      });
    });

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[
          TextField(
            controller: _ctrNome,
            decoration: InputDecoration(labelText: 'Informe seu Nome'),
          ),
          FlatButton(
            onPressed: () {
              this.gravarNome(_ctrNome.text);
            },
            child: Text('Gravar'),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutes.PAGE_CLIENTES);
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.teal,
                    boxShadow: [BoxShadow(blurRadius: 2.0)],
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.people,
                        color: Colors.white,
                        size: 70,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'TOTAL DE CLIENTES (${totalClientes})',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 20),
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.warning),
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
            label: 'Limpar Tabela',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              repositoryCliente.clearTable().then((_) {
                setState(() {});
              });
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.add),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            label: 'Adicionar Teste',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              var cliente = Cliente(
                  nome: 'Teste',
                  email: 'teset@tese.com',
                  tipo: 'JURIDICA',
                  sincronizado: 0);
              repositoryCliente.insertCliente(cliente);
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.list),
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
            label: 'Consultar Clientes',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.PAGE_CLIENTES);
            },
          ),
        ],
      ),
    );
  }
}
