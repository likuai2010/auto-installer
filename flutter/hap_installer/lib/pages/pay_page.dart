import 'package:flutter/material.dart';
import 'package:hap_installer/HistoryViewModel.dart';
import 'package:provider/provider.dart';

class PayPage extends StatelessWidget {
  const PayPage({super.key});

  Widget _payList(BuildContext context, HistoryViewModel model) {
    // return SizedBox(
    //   width: 200,
    //   height: 200,
    //   child: Image.asset('assets/pay/weixin.jpg')   ,
    // );
    final columns = MediaQuery.of(context).size.width / 120;
    return GridView.count(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      childAspectRatio: 1.5,
      crossAxisCount: columns.toInt(),
      children: List.generate(model.payList.payList.length, (i) {
        return Card.filled(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text(model.payList.payList[i].nick),
                Expanded(child: Container()),
                Text(model.payList.payList[i].amount),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final hm = Provider.of<HistoryViewModel>(context);
    hm.fetchPayList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('充电支持'),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: const Text("充电"),
                    content: SizedBox(
                      width: 300,
                      height: 400,
                      child: Column(
                        children: [
                          const Text("如果您觉得我们的软件对您有帮助，欢迎扫码赞赏。"),
                          SizedBox(
                            width: 240,
                            height: 240,
                            child: Image.asset("assets/pay/weixin.jpg"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: const Text("赞赏"),
          ),
        ],
      ),
      body: Consumer<HistoryViewModel>(
        builder: (context, model, child) {
          final texttheme = Theme.of(context).textTheme;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Text(
                  "更新时间: ${model.payList.time}",
                  style: texttheme.labelSmall,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(child: _payList(context, model)),
            ],
          );
        },
      ),
    );
  }
}
