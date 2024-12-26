import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location_demo/controllers/location_controller.dart';
import 'package:location_demo/services/location_services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'access device location demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocationController locationController =
      Get.put<LocationController>(LocationController());

  @override
  void initState() {
    LocationServices.instance
        .getUserLocation(locationController: locationController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Obx(
        () {
          return locationController.processingLocationAccess.value
              ? const Column(
                  children: [
                    CircularProgressIndicator.adaptive(),
                    Text('processing...'),
                  ],
                )
              : Center(
                  child: locationController.errorDesc.value.isNotEmpty ||
                          locationController.userLocation.value == null
                      ? Column(
                          children: [
                            Text(locationController.errorDesc.value),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'latitude: ${locationController.userLocation.value!.latitude}',
                            ),
                            Text(
                              'longitude: ${locationController.userLocation.value!.longitude}',
                            ),
                            Text(
                              'user Address: ${locationController.uAddress.value}',
                            ),
                          ],
                        ),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
