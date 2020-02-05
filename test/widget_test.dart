// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:bajsappen/database_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bajsappen/main.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';

class FakeDatabase extends Mock implements DatabaseHelper {
  final List<DateTime> _poops = [];

  @override
  Future<List<DateTime>> getAllPoops() {
    return Future.value(_poops);
  }

  @override
  Future<int> insert(DateTime poop) {
    _poops.add(poop);
    return Future.value(_poops.length);
  }
}

void main() {
  testWidgets('First page loads', (WidgetTester tester) async {
    FakeDatabase fakeDatabase = FakeDatabase();
    await tester.pumpWidget(Bajsappen());

    MyHomePageState homepageState = tester.state(find.byType(MyHomePage));
    homepageState.helper = fakeDatabase;
    homepageState.read();

    await tester.pump();

    var nowString = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    var poopButtonFinder = find.text('💩');

    // verify there is a button, but no registered poops
    expect(poopButtonFinder, findsOneWidget);
    expect(find.text(nowString), findsNothing);
  });

  testWidgets('One may add a poop', (WidgetTester tester) async {
    FakeDatabase fakeDatabase = FakeDatabase();
    await tester.pumpWidget(Bajsappen());

    MyHomePageState homepageState = tester.state(find.byType(MyHomePage));
    homepageState.helper = fakeDatabase;
    homepageState.read();

    await tester.pump();

    var nowString = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
    var poopButtonFinder = find.text('💩');

    await tester.tap(poopButtonFinder);
    await tester.pump();

    var addButtonFinder = find.text('Lägg till');
    expect(addButtonFinder, findsOneWidget);

    await tester.tap(addButtonFinder);
    await tester.pump();

    expect(find.text(nowString), findsOneWidget);
  });

  // test scenarios:
  /*
   * Test scenarios:
   *
   * First start (all poops are null)
   * Make sure:
   * * first page loads
   * * list of all poops loads (but is empty)
   * * count widget loads and is set to 0
   * * weekday widget loads and no weekday is displayed
   *
   * Count widget:
   * * empty list init -> count is 0 and all poops list is empty
   * * list with items -> go to poop list, it has x items. Remove one. Go back -> count is decreased with 1
   * * remove by swipe (and long press)
   *
   * Weekday widget:
   * * No data -> no weekday
   * * some data -> make sure the chart is ok (the data backing the chart)
   *
   * I did it page:
   * * There should be a button
   * * a poop is added -> it should be latest poop
   * * a historic poop is added -> latest poop should remain the same
   */
}
