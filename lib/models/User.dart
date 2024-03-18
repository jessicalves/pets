class Usuario {
  late String idUsuario;
  late String nome;
  late String email;
  late String senha;

  Usuario({
    required this.email,
    required this.senha,
    this.idUsuario = "",
    this.nome = "",
  });

  Map<String, dynamic> toMap() {
    return {
      "idUsuario": idUsuario,
      "nome": nome,
      "email": email,
    };
  }
}
