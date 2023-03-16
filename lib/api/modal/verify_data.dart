import 'package:scansquad/routes/common_functions.dart';

Map<String, dynamic> verifyData(
    List<String?> allQrdatalist, DateTime lastModifiedSync) {
  bool validity = false;
  var minimum_t, maximum_t;
  Map<String, dynamic> data;
  if (allQrdatalist.isNotEmpty) {
    String initialUserName =
        extractQRDataText(allQrdatalist[0]!).entries.first.value;
    List timeStamps = [];
    for (var i = 0; i < allQrdatalist.length; i++) {
      timeStamps.add((extractQRDataText(allQrdatalist[i]!)).entries.last.value);
      if (initialUserName ==
          extractQRDataText(allQrdatalist[i]!).entries.first.value) {
        validity = true;
      }
    }

    formatTimeStamp(lastModifiedSync);
    timeStamps.sort();
    Map<String, String> time = getMinMaxTimeStamps(timeStamps);
    minimum_t = time.values.first;
    maximum_t = time.values.last;
    print('======Min=$minimum_t');
    print('======Max=$maximum_t');
    data = {
      'isValid': validity,
      'userName': initialUserName,
      'min_time': minimum_t,
      'max_time': maximum_t,
      'last_modified': lastModifiedSync
    };
  } else {
    data = {'isValid': validity, 'last_modified': lastModifiedSync};
  }

  return data;
}

Map<String, dynamic> extractQRDataText(String barcode) {
  String _name = barcode.substring(0, barcode.length - 4);
  String _hm = barcode.substring(barcode.length - 4);
  int hm = int.parse(_hm);
  Map<String, dynamic> mappedData = {'name': _name, 'hours-minutes': hm};
  return mappedData;
}

Map<String, String> getMinMaxTimeStamps(List timeStamps) {
  var min_t = timeStamps[0];
  var max_t = timeStamps[timeStamps.length - 1];
  String minimum_time = min_t.toString();
  String maximum_time = max_t.toString();
  if (minimum_time.length == 3) {
    minimum_time = '0$minimum_time';
  }
  if (minimum_time.length == 2) {
    minimum_time = '00$minimum_time';
  }
  if (minimum_time.length == 1) {
    minimum_time = '000$minimum_time';
  }
  if (maximum_time.length == 3) {
    maximum_time = '0$maximum_time';
  }
  if (maximum_time.length == 2) {
    maximum_time = '00$maximum_time';
  }
  if (maximum_time.length == 1) {
    maximum_time = '000$maximum_time';
  }
  Map<String, String> reqTimeStamps = {
    'min_t': minimum_time,
    'max_t': maximum_time
  };
  return reqTimeStamps;
}

String getFormattedTimeDuration(String timeString) {
  String hours = timeString.substring(0, 2);
  String minutes = timeString.substring(2, 4);
  String formattedTimeDuration = '$hours:$minutes';
  return formattedTimeDuration;
}
