class Note {
  int? _id; // Nullable to handle cases without an ID
  String _title; // Non-nullable
  String _description; // Non-nullable
  String _date; // Non-nullable
  int _priority; // Non-nullable

  // Constructor initializes all fields
  Note(this._title, this._date, this._priority, [this._description = ""]);

  // Constructor with ID
  Note.withId(this._id, this._title, this._date, this._priority, [this._description = ""]);

  // Constructor for initializing from a map
  Note.fromMapObject(Map<String, dynamic> map)
      : _id = map['id'],
        _title = map['title'],
        _description = map['description'] ?? "",
        _date = map['date'],
        _priority = map['priority'];

  int? get id => _id;

  String get title => _title;

  String get description => _description;

  int get priority => _priority;

  String get date => _date;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      _description = newDescription;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      _priority = newPriority;
    }
  }

  set date(String newDate) {
    _date = newDate;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (_id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }
}
