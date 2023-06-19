import 'dart:convert';
import 'package:course_asset_management/config/app_constant.dart';
import 'package:course_asset_management/models/asset_model.dart';
import 'package:course_asset_management/pages/asset/create_asset_page.dart';
import 'package:d_info/d_info.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<AssetModel> assets = [];

  readAssets() async {
    assets.clear();

    Uri url = Uri.parse(
      'http://192.168.1.26/ABP_Mobile/asset/read.php',
    );
    try {
      final response = await http.get(url);
      DMethod.printResponse(response);

      Map resBody = jsonDecode(response.body);
      bool success = resBody['success'] ?? false;
      if (success) {
        List data = resBody['data'];
        assets = data.map((e) => AssetModel.fromJson(e)).toList();
      }
      setState(() {});
    } catch (e) {
      DMethod.printTitle('catch', e.toString());
    }
  }

  @override
  void initState() {
    readAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstant.appName),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                readAssets();
              },
              icon: Icon(Icons.search))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        },
        child: const Icon(Icons.add),
      ),
      body: assets.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Empty"),
                  IconButton(onPressed: () {}, icon: Icon(Icons.refresh))
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async => {readAssets()},
              child: GridView.builder(
                itemCount: assets.length,
                padding: EdgeInsets.fromLTRB(16, 16, 16, 80),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.8),
                itemBuilder: (context, index) {
                  AssetModel item = assets[index];
                  return Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'http://192.168.1.26/image/' + item.image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    item.type,
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                            Material(
                              borderRadius: BorderRadius.circular(4),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(4),
                                onTap: () {},
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Icon(Icons.more_vert),
                                ),
                              ),
                              color: Colors.purple[50],
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
