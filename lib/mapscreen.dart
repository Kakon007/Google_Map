import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map_flutter_app/mapdata.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flushbar/flushbar.dart';


class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _controller;
  static GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String searchaddress;
  // Future<MapDataModel> jobs;
  static const LatLng _center = const LatLng(23.773649, 90.411472);
  // static const LatLng _anotherLatLng = const LatLng(23.782448, 90.421682);
  List<MapDataModel> dataList = new List<MapDataModel>();
  //static LatLng _initialPosition;

  Set<Marker> setMarker = {};
 // Position currentPosition;
  BitmapDescriptor bitmapDescriptor;
  //InfoWindow mm;


  void setCustomMarker() async{
    bitmapDescriptor= await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "asste/iconss.png");
  }

  Widget showFloatingFlushbar(BuildContext context) {
    Flushbar(
      padding: EdgeInsets.only(top:10),
      borderRadius: 8,
      backgroundGradient: LinearGradient(
        colors: [Colors.black, Colors.black12],
        stops: [0.6, 1],
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      // All of the previous Flushbars could be dismissed by swiping down
      // now we want to swipe to the sides
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      // The default curve is Curves.easeOut
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      title: 'Senior App Developer (Flutter)',
      message: "Ishraak Solutions is looking for some Senior App Developers with Flutter expertise. "
          "The primary role will be creating/modifying cross-platform applications (iOS, Android, and others) "
          "using Google's Flutter development framework.",

    ).show(context);
  }



  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
      myLocation();
    });

  }

  myLocation() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //currentPosition=position;
 LatLng latlngPosition= LatLng(position.latitude,position.longitude);
 CameraPosition cameraPosition=CameraPosition(target:latlngPosition,zoom: 12.0 );
    _controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

  }

  static MarkerId markerId1 = MarkerId("1");
  static MarkerId markerId2 = MarkerId("12");

  setMerker() {
    dataList.forEach((e) {
      double lat1=double.tryParse(dataList.first.latitude);
      double lng1=double.tryParse(dataList.first.longitude);
      double lat2=double.tryParse(dataList.last.latitude);
      double lng2=double.tryParse(dataList.last.longitude);

      //String id= e.id[0];
      String id1= dataList.first.id;
      String id2=dataList.last.id;


      Widget displayModalBottomSheet(context) {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext bc) {
              return Container(
                child: new Wrap(
                  children: <Widget>[
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Image.asset("asste/ish.png")),
                            SizedBox(width: 5,),
                            Expanded(child: Column(
                              children: [
                                Text("Senior developer(Flutter)"),
                                Text("Ishraak Solutions Limited"),
                                Text("Dhaka,Bangladesh"),
                                Text("60000-100000 BDT")
                              ],
                            )),
                            SizedBox(width: 5,),
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Icon(Icons.favorite),
                             )

                          ],
                        ),
                        //SizedBox(height: 10,),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.lock_clock),
                            ),
                            Expanded(child: Text("Posted On 26/11/2020")),
                            SizedBox(width: 5,),
                            Text("Deadline in 15 days"),
                            SizedBox(width: 5,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RaisedButton(onPressed: (){},color: Colors.yellow,child: Text("Details"),),
                            )
                          ],
                        )
                      ],
                    )
                    // new ListTile(
                    //   leading: new Icon(Icons.videocam),
                    //   title: new Text('Video'),
                    //   onTap: () => {},
                    // ),
                  ],
                ),
              );
            });
      }

      Widget displayModalBottomSheetForCompany(context) {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext bc) {
              return Container(
                child: new Wrap(
                  children: <Widget>[

                    ListTile(
                      leading: Icon(Icons.home),
                      title:  Text("Ishraak Solutions Limited",style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Text("We are a software company with a special focus on Artificial Intelligence/Machine Learning. "
                          "We develop web and mobile applications."
                          " We also offer professional training on Machine Learning, Deep learning and other software development courses."
                          "Our team comprises talented professionals expert in cutting edge technologies and state of the art engineering processes."),
                      onTap: () => {},
                    ),
                  ],
                ),
              );
            });
      }


      //////MARKER/////////////////////////////////

      setMarker.add(
        Marker(
          markerId: MarkerId(id1),
          icon: bitmapDescriptor,
          position: LatLng(lat1, lng1),
          infoWindow: InfoWindow(
            title: dataList.first.jobtype,
            snippet: dataList.first.companyName,
            onTap: (){
              // _scaffoldKey.currentState.showSnackBar(SnackBar(
              //   duration: const Duration(seconds: 10),
              //   content: Text("Ishraak Solutions is looking for some Senior App Developers with Flutter expertise. "
              //       "The primary role will be creating/modifying cross-platform applications (iOS, Android, and others) "
              //       "using Google's Flutter development framework."),
              // ));
              // _scaffoldKey.currentState.showBottomSheet(
              //       (BuildContext context) {
              //     return showFloatingFlushbar(context);
              //     // Navigator.push(context, MaterialPageRoute(builder: (context)=>JobDetails()));
              //   },
              // );

             //showFloatingFlushbar(context);

              displayModalBottomSheet(context);
            }
          ),
          onTap: () {
            // _scaffoldKey.currentState.showBottomSheet(
            //       (BuildContext context) {
            //     return AlertDialog(
            //       title: new Text("Ishraak Solutions Limited"),
            //       content: new Text("Software Company"),
            //       backgroundColor: Colors.white,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: new BorderRadius.circular(15)),
            //       actions: <Widget>[
            //         new FlatButton(
            //           child: new Text("Go To Details Page"),
            //           textColor: Colors.yellow,
            //           onPressed: () {
            //             // this._yesOnPressed();
            //           },
            //         ),
            //         new FlatButton(
            //           child: Text("No"),
            //           textColor: Colors.redAccent,
            //           onPressed: () {
            //             // this._noOnPressed();
            //           },
            //         ),
            //       ],
            //     );
            //     // Navigator.push(context, MaterialPageRoute(builder: (context)=>JobDetails()));
            //   },
            // );
            displayModalBottomSheetForCompany(context);
          },
        ),

      );
      setMarker.add(
        Marker(

          markerId: MarkerId(id2),
          icon: bitmapDescriptor,
          position: LatLng(lat2, lng2),
          infoWindow: InfoWindow(
            title: dataList.last.jobtype,
            snippet: dataList.last.jobtitle,
            onTap: (){
              displayModalBottomSheet(context);
            },
          ),
          onTap: () {
            // _scaffoldKey.currentState.showBottomSheet(
            //       (BuildContext context) {
            //     return AlertDialog(
            //       title: new Text("Tiger IT"),
            //       content: new Text("Software Company"),
            //       backgroundColor: Colors.white,
            //       shape: RoundedRectangleBorder(
            //           borderRadius: new BorderRadius.circular(15)),
            //       actions: <Widget>[
            //         new FlatButton(
            //           child: new Text("Go To Details Page"),
            //           textColor: Colors.greenAccent,
            //           onPressed: () {
            //             // this._yesOnPressed();
            //           },
            //         ),
            //         new FlatButton(
            //           child: Text("No"),
            //           textColor: Colors.redAccent,
            //           onPressed: () {
            //             // this._noOnPressed();
            //           },
            //         ),
            //       ],
            //     );
            //     // Navigator.push(context, MaterialPageRoute(builder: (context)=>JobDetails()));
            //   },
            // );

            displayModalBottomSheetForCompany(context);
          },
        ),

      );
    });
  }




  @override
  void initState() {
    fetchjob();
    super.initState();
    setCustomMarker();
    // //jobs=ApIManager().getJobs();
    // print(jobs);
  }




  Future<List<MapDataModel>> fetchjob() async {
    String url =
        "https://raw.githubusercontent.com/Kakon007/jobap/main/job.json";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      //MapDataModel data = MapDataModel.fromJson(json.decode(response.body));
      List<MapDataModel> data = mapDataModelFromJson(response.body);
      data.forEach((elemant) {
        setState(() {
          dataList.add(elemant);
        });
      });
      setMerker();
      print('Data:: ' + data.first.companyName);
      return data;
    } else {
      return null;
    }
  }

  // @override
  // void dispose() {
  //   fetchjob()
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Search Job Location',style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.yellow,
        ),
        body: FutureBuilder(
          future: fetchjob(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              List<MapDataModel> data = snapshot.data;
              return Stack(
                children: [
                  GoogleMap(
                    onTap: (latLng){
                      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Latitude: ${latLng.latitude}, Longitude: ${latLng.longitude}"),));
                    },
                    myLocationButtonEnabled: true,
                    padding: EdgeInsets.only(top: 530,right: 20),
                    myLocationEnabled: true,
                    markers: setMarker,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 12.0,
                    ),
                    mapType: MapType.normal,
                  ),

                  _searchlocation(),
                  // FlatButton(onPressed: (){
                  //   print("API DATA"+jobs.toString());
                  // }, child: Text("Fetch"))
                ],
              );
            }
          },
        ),
      ),
    );
  }

  _searchlocation() {
    return Positioned(
      top: 40,
      left: 15,
      right: 15,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white),
        child: TextField(
          decoration: InputDecoration(
              hintText: "Enter Address",
              alignLabelWithHint: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 15, left: 15, right: 15),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: searchaddressandNav,
                iconSize: 30,
              )),
          onChanged: (value) {
            setState(() {
              searchaddress = value;
            });
          },
        ),
      ),
    );
  }

  searchaddressandNav() async{
    Geolocator().placemarkFromAddress(searchaddress).then((result) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
          LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 10.0)));
    });

    // Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    // setState(() {
    //   _initialPosition = LatLng(position.latitude, position.longitude);
    //   print('${placemark[0].name}');
    // });
  }
}
