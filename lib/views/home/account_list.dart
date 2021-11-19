import 'package:flutter/material.dart';
import 'package:passkeeper/models/account.dart';
import 'package:passkeeper/views/home/account_tile.dart';
import 'package:provider/provider.dart';

class AccountList extends StatefulWidget {
  const AccountList({Key? key, required this.accounts}) : super(key: key);
  final List<Account> accounts;

  @override
  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.accounts.length,
      itemBuilder: (context, index) {
        return AccountTile(account: widget.accounts[index], index: index);
      },
    );
  }
}
