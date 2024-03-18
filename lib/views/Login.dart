import 'package:firebase_analytics/firebase_analytics.dart';
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
  bool _carregando = false;
  late TextEditingController _controllerEmail;
  late TextEditingController _controllerSenha;

  @override
  void initState() {
    super.initState();
    _controllerEmail = TextEditingController();
    _controllerSenha = TextEditingController();
    _verificaUserLogado();
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerSenha.dispose();
    super.dispose();
  }

  void _verificaUserLogado() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacementNamed(context, "/donation");
    }
  }

  Future<void> _realizarAcao() async {
    final email = _controllerEmail.text.trim();
    final senha = _controllerSenha.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      setState(() {
        _mensagemErro = "Preencha todos os campos!";
      });
      return;
    }

    setState(() {
      _carregando = true;
      _mensagemErro = "";
    });

    try {
      if (_cadastrar) {
        await _cadastrarUsuario(Usuario(email: email, senha: senha));
      } else {
        await _logarUsuario(Usuario(email: email, senha: senha));
      }
    } catch (e) {
      setState(() {
        _mensagemErro = "Erro: $e";
        _carregando = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "Login Screen");
  }

  Future<void> _cadastrarUsuario(Usuario usuario) async {
    final auth = FirebaseAuth.instance;
    final firebaseUser = await auth.createUserWithEmailAndPassword(
      email: usuario.email,
      password: usuario.senha,
    );

    if (firebaseUser != null) {
      Navigator.pushReplacementNamed(context, "/donation");
    }
  }


  Future<void> _logarUsuario(Usuario usuario) async {
    final auth = FirebaseAuth.instance;
    final firebaseUser = await auth.signInWithEmailAndPassword(
      email: usuario.email,
      password: usuario.senha,
    );

    if (firebaseUser != null) {
      Navigator.pushReplacementNamed(context, "/donation");
    }
  }

  void _validarCampos() {
    final email = _controllerEmail.text;
    final senha = _controllerSenha.text;
    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty && senha.length > 6) {
        final usuario = Usuario(email: email, senha: senha);
        _cadastrar ? _cadastrarUsuario(usuario) : _logarUsuario(usuario);
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
        title:  Text(""),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "assets/paws.png",
                    width: 150,
                    height: 120,
                  ),
                ),
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
                    const Text("Logar"),
                    Switch(
                      activeColor: Colors.green,
                      value: _cadastrar,
                      onChanged: (bool valor) {
                        setState(() {
                          _cadastrar = valor;
                          _textoBotao = valor ? "Cadastrar" : "Entrar";
                        });
                      },
                    ),
                    const Text("Cadastrar"),
                  ],
                ),
                BotaoCustomizado(
                  texto: _textoBotao,
                  onPressed: _realizarAcao,
                ),
                _carregando
                    ? const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.green,
                    ),
                  ),
                )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    _mensagemErro,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
