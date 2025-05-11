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
  String selectedFilter = 'Бүгд'; // ✅ Сонгогдсон шүүлтүүр

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
          // ✅ Filter хийсэн дата
          final filteredData =
              snapshot.data!.where((info) {
                if (selectedFilter == 'Бүгд') return true;
                return info.tag ==
                    selectedFilter; // category нь InfoModel-ийн төрөл
              }).toList();

          return Scaffold(
            endDrawer: Drawer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Мөнх",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "MunkhErdene@gmail.com",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          "https://your-image-url.com",
                        ),
                        radius: 24,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    title: Text('Хувийн мэдээлэл'),
                    trailing: Icon(Icons.person),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Миний зарууд'),
                    trailing: Icon(Icons.assignment),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Нууц үг'),
                    trailing: Icon(Icons.lock),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Өнгө солих'),
                    trailing: Icon(Icons.brightness_6),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text('Текст унших'),
                    trailing: Icon(Icons.mic),
                    onTap: () {},
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Center(
                      child: ListTile(
                        title: Text(
                          'Гарах',
                          style: TextStyle(color: Colors.red),
                        ),
                        leading: Icon(Icons.logout, color: Colors.red),
                        onTap: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),

            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Image.asset('assets/images/logo.png', height: 70),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.notifications_none,
                    size: 35,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const NotificationScreen()),
                    // );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Builder(
                    builder:
                        (context) => GestureDetector(
                          onTap: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          child: CircleAvatar(
                            //backgroundImage: AssetImage(user?.avatar ?? 'assets/default_avatar.png'),
                            radius: 18,
                          ),
                        ),
                  ),
                ),
              ],
            ),

            // ✅ Body эхэлж байна
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Шүүлтүүрийн товчлуурууд (хөндлөн scroll + сонгогдсон төлөв)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          [
                            'Бүгд',
                            'Улс төр',
                            'Нийгэм',
                            'Эрүүл мэнд',
                            'Боловсрол',
                          ].map((filter) {
                            bool isSelected = filter == selectedFilter;
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedFilter = filter;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isSelected
                                          ? Colors.blue
                                          : Colors.transparent,
                                  foregroundColor:
                                      isSelected ? Colors.white : Colors.black,
                                  elevation: 0,
                                  side: BorderSide.none,
                                ),
                                child: Text(filter),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // ✅ Шүүгдсэн InfoCard жагсаалт
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 10,
                        children: List.generate(
                          filteredData.length,
                          (index) => InfoCard(data: filteredData[index]),
                        ),
                      ),
                    ),
                  ),
                ],
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
