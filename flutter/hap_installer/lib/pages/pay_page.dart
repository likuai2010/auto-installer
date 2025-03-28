import 'package:flutter/material.dart';
import 'package:hap_installer/HistoryViewModel.dart';
import 'package:provider/provider.dart';

class PayPage extends StatelessWidget {
  const PayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    Widget _payList(BuildContext context, HistoryViewModel model){
      return SizedBox(
        width: 200,
        height: 200,
        child: Image.asset('assets/pay/weixin.jpg')   ,
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('充电支持')),
      body:  Consumer<HistoryViewModel>( builder: (context, model, child) {
        final texttheme = Theme.of(context).textTheme;
        return Expanded(
            child: Column(children: [
                Padding(padding: const EdgeInsets.all(5), child: Text("本软件为免费软件不会强制收取您任何费用。如果您觉得我们的软件对您有帮助，欢迎扫码赞赏。", style: texttheme.labelSmall,)),
                SizedBox(height: 10),
                Expanded(child:  _payList(context, model)),
            ])
            );
      }),
    );
  }
}
