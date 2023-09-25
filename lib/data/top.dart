// ignore_for_file: non_constant_identifier_names

import 'package:flutter_finance_app_ui/data/1.dart';

List<money> geter_top() {
  money snap_Food = money();
  snap_Food.time = 'jan 30,2022';
  snap_Food.image = 'mac.png';
  snap_Food.buy = true;
  snap_Food.fee = '- \$ 100';
  snap_Food.name = 'macdonald';
  money snap = money();
  snap.image = 'Transfer.png';
  snap.time = 'today';
  snap.buy = true;
  snap.name = 'Transfer';
  snap.fee = '- \$ 60';

  return [snap_Food, snap];
}
