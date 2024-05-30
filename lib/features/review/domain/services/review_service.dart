import 'package:get/get_connect/http/src/response/response.dart';
import 'package:sixvalley_delivery_boy/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_delivery_boy/data/api/api_checker.dart';
import 'package:sixvalley_delivery_boy/features/auth/domain/models/response_model.dart';
import 'package:sixvalley_delivery_boy/features/review/domain/repositories/review_repository_interface.dart';
import 'package:sixvalley_delivery_boy/features/review/domain/services/review_service_interface.dart';

class ReviewService implements ReviewServiceInterface {

  ReviewRepositoryInterface reviewRepoInterface;
  ReviewService({required this.reviewRepoInterface});

  @override
  Future getReviewList(int offset, int isSaved) async{
     return await reviewRepoInterface.getReviewList(offset, isSaved);
  }

  @override
  Future<ResponseModel> saveReview(int? reviewId, int isSaved) async{
    Response response = await reviewRepoInterface.saveReview(reviewId, isSaved);
    if (response.statusCode == 200) {
      String? message;
      message = response.body['message'];
      showCustomSnackBarWidget(message, isError: false);
      return ResponseModel(true, '');
    } else {
      ApiChecker.checkApi(response);
      return ResponseModel(false, '');
    }
  }

}