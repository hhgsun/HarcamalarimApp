import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harcamalarim/models/spend.dart';
import 'package:harcamalarim/services/spends_service.dart';
import 'package:harcamalarim/views/spend_detail_view.dart';
import 'package:provider/provider.dart';

class SpendsMapView extends StatefulWidget {
  const SpendsMapView({Key? key}) : super(key: key);

  @override
  _SpendsMapViewState createState() => _SpendsMapViewState();
}

class _SpendsMapViewState extends State<SpendsMapView> {
  late List<Spend> spends;

  Widget get buildGoogleMap => GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
              spends.last.coords!.latitude, spends.last.coords!.longitude),
          zoom: 8.00,
        ),
        markers: spends
            .map(
              (s) => Marker(
                markerId: MarkerId(s.id.toString()),
                position: LatLng(s.coords!.latitude, s.coords!.longitude),
                infoWindow: InfoWindow(
                  title: s.desc,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SpendDetailView(spend: s),
                      ),
                    );
                  },
                ),
              ),
            )
            .toSet(),
      );

  @override
  void initState() {
    spends = Provider.of<SpendsService>(context, listen: false).spends;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Harcamalarım"),
      ),
      body: buildGoogleMap,
    );
  }
}
