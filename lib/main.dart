import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

import 'package:flutter_with_redux/model/model.dart';
import 'package:flutter_with_redux/redux/actions.dart';
import 'package:flutter_with_redux/redux/reducers.dart';
import 'package:flutter_with_redux/redux/middleware.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // create store
  final DevToolsStore<AppState> store = DevToolsStore<AppState>(
    // final Store<AppState> store = Store<AppState>(
    appStateReducer,
    initialState: AppState.initialState(),
    middleware: appStateMiddleware(),
  );

  @override
  Widget build(BuildContext context) {
    // surround entire application with StoreProvider<Model>(...)
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: "MyApp",
        theme: ThemeData.dark(),
        // StoreBuilder listens to store for actions
        home: StoreBuilder<AppState>(
          onInit: (store) => store.dispatch(GetItemsAction()),
          builder: (BuildContext context, Store<AppState> store) =>
              MyHomePage(store),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final DevToolsStore<AppState> store;
  // final Store<AppState> store;

  MyHomePage(this.store);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter with Redux"),
      ),
      body: StoreConnector<AppState, _ViewModel>(
        // converter sends ViewModel object to descending widgets
        converter: (Store<AppState> store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) => Column(
              children: <Widget>[
                AddItemWidget(viewModel),
                Expanded(
                  child: ItemListWidget(viewModel),
                ),
                RemoveItemsButton(viewModel),
              ],
            ),
      ),
      drawer: Container(
        child: ReduxDevTools(store),
      ),
    );
  }
}

class RemoveItemsButton extends StatelessWidget {
  final _ViewModel model;

  RemoveItemsButton(this.model);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text('Delete all ITems'),
      onPressed: () => model.onRemoveItems(),
    );
  }
}

class ItemListWidget extends StatelessWidget {
  final _ViewModel model;
  ItemListWidget(this.model);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: model.items
          .map(
            (Item item) => ListTile(
                  title: Text(item.body),
                  leading: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => model.onRemoveItem(item),
                  ),
                  trailing: Checkbox(
                    value: item.completed,
                    onChanged: (b) {
                      model.onCompleted(item);
                    },
                  ),
                ),
          )
          .toList(),
    );
  }
}

class AddItemWidget extends StatefulWidget {
  final _ViewModel model;

  AddItemWidget(this.model);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItemWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO:  <Imported_Class_w_Widget>(_AddItemWidgetFunction)
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'add an item',
      ),
      onSubmitted: (String s) {
        // pass to ViewModel with onAddItem function
        widget.model.onAddItem(s);
        controller.text = '';
      },
    );
  }
}

class _ViewModel {
  // final Function(<Parameter_Types>)
  final List<Item> items;
  final Function(Item) onCompleted;
  final Function(String) onAddItem;
  final Function(Item) onRemoveItem;
  final Function() onRemoveItems;

  _ViewModel({
    this.items,
    this.onCompleted,
    this.onAddItem,
    this.onRemoveItem,
    this.onRemoveItems,
  });

  factory _ViewModel.create(Store<AppState> store) {
    // defining functions for ViewModel with necessary paramters
    _onAddItem(String body) {
      store.dispatch(AddItemAction(body));
    }

    _onCompleted(Item item) {
      store.dispatch(ItemCompletedAction(item));
    }

    _onRemoveItem(Item item) {
      store.dispatch(RemoveItemAction(item));
    }

    _onRemoveItems() {
      store.dispatch(RemoveItemsAction());
    }

    // return created ViewModel object
    return _ViewModel(
      items: store.state.items,
      onCompleted: _onCompleted,
      onAddItem: _onAddItem,
      onRemoveItem: _onRemoveItem,
      onRemoveItems: _onRemoveItems,
    );
  }
}
