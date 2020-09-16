import 'package:app_sqlite/classes/app_routes.dart';
import 'package:app_sqlite/classes/cliente.dart';
import 'package:app_sqlite/repository/respository_cliente.dart';
import 'package:app_sqlite/widgets/widget_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageClientes extends StatefulWidget {
  @override
  _PageClientesState createState() => _PageClientesState();
}

class _PageClientesState extends State<PageClientes> {
  bool _ocupado = false;
  List<Cliente> _lista = List<Cliente>();
  RepositoryCliente repositoryCliente = RepositoryCliente();

  Future consultaClientes() async {
    this._lista = await repositoryCliente.getClientes();
    this._ocupado = false;
    setState(() {});
  }

  Future consultaClienteNome(String nome) async {
    this._lista.clear();
    this._lista = await repositoryCliente.getClientesNome(nome);
    setState(() {});
  }

  Future excluiCliente(Cliente cliente) async {
    await repositoryCliente.deleteCliente(cliente);
  }

  @override
  void initState() {
    consultaClientes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            labelText: 'Pesquisa por nome',
          ),
          onChanged: (value) {
            this.consultaClienteNome(value);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              this._ocupado = true;
              setState(() {});
              consultaClientes();
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.PAGE_ADD).then((retorno) {
            this._ocupado = true;
            setState(() {
              this.consultaClientes();
            });
          });
        },
      ),
      body: Visibility(
        visible: this._ocupado,
        child: Loader(
          texto: 'Testando Loader ...',
        ),
        replacement: ListView.builder(
          itemCount: _lista.length,
          itemBuilder: (context, index) {
            Cliente cliente = _lista.elementAt(index);
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
              isThreeLine: true,
              title: Text(cliente.nome),
              subtitle: Text('# ${cliente.id}' + '\n' + cliente.email),
              trailing: Container(
                width: 100,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.PAGE_EDIT, arguments: cliente)
                            .then((retorno) {
                          if (retorno) {
                            this._ocupado = true;
                            setState(() {
                              this.consultaClientes();
                            });
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Exclusão'),
                            content: Text('Deseja excluir esse cliente?'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text(
                                  'NÃO',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Text(
                                  'SIM',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ).then((retorno) {
                          if (retorno) {
                            this.excluiCliente(cliente).then((_) {
                              this._ocupado = true;
                              setState(() {
                                consultaClientes();
                              });
                            });
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
