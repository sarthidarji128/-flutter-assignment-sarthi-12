import 'package:flutter/material.dart';
import './screens/add_flower.dart';
import './screens/list_flower.dart';
import './screens/view_flower.dart';
import './screens/edit_flower.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flower App",
      initialRoute: '/',
      routes: {
        '/': (context) => ListFlowerScreen(),
        '/add-flower': (context) => AddFlowerScreen(),
        '/view-flower': (context) => ViewFlowerScreen(),
        '/edit-flower': (context) => EditFlowerScreen(),
      },
    );
  }
}
