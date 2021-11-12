import 'package:flutter/material.dart';
import 'package:passkeeper/models/account.dart';
import 'package:passkeeper/views/home/account_tile.dart';

class AccountList extends StatefulWidget {
  const AccountList({Key? key}) : super(key: key);

  @override
  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  @override
  Widget build(BuildContext context) {
    final accounts = <Account>[
      Account('facebook', 'morel', 'pass'),
      Account('instagram', 'andre', 'ciao'),
    ]; // TODO

    return ListView.builder(
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        return AccountTile(account: accounts[index]);
      },
    );
  }
}
