import 'package:flutter/material.dart';
import '../services/flower_service.dart';
import '../models/flower.dart';

class ListFlowerScreen extends StatefulWidget {
  ListFlowerScreenState createState() => ListFlowerScreenState();
}

class ListFlowerScreenState extends State<ListFlowerScreen> {
  List<Flower> flowers = [];

  void loadFlowers() async {
    await FlowerService.getFlowers().then(
      (value) => {
        setState(() {
          flowers = List<Flower>.from(value);
        }),
      },
    );
  }

  void initState() {
    super.initState();
    loadFlowers();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flower List')),
      body: ListView.builder(
        itemCount: flowers.length,
        itemBuilder: (context, index) {
          Flower flower = flowers[index];
          return ListTile(
            title: Text(flower.name),
            subtitle: Text(flower.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/view-flower', arguments: flower);
                  },
                ),
                IconButton(icon: Icon(Icons.edit), onPressed: () async {
                  await Navigator.of(context).pushNamed('/edit-flower', arguments: flower);
                  loadFlowers();
                }),
                IconButton(icon: Icon(Icons.delete), onPressed: () async {
                  await FlowerService.deleteFlower(flower.id);
                  loadFlowers();
                }),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed('/add-flower');
          loadFlowers();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
