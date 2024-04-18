class Requests{
  late String _requestId = "" ;
  late String _userId = "" ;
  late String _sanayeeId = "" ;
  late String _userLoc = "" ;
  late String _userPhone = "" ;
  late double _lat = 0 ;
  late double _long = 0 ;
  late List<dynamic> _selectedService = [] ;
  late String _category = "" ;
  late String _selectedMonth = "" ;
  late String _selectedDay = "" ;
  late String _selectedDayName = "" ;
  late int _selectedTime=0;
  late String _description = "" ;
  late String _state = "Not Accepted Yet" ;
  late String _isArrived = "No" ;
  String get requestId => _requestId;

  set requestId(String value) {
    _requestId = value;
  }

  String get userId => _userId;

  String get state => _state;

  set state(String value) {
    _state = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  int get selectedTime => _selectedTime;

  set selectedTime(int value) {
    _selectedTime = value;
  }

  String get selectedDayName => _selectedDayName;

  set selectedDayName(String value) {
    _selectedDayName = value;
  }

  String get selectedDay => _selectedDay;

  set selectedDay(String value) {
    _selectedDay = value;
  }

  String get selectedMonth => _selectedMonth;

  set selectedMonth(String value) {
    _selectedMonth = value;
  }

  String get category => _category;

  set category(String value) {
    _category = value;
  }

  List<dynamic> get selectedService => _selectedService;

  set selectedService(List<dynamic> value) {
    _selectedService = value;
  }

  double get long => _long;

  set long(double value) {
    _long = value;
  }

  double get lat => _lat;

  set lat(double value) {
    _lat = value;
  }

  String get userPhone => _userPhone;

  set userPhone(String value) {
    _userPhone = value;
  }

  String get userLoc => _userLoc;

  set userLoc(String value) {
    _userLoc = value;
  }

  String get sanayeeId => _sanayeeId;

  set sanayeeId(String value) {
    _sanayeeId = value;
  }

  set userId(String value) {
    _userId = value;
  }
  String get isArrived => _isArrived;

  set isArrived(String value) {
    _isArrived = value;
  }
}
