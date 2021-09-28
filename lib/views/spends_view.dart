import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:harcamalarim/services/spends_service.dart';
import 'package:harcamalarim/views/edit_spend_view.dart';
import 'package:harcamalarim/views/spend_detail_view.dart';
import 'package:harcamalarim/views/spends_map_view.dart';
import 'package:provider/provider.dart';

class SpendsView extends StatefulWidget {
  const SpendsView({Key? key}) : super(key: key);

  @override
  _SpendsViewState createState() => _SpendsViewState();
}

class _SpendsViewState extends State<SpendsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Harcamalarım"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SpendsMapView(),
                ),
              );
            },
            icon: const Icon(Icons.map_outlined),
            tooltip: "Haritada Göster",
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer<SpendsService>(builder: (context, service, child) {
          return Column(
            children: service.spends
                .map(
                  (sp) => Column(
                    children: [
                      Slidable(
                        child: ListTile(
                          title: Text(sp.desc ?? "Açıklama"),
                          subtitle: Text(sp.catId ?? "Kategori"),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SpendDetailView(spend: sp),
                              ),
                            );
                          },
                        ),
                        actionPane: const SlidableDrawerActionPane(),
                        secondaryActions: [
                          IconSlideAction(
                            caption: "Düzenle",
                            icon: Icons.edit_location_alt_outlined,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditSpendView(spend: sp),
                                ),
                              );
                            },
                          ),
                          IconSlideAction(
                            caption: "Sil",
                            icon: Icons.delete,
                            onTap: () {
                              Provider.of<SpendsService>(context, listen: false)
                                  .deleteSpend(sp);
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
                )
                .toList(),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_location_alt_rounded),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const EditSpendView(),
            ),
          );
        },
      ),
    );
  }
}
