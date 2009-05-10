package {
public class MusicEvent {
  private static var _allEvents:Array = new Array();

  private var _id:String;
  private var _eventName:String;
  private var _startTime:String;
  private var _endTime:String;
  private var _venue:Venue;
  private var _price:String;
  private var _url:String;
  private var _type:String;

  public function MusicEvent( id:String, eventName:String, startTime:String, endTime:String, venue:Venue, price:String, url:String, type:String) {
    _id = id;
    _eventName = eventName;
    _startTime = startTime;
    _endTime = endTime;
    _venue = venue;
    _price = price;
    _url = url;
    _type=type;

    _allEvents.push(this);
  }
  public function getId( ):String {
    return _id;
  }
  public function getEventName( ):String {
    return _eventName;
  }
  public function getStartTime( ):String {
    return _startTime;
  }
  public function getEndTime( ):String {
    return _endTime;
  }
  public function getVenue( ):Venue {
    return _venue;
  }
  public function getPrice( ):String {
    return _price;
  }
  public function getUrl( ):String {
    return _url;
  }
  public function getType( ):String {
    return _type;
  }

  public static function getAllEvents( ):Array {
    return _allEvents;
  }

  // yeah, why are we doing these loops every time?
  // Because premature optimization... etc.
  public static function getMaxLat( ):Number {
    var maxLat:Number = -500.0;
    for each ( var mev:MusicEvent in getAllEvents() ) {
        if (maxLat < mev.getVenue().getLat()) {
          maxLat = mev.getVenue().getLat();
        }
      }
    return maxLat;
  }
  public static function getMinLat( ):Number {
    var minLat:Number = 500.0;
    for each ( var mev:MusicEvent in getAllEvents() ) {
        if (minLat > mev.getVenue().getLat()) {
          minLat = mev.getVenue().getLat();
        }
      }
    return minLat;
  }
  public static function getMaxLong( ):Number {
    var maxLong:Number = -500.0;
    for each ( var mev:MusicEvent in getAllEvents() ) {
        if (maxLong < mev.getVenue().getLat()) {
          maxLong = mev.getVenue().getLat();
        }
      }
    return maxLong;
  }
  public static function getMinLong( ):Number {
    var minLong:Number = 500.0;
    for each ( var mev:MusicEvent in getAllEvents() ) {
        if (minLong > mev.getVenue().getLat()) {
          minLong = mev.getVenue().getLat();
        }
      }
    return minLong;
  }
}
}