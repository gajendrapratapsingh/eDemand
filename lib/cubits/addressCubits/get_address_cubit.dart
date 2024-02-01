import 'package:e_demand/app/generalImports.dart';

abstract class GetAddressState {}

class GetAddressInitial extends GetAddressState {}

class GetAddressInProgress extends GetAddressState {}

class GetAddressSuccess extends GetAddressState {

  GetAddressSuccess(this.data);
  List<GetAddressModel> data;
}

class GetAddressFail extends GetAddressState {

  GetAddressFail(this.error);
  final String error;
}

class GetAddressCubit extends Cubit<GetAddressState> {
  GetAddressCubit() : super(GetAddressInitial());

  final AddressRepository _address = AddressRepository();

  Future fetchAddress() async {
    try {
      emit(GetAddressInProgress());

      final List<GetAddressModel> response = await _address.fetchAddress();
      emit(GetAddressSuccess(response));
    } catch (e) {
      emit(GetAddressFail(e.toString()));
    }
  }
}
