import 'package:bloc_2/bloc/person.dart';
import 'package:flutter/foundation.dart';

const person1Url = 'http://127.0.0.1:5500/api/persons1.json';
const person2Url = 'http://127.0.0.1:5500/api/persons2.json';

typedef PersonLoader = Future<Iterable<Person>> Function(String url);

enum PersonUrl {
  persons1,
  persons2,
}

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonsAction extends LoadAction {
  final String url;
  final PersonLoader loader;
  const LoadPersonsAction({
    required this.url,
    required this.loader,
  }) : super();
}
