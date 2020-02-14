import 'package:beautifulsoup/beautifulsoup.dart';

// 1st Argument : Table, 2nd Argument : Required Row
getTableRow(tablelist, row) {
  var tablelistdoc = Beautifulsoup(tablelist);
  var tablerows2 =
      tablelistdoc.find_all("tr").map((e) => (e.outerHtml)).toList();
  var tablerows = '';
  if (tablerows2.length > row)
    tablerows = tablerows2[row];
  else
    tablerows = '';
  var tabledoc = Beautifulsoup(tablerows).get_text();
  var tabledoclist = tabledoc.split('\n');
  for (int i = 0; i < tabledoclist.length; i++)
    tabledoclist[i] = tabledoclist[i].trim();

  tabledoclist.removeWhere((value) => value == '');
  return tabledoclist;
}

getTimeTableRow(tablelist, row) {
  var tablelistdoc = Beautifulsoup(tablelist);
  var tablerows2 =
      tablelistdoc.find_all("tr").map((e) => (e.outerHtml)).toList();
  var tablerows = '';
  if (tablerows2.length > row)
    tablerows = tablerows2[row];
  else
    tablerows = '';
  var tabledoc = Beautifulsoup(tablerows).get_text();
  var tabledoclist = tabledoc.split('\n');
  // for (int i = 0; i < tabledoclist.length; i++)
  //   tabledoclist[i] = tabledoclist[i].trim();

  // tabledoclist.removeWhere((value) => value == '');
  return tabledoclist;
}




