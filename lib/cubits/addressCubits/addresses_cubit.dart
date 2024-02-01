import 'package:e_demand/app/generalImports.dart';

abstract class AddressesState {}

class AddressesInitial extends AddressesState {}

class Addresses extends AddressesState {

  Addresses(this.addresses);
  List<GetAddressModel> addresses = [];
}

class AddressesCubit extends Cubit<AddressesState> {
  AddressesCubit() : super(AddressesInitial());

  void load(final List<GetAddressModel> data) {
    emit(Addresses(data));
  }

  void removeAddress(final String id) {
    final List<GetAddressModel> address = (state as Addresses).addresses;

    address.removeWhere((final element) => element.id == id);
    emit(Addresses(List.from(address)));
  }

  void addAddress(final GetAddressModel model) {
    final List<GetAddressModel> address = List<GetAddressModel>.from((state as Addresses).addresses);
    address.add(model);
    emit(Addresses(List.from(address)));
  }

  void updateAddress(final String id, final GetAddressModel model) {
    final int index = (state as Addresses).addresses.indexWhere((final element) => element.id == id);

    (state as Addresses).addresses[index] = model;
    emit(Addresses(List.from((state as Addresses).addresses)));
  }
}
