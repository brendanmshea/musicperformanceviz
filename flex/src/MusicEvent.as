package {
public class MusicEvent {

  private var _id:String;
  private var _eventName:String;
  private var _startTime:String;
  private var _endTime:String;
  private var _venue:Venue;
  private var _price:String;
  private var _url:String;
  private var _type:String;
  private var _display:Boolean;

  public function MusicEvent( id:String, eventName:String, startTime:String, endTime:String, venue:Venue, price:String, url:String, type:String) {
    _id = id;
    _eventName = eventName;
    _startTime = startTime;
    _endTime = endTime;
    _venue = venue;
    _price = price;
    _url = url;
    _type=type;
    // Initialize display to false.
    _display = false;
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

	public function getDisplay():Boolean {
		return _display;
	}

	public function setDisplay(display:Boolean):void {
		_display = display;
	}

	public function toString():String {
		return "MusicEvent: id " + _id + ", event name: " + _eventName;
	}
}
}