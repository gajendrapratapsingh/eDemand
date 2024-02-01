import 'package:e_demand/app/generalImports.dart';

class DownloadInvoiceCubit extends Cubit<DownloadInvoiceState> {
  DownloadInvoiceCubit(this.bookingRepository) : super(DownloadInvoiceInitial());
  BookingRepository bookingRepository;

  void downloadInvoice({required final String bookingId}) {
    emit(DownloadInvoiceInProgress(bookingId: bookingId));

    bookingRepository.downloadInvoice(bookingId: bookingId).then((final value) {
      emit(DownloadInvoiceSuccess(invoiceData: value, bookingId: bookingId));
    }).catchError((final e, final st) {
      emit(DownloadInvoiceFailure(errorMessage: e.toString(), bookingId: bookingId));
    });
  }
}

//State
abstract class DownloadInvoiceState {}

class DownloadInvoiceInitial extends DownloadInvoiceState {}

class DownloadInvoiceInProgress extends DownloadInvoiceState {
  final String bookingId;

  DownloadInvoiceInProgress({required this.bookingId});
}

class DownloadInvoiceSuccess extends DownloadInvoiceState {
  DownloadInvoiceSuccess({required this.bookingId, required this.invoiceData});

  final List<int> invoiceData;
  final String bookingId;
}

class DownloadInvoiceFailure extends DownloadInvoiceState {
  DownloadInvoiceFailure({required this.bookingId, required this.errorMessage});

  final String errorMessage;
  final String bookingId;
}
