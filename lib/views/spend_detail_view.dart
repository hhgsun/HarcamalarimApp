import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harcamalarim/models/spend.dart';

class SpendDetailView extends StatefulWidget {
  final Spend spend;
  const SpendDetailView({Key? key, required this.spend}) : super(key: key);

  @override
  _SpendDetailViewState createState() => _SpendDetailViewState();
}

class _SpendDetailViewState extends State<SpendDetailView> {
  late Spend spend;

  @override
  void initState() {
    spend = widget.spend;
    super.initState();
  }

  Widget get buildGoogleMap => GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(spend.coords!.latitude, spend.coords!.longitude),
          zoom: 8.00,
        ),
        markers: {
          Marker(
            markerId: const MarkerId("id"),
            position: LatLng(spend.coords!.latitude, spend.coords!.longitude),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: spend.catId ?? ""),
          )
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300.0,
              child: buildGoogleMap,
            ),
            ListTile(
              trailing: const Icon(Icons.description),
              title: Text(
                spend.desc ?? "",
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              trailing: const Icon(Icons.category),
              title: Text(
                spend.catId ?? "",
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              trailing: const Icon(Icons.price_check),
              title: Text(
                (spend.amount ?? "") + " TL",
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
