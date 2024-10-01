import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_recipe/view/responsive_layout/responsive_layout.dart';

import 'responsive_layout/desktop_body.dart';
import 'responsive_layout/mobile_body.dart';

class HomePageView extends StatefulWidget{
  const HomePageView({super.key});
  @override
  State<StatefulWidget>createState()=>_MainPageViewState();
}

class _MainPageViewState extends State<HomePageView>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        desktopBody: DesktopBody(),
        mobileBody: MobileBody()
      ),
    );
  }
}