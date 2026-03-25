import 'package:flutter/material.dart';
import 'package:frontend/constants/constant_texts.dart';
import 'package:frontend/constants/assets_path.dart';

class BoardingScreenBuilder{
  static const List<Map<String,dynamic>> pageviewBuilder=[
    {
      'title':ConstantTexts.boardingScreen1Title,
      'description':ConstantTexts.boardingScreen1Description,
      'image':BoardingScreenData.welcome
    },
    {
      'title':ConstantTexts.boardingScreen3Title,
      'description':ConstantTexts.boardingScreen3Description,
      'image':BoardingScreenData.findHomeImage
    },
    {
      'title': ConstantTexts.boardingScreen4Title,
      'description': ConstantTexts.boardingScreen4Description,
      'image': BoardingScreenData.verified,
    },
  ];

}