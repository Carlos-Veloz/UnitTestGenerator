import 'package:core_di/di.dart';
import 'package:core_redux/redux.dart';
import 'package:rlv_vive_mas/di/rlv_vive_mas_state.dart';
import 'package:rlv_vive_mas/domain/repository/vive_mas_repository.dart';
import 'package:rlv_vive_mas/redux/wbi_assessment/wbi_assessment_actions.dart';
import 'package:rlv_vive_mas/redux/wbi_assessment/wbi_assessment_state.dart';

class GetWBIAssessmentRequest extends Request {
  final String assessmentId;
  final String habitId;

  const GetWBIAssessmentRequest({
    required this.assessmentId,
    required this.habitId,
  });
}

class GetWBIAssessmentMiddleware
    extends BaseMiddleware<RlvViveMasState, GetWBIAssessmentRequest> {
  @override
  Future run(
    Store<RlvViveMasState> store,
    GetWBIAssessmentRequest request,
    NextDispatcher next,
  ) async {
    if (store.state.viveMasState.assessmentState.status !=
        GetWBIAssessmentStatus.loading) {
      store.dispatch(const SetLoadingAction());
    }

    final repository = GetIt.instance<ViveMasRepository>();
    final assessmentOrFailure = await repository.getWBIAssessmentById(
      request.assessmentId,
      request.habitId,
    );

    assessmentOrFailure.fold(
      (failure) => store.dispatch(SetFailureAction(failure)),
      (assessment) =>
          store.dispatch(SetAssessmentAction(assessment: assessment)),
    );
  }
}
