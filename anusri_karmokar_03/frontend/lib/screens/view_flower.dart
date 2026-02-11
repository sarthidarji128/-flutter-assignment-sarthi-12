import 'package:flutter/material.dart';
import '../models/flower.dart';

class ViewFlowerScreen extends StatelessWidget {
 
  Widget build(BuildContext context) {

    final Flower flower = ModalRoute.of(context)!.settings.arguments as Flower;

    return Scaffold(
      appBar: AppBar(
        title: Text('Flower Details'),
      ),
      body: Center(
        child: Column(
            children:[
                if(flower.imageUrl != null && flower.imageUrl!.isNotEmpty)
                  Image.network(flower.imageUrl!,width:200,height:200,fit: BoxFit.cover),
                Text(flower.name),
                Text(flower.description),
            ]
        )
      ),
    );
  }
}
