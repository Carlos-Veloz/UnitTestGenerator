import 'package:core_redux/redux.dart';
import 'package:rlv_vive_mas/di/rlv_vive_mas_state.dart';
import 'package:rlv_vive_mas/domain/entities/wbi_question_entity.dart';
import 'package:rlv_vive_mas/redux/wbi_assessment/wbi_assessment_actions.dart';

class WBIMAssessmentSaveContinueRequest extends Request {
  final List<WBIQuestionEntity> questionsAnswered;

  const WBIMAssessmentSaveContinueRequest({
    required this.questionsAnswered,
  });
}

class WBIAssessmentSaveContinueMiddleware extends BaseMiddleware<RlvViveMasState, WBIMAssessmentSaveContinueRequest> {
  @override
  Future run(Store<RlvViveMasState> store, WBIMAssessmentSaveContinueRequest request, NextDispatcher next) {
    return store.dispatch(const MoveToInterestsSelectionAction());
  }
}