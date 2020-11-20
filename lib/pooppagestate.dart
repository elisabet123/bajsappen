import 'package:bajsappen/poop.dart';
import 'package:bajsappen/remote_storage.dart';
import 'package:flutter/material.dart';

import 'database_helpers.dart';

abstract class PoopPageState extends State<StatefulWidget> {
  DatabaseHelper _helper = DatabaseHelper.instance;
  Remote _remote;
  bool hasRemote = false;

  bool synced = false;

  List<Poop> poops = [];

  PoopPageState() {
    refresh();
  }

  Future<Remote> _getRemote() async {
    if (_remote == null) {
      String name = await _helper.getName();
      if (name == null) {
        _remote = Remote();
      } else {
        hasRemote = true;
        _remote = RemoteStorage(name);
      }
    }
    return _remote;
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
    await (await _getRemote()).addPoop(poop);
    await _helper.insertPoop(poop);
    refresh();
  }

  void deletePoop(Poop poop) async {
    (await _getRemote()).deletePoop(poop);
    await _helper.delete(poop);
    refresh();
  }

  Future<List<Poop>> getAllPoops([int sinceEpoch = 0]) async {
    if (!synced) {
      await syncRemote();
      synced = true;
    }
    return _helper.getAllPoops(sinceEpoch);
  }

  Future<void> syncRemote() async {
    var remote = await _getRemote();
    if (hasRemote) {
      List<Poop> poops = await remote.getAllPoops();
      _helper.clear();
      poops.forEach((poop) => _helper.insertPoop(poop));
    }
  }

  void refresh();
}
