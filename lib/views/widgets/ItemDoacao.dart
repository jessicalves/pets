import 'package:flutter/material.dart';
import 'package:pets/models/Donation.dart';

class ItemDoacao extends StatelessWidget {
  final Donation donation;
  final VoidCallback onTapItem;
  final VoidCallback? onPressedRemover;

  const ItemDoacao({
    Key? key,
    required this.donation,
    required this.onTapItem,
    this.onPressedRemover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapItem,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        donation.titulo,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        donation.descricao,
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Contato: ${donation.contato}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${donation.cidade}-${donation.estado}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              if (onPressedRemover != null)
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: onPressedRemover,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
