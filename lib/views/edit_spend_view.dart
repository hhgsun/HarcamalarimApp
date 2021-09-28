import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harcamalarim/models/coords.dart';
import 'package:harcamalarim/models/spend.dart';
import 'package:harcamalarim/services/spends_service.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class EditSpendView extends StatefulWidget {
  final Spend? spend;
  const EditSpendView({Key? key, this.spend}) : super(key: key);

  @override
  _EditSpendViewState createState() => _EditSpendViewState();
}

class _EditSpendViewState extends State<EditSpendView> {
  late GoogleMapController _googleMapController;
  final _formKey = GlobalKey<FormState>();

  bool isUpdate = false;
  late Spend spend;
  bool isNewCat = false;
  late List<String?> cats;

  double defaultLat = 40.9694567;
  double defaultLng = 29.0000;

  Marker marker = const Marker(markerId: MarkerId("id"));

  Widget get buildGoogleMap => GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(defaultLat, defaultLng),
          zoom: 8.00,
        ),
        markers: {marker},
        onMapCreated: (GoogleMapController controller) {
          _googleMapController = controller;
        },
        onTap: addMarker,
      );

  addMarker(LatLng latlng) {
    setState(() {
      marker = Marker(
        markerId: const MarkerId("id"),
        position: latlng,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(title: "Deneme"),
      );
      defaultLat = latlng.latitude;
      defaultLng = latlng.longitude;
    });
  }

  void initLocationData() {
    if (isUpdate) {
      defaultLat = spend.coords!.latitude;
      defaultLng = spend.coords!.longitude;
    } else {
      LocationData locationData =
          Provider.of<SpendsService>(context, listen: false)
              .locationService
              .locationData!;
      if (locationData.latitude != null) {
        defaultLat = locationData.latitude!;
      }
      if (locationData.longitude != null) {
        defaultLng = locationData.longitude!;
      }
    }
    addMarker(LatLng(defaultLat, defaultLng));

    /* print(
      "---> LOCATION: " + defaultLat.toString() + " " + defaultLng.toString(),
    ); */
    setState(() {});
  }

  @override
  void initState() {
    cats = Provider.of<SpendsService>(context, listen: false).cats;

    if (widget.spend != null && widget.spend?.id != null) {
      spend = widget.spend!;
      isUpdate = true;
    } else {
      spend = Spend(
        desc: "",
        amount: "",
        date: DateTime.now(),
        catId: "",
        coords: Coords(defaultLat, defaultLng),
      );
      isUpdate = false;
    }
    setState(() {});
    initLocationData();
    super.initState();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdate ? "Harcamanı Düzenle" : "Harcama Ekle"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300.0,
              width: MediaQuery.of(context).size.width,
              child: buildGoogleMap,
            ),
            Column(
              children: [
                Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Açıklama",
                          ),
                          onChanged: (v) {
                            spend.desc = v.toString();
                          },
                          initialValue: spend.desc,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen açıklama giriniz';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Tutar (TL)",
                          ),
                          onChanged: (v) {
                            spend.amount = v.toString();
                          },
                          keyboardType: TextInputType.number,
                          initialValue: spend.amount,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen Tutar giriniz';
                            }
                            return null;
                          },
                        ),
                        ListTile(
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                isNewCat = !isNewCat;
                              });
                            },
                            icon: Icon(isNewCat
                                ? Icons.close_outlined
                                : Icons.add_box_outlined),
                          ),
                          title: isNewCat
                              ? TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: "Yeni Kategori",
                                  ),
                                  onChanged: (v) {
                                    spend.catId = v.toString();
                                  },
                                  initialValue: spend.catId,
                                  validator: (value) {
                                    if (value == "") {
                                      return 'Lütfen Kategori giriniz';
                                    }
                                    return null;
                                  },
                                )
                              : DropdownButton<String>(
                                  hint: Text(
                                    spend.catId != ""
                                        ? spend.catId!
                                        : "Kategori Seçiniz",
                                  ),
                                  value: cats
                                          .where((c) => c == spend.catId)
                                          .isNotEmpty
                                      ? cats
                                          .where((c) => c == spend.catId)
                                          .first
                                      : cats[0],
                                  isExpanded: true,
                                  items: cats.map((String? value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value ?? "--"),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      spend.catId = val;
                                    });
                                  },
                                ),
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              handleSaveForm();
                            }
                          },
                          child: const Text('KAYDET'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void handleSaveForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isUpdate ? "Güncelleme Başarılı" : "Ekleme Başarılı"),
      ),
    );
    spend.coords = Coords(defaultLat, defaultLng);
    spend.date = DateTime.now();
    if (isUpdate) {
      Provider.of<SpendsService>(context, listen: false).updateSpend(spend);
    } else {
      spend.id = DateTime.now().toIso8601String();
      Provider.of<SpendsService>(context, listen: false).addSpend(spend);
    }
    setState(() {});
    Navigator.of(context).pop();
  }
}
