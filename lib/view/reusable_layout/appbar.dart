import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Food Recipe'),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);


}