import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pets/models/Donation.dart';
import 'package:pets/views/widgets/BotaoCustomizado.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:estados_municipios/estados_municipios.dart';
import 'package:pets/views/widgets/InputCustomizado.dart';

class NewDonation extends StatefulWidget {
  const NewDonation({Key? key}) : super(key: key);

  @override
  State<NewDonation> createState() => _NewDonationState();
}

class _NewDonationState extends State<NewDonation> {
  final _formKey = GlobalKey<FormState>();
  List<DropdownMenuItem<String>> _litaEstados = [];
  List<DropdownMenuItem<String>> _litaCategoria = [];
  File? _image;
  final TextEditingController _controllerTitulo = TextEditingController();
  final TextEditingController _controllerDescricao = TextEditingController();
  final TextEditingController _controllerContato = TextEditingController();
  final TextEditingController _controllerCidade = TextEditingController();
  late Donation _doacao;

  Future<void> _selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage as File?;
      });
    }
  }

  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;
    return File(pickedFile.path);
  }

  Future _uploadImagens() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String nameImage = DateTime.now().microsecondsSinceEpoch.toString();
    Reference storageRef =
        storage.ref().child("doacoes").child(_doacao.id).child(nameImage);
    UploadTask uploadTask = storageRef.putFile(_image!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    String url = await taskSnapshot.ref.getDownloadURL();
    _doacao.foto = url;
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    _carregarItensDropDown();
    _doacao = Donation();
  }

  _carregarItensDropDown() async {
    final controller = EstadosMunicipiosController();
    final Estados = await controller.buscaTodosEstados();
    for (var estado in Estados) {
      _litaEstados.add(DropdownMenuItem(
        value: estado.id.toString(),
        child: Text(estado.sigla.toString()),
      ));
    }

    _litaCategoria.add(const DropdownMenuItem(
      value: "1",
      child: Text("Alimentos"),
    ));
    _litaCategoria.add(const DropdownMenuItem(
      value: "2",
      child: Text("Acessórios"),
    ));
    _litaCategoria.add(const DropdownMenuItem(
      value: "3",
      child: Text("Brinquedos"),
    ));
    _litaCategoria.add(const DropdownMenuItem(
      value: "4",
      child: Text("Medicamentos"),
    ));
    _litaCategoria.add(const DropdownMenuItem(
      value: "5",
      child: Text("Outros"),
    ));

    setState(() {
      _litaEstados;
      _litaCategoria;
    });
  }

  _salvarDoacao() async {
    await _uploadImagens();

    FirebaseAuth auth = FirebaseAuth.instance;
    var usuarioLogado = auth.currentUser;
    FirebaseFirestore db = FirebaseFirestore.instance;
    var doacoesRef = db
        .collection('minhas_doacoes')
        .doc(usuarioLogado?.uid)
        .collection("doacoes")
        .doc(_doacao.id)
        .set(_doacao.toMap())
        .then((value) => {Navigator.pushReplacementNamed(context, "/donation")});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Nova doação",
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/donation");
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormField<File>(
                  initialValue: _image,
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecione uma imagem.';
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 100,
                          child: GestureDetector(
                            onTap: () async {
                              _selectImage();
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[400],
                              radius: 50,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_image != null)
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Image.file(
                                                        _image!,
                                                        width: double.infinity,
                                                        height: 200,
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _image = null;
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          });
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(
                                                                      Colors
                                                                          .red),
                                                        ),
                                                        child: const Text(
                                                            'Remover'),
                                                      )
                                                    ],
                                                  ),
                                                ));
                                      },
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: FileImage(_image!),
                                        child: Container(
                                          color: const Color.fromRGBO(
                                              255, 255, 255, 0.4),
                                          alignment: Alignment.center,
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (_image == null)
                                    Icon(
                                      Icons.add_a_photo,
                                      size: 40,
                                      color: Colors.grey[100],
                                    ),
                                  if (_image == null)
                                    Text(
                                      "Adicionar",
                                      style: TextStyle(color: Colors.grey[100]),
                                    )
                                ],
                              ),
                            ),
                          ),
                        ),
                        state.hasError
                            ? Text(
                                state.errorText!,
                                style: TextStyle(color: Colors.red),
                              )
                            : Container(),
                      ],
                    );
                  },
                ),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: DropdownButtonFormField(
                        hint: const Text("Estados"),
                        onSaved: (estado) {
                          _doacao.estado = estado!;
                        },
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                        items: _litaEstados,
                        onChanged: (_) {},
                      ),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: DropdownButtonFormField(
                        hint: const Text("Categorias"),
                        onSaved: (categora) {
                          _doacao.categoria = categora!;
                        },
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                        items: _litaCategoria,
                        onChanged: (_) {},
                      ),
                    )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15, top: 15),
                  child: InputCustomizado(
                    onSubmitted: (titulo) {
                      _doacao.titulo = titulo;
                    },
                    hint: "Título",
                    controller: _controllerTitulo,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    hint: "Descricão",
                    onSubmitted: (descricao) {
                      _doacao.descricao = descricao;
                    },
                    controller: _controllerDescricao,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    hint: "Contato",
                    onSubmitted: (contato) {
                      _doacao.contato = contato;
                    },
                    controller: _controllerContato,
                    type: TextInputType.phone,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    hint: "Cidade",
                    onSubmitted: (cidade) {
                      _doacao.cidade = cidade;
                    },
                    controller: _controllerCidade,
                  ),
                ),
                BotaoCustomizado(
                  texto: "Salvar",
                  onPressed: () {
                    _formKey.currentState!.save();
                    _salvarDoacao();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
