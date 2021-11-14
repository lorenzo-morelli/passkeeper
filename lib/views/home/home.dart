import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:passkeeper/models/account.dart';
import 'package:passkeeper/services/auth.dart';
import 'package:passkeeper/shared/constants.dart';
import 'package:passkeeper/widgets/search_widget.dart';

import 'account_tile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Account> accounts;
  final AuthService _auth = AuthService();
  String query = '';
  final _formKey = GlobalKey<FormState>();
  final allAccounts = <Account>[
    Account('facebook', 'morel', 'pass'),
    Account.withColor('instagram', 'andre', 'ciao', Colors.red),
  ]; // TODO

  List<Color> colors = [
    Colors.green,
    Colors.orange,
    Colors.blue,
    Colors.pink,
    Colors.yellow,
    Colors.cyanAccent,
    Colors.purple,
    Colors.red,
    Colors.deepOrange,
    Colors.teal,
    Colors.indigoAccent,
    Colors.amber,
    Colors.cyan,
    Colors.blueGrey,
    Colors.brown,
    Colors.black,
  ];

  @override
  void initState() {
    super.initState();
    accounts = allAccounts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          SizedBox(height: 50),
          Container(
            alignment: Alignment.bottomRight,
            child: PopupMenuButton<int>(
              onSelected: (item) => dropDown(context, item),
              icon: Icon(Icons.settings),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 0,
                  child: Text('Settings'),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text('Logout'),
                ),
              ],
            ),
          ),
          SizedBox(width: 15),
          SizedBox(height: 25),
          Stack(
            children: [
              AspectRatio(aspectRatio: 2.48, child: Image.asset('assets/images/home.png', fit: BoxFit.cover)),
              Column(
                children: [
                  SizedBox(height: 35),
                  Wrap(
                    runSpacing: -6,
                    children: [
                      Center(
                        child: Text(
                          'PassKeeper.',
                          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 60),
                      Center(
                        child: Text(
                          'A safe place to store all',
                          style: TextStyle(fontSize: 19, fontStyle: FontStyle.italic),
                        ),
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontFamily: 'GentiumBook', fontWeight: FontWeight.w600, color: Colors.black, fontSize: 19),
                            children: const [
                              TextSpan(text: 'your '),
                              TextSpan(
                                text: 'passwords',
                                style: TextStyle(decoration: TextDecoration.lineThrough),
                              ),
                              TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 30),
          SearchWidget(
            text: query,
            onChanged: searchAccount,
            hintText: 'search...',
          ),
          Expanded(
            child: accounts.isNotEmpty
                ? ListView.builder(
                    padding: EdgeInsets.only(top: 10),
                    itemCount: accounts.length,
                    itemBuilder: (context, index) {
                      return AccountTile(account: accounts[index], index: index);
                    },
                  )
                : Text('Nothing found :('),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addAccount(context),
        tooltip: 'Add new account',
        child: const Icon(Icons.add),
      ),
    );
  }

  void searchAccount(String query) {
    final accounts = allAccounts.where((account) {
      final siteLower = account.site.toLowerCase();
      final searchLower = query.toLowerCase();

      return siteLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.accounts = accounts;
    });
  }

  void addAccount(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Colors.white70,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(Constants.cornRad)),
            ),
            title: Text(
              'Add new account',
              textAlign: TextAlign.center,
            ),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: Constants.textInputDecoration,
                    validator: (val) => val!.isEmpty ? 'Please enter a site' : null,
                    onChanged: (val) => {},
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    decoration: Constants.textInputDecoration.copyWith(
                      hintText: 'username',
                    ),
                    validator: (val) => val!.isEmpty ? 'Please enter a username' : null,
                    onChanged: (val) => {},
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    decoration: Constants.textInputDecoration.copyWith(
                      hintText: 'password',
                    ),
                    validator: (val) => val!.isEmpty ? 'Please enter a password' : null,
                    onChanged: (val) => {},
                  ),
                  SizedBox(height: 30),
                  // Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 40),
                  //   child: BlockPicker(
                  //     pickerColor: color,
                  //     availableColors: colors,
                  //     onColorChanged: (color) => setState(() {
                  //       this.color = color;
                  //       print('color changed: $color');
                  //     }),
                  //   ),
                  // ),
                  //SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Text(
                          'Cancel',
                          style: TextStyle(decoration: TextDecoration.underline),
                        ),
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.all(Radius.circular(Constants.cornRad)),
                        ),
                        child: TextButton(
                          child: Text(
                            'Create',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ));

  void dropDown(BuildContext context, int item) {
    switch (item) {
      case 1:
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(Constants.cornRad)),
            ),
            title: Text(
              'Are you sure?',
              textAlign: TextAlign.center,
            ),
            content: Row(
              children: [
                TextButton(
                  child: Text('Yes'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _auth.signOut();
                  },
                ),
                TextButton(
                  child: Text('No'),
                  onPressed: Navigator.of(context).pop,
                ),
              ],
            ),
          ),
        );
        break;
    }
  }
}
