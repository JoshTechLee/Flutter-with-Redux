import 'package:flutter_with_redux/model/model.dart';

// action properties and parameters determined by what is needed to change the store
// Class objects are what are passed in via action call
// all properties are used to interact with reducers
// TLDR: things passed to reducer via action object

class AddItemAction{
  static int _id = 0;
  final String body;

  AddItemAction(this.body){
    _id++;
  }

  int get id => _id;
}

class RemoveItemAction{
  final Item item;

  RemoveItemAction(this.item);
}

class RemoveItemsAction{}

class GetItemsAction{}

class LoadedItemsAction{
  final List<Item> items;
  LoadedItemsAction(this.items);
}

class ItemCompletedAction {
  final Item item;

  ItemCompletedAction(this.item);
}