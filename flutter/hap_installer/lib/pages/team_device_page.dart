
import 'package:flutter/material.dart';
import 'package:hap_installer/EcoViewModel.dart';
import 'package:provider/provider.dart';

class TeamDevicePage extends StatelessWidget {
  const TeamDevicePage({super.key});

  List<Widget> teamList(EcoViewModel model){
    if(!model.isLogin) {
      return [ListTile(title: Text("请登录！"))];
    }
    return model.teamList.map((t){
          return  ListTile(title: Text(t.name), selected: model.userInfo?.teamId == t.id, onTap: (){
            model.changeTeam(t);
          },);
    }).toList();
  }
  List<Widget> deviceList(EcoViewModel model){
    if(model.deviceList.isEmpty) {
      return [ListTile(title: Text("请连接设备！"))];
    }
    return model.deviceList.map((t){
        return  ListTile(
          title: Text(t), 
          selected: true, 
          onTap: (){
            model.changeDevice(t);
          });
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<EcoViewModel>(builder: (_, model, child){
        return ListView(children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
                child: Text("当前连接", style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              Padding(padding: const EdgeInsets.all(10), child: Text("团队")),
              ...teamList(model),
              Padding(padding: const EdgeInsets.all(10), child: Text("设备")),
              ...deviceList(model),

          ]);
    });
    
  }


}