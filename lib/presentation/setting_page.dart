import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodie_hub/provider/scheduling_provider.dart';
import 'package:foodie_hub/utils/style_manager.dart';
import 'package:foodie_hub/widgets/custom_dialog.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return ListView(children: [
      Material(
        child: ListTile(
            title: Text(
              'Daily Notifications',
              style: getBlackTextStyle(),
            ),
            trailing: Consumer<SchedulingProvider>(
              builder: (context, scheduled, _) {
                return Switch.adaptive(
                  value: scheduled.isScheduled,
                  onChanged: (value) async {
                    if (Platform.isIOS) {
                      customDialog(context);
                    } else {
                      scheduled.scheduledNews(value);
                    }
                  },
                );
              },
            )),
      )
    ]);
  }
}
