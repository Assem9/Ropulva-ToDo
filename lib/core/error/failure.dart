
abstract class Failure{
  final String message ;
  final String code ;
  const Failure({
    required this.message,
    required this.code,
  });
}

class ServerFailure extends Failure{
  final bool? docNotExist ;
  const ServerFailure({
    required super.message,
    required super.code,
    this.docNotExist = false
  });
}

class InternalFailure extends Failure{
  InternalFailure({required super.message, required super.code});
}