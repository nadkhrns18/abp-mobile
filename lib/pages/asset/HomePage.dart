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
    setState(() {});

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

  showMenuItem(AssetModel item) {
    showDialog(
        context: context,
        builder: (context) {
            return SimpleDialog(
                title: Text(item.name),
                children: [
                  ListTile(
                        onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                              builder: (context) =>  const UpdateAssetPage(
                                oldAsset: item,
                              ), //UpdateAssetPage
                            ), // MaterialPageRoute
                          ). then((value) => readAssets());
                        },
                        horizontalTitleGap: 0,
                        leading: const Icon(Icon.edit, colors.blue),
                        title: const Text('Update'),
                   ),
                  ListTile(
                        onTap: () {
                            Navigator.pop(context);
                        },
                        horizontalTitleGap: 0,
                        leading: const Icon(Icon.delete, colors.red),
                        title: const Text('Delete'),
               ), // ListTile
             ],
            ); // SimpleDialog
        },
    )
  }

  deleteAsset(AssetModel item) async {
    bool? yes = await DInfo.dialogConfirmation(
        context, 
        'Delete', 
        'You sure want to delete ${item.name}?',
    );
    if (yes??false) {
      Uri url = Uri.parse(
        '${AppConstant.baseURL}/asset/delete,php',
      );
    try {
        final response = await http.post(url, body: {
            'id': item.id,
            'image': item.image,
        });
        DMethod.printResponse(response);

         Map resBody= jsonDecode(response.body);
        bool success = resBody['success'] ?? false;
        if (success) {
            DInfo.toastSuccess('Success Delete Asset');
            readAssets();//refresh data list asset
        } else {
            DInfo.toastError('Failed Delete Asset');
        }
      } catch (e) {
        DMethod.printTittle('catch', e.toString());
      }
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
        leading: PopupMenuButton(
                    icon: const Icon(Icons.menu),
                    onSelected: (value) {
                        if (value=='logout'){
                            Navigator.pushReplacment(
                        context,
                        MaterialPageRoute(builder: (context) => Loginpage()),
                        );     
                        }
                    itemBuilder:(context) => [
                    const PopupMenuItem(
                        value: 'logout',
                        child: Text('Logout'),
                ),
              ], 
            ), //  PopupMenuButton
        title: Text(AppConstant.appName),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) =>  const SearchAssetPage(),
                  ), // MaterialPageRoute
                );
                  },
              icon: Icon(Icons.search),
          ), // IconButton
        ],
      ), // AppBar
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) =>  const CreateAssetPage(),
                ), // MaterialPageRoute
            ). then((value) => readAssets());
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
                ), // SilverGridDelegateWithFixedCrossAxisCount
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
                          ), // Image.network
                        ), // ClipRRect
                      ), // Expanded
                      const SizedBox(height: 8),
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
                                onTap: () {
                                    showMenuItem(item);
                                },
                                splashColor: Colors.purpleAccent,
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
