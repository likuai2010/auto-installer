import 'package:flutter/material.dart';
import 'package:hap_installer/EcoViewModel.dart';
import 'package:hap_installer/pages/Home.dart';

class SplashScreen extends StatelessWidget{
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: viewmodel.init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: Column(children: [CircularProgressIndicator(), Text("请稍等...")], crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,)),
          );
        } else {
          return const Home();
        }
      },
    );
  }
}