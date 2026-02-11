import 'package:flutter/material.dart';
// import 'dart:io';
import 'dart:typed_data';
// import 'package:image_picker/image_picker.dart';
import '../models/flower.dart';
import 'package:file_picker/file_picker.dart';
import '../services/flower_service.dart';

class EditFlowerScreen extends StatefulWidget {
  EditFlowerScreenState createState() => EditFlowerScreenState();
}

class EditFlowerScreenState extends State<EditFlowerScreen> {
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final oldImageURLController = TextEditingController();
  final oldPdfURLController = TextEditingController();

  // Web (Chrome) uploads as bytes
  Uint8List? webImageBytes;
  Uint8List? webPdfBytes;
  String? webPdfName;

  // Web (Chrome) specific upload functions - existing ones remain unchanged
  Future<void> uploadImageWeb() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        webImageBytes = result.files.single.bytes;
      });
    }
  }

  Future<void> uploadPdfWeb() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        webPdfBytes = result.files.single.bytes;
        webPdfName = result.files.single.name;
      });
    }
  }

  void editFlowerWeb() async {
    final response = await FlowerService.editFlowerWeb(
      id: idController.text,
      name: nameController.text,
      description: descriptionController.text,
      imageBytes: webImageBytes,
      pdfBytes: webPdfBytes,
      oldImageURL: oldImageURLController.text,
      oldPdfURL: oldPdfURLController.text,
    );
    print(response);
    if (response['message'] == 'Flower updated successfully') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Flower updated successfully!')));
      Navigator.of(context).pop();
    }
  }

  Widget build(BuildContext context) {
    final Flower flower = ModalRoute.of(context)!.settings.arguments as Flower;
    nameController.text = flower.name;
    descriptionController.text = flower.description;
    idController.text = flower.id;
    oldImageURLController.text = flower.imageUrl;
    oldPdfURLController.text = flower.pdfUrl;

    return Scaffold(
      appBar: AppBar(title: Text('Edit Flower')),
      body: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: 'Enter flower name',
            ),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Enter flower description',
            ),
          ),

          // Web / Chrome image upload
          ElevatedButton(
            child: Text('Upload Image (Web)'),
            onPressed: uploadImageWeb,
          ),
          if (webImageBytes != null)
            Image.memory(
              webImageBytes!,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),

          // Web / Chrome PDF upload
          ElevatedButton(
            child: Text('Upload Pdf (Web)'),
            onPressed: uploadPdfWeb,
          ),
          if (webPdfName != null) Text('Pdf Name (Web) :- $webPdfName'),

          // Web / Chrome Edit Flower
          ElevatedButton(
            child: Text('Edit Flower (Web)'),
            onPressed: editFlowerWeb,
          ),
        ],
      ),
    );
  }
}
