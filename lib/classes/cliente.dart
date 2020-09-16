class Cliente {
  int id;
  String nome;
  String email;
  String tipo;
  int sincronizado;

  Cliente({this.id, this.nome, this.email, this.tipo, this.sincronizado});

  Cliente.fromMap(Map<String, dynamic> mapCliente) {
    id = mapCliente['id'];
    nome = mapCliente['nome'];
    email = mapCliente['email'];
    tipo = mapCliente['tipo'];
    sincronizado = mapCliente['sincronizado'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'tipo': tipo,
      'sincronizado': sincronizado
    };
  }
}
