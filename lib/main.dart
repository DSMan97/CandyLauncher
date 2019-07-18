import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:launcher_assist/launcher_assist.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new CandyLauncher());



class CandyLauncher extends StatefulWidget {

  @override
  State createState() => new _CandyLauncherState();

}

class _CandyLauncherState extends State<CandyLauncher> {

  var installedAppDetails;
  var userWallpaper;
  var menuAppDetails;
  List<dynamic> mApps =  List<dynamic>();
  List<dynamic> mAppsImage =  List<dynamic>();

  @override
  Widget build(BuildContext context) {
    if(installedAppDetails != null) {
      List<Widget> appWidgets = getAppIcons();
      return new MaterialApp(
          home: DefaultTabController(
          length: 2,
          child: Scaffold(
            resizeToAvoidBottomPadding: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: TabBar(
                indicatorColor: Colors.red,
                labelColor: Colors.white,
                isScrollable: true,
                tabs: [
                  Tab(icon: Icon(Icons.home)),
                  Tab(icon: Icon(Icons.apps)),
                ],
              ),
              actions: <Widget>[
                IconButton(icon: Icon(Icons.settings), onPressed: launchSettings,)
              ],
            ),

              body: TabBarView(
                children: [
                  Stack(
                      children: <Widget>[
                        userWallpaper = new Image.asset("images/wallpaper.jpeg",
                            fit: BoxFit.cover,
                            height: double.infinity,
                            width: double.infinity
                        ),
                        new Padding(
                            padding: new EdgeInsets.only(top: 0.0),
                            child: new GridView.count(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: getMenu(),
                                crossAxisCount: 3,
                                crossAxisSpacing: 16.0,
                                mainAxisSpacing: 20.0,
                                childAspectRatio: 1.0,
                                padding: const EdgeInsets.all(16.0)
                            )
                        )
                      ]
                  ),
              Stack(
              children: <Widget>[
              userWallpaper = new Image.asset("images/wallpaper.jpeg",
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity
              ),
              new Padding(
                  padding: new EdgeInsets.only(top: 0.0),
                  child: new GridView.count(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: appWidgets,
                      crossAxisCount: 5,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 20.0,
                      childAspectRatio: 1.0,
                      padding: const EdgeInsets.all(16.0)
                  )
              )
              ]
          ),

                ],
              ),
          ),
          ),
      );
    } else {
      return new Center();
    }
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight
    ]);
    loadMenuStuff();
    loadNativeStuff();

  }

  void loadNativeStuff() {
    LauncherAssist.getAllApps().then((_appDetails) {
      setState(() {
        installedAppDetails = _appDetails;
      });
    });
  }

  void loadMenuStuff() {
    LauncherAssist.getAllApps().then((_appDetails) {
      setState((){
        menuAppDetails = _appDetails;
        for(var i=0;i<menuAppDetails.length;i++) {
          if(menuAppDetails[i]["package"]=="es.plus.yomvi"){
            print("Menu: " + menuAppDetails[i]["package"]);
            var h = menuAppDetails[i];
            mApps.add(h);
            mAppsImage.add("images/Movistar_plus.png");
          }
        }
        for(var i=0;i<menuAppDetails.length;i++) {
          if(menuAppDetails[i]["package"]=="com.netflix.mediaclient"){
            print("Menu: " + menuAppDetails[i]["package"]);
            var h = menuAppDetails[i];
            mApps.add(h);
            mAppsImage.add("images/Netflix.png");
          }
        }
        for(var i=0;i<menuAppDetails.length;i++) {
          if(menuAppDetails[i]["package"]=="com.amazon.avod.thirdpartyclient"){
            print("Menu: " + menuAppDetails[i]["package"]);
            var h = menuAppDetails[i];
            mApps.add(h);
            mAppsImage.add("images/Prime.png");
          }
        }
        for(var i=0;i<menuAppDetails.length;i++) {
          if(menuAppDetails[i]["package"]=="com.mitelelite"){
            print("Menu: " + menuAppDetails[i]["package"]);
            var h = menuAppDetails[i];
            mApps.add(h);
            mAppsImage.add("images/mitele.png");
          }
        }
        for(var i=0;i<menuAppDetails.length;i++) {
          if(menuAppDetails[i]["package"]=="com.a3.sgt"){
            print("Menu: " + menuAppDetails[i]["package"]);
            var h = menuAppDetails[i];
            mApps.add(h);
            mAppsImage.add("images/a3p.png");
          }
        }

        print("Menu2 " + mApps.length.toString());

      });
    });
  }

  getMenu() {
    List<Widget> appWidgets = [];
    for(var i=0;i<mApps.length;i++) {
      if(mApps[i]["package"] == "com.progur.candy") continue;
      var label = new Text(mApps[i]["label"],
          style: new TextStyle(fontSize: 10.0,
              color: Colors.black,
              decoration: TextDecoration.none,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.normal
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center
      );
      var labelContainer = new Container(
          decoration: new BoxDecoration (
              color: Colors.transparent,
              borderRadius: new BorderRadius.all(new Radius.circular(5.0))
          ),
          child: label,
          padding: new EdgeInsets.all(4.0),
          margin: new EdgeInsets.only(top: 4.0)
      );
      var image = new Image.asset(mAppsImage[i]);
      var icon = new Image.memory(mApps[i]["icon"],
          fit: BoxFit.scaleDown, width: 48.0, height: 48.0);
      appWidgets.add(new GestureDetector(
          onTap: () {
            launchApp(mApps[i]["package"]);
          },
          child: new Card(
            margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child: new Column(
                  children: <Widget>[image, labelContainer]
              )
          )
      )
      );
    }
    return appWidgets;
  }

   getAppIcons() {
    List<Widget> appWidgets = [];
    for(var i=0;i<installedAppDetails.length;i++) {
      if(installedAppDetails[i]["package"] == "com.progur.candy") continue;
      var label = new Text(installedAppDetails[i]["label"],
          style: new TextStyle(fontSize: 10.0,
              color: Colors.white,
              decoration: TextDecoration.none,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.normal
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center
      );
      var labelContainer = new Container(
          decoration: new BoxDecoration (
              color: Colors.transparent,
              borderRadius: new BorderRadius.all(new Radius.circular(5.0))
          ),
          child: label,
          padding: new EdgeInsets.all(4.0),
          margin: new EdgeInsets.only(top: 4.0)
      );
      var icon = new Image.memory(installedAppDetails[i]["icon"],
          fit: BoxFit.scaleDown, width: 48.0, height: 48.0);
      appWidgets.add(new GestureDetector(
          onTap: () {
            launchApp(installedAppDetails[i]["package"]);
          },
          child: new GridTile(
              child: new Column(
                  children: <Widget>[icon, labelContainer]
              )
          )
      )
      );
    }
    return appWidgets;
  }

  void launchApp(String packageName) {
    LauncherAssist.launchApp(packageName);
  }
  void launchSettings() {
    LauncherAssist.launchApp("com.android.settings");
  }
}