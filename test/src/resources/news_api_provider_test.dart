// tests MUST end in _test.dart for the test runner to find it
import 'package:news/src/resources/news_api_provider.dart';
// can't do relative reference if outside lib library
import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  test('FetchTopIds returns a list of ids', () async {
    // setup of test case
    final newsApi = NewsApiProvider();
    // generally mock a http request (if the api goes down, tests fail. also slow. also, they may change the API.)

    // overwrite the actual client
    newsApi.client = MockClient((request) async {
      // returns when a legitimate request is sent
      return Response(json.encode([1, 2, 3, 4]), 200);
    });

    // expectation
    final ids = await newsApi.fetchTopIds();
    expect(ids, [1,2,3,4]);
  });
}