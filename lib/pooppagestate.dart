
import 'package:bajsappen/poop.dart';
import 'package:flutter/material.dart';

import 'database_helpers.dart';

abstract class PoopPageState extends State<StatefulWidget> {
  DatabaseHelper _helper = DatabaseHelper.instance;
  List<Poop> poops = [];

  PoopPageState() {
    refresh();
  }

  void setHelper(DatabaseHelper helper) {
    this._helper = helper;
  }

  @override
  void didUpdateWidget(Widget oldVariant) {
    refresh();
    super.didUpdateWidget(oldVariant);
  }

  void addPoop(Poop poop) async {
    await _helper.insertPoop(poop);
    refresh();
  }

  void deletePoop(Poop poop) async {
    await _helper.delete(poop);
    refresh();
  }

  Future<List<Poop>> getAllPoops([int sinceEpoch = 0]) async {
    return _helper.getAllPoops(sinceEpoch);
  }

  void refresh();
}