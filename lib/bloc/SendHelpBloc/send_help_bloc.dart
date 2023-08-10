import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../Model/Help/SendHelpRequestModel.dart';
import '../../Repository/SaveALifeRepository.dart';

part 'send_help_event.dart';
part 'send_help_state.dart';

class SendHelpBloc extends Bloc<SendHelpBlocEvent, SendHelpBlocState> {
  SaveaLifeRepository saveALiferepository;
  String accesstoken;
  SendHelpBloc({required this.saveALiferepository, required this.accesstoken})
      : super(SendHelpInitialState()) {
    on<SendHelpBlocEvent>((event, emit) async {
      if (event is SendHelpProgressEvent) {
        emit(SendHelpProgressState());
      }

      if (event is SendHelpRequestEvent) {
        emit(SendHelpProgressState());
        try {
          final response = await saveALiferepository.sendHelpRequest(
              event.sendHelpRequestModel, accesstoken);
          emit(SendHelpRequestSucessState(msg: response));
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }
}
