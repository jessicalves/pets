import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final Color corTexto;

  const BotaoCustomizado(
      {Key? key,
      required this.texto,
      required this.onPressed,
      this.corTexto = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
        elevation: MaterialStateProperty.all<double>(5),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            texto,
            style: TextStyle(fontSize: 16, color: corTexto),
          ),
        ],
      ),
    );
  }
}
