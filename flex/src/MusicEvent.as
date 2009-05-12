package {
public class MusicEvent {
  private var _id:String;
  private var _eventName:String;
  private var _rawStartTime:String;
  private var _rawEndTime:String;
  private var _startTime:Date;
  private var _venue:Venue;
  private var _rawPrice:String;
  private var _price:Number;
  private var _url:String;
  private var _type:String;
  private var _display:Boolean;

  public function MusicEvent( id:String, eventName:String, startTime:String, endTime:String, venue:Venue, price:String, url:String, type:String) {
    _id = id;
    _eventName = eventName;
    _rawStartTime = startTime;
    _rawEndTime = endTime;
    _venue = venue;
    _rawPrice = price;
    _url = url;
    _type=type;
    // Initialize display to false.
    _display = false;
    // Parse the dates.
    _startTime = parseDate(_rawStartTime);
    // Parse the price.
    _price = Number(_rawPrice);
    
}
  public function getId( ):String {
    return _id;
  }
  public function getEventName( ):String {
    return _eventName;
  }
  public function getRawStartTime( ):String {
    return _rawStartTime;
  }
  public function getRawEndTime( ):String {
    return _rawEndTime;
  }
  public function getVenue( ):Venue {
    return _venue;
  }
  public function getRawPrice( ):String {
    return _rawPrice;
  }
  public function getUrl( ):String {
    return _url;
  }
  public function getType( ):String {
    return _type;
  }

	public function getStartTime():Date {
		return _startTime;
	}

	public function getPrice():Number {
		return _price;
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

	public function parseDate(rawDate:String):Date {
		if (rawDate == null || rawDate == "") {
			return null;
		}
		var components:Array = rawDate.split(" ");
		if (components == null || components.length < 2) {
			return null;
		}
		var date:String = components[0];
		var time:String = components[1];
		var dateComponents:Array = date.split("-");
		var timeComponents:Array = time.split(":");
		if (dateComponents == null || dateComponents.length < 3) {
			return null;
		}
		if (timeComponents == null || timeComponents.length < 3) {
			return null;
		}
		return new Date(Number(dateComponents[0]), Number(dateComponents[1]), Number(dateComponents[2]),
		                Number(timeComponents[0]), Number(timeComponents[1]), Number(timeComponents[2]));
	}
}
}