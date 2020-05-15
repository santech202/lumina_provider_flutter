import 'dart:io';

import 'package:custom_switch/custom_switch.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:lumina/models/home_models/device.dart';
import 'package:lumina/providers/devices_model.dart';
import 'package:lumina/providers/group_home_model.dart';

import 'package:provider/provider.dart';

class GroupDeviceList extends StatefulWidget {

  final List<Device> devices;

  GroupDeviceList({@required this.devices});

  _GroupDeviceListState createState() => _GroupDeviceListState();

}

class _GroupDeviceListState extends State<GroupDeviceList>{

  ScrollController _rrectController = ScrollController();

  final themeColor = Color(0xfff5a623);
  final primaryColor = Color(0xff203152);

  int i;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollbar.semicircle(
      controller: _rrectController,
      backgroundColor: Colors.blue,

      child: ListView.builder(
        controller: _rrectController,
        itemCount: widget.devices.length,
        itemBuilder: (BuildContext context, int index){
          return GestureDetector(
            onLongPress: (){
              setState(() {
                i = index;
              });

              openDialog();

            },
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)
              ),
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: index % 4 == 0
                        ? [Color(0xffed742e), Color(0xfff8ea4d)]
                        : index % 4 == 1
                        ? [Color(0xff8339e8), Color(0xff492ac8)]
                        : index % 4 == 2
                        ? [Color(0xffe4437c), Color(0xff5f37f0)]
                        : [Color(0xff367be4), Color(0xff0000ff)],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.0),
                  ),
                ),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 10.0, left: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              child: widget.devices[index].isLike
                                  ? Icon(Icons.star, color: Colors.white)
                                  : Icon(Icons.star_border, color: Colors.white,),
                              onTap: (){
                                Provider.of<DeviceModel>(context, listen: false).toggleDevice(widget.devices[index]);
                              },
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5.0),
                              child: FutureBuilder(
                                  future: convert_address(widget.devices[index].id),
                                  builder: (context, snapshot){
                                    return snapshot.data != null
                                        ? Text(
                                          snapshot.data,
                                          style: TextStyle(color: Colors.white),
                                        )
                                        : FutureBuilder(
                                            future: convert_address_dynamic(widget.devices[index].id),
                                            builder: (context, snapshot){
                                              return snapshot.data != null
                                                  ? Text(
                                                      snapshot.data,
                                                      style: TextStyle(color: Colors.white),
                                                    )
                                                  : Container();
                                            },
                                          );
                                  }
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              child: Text(
                                widget.devices[index].title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            Container(
                                height: 30,
                                width: 65,

                                decoration: BoxDecoration(
                                  color: widget.devices[index].isOn
                                      ? Colors.grey[500]
                                      : Colors.greenAccent[700],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: widget.devices[index].isOn
                                    ? Center(child: Text('Sunset', textAlign: TextAlign.center, ))
                                    : Center(child: Text('Sunrise', textAlign: TextAlign.center, style: TextStyle(color: Colors.white),))
                            ),
                            Container(
                                child: CustomSwitch(
                                  activeColor: Colors.greenAccent[700],
                                  value: widget.devices[index].isOn,
                                  onChanged: (value){
                                    print('VALUE: $value');
                                    setState(() {
                                      widget.devices[index].isOn = value;
                                    });
                                  },
                                )
                            )
                          ],
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 20.0, right: 30.0),
                          child: FlutterSlider(
                            values: [widget.devices[index].lowervalue],
                            max: 100,
                            min: 0,
                            onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                              setState(() {
                                widget.devices[index].lowervalue = lowerValue;
                              });
                            },
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Future<Null> openDialog() async{
    switch(await showDialog(
        context: context,
        builder: (BuildContext context){
          return SimpleDialog(
            contentPadding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
            children: <Widget>[
              Container(
                color: themeColor,
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                height: 100.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      'Remove Group',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      'Are you sure to remove this group?',
                      style: TextStyle(color: Colors.white70, fontSize: 14.0),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: (){
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.cancel,
                        color: primaryColor,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'CANCEL',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: (){

                  Delete_group();

                  try{
                    Delete_group_dynamic();
                  }catch(e){
                    print(e);
                  }

                  Provider.of<DeviceModel>(context, listen: false).deleteDevice(widget.devices[i]);
                  Navigator.pop(context, 0);

                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle,
                        color: primaryColor,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'YES',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        }
    )){
      case 0:
        break;
      case 1:
        exit(0);
        break;
    }
  }

  void Delete_group(){

    List group_id = widget.devices[i].id;
    int length = group_id.length;
    final allGroup = Provider.of<GroupHomeModel>(context, listen: false).allGroupHomes;

    switch(length){
      case 3:

        for(int i_home = 0; i_home < allGroup.length ; i_home++){
          for(int i_room = 0; i_room < allGroup[i_home].group_room.length; i_room ++){
            for(int i_window = 0; i_window < allGroup[i_home].group_room[i_room].group_window.length; i_window ++){

              List current_id = allGroup[i_home].group_room[i_room].group_window[i_window].id;
              if(listEquals(current_id, group_id)){
                setState(() {
                  allGroup[i_home].group_room[i_room].group_window[i_window].islock = false;
                  allGroup[i_home].group_room[i_room].group_window[i_window].isGroup = false;
                });
                break;
              }
            }
          }
        }
        break;

      case 2:
        for(int i_home = 0; i_home < allGroup.length ; i_home++){
          for(int i_room = 0; i_room < allGroup[i_home].group_room.length; i_room ++){

            List current_id = allGroup[i_home].group_room[i_room].id;

            if(listEquals(current_id, group_id)){
              setState(() {
                allGroup[i_home].group_room[i_room].islock = false;
                allGroup[i_home].group_room[i_room].isGroup = false;
              });
              break;
            }
          }
        }
        break;

      case 1:

        for(int i_home = 0; i_home < allGroup.length ; i_home++){

          List current_id = allGroup[i_home].id;
          if(listEquals(current_id, group_id)){
            setState(() {
              allGroup[i_home].islock = false;
              allGroup[i_home].isGroup = false;
            });
            break;
          }
        }
        break;
    }


  }

  void Delete_group_dynamic(){

    List group_id = widget.devices[i].id;

    final allGroup = Provider.of<GroupHomeModel>(context, listen: false).allGroupHomes;

    if(group_id.length == 3){

      int home_id = group_id[0];
      int room_id = group_id[1];
      int window_id = group_id[2];

      setState(() {
        allGroup[home_id].group_room[room_id].group_window[window_id].islock = false;
        allGroup[home_id].group_room[room_id].group_window[window_id].isGroup = false;
      });

    }if(group_id.length == 2){

      int home_id = group_id[0];
      int room_id = group_id[1];

      setState(() {
        allGroup[home_id].group_room[room_id].islock = false;
        allGroup[home_id].group_room[room_id].isGroup = false;
      });
    }if(group_id.length == 1){

      int home_id = group_id[0];

      setState(() {
        allGroup[home_id].islock = false;
        allGroup[home_id].isGroup = false;
      });
    }


  }

  Future<String> convert_address_dynamic(List id) async{

    int length = id.length;

    switch(length){
      case 4:

        int i_home = id[0];
        int i_room = id[1];
        int i_window = id[2];

        final allGroups = Provider.of<GroupHomeModel>(context, listen: false).allGroupHomes;

        String st_home = allGroups[i_home].group_home_title;
        String st_room = allGroups[i_home].group_room[i_room].group_room_title;
        String st_window = allGroups[i_home].group_room[i_room].group_window[i_window].group_window_title;

        String Address = st_home + " / " + st_room + " / " + st_window;
        return Address;
        break;

      case 3:

        int i_home = id[0];
        int i_room = id[1];


        final allGroups = Provider.of<GroupHomeModel>(context, listen: false).allGroupHomes;

        String st_home = allGroups[i_home].group_home_title;
        String st_room = allGroups[i_home].group_room[i_room].group_room_title;

        String Address = st_home + " / " + st_room;
        return Address;
        break;

      case 2:

        int i_home = id[0];

        final allGroups = Provider.of<GroupHomeModel>(context, listen: false).allGroupHomes;

        String st_home = allGroups[i_home].group_home_title;

        String Address = st_home;
        return Address;
        break;

    }

  }

  Future<String> convert_address(List id) async{

    int length = id.length;
    String st_home, st_room, st_window;
    final allGroups = Provider.of<GroupHomeModel>(context, listen: false).allGroupHomes;

    switch(length){
      case 4:

        for(int i_home = 0; i_home < allGroups.length; i_home ++){
          for (int i_room = 0; i_room < allGroups[i_home].group_room.length; i_room ++ ){
            for(int i_window = 0; i_window < allGroups[i_home].group_room[i_room].group_window.length; i_window ++){
              for(int i_device = 0; i_device < allGroups[i_home].group_room[i_room].group_window[i_window].device.length; i_device ++){

                List current_id = allGroups[i_home].group_room[i_room].group_window[i_window].device[i_device].id;
                if(listEquals(current_id, id)){

                  st_home = allGroups[i_home].group_home_title;
                  st_room = allGroups[i_home].group_room[i_room].group_room_title;
                  st_window = allGroups[i_home].group_room[i_room].group_window[i_window].group_window_title;
                  break;
                }


              }
            }
          }
        }


        String Address = st_home + " / " + st_room + " / " + st_window;
        return Address;
        break;

      case 3:

        for(int i_home = 0; i_home < allGroups.length; i_home ++){
          for (int i_room = 0; i_room < allGroups[i_home].group_room.length; i_room ++ ){
            for(int i_window = 0; i_window < allGroups[i_home].group_room[i_room].group_window.length; i_window ++){

              List current_id = allGroups[i_home].group_room[i_room].group_window[i_window].id;

              if(listEquals(current_id, id)){

                st_home = allGroups[i_home].group_home_title;
                st_room = allGroups[i_home].group_room[i_room].group_room_title;
                break;
              }


            }
          }
        }


        String Address = st_home + " / " + st_room;
        return Address;
        break;

      case 2:

        for(int i_home = 0; i_home < allGroups.length; i_home ++){
          for (int i_room = 0; i_room < allGroups[i_home].group_room.length; i_room ++ ){

            List current_id = allGroups[i_home].group_room[i_room].id;

            if(listEquals(current_id, id)){

              st_home = allGroups[i_home].group_home_title;
              break;
            }


          }
        }

        String Address = st_home;
        return Address;
        break;

    }

  }
}