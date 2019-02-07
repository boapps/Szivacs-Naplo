import 'dart:async';
import '../Datas/Evaluation.dart';
import '../Datas/Account.dart';
import '../Datas/Absence.dart';
import '../globals.dart' as globals;

void refreshOnline() async {
  globals.global_evals.clear();
  globals.global_absents.clear();
  for (Account account in globals.accounts) {
    print(account.user.name);
    await account.refreshEvaluations(false, false);
    await account.refreshAbsents(false, false);
    globals.global_evals.addAll(account.evaluations);
    globals.global_absents.addAll(account.absents);
  }
}

Future<void> refreshOffline() async {
  globals.global_evals.clear();
  globals.global_absents.clear();
  for (Account account in globals.accounts) {
    await account.refreshEvaluations(false, true);
    await account.refreshAbsents(false, true);
    globals.global_evals.addAll(account.evaluations);
    globals.global_absents.addAll(account.absents);
  }
}

List<Evaluation> get normalEvals => globals.global_evals.where((Evaluation e) => e.type == "MidYear").toList();
List<Evaluation> get normalEvalsSingle => globals.global_evals.where((Evaluation e) => e.type == "MidYear" && e.owner.id == globals.selectedUser.id).toList();

Map<String, List<Absence>> get absentsSingle {
  Map<String, List<Absence>> global_absents = new Map();
  globals.global_absents.forEach((String s, List<Absence> ab){
    if (ab[0].owner.id==globals.selectedUser.id)
      global_absents.putIfAbsent(s, () => ab);
  });

  return global_absents;
}