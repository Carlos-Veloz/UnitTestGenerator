import 'package:core_di/di.dart';
import 'package:core_redux/redux.dart';
import 'package:rlv_vive_mas/di/rlv_vive_mas_state.dart';
import 'package:rlv_vive_mas/domain/middlewares/vive_mas_plan/get_vive_mas_plan_middleware.dart';
import 'package:rlv_vive_mas/domain/repository/vive_mas_repository.dart';
import 'package:rlv_vive_mas/redux/wbi_assessment/wbi_assessment_actions.dart';
import 'package:rlv_vive_mas/redux/wbi_assessment/wbi_assessment_state.dart';

class SendWBIAssessmentRequest extends Request {
  const SendWBIAssessmentRequest();
}

class SendWBIAssessmentMiddleware
    extends BaseMiddleware<RlvViveMasState, SendWBIAssessmentRequest> {
  @override
  Future run(
    Store<RlvViveMasState> store,
    SendWBIAssessmentRequest request,
    NextDispatcher next,
  ) async {
    if (store.state.viveMasState.assessmentState.status !=
        GetWBIAssessmentStatus.loading) {
      store.dispatch(const SetLoadingAction());
    }

    final repository = GetIt.instance<ViveMasRepository>();

    final assessment = store.state.viveMasState.assessmentState.assessment!;
    final dni = store.state.authState.token?.userId ?? "";
    final profileDetailInfo = store.state.myProfileState.myProfileState.profileInfo;
    final corporate = store.state.healthState.membershipCertificateState.company;
    final planCode = store.state.viveMasState.loyaltyState.userInfo?.additionalData?.planCode;
    final links = store.state.productsLinkageState.linkageState.products.linksWithViveMas();

    final unitOrFailure = await repository.postWBIAssessment(
      assessment.questions,
      assessment.habitId,
      assessment.assessmentId,
      dni,
      profileDetailInfo,
      corporate,
      planCode,
      links,
    );

    unitOrFailure.fold(
      (failure) => store.dispatch(SetFailureAction(failure)),
      (unit) => store.dispatch(const SetSentSuccessfullyAction()),
    );
  }
}
