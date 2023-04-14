import 'package:flutter/material.dart';
import 'package:pets/models/Donation.dart';

class ItemDoacao extends StatelessWidget {
  Donation donation;
  VoidCallback onTapItem;
  VoidCallback onPressedRemover;

  ItemDoacao(
      {Key? key,
      required this.donation,
      required this.onTapItem,
      required this.onPressedRemover})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: 110,
                height: 110,
                child: Image.network(
                  donation.foto,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        donation.titulo,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(donation.descricao, style: TextStyle(fontSize: 14)),
                      Text(
                        'Contato: ' + donation.contato + '',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        donation.cidade + '-' + donation.estado,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              if (onPressedRemover != null)
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () {},
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
