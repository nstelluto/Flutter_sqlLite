import 'package:app_sqlite/classes/cliente.dart';
import 'package:app_sqlite/repository/respository_cliente.dart';
import 'package:app_sqlite/widgets/widget_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageAdd extends StatefulWidget {
  @override
  _PageAddState createState() => _PageAddState();
}

class _PageAddState extends State<PageAdd> {
  var _isRadioValue = 0;
  var _ocupado = false;
  var _ctrId = TextEditingController();
  var _ctrNome = TextEditingController();
  var _ctrEmail = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  RepositoryCliente repository;
  Future gravaCliente() async {
    var cli = Cliente(
        nome: _ctrNome.text,
        email: _ctrEmail.text,
        tipo: (_isRadioValue == 0) ? 'FISICA' : 'JURIDICA',
        sincronizado: 0);
    return await repository.insertCliente(cli);
  }

  @override
  Widget build(BuildContext context) {
    this.repository = Provider.of<RepositoryCliente>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionado Cliente'),
      ),
      body: Visibility(
        visible: this._ocupado,
        child: Loader(
          texto: 'Gravando Cliente ...',
        ),
        replacement: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _ctrNome,
                      enabled: true,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Informe o Nome';
                        }
                      },
                    ),
                    TextFormField(
                      controller: _ctrEmail,
                      enabled: true,
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Informe o E-mail';
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Radio(
                          value: 0,
                          groupValue: this._isRadioValue,
                          onChanged: (value) {
                            setState(() {
                              this._isRadioValue = value;
                            });
                          },
                        ),
                        Text(
                          'FISICA',
                          style: TextStyle(fontSize: 16),
                        ),
                        Radio(
                          value: 1,
                          groupValue: this._isRadioValue,
                          onChanged: (value) {
                            setState(() {
                              this._isRadioValue = value;
                            });
                          },
                        ),
                        Text(
                          'JURIDICA',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    FlatButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            this._ocupado = true;
                          });
                          gravaCliente().then((_) {
                            Navigator.of(context).pop(true);
                          });
                        }
                      },
                      child: Text('GRAVAR'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
