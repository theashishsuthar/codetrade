import 'package:codetrade/Helper/database_helper.dart';
import 'package:codetrade/model/User.dart';

import 'dart:async';

import 'package:flutter/material.dart';

class MainControll extends ChangeNotifier {
  DatabaseHelper con = new DatabaseHelper();

  //To save User
  Future<int> saveUser(User user) async {
    final db = await con.initDb();

    return db.insert('User', user.toMap());
  }

  //Fetch ALl User

  Future<List<User>> fetchUser() async {
    //returns the memos as a list (array)

    final db = await con.initDb();
    final maps = await db
        .query("User"); //query all the rows in a table as an array of maps

    return List.generate(maps.length, (i) {
      //create a list of memos
      return User(
        id: maps[i]['id'],
        username: maps[i]['username'],
        password: maps[i]['password'],
      );
    });
  }

  //A method to delete uuser
  Future<int> deleteUser(int id) async {
    //returns number of items deleted
    final db = await con.initDb();

    int result = await db.delete("User", //table name
        where: "id = ?",
        whereArgs: [id] // use whereArgs to avoid SQL injection
        );
    notifyListeners();
    return result;
  }

  Future<int> getLogin(String user, String password) async {
    var dbClient = await con.initDb();
    var res = await dbClient.rawQuery(
        "SELECT * FROM User WHERE username = '$user' and password = '$password'");

    notifyListeners();

    return res.length;
  }

  Future<List<User>> getAllUser() async {
    var dbClient = await con.db;
    var res = await dbClient.query("user");

    notifyListeners();

    List<User> list =
        res.isNotEmpty ? res.map((c) => User.fromMap(c)).toList() : null;

    return list;
  }
}
