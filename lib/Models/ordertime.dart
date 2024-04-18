
class OrderTime{
  late String _selectedMonth;
  late String _selectedDay;
  late String _selectedDayName;
  late int _selectedTime;

  String get SelectedMonth => _selectedMonth;

  set SelectedMonth(String value) {
    _selectedMonth = value;
  }

  String get SelectedDay => _selectedDay;

  set SelectedDay(String value) {
    _selectedDay = value;
  }

  String get SelectedDayName => _selectedDayName;

  set SelectedDayName(String value) {
    _selectedDayName = value;
  }

  int get SelectedTime => _selectedTime;

  set SelectedTime(int value) {
    _selectedTime = value;
  }

}