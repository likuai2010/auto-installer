import 'package:flutter/material.dart';

class HdcCmdPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('命令行工具')),
      body: Padding(padding: EdgeInsets.all(10), 
      child: Expanded(
          child: 
            Container(
              constraints: BoxConstraints.expand(),
              color: Colors.black,
              child:  Text("", style: TextStyle(color: Colors.white))
            )
        ),
      ),
      bottomNavigationBar:Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: Row(
          children: [ Expanded(child: TextField()), SizedBox(width: 10), IconButton(onPressed: (){}, icon: Icon(Icons.check_circle))],
      )),
    );
  }
}