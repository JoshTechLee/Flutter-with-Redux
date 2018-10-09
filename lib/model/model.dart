import 'package:flutter/foundation.dart';

// entities we will use to hold individual pieces of data
class Item {
  final int id;
  final String body;
  final bool completed;

  Item({
    @required this.id,
    @required this.body,
    this.completed = false,
  });
  // Completely create a new object with new properties
  // INSTEAD of mutating old object
  Item copyWith({int id, String body, bool, completed}) {
    // ??   =   if (body/id) is null, replace with (this.body/this.id)
    return Item(
      body: body ?? this.body,
      id: id ?? this.id,
      completed: completed ?? this.completed,
    );
  }

  // fromJson named constructor
  Item.fromJson(Map json)
      : body = json['body'],
        id = json['id'],
        completed = json['completed'];

  // map item to json format
  Map toJson() => {
        'id': id,
        'body': body,
        'completed': completed,
      };
  
  // private function (toJson) to String (toString)
  @override
  String toString() {
    return toJson().toString();
  }
}

// entire state of application
class AppState {
  final List<Item> items;

  const AppState({
    @required this.items,
  });
  // initial state is empty list of <Item>
  AppState.initialState() : items = List.unmodifiable(<Item>[]);
  // fromJson named constructor
  // takes json list of objects given by 'items'
  // map objects into individual item objects and put back into list
  AppState.fromJson(Map json)
      : items = (json['items'] as List).map((i) => Item.fromJson(i)).toList();

  // get entire items list and put into 'items' key for
  Map toJson() => {'items': items};
}
