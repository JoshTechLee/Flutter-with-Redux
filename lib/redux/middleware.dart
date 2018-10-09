import 'package:redux/redux.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_with_redux/model/model.dart';
import 'package:flutter_with_redux/redux/actions.dart';

List<Middleware<AppState>> appStateMiddleware([AppState state = const AppState(items: [])]) {
  final loadItems = _loadFromPrefs(state);
  final saveItems = _saveToPrefs(state);

  return [
    TypedMiddleware<AppState, AddItemAction>(saveItems),
    TypedMiddleware<AppState, ItemCompletedAction>(saveItems),
    TypedMiddleware<AppState, RemoveItemAction>(saveItems),
    TypedMiddleware<AppState, RemoveItemsAction>(saveItems),
    TypedMiddleware<AppState, GetItemsAction>(loadItems),
  ];
}

Middleware<AppState> _loadFromPrefs(AppState state) {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);

    loadFromPrefs()
        .then((state) => store.dispatch(LoadedItemsAction(state.items)));
  };
}

Middleware<AppState> _saveToPrefs(AppState state) {
    return (Store<AppState> store, action, NextDispatcher next) {
    next(action);

    saveToPrefs(store.state);
  };
}

// save data in shared preferences store
void saveToPrefs(AppState state) async {
  // create instance of SharedPreferences
  SharedPreferences preferences = await SharedPreferences.getInstance();
  // encode the current AppState state into json, then to a string
  String string = json.encode(state.toJson());
  // send it into preferences in 'itemsState' key
  await preferences.setString('itemsState', string);
  print('[saveToPrefs]: $string');
}

// load data from shared preferences store
Future<AppState> loadFromPrefs() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String string = preferences.getString('itemsState');
  print('[loadFromPrefs]: $string');
  if (string != null) {
    Map map = json.decode(string);
    return AppState.fromJson(map);
  }
  return AppState.initialState();
}

// void appStateMiddleware(
//     // if no action triggered in function, action sent to reducer
//     Store<AppState> store,
//     action,
//     NextDispatcher next) async {
//   next(action);

//   if (action is AddItemAction ||
//       action is RemoveItemAction ||
//       action is RemoveItemsAction) {
//     saveToPrefs(store.state);
//   }
//   // get items from preference store and send to LoadedItemsAction
//   if (action is GetItemsAction) {
//     print("[GetItemsAction]: HELLO FROM MIDDLEWARE!");
//     await loadFromPrefs()
//         .then((state) => store.dispatch(LoadedItemsAction(state.items)));
//   }
// }
