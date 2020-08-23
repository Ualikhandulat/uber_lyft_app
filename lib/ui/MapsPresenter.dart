
import 'dart:convert';
import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_lyft_app/simulator/JsonMessage.dart';
import 'package:uber_lyft_app/simulator/WebSocket.dart';
import 'package:uber_lyft_app/utils/Constants.dart';

import 'MapsView.dart';
import '../NetworkService.dart';
import '../simulator/WebSocketListener.dart';

class MapsPresenter  implements WebSocketListener{


  WebSocket webSocket;

  MapsView uiView;

   static const String TAG = "MapsPresenter";

  MapsPresenter( NetworkService networkService ) {
    webSocket=networkService.createWebSocket(this);
  }

   onAttach(MapsView uiView) {
    this.uiView = uiView;
    webSocket.connect();
  }

   onDetach() {
    webSocket.disconnect();
    uiView = null;
  }

  @override
  onConnect() {

    log('$TAG: onConnect');
  }


   requestNearbyCabs(LatLng latLng) {
     JsonMessage jsonMessage=JsonMessage();
     jsonMessage.tag=Constants.nearByCabs;
     jsonMessage.data=List<LatLng>();
     jsonMessage.data.add(latLng);
     var jsonData = jsonEncode(jsonMessage);
     webSocket.sendMessage(jsonData);
  }

  requestCab(LatLng pickLat,LatLng dropLat){

    JsonMessage jsonMessage=JsonMessage();
    jsonMessage.tag=Constants.requestForCab;
    jsonMessage.data=List<LatLng>();
    jsonMessage.data.add(pickLat);
    jsonMessage.data.add(dropLat);
    var jsonData = jsonEncode(jsonMessage);
    webSocket.sendMessage(jsonData);


  }



  @override
  onDisconnect() {
    // TODO: implement onDisconnect
    throw UnimplementedError();
  }

  @override
  onError(String error) {
    // TODO: implement onError
    throw UnimplementedError();
  }

  @override
  onMessage(String message) {

    Map<String, dynamic> map = jsonDecode(message);
    JsonMessage obj=JsonMessage.fromJson(map);


    if(obj.tag==Constants.nearByCabs){
      uiView.showNearbyCabs(obj.data);
    }else if(obj.tag==Constants.pickUpPath){
      uiView.showPath(obj.data);
    }

  }




}