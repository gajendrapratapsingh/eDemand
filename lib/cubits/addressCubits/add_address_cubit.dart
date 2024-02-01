import 'package:e_demand/app/generalImports.dart';

class AddAddressState {}

class AddAddressInitial extends AddAddressState {}

class AddAddressInProgress extends AddAddressState {}

class AddAddressSuccess extends AddAddressState {

  AddAddressSuccess(this.result);
  final dynamic result;
}

class AddAddressFail extends AddAddressState {

  AddAddressFail(this.error);
  final dynamic error;
}

class AddAddressCubit extends Cubit<AddAddressState> {
  AddAddressCubit() : super(AddAddressInitial());
  final AddressRepository addressRepository = AddressRepository();

  Future<void> addAddress(final AddressModel addressDataModel) async {
    try {
      emit(AddAddressInProgress());
      final Map<String, dynamic> response = await addressRepository.addAddress(addressDataModel);
      if (response["error"] == true) {
        emit(AddAddressFail(response["message"]));
      } else {
        emit(AddAddressSuccess(response));
      }
    } catch (e) {
      emit(AddAddressFail(e));
    }
  }
}
