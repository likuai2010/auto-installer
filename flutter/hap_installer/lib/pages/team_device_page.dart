
import 'package:flutter/material.dart';
import 'package:hap_installer/EcoViewModel.dart';
import 'package:provider/provider.dart';

class TeamDevicePage extends StatelessWidget {
  const TeamDevicePage({super.key});

  List<Widget> teamList(EcoViewModel model){
    if(!model.isLogin) {
      return [const ListTile(title: Text("无"))];
    }
    return model.teamList.map((t){
          return  ListTile(title: Text(t.name), selected: model.userInfo?.teamId == t.id, onTap: (){
            model.changeTeam(t);
          },);
    }).toList();
  }
  List<Widget> deviceList(EcoViewModel model){
    if(model.deviceList.isEmpty) {
      return [const ListTile(title: Text("无"))];
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
   List<Widget> historyList(BuildContext context, EcoViewModel model){
    if(model.historyList.isEmpty) {
      return [const ListTile(title: Text("无"))];
    }
    return model.historyList.map((t){
        return  ListTile(
          title: Text(t), 
          selected: true, 
          onTap: (){
            model.tryConnectToDevice(context, t);
          });
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    
    return Consumer<EcoViewModel>(builder: (_, model, child){
        return ListView(children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
                child: const Text("当前状态", style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              const Padding(padding: EdgeInsets.all(10), child: Text("团队")),
              ...teamList(model),
              const Padding(padding: EdgeInsets.all(10), child: Text("可用设备")),
              ...deviceList(model),
              Padding(padding: const EdgeInsets.all(10), child: Row(children: [
                const  Expanded(child: Text("历史连接")),
                TextButton(onPressed: (){
                  model.resetHistory();
                }, child:  const Text("清除"))
              ],)),
              ...historyList(context, model),
          ]);
    });
    
  }


}