import 'package:flutter/material.dart';
import 'package:pets/views/widgets/BotaoCustomizado.dart';
import 'package:pets/views/widgets/InputCustomizado.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/User.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _cadastrar = false;
  String _mensagemErro = "";
  String _textoBotao = "Entrar";
  final TextEditingController _controllerEmail =
      TextEditingController(text: "jessica@gmail.com");
  final TextEditingController _controllerSenha =
      TextEditingController(text: "1234567");

  _cadastrarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .createUserWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {});
  }

  _logarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {
      Navigator.pushReplacementNamed(context, "/donation");
    });
  }

  _validarCampos() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty && senha.length > 6) {
        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        if (_cadastrar) {
          _cadastrarUsuario(usuario);
        } else {
          _logarUsuario(usuario);
        }
      } else {
        setState(() {
          _mensagemErro = "Preencha a senha! digite mais de 6 caracteres";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Preencha o E-mail válido";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                    padding: EdgeInsets.only(bottom: 32),
                    child: Image.asset(
                      "assets/paws.png",
                      width: 150,
                      height: 120,
                    )),
                InputCustomizado(
                  controller: _controllerEmail,
                  hint: "E-mail",
                  autofocus: true,
                  type: TextInputType.emailAddress,
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
                InputCustomizado(
                  controller: _controllerSenha,
                  hint: "Senha",
                  obscure: true,
                  type: TextInputType.text,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Logar"),
                    Switch(
                        activeColor: Colors.green,
                        value: _cadastrar,
                        onChanged: (bool valor) {
                          setState(() {
                            _cadastrar = valor;
                            _textoBotao = "Entrar";
                            if (_cadastrar) {
                              _textoBotao = "Cadastrar";
                            }
                          });
                        }),
                    Text("Cadastrar")
                  ],
                ),
                BotaoCustomizado(
                  texto: "Entrar",
                  onPressed: () {
                  _validarCampos();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    _mensagemErro,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
