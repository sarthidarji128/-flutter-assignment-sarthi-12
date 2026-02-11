import 'package:flutter/material.dart';
import '../models/flower.dart';

class ViewFlowerScreen extends StatefulWidget {
  ViewFlowerScreenState createState() => ViewFlowerScreenState();
}

class ViewFlowerScreenState extends State<ViewFlowerScreen> {
  Widget build(BuildContext context) {
    final Flower flower = ModalRoute.of(context)!.settings.arguments as Flower;
    return Scaffold(
      appBar: AppBar(title: Text('List Flower')),
      body: Center(
        child: Column(
          children: [
            Text("View Flower"),
            Image.network(
              flower.imageUrl,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            Text(flower.name),
            Text(flower.description),
            Text(flower.pdfUrl),
          ],
        ),
      ),
    );
  }
}
