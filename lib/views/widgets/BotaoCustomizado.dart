import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final Color corTexto;

  const BotaoCustomizado({
    Key? key,
    required this.texto,
    required this.onPressed,
    this.corTexto = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, 50),
        backgroundColor: Colors.green,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        texto,
        style: TextStyle(fontSize: 16, color: corTexto),
      ),
    );
  }
}
