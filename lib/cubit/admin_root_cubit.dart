import 'package:bloc/bloc.dart';
import 'admin_root_state.dart';

class AdminRootCubit extends Cubit<AdminRootState> {
  AdminRootCubit() : super(const AdminRootState(0));

  void changeTab(int index) {
    emit(AdminRootState(index));
  }
}
