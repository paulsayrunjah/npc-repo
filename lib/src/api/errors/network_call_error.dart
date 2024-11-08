class ServerException implements Exception {}

class DataParsingException implements Exception {}

class NoConnectionException implements Exception {}

class CustomApiException implements Exception {
  CustomApiException(this.cause);
  String cause;
}

class NetworkErrorObject {
  const NetworkErrorObject({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  // ignore: prefer_constructors_over_static_methods
  static NetworkErrorObject handleError(final Exception exception) {
    if (exception is ServerException) {
      return const NetworkErrorObject(
        title: 'Error Code: INTERNAL_SERVER_FAILURE',
        message: 'It seems that the server is not reachable at the moment, try '
            'again later, should the issue persist please reach out to the '
            'developer at kDeveloperEmail',
      );
    }
    if (exception is DataParsingException || exception is FormatException) {
      return const NetworkErrorObject(
        title: 'Error Code: INTERNAL_SERVER_FAILURE',
        message: "Can't parse the server data "
            'again later, should the issue persist please reach out to the '
            'developer at kDeveloperEmail',
      );
    }

    if (exception is NoConnectionException) {
      return const NetworkErrorObject(
        title: 'Error Code: NO_CONNECTIVITY',
        message: 'It seems that your device is not connected to the network, '
            'please check your internet connectivity or try again later.',
      );
    }

    if (exception is CustomApiException) {
      return NetworkErrorObject(
        title: 'Error Code: CUSTOM_ERROR',
        message:
            exception.cause.isEmpty ? "Can't process request" : exception.cause,
      );
    }

    return const NetworkErrorObject(
      title: 'Error Code: APP_FAILURE',
      message: 'It seems that the server is not reachable at the moment, try '
          'again later, should the issue persist please reach out to the '
          'developer at kDeveloperEmail',
    );
  }
}
