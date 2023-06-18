import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CheckInternetConnectionPage extends StatefulWidget {

  const CheckInternetConnectionPage({ super.key });

  @override
  State<CheckInternetConnectionPage> createState() => _CheckInternetConnectionPageState();
}

class _CheckInternetConnectionPageState extends State<CheckInternetConnectionPage> {
  final platform = const MethodChannel('flutter.seventh/network_connection');
  String _hasInternetText = "";
  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
  bool hasInternet;
  try {
    final bool result = await platform.invokeMethod('hasInternet');
    hasInternet = result;
  } on PlatformException catch (e) {
    hasInternet = false;
  }

  setState(() {
    _hasInternetText = hasInternet ? "Você está conectado à internet!": "Você não está conectado à internet!";
  });
}

   @override
   Widget build(BuildContext context) {
       return Scaffold(
           appBar: AppBar(title: const Text(''),),
           body: Center(child: Text(_hasInternetText,),),
           floatingActionButton: FloatingActionButton(
        onPressed: _checkInternetConnection,
        tooltip: 'Check Internet',
        child: const Icon(Icons.network_wifi),
      ),
       );
  }
}