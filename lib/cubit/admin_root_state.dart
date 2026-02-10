import 'package:equatable/equatable.dart';

class AdminRootState extends Equatable {
  final int index;

  const AdminRootState(this.index);

  @override
  List<Object?> get props => [index];
}
