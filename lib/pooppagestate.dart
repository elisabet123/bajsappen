
import 'package:bajsappen/poop.dart';
import 'package:bajsappen/remote_storage.dart';
import 'package:flutter/material.dart';

import 'database_helpers.dart';

abstract class PoopPageState extends State<StatefulWidget> {
  DatabaseHelper _helper = DatabaseHelper.instance;
  RemoteStorage _remote = RemoteStorage("Selma");

  bool synced = false;

  List<Poop> poops = [];

  PoopPageState() {
    refresh();
  }

  void setHelper(DatabaseHelper helper) {
    this._helper = helper;
  }
  void setRemote(RemoteStorage remoteStorage) {
    this._remote = remoteStorage;
  }

  @override
  void didUpdateWidget(Widget oldVariant) {
    refresh();
    super.didUpdateWidget(oldVariant);
  }

  void addPoop(Poop poop) async {
    await _helper.insertPoop(poop);
    await _remote.addPoop(poop);
    refresh();
  }

  void deletePoop(Poop poop) async {
    await _helper.delete(poop);
    _remote.deletePoop(poop);
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
    List<Poop> poops = await _remote.getAllPoops();
    _helper.clear();
    poops.forEach((poop) => _helper.insertPoop(poop));
  }

  void refresh();
}