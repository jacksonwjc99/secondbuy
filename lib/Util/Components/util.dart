import 'package:intl/intl.dart';

class Util {
  static String timeSinceSet(String sellTime) {
    print(sellTime.toString());
    DateFormat df = DateFormat('yyyy-MM-dd HH:mm:ss');
    DateTime dateNow = df.parse(DateTime.now().toString());

    int difference = dateNow.difference(DateTime.parse(sellTime)).inMinutes;

    if (difference > 60) {
      // Hour
      double hour = difference / 60;
      if (hour < 24) {
        return hour.floor().toString() + (hour < 2 ? " hr " : " hrs ") + " ago";
      }

      //Days
      double days = hour / 24;
      if (days < 7) {
        return days.floor().toString() +
            (days < 2 ? " day " : " days ") +
            " ago";
      }

      //Weeks
      double weeks = days / 7;
      if (weeks < 4) {
        return weeks.floor().toString() +
            (weeks < 2 ? " wk " : " wks ") +
            " ago";
      }

      //Weeks
      double months = weeks / 4;
      if (months < 12) {
        return months.floor().toString() +
            (months < 2 ? " mth " : " mths ") +
            " ago";
      }

      //Weeks
      double years = months / 12;
      return years.floor().toString() + (years < 2 ? " yr " : " yrs ") + " ago";
    } else {
      if (difference < 0)
        return (difference.floor() * -1).toString() + " mins left";

      if (difference < 10)
        return "Just now";
      else
        return difference.floor().toString() + " mins ago";
    }
  }
}
