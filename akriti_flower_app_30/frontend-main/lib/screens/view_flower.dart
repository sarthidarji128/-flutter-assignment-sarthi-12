import 'package:flutter/material.dart';
import '../services/flower_service.dart';
import '../models/flower.dart';

class ViewFlowerScreen extends StatelessWidget{

  
     
     Widget build(BuildContext context){
          final Flower flower = ModalRoute.of(context)!.settings.arguments as Flower;

        return Scaffold(
            appBar: AppBar(
                title:Text('View Flower'),

            ),
            body:Center(
                child:Column(
                    children:[
                        Image.network(
                            flower.imageUrl,width:200,height:200,fit:BoxFit.cover
                        ),
                        Text(flower.name),
                        Text(flower.description),                    ]
                )
            ),
        );
     }
}