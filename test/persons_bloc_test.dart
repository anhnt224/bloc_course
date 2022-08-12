import 'package:bloc_2/bloc/bloc_action.dart';
import 'package:bloc_2/bloc/person.dart';
import 'package:bloc_2/bloc/persons_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

const mockedPerson1 = [
  Person(name: 'Foo 1', age: 20),
  Person(name: 'Bar 1', age: 30),
  Person(name: 'Baz 2', age: 40),
];

const mockedPerson2 = [
  Person(name: 'Foo 2', age: 20),
  Person(name: 'Bar 2', age: 30),
  Person(name: 'Baz 2', age: 40),
];

Future<Iterable<Person>> mockGetPerson1(String _) =>
    Future.value(mockedPerson1);

Future<Iterable<Person>> mockGetPerson2(String _) =>
    Future.value(mockedPerson2);

void main() {
  group(
    'Testing bloc',
    () {
      //write our test
      late PersonBloc bloc;

      setUp(() {
        bloc = PersonBloc();
      });

      blocTest<PersonBloc, FetchResult?>('Testing initial state',
          build: () => bloc, verify: (bloc) => bloc.state == null);

      // fetch mock data (person1) and compare it with FetchResult
      blocTest(
        'Mock retrieving persons from first iterable',
        build: () => bloc,
        act: (bloc) {
          (bloc as PersonBloc).add(
            const LoadPersonsAction(loader: mockGetPerson1, url: 'dummy_url_1'),
          );
          bloc.add(
            const LoadPersonsAction(loader: mockGetPerson1, url: 'dummy_url_1'),
          );
        },
        expect: () => [
          const FetchResult(
            persons: mockedPerson1,
            isRetrievedFromCache: false,
          ),
          const FetchResult(
            persons: mockedPerson1,
            isRetrievedFromCache: true,
          ),
        ],
      );
      blocTest(
        'Mock retrieving persons from second iterable',
        build: () => bloc,
        act: (bloc) {
          (bloc as PersonBloc).add(
            const LoadPersonsAction(loader: mockGetPerson2, url: 'dummy_url_2'),
          );
          bloc.add(
            const LoadPersonsAction(loader: mockGetPerson2, url: 'dummy_url_2'),
          );
        },
        expect: () => [
          const FetchResult(
            persons: mockedPerson2,
            isRetrievedFromCache: false,
          ),
          const FetchResult(
            persons: mockedPerson2,
            isRetrievedFromCache: true,
          ),
        ],
      );
    },
  );
}
