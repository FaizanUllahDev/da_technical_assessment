import 'package:da_technical_assessment/core/utils/date_service.dart';
import 'package:da_technical_assessment/core/utils/utils.dart';

class TopUpService {
  static int get maxAmountPerMonthPerBeneficiary =>
      Utils.currentUser.isVerified == true
          ? maxAmountPerMonthForVerifiedUserPerBeneficiary
          : maxAmountPerMonthForNonVerifiedUserPerBeneficiary;

  static const int maxAmountPerMonthForVerifiedUserPerBeneficiary = 500;
  static const int maxAmountPerMonthForNonVerifiedUserPerBeneficiary = 1000;
  static num maxBasedLimitAmount = 3000;

  static Map<String, num> userTopUpLimits = {};

  // Function to check if a top-up transaction exceeds the limit
  static bool isBasedAmountExceedingLimit() {
    final bool result = maxBasedLimitAmount <= 0 ? true : false;
    return result;
  }

  // Function to check if a top-up transaction exceeds the limit
  static bool isExceedingLimit(String userId, num amount) {
    num totalTopUp = (userTopUpLimits[userId] ?? 0.0) + amount;
    return totalTopUp > maxAmountPerMonthPerBeneficiary;
  }

  // Function to process a top-up transaction
  static bool processTopUp(String userId, num amount) {
    if (!isExceedingLimit(userId, amount)) {
      // If not exceeding limit, update user's total top-up amount
      userTopUpLimits[userId] = (userTopUpLimits[userId] ?? 0) + amount;
      maxBasedLimitAmount = maxBasedLimitAmount - userTopUpLimits[userId]!;
      return true; // Transaction successful
    } else {
      return false; // Transaction failed due to limit exceeded
    }
  }
}
