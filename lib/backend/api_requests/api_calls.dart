import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

class ExercisesCall {
  static Future<ApiCallResponse> call() async {
    return ApiManager.instance.makeApiCall(
      callName: 'exercises',
      apiUrl:
          'https://firebasestorage.googleapis.com/v0/b/ironfit-edef8.appspot.com/o/back_exercises.json?alt=media&token=ea88afa0-19e4-4fd2-8f39-3e0d9c609b9e',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}
