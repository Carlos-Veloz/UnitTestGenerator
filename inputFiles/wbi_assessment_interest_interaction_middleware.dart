import 'package:core_redux/redux.dart';
import 'package:rlv_vive_mas/di/rlv_vive_mas_state.dart';
import 'package:rlv_vive_mas/domain/entities/wbi_interest_entity.dart';
import 'package:rlv_vive_mas/redux/wbi_assessment/wbi_assessment_actions.dart';

const _maxInterestSelection = 2;

class WBIAssessmentInterestInteractionRequest extends Request {
  final WBIInterestEntity interestInteractedWith;

  const WBIAssessmentInterestInteractionRequest({
    required this.interestInteractedWith,
  });
}

class WBIAssessmentInterestInteractionMiddleware extends BaseMiddleware<
    RlvViveMasState, WBIAssessmentInterestInteractionRequest> {
  @override
  Future run(Store<RlvViveMasState> store,
      WBIAssessmentInterestInteractionRequest request, NextDispatcher next) async {
    final isNewSelection = request.interestInteractedWith.isSelected;
    final maxSelectionReached = store
            .state.viveMasState.assessmentState.assessment!.interests
            .where((interest) => interest.isSelected)
            .length >=
        _maxInterestSelection;

    if (maxSelectionReached && !isNewSelection) {
      store.dispatch(
          UpdateInterestSelectionAction(request.interestInteractedWith));
    }

    if (!maxSelectionReached) {
      store.dispatch(
          UpdateInterestSelectionAction(request.interestInteractedWith));
    }

    if (maxSelectionReached && isNewSelection) {
      store.dispatch(const ShowMaxSelectionAlertAction());
    }

    final atLeastOneSelected = store
        .state.viveMasState.assessmentState.assessment!.interests
        .where((interest) => interest.isSelected)
        .isNotEmpty;
    if (atLeastOneSelected) {
      store.dispatch(const EnableFinishButtonAction());
    } else {
      store.dispatch(const DisableFinishButtonAction());
    }
  }
}
