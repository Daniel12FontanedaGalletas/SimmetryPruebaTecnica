import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;

  const UserEntity({required this.uid});

  @override
  List<Object?> get props => [uid];
}
