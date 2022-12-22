import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserProductItemTile extends StatelessWidget {
  const UserProductItemTile(
      {super.key, required this.title, required this.imageUrl});
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(imageUrl),
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                  icon: Icon(Icons.edit),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).errorColor,
                  onPressed: () {}),
            ],
          ),
        ));
  }
}
