import 'package:flutter/material.dart';

class DesktopBody extends StatefulWidget {
  const DesktopBody({Key? key}) : super(key: key);

  _DesktopBodyState createState()=>_DesktopBodyState();

}

class _DesktopBodyState extends State<DesktopBody>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Text('Desktop View'),
      ),
    );
  }
}