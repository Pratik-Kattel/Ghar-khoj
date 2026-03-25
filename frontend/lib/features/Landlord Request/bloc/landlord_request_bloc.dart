import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/services/get_user_data.dart';
import '../Repository/landlord_request_repo.dart';
import 'landlord_request_event.dart';
import 'landlord_request_state.dart';

class LandlordRequestBloc
    extends Bloc<LandlordRequestEvent, LandlordRequestState> {
  final LandlordRequestRepo repo;

  LandlordRequestBloc({required this.repo}) : super(LandlordRequestInitial()) {
    on<SubmitLandlordRequestEvent>(_onSubmit);
  }

  Future<void> _onSubmit(
      SubmitLandlordRequestEvent event,
      Emitter<LandlordRequestState> emit,
      ) async {
    emit(LandlordRequestLoading());
    try {
      await repo.submitRequest(
        email: event.email,
        citizenshipFile: event.citizenshipFile,
      );
      emit(LandlordRequestSuccess());
    } on Exception catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      emit(LandlordRequestError(message));
    }
  }
}