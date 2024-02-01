import 'package:e_demand/app/generalImports.dart';

abstract class DeleteAddressState {}

class DeleteAddressInitial extends DeleteAddressState {}

class DeleteAddressInProgress extends DeleteAddressState {}

class DeleteAddressSuccess extends DeleteAddressState {

  DeleteAddressSuccess(this.id);
  final String id;
}

class DeleteAddressFail extends DeleteAddressState {

  DeleteAddressFail(this.error);
  final dynamic error;
}

class DeleteAddressCubit extends Cubit<DeleteAddressState> {
  DeleteAddressCubit() : super(DeleteAddressInitial());
  final AddressRepository _address = AddressRepository();

  Future deleteAddress(final String id) async {
    try {
      emit(DeleteAddressInProgress());
      await _address.deleteAddress(id);
      emit(DeleteAddressSuccess(id));
    } catch (e) {
      emit(DeleteAddressFail(e.toString()));
    }
  }
}
