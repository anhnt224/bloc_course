import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Person {
  final String name;
  final int age;
  const Person({
    required this.name,
    required this.age,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'age': age,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      name: map['name'] as String,
      age: map['age'] as int,
    );
  }

  factory Person.fromJson(String source) =>
      Person.fromMap(json.decode(source) as Map<String, dynamic>);
}
