import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: getUsers,
        backgroundColor: Colors.deepOrange,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Center(
          child: Text(
            'List Users',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index)
            {
              final user = users[index];
              //final color = user.gender == 'male' ? Colors.deepOrange: Colors.yellow;
              return ListTile(
                title: Text(user.name.first),
                subtitle: Text(user.phone),
                //tileColor: color,
              );
            }
        ),
      ),
    );
  }

  Future<void> getUsers() async {
    const url = 'https://randomuser.me/api/?results=100';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    // on passe à la transformation des données à notre classe
    final results = json['results'] as List<dynamic>;
    final transformed = results.map((e) {
      final name = UserName(
          title: e['name']['title'],
          first: e['name']['first'],
          last: e['name']['last'],
      );

      return User(
          gender: e['gender'],
          email: e['email'],
          cell: e['cell'],
          phone: e['phone'],
          nat: e['nat'],
          name: name,
      );
    }).toList();

    setState(() {
      users = transformed;
    });
  }

}
