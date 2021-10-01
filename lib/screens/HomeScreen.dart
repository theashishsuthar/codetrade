import 'package:codetrade/model/User.dart';
import 'package:codetrade/providers/Login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _userNameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            title: Text('CodeTrade'),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(
                    icon: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [Icon(Icons.person_add), Text('Add User')],
                )),
                Tab(
                    icon: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [Icon(Icons.group), Text('Users')],
                )),
                Tab(
                    icon: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [Icon(Icons.lock), Text('Sign in')],
                )),
              ],
            )),
        body: TabBarView(
          children: [signUpForm(), userList(), loginForm()],
        ),
      ),
    );
  }

  //Sign up form which takes username and password input

  Widget signUpForm() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05),
      child: Column(
        children: [
          TextFormField(
            controller: _userNameController,
            focusNode: _userNameFocus,
            decoration: InputDecoration(hintText: 'Enter a username'),
          ),
          TextFormField(
            controller: _passwordController,
            focusNode: _passwordFocus,
            decoration: InputDecoration(hintText: 'Enter a password'),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          MaterialButton(
            onPressed: () {
              //Validations
              if (_userNameController.text.trim().length != 0 &&
                  _passwordController.text.trim().length != 0) {
                User user = User(
                    username: _userNameController.text,
                    password: _passwordController.text);

                FocusScope.of(context).unfocus();

                //Function to store data

                Provider.of<MainControll>(context, listen: false)
                    .saveUser(user)
                    .then((value) {
                  print(value);
                  if (value > 0) {
                    //Succesfuly validating
                    toastMessage('User added successfully');
                  } else {
                    //Error handling part
                    FlutterToast(
                      context,
                    ).showToast(child: Text('Something went wrong'));
                  }
                });
              } else {
                //Validations
                FocusScope.of(context).unfocus();
                toastMessage('All fields are manadatory');
              }
            },
            color: Colors.blue,
            child: Text(
              'Submit',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  //List of users

  Widget userList() => Container(
        child: Container(
            child: FutureBuilder(
          future: Provider.of<MainControll>(context).fetchUser(),
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasError) {
                return Container(
                  child: Center(
                    child: Text('Error occured'),
                  ),
                );
              } else if (snapshot.hasData) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: snapshot.data.length != 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Card(
                              child: ListTile(
                                leading: Icon(Icons.person),
                                title: Text(snapshot.data[i].userName),
                                trailing: Container(
                                    child: IconButton(
                                        onPressed: () {
                                          //deletetion function
                                          Provider.of<MainControll>(context,
                                                  listen: false)
                                              .deleteUser(snapshot.data[i].iD);
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ))),
                              ),
                            );
                          })
                      : Container(
                          child: Center(
                            child: Text('No Users here yet'),
                          ),
                        ),
                );
              } else {
                return Container(
                  child: Text('No data found'),
                );
              }
            }
          },
        )),
      );

  //login form

  Widget loginForm() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05),
      child: Column(
        children: [
          TextFormField(
            controller: _userNameController,
            focusNode: _userNameFocus,
            decoration: InputDecoration(hintText: 'Enter a username'),
          ),
          TextFormField(
            controller: _passwordController,
            focusNode: _passwordFocus,
            decoration: InputDecoration(hintText: 'Enter a password'),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          MaterialButton(
            onPressed: () {
              if (_userNameController.text.trim().length != 0 &&
                  _passwordController.text.trim().length != 0) {
                User user = User(
                    username: _userNameController.text,
                    password: _passwordController.text);

                FocusScope.of(context).unfocus();

                Provider.of<MainControll>(context, listen: false)
                    .getLogin(
                        _userNameController.text, _passwordController.text)
                    .then((value) {
                  if (value > 0) {
                    //Succesfuly validating
                    toastMessage('User Exist');
                  } else {
                    FlutterToast(
                      context,
                    ).showToast(child: Text('User does not exist'));
                  }
                });
              } else {
                FocusScope.of(context).unfocus();
                toastMessage('All fields are manadatory');
              }
            },
            color: Colors.blue,
            child: Text(
              'Submit',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
  //Toast message

  toastMessage(String title) => FlutterToast(
        context,
      ).showToast(
          child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: Text(title)));
}
