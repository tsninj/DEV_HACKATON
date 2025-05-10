import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/info_model.dart';
import '../provider/globalProvider.dart';
import '../widgets/information_view.dart';
import 'dart:convert';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  Future<List<InfoModel>> _getData() async {
    String res = await DefaultAssetBundle.of(
      context,
    ).loadString("assets/info.json");
    List<InfoModel> data = InfoModel.fromList(jsonDecode(res));
    Provider.of<Global_provider>(context, listen: false).setInfos(data);
    return Provider.of<Global_provider>(context, listen: false).infos;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getData(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Products',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(223, 252, 252, 252),
                ),
              ),
              actions: [
                IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
              ],
            ),

            body: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 10,
                  children: List.generate(
                    snapshot.data!.length,
                    (index) => InfoCard(
                      data: snapshot.data![index],
                    ), // ← дамжуулж байна
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(),
            ),
          );
        }
      }),
    );
  }
}
