// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc_action.dart';
import 'bloc/person.dart';
import 'bloc/persons_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => PersonBloc(),
        child: const HomePage(),
      ),
    );
  }
}

Future<List<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromMap(e)).toList());

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    context.read<PersonBloc>().add(const LoadPersonsAction(
                        url: person1Url, loader: getPersons));
                  },
                  child: const Text('Load json #1')),
              TextButton(
                  onPressed: () {
                    context.read<PersonBloc>().add(const LoadPersonsAction(
                        url: person2Url, loader: getPersons));
                  },
                  child: const Text('Load json #2'))
            ],
          ),
          BlocBuilder<PersonBloc, FetchResult?>(buildWhen: (previous, current) {
            return previous?.persons != current?.persons;
          }, builder: (context, fetchResult) {
            final persons = fetchResult?.persons;
            if (persons == null) {
              return const SizedBox();
            }
            return Expanded(
              child: ListView.builder(
                itemCount: persons.length,
                itemBuilder: ((context, index) {
                  final person = persons[index];
                  return ListTile(
                    title: Text(person?.name ?? 'aa'),
                  );
                }),
              ),
            );
          })
        ],
      ),
    );
  }
}
