import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_todo/.env.dart';
import 'package:flutter_todo/models/filter.dart';
import 'package:flutter_todo/widgets/ui_elements/rounded_button.dart';
import 'package:flutter_todo/widgets/ui_elements/loading_modal.dart';
import 'package:flutter_todo/widgets/todo/todo_list_view.dart';
import 'package:flutter_todo/scoped_models/app_model.dart';

class TodoListPage extends StatefulWidget {
  final AppModel model;

  TodoListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _TodoListPageState();
  }
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  void initState() {
    widget.model.fetchTodos();

    super.initState();
  }

  Widget _buildAppBar(AppModel model) {
    return AppBar(
      title: Text(Configure.AppName),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.lock),
          onPressed: () async {
            bool confirm = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: Text('Are you sure to logout?'),
                  contentPadding: EdgeInsets.all(12.0),
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RoundedButton(
                          label: 'No',
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        RoundedButton(
                          label: 'Yes',
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            );

            if (confirm) {
              model.logout();
            }
          },
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(AppModel model) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        model.setCurrentTodo(null);

        Navigator.pushNamed(context, '/editor');
      },
    );
  }

  Widget _buildAllFlatButton(AppModel model) {
    return FlatButton(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.all_inclusive,
              color: model.filter == Filter.All ? Colors.white : Colors.black,
            ),
            Text(
              'All',
              style: TextStyle(
                color: model.filter == Filter.All ? Colors.white : Colors.black,
              ),
            )
          ],
        ),
      ),
      onPressed: () {
        model.applyFilter(Filter.All);
      },
    );
  }

  Widget _buildDoneFlatButton(AppModel model) {
    return FlatButton(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.check,
              color: model.filter == Filter.Done ? Colors.white : Colors.black,
            ),
            Text(
              'Done',
              style: TextStyle(
                color:
                    model.filter == Filter.Done ? Colors.white : Colors.black,
              ),
            )
          ],
        ),
      ),
      onPressed: () {
        model.applyFilter(Filter.Done);
      },
    );
  }

  Widget _buildNotDoneFlatButton(AppModel model) {
    return FlatButton(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.check_box_outline_blank,
              color:
                  model.filter == Filter.NotDone ? Colors.white : Colors.black,
            ),
            Text(
              'Not Done',
              style: TextStyle(
                color: model.filter == Filter.NotDone
                    ? Colors.white
                    : Colors.black,
              ),
            )
          ],
        ),
      ),
      onPressed: () {
        model.applyFilter(Filter.NotDone);
      },
    );
  }

  Widget _buildBottomAppBar(AppModel model) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(),
          _buildAllFlatButton(model),
          _buildDoneFlatButton(model),
          _buildNotDoneFlatButton(model),
          SizedBox(
            width: 80.0,
          ),
        ],
      ),
      color: Colors.blue,
      shape: CircularNotchedRectangle(),
    );
  }

  Widget _buildPageContent(AppModel model) {
    return Scaffold(
      appBar: _buildAppBar(model),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: _buildFloatingActionButton(model),
      bottomNavigationBar: _buildBottomAppBar(model),
      body: Center(
        child: TodoListView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget child, AppModel model) {
        Stack stack = Stack(
          children: <Widget>[
            _buildPageContent(model),
          ],
        );

        if (model.isLoading) {
          stack.children.add(LoadingModal());
        }

        return stack;
      },
    );
  }
}
