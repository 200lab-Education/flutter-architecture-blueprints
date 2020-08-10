import 'package:app/data/app_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  test('AppError Test', () async {
    expect(
        AppError(
          DioError(type: DioErrorType.CONNECT_TIMEOUT),
        ).type,
        equals(AppErrorType.TIMEOUT));

    expect(
        AppError(
          DioError(type: DioErrorType.RECEIVE_TIMEOUT),
        ).type,
        equals(AppErrorType.TIMEOUT));

    expect(
        AppError(
          DioError(type: DioErrorType.SEND_TIMEOUT),
        ).type,
        equals(AppErrorType.TIMEOUT));

    expect(
        AppError(
          DioError(type: DioErrorType.RESPONSE),
        ).type,
        equals(AppErrorType.SERVER));

    expect(
        AppError(
          DioError(type: DioErrorType.CANCEL),
        ).type,
        equals(AppErrorType.CANCEL));

    expect(
        AppError(
          DioError(type: DioErrorType.DEFAULT),
        ).type,
        equals(AppErrorType.UNKNOWN));

    expect(AppError(AsyncError<String>('error')).type,
        equals(AppErrorType.UNKNOWN));

    expect(AppError(null).type, equals(AppErrorType.UNKNOWN));
  });
}
