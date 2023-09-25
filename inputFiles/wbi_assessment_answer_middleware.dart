import 'package:core_redux/redux.dart';
import 'package:rlv_vive_mas/di/rlv_vive_mas_state.dart';
import 'package:rlv_vive_mas/domain/entities/wbi_question_entity.dart';
import 'package:rlv_vive_mas/redux/wbi_assessment/wbi_assessment_actions.dart';

class WBIAssessmentAnswerRequest extends Request {
  final WBIQuestionEntity questionAnswered;

  const WBIAssessmentAnswerRequest({
    required this.questionAnswered,
  });
}

class WBIAssessmentAnswerMiddleware
    extends BaseMiddleware<RlvViveMasState, WBIAssessmentAnswerRequest> {
  @override
  Future run(Store<RlvViveMasState> store, WBIAssessmentAnswerRequest request,
      NextDispatcher next) async {

    final questions = store.state.viveMasState.assessmentState.assessment!.questions;
    final questionsUpdated = questions.map((question) =>
    question.id == request.questionAnswered.id
        ? question.copyWith(answer: request.questionAnswered.answer)
        : question).toList();

    await store.dispatch(QuestionAnsweredAction(questionsUpdated));

    final totalQuestions = store.state.viveMasState
        .assessmentState.assessment!.questions.length;
    final totalQuestionsAnswered = store
        .state.viveMasState.assessmentState.assessment!.questions
        .where((question) => question.answer.id.isNotEmpty)
        .length;

    final progressionPercentage =
        (totalQuestionsAnswered / totalQuestions) * 100;
    if (progressionPercentage == 100) {
      store.dispatch(const PrimaryQuestionsCompletedAction());
    }
    store.dispatch(UpdateQuestionProgressAction(progressionPercentage));
  }
}
