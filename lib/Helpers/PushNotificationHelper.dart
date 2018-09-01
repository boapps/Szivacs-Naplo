import 'RequestHelper.dart';
import 'dart:async';
import 'dart:convert' show utf8, json;
import '../Utils/AccountManager.dart';
import '../Datas/User.dart';

class PushNotificationHelper {
  void enablePushNotification() async {
//    RequestHelper().getPushRegId(schoolCode, instituteUserId, handle);
    List<User> users = await AccountManager().getUsers();
    String instituteUserId = users[0].id.toString();
    String schoolCode = users[0].schoolCode;
    String handle = schoolCode + "-" + instituteUserId;

    print("debuginfo: ");
    print(instituteUserId);
    print(schoolCode);
    print(handle);
    String regBody = (await RequestHelper().getPushRegId(
      schoolCode, instituteUserId, handle)).body;
    print("regbody");
    print(regBody);
    Map<String, dynamic> regMap = json.decode(regBody);

    print(regMap);
    String code = regMap.values.toList()[0];
    print(code);

  }
}