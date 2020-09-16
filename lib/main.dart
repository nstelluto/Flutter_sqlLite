import 'package:app_sqlite/classes/app_routes.dart';
import 'package:app_sqlite/pages/page_add.dart';
import 'package:app_sqlite/pages/page_clientes.dart';
import 'package:app_sqlite/pages/page_edit.dart';
import 'package:app_sqlite/pages/page_principal.dart';
import 'package:app_sqlite/repository/respository_cliente.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<RepositoryCliente>(
          create: (_) => RepositoryCliente(),
        )
      ],
      child: MaterialApp(
        title: 'SQLite',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        routes: {
          AppRoutes.PAGE_PRINCIPAL: (_) => PagePrincipal(),
          AppRoutes.PAGE_CLIENTES: (_) => PageClientes(),
          AppRoutes.PAGE_ADD: (_) => PageAdd(),
          AppRoutes.PAGE_EDIT: (_) => PageEdit()
        },
      ),
    );
  }
}
