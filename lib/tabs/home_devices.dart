import 'package:flutter/material.dart';
import 'package:lumina/providers/devices_model.dart';
import 'package:lumina/providers/schedule_model.dart';
import 'package:lumina/providers/setting_model.dart';
import 'package:lumina/widgets/device_list.dart';
import 'package:provider/provider.dart';


class home_devices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Consumer<DeviceModel>(
          builder: (context, todos, child) => DeviceList(
            devices: todos.realDevices,
          ),
        ),
      ),
    );
  }
}
