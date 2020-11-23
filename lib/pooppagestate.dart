import 'package:bajsappen/poop.dart';
import 'package:bajsappen/remote_storage.dart';
import 'package:flutter/material.dart';

import 'database_helpers.dart';

abstract class PoopPageState extends State<StatefulWidget> {
  DatabaseHelper _helper = DatabaseHelper.instance;
  RemoteStorage _remote = RemoteStorage();
  bool hasRemote = false;

  bool synced = false;

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
    String prefix = await _helper.getPersonalCode();
    await _remote.addPoop(poop, prefix);
    await _helper.insertPoop(poop);
    refresh();
  }

  void deletePoop(Poop poop) async {
    String prefix = await _helper.getPersonalCode();
    await _remote.deletePoop(poop, prefix);
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
    String prefix = await _helper.getPersonalCode();
    if (prefix.isNotEmpty) {
      List<Poop> poops = await _remote.getAllPoops(prefix);
      _helper.clear();
      poops.forEach((poop) => _helper.insertPoop(poop));
    }
  }

  setPersonalCode(String code) async {
    await _helper.setPersonalCode(code);
  }

  Future<String> getPersonalCode() async {
    return _helper.getPersonalCode();
  }

  void refresh();
}
