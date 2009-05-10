import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;

// Contains all of our music events.  Doesn't change after being loaded.
// However, the event itself keeps track of whether it is 'displayed'
// or not, based on the filter.
private var _events:Array = new Array();

public function init():void {
	trace("init called");
	var loader:URLLoader = new URLLoader();
    loader.addEventListener(Event.COMPLETE, completeHandler);
	var request:URLRequest = new URLRequest("data.tsv");
	try {
		loader.load(request);
	} catch (error:Error) {
		trace("Unable to load requested document.  error: " + error);
	}
	trace("init finished");
}

private function completeHandler(event:Event):void {
	trace("completeHandler called");
	var loader:URLLoader = URLLoader(event.target);
	parseData(loader.data);
	initializeMap(getMiddleLat(), getMiddleLong(), _events);
	trace("completeHandler done");
}

private function parseData( result:Object ):void {
	trace("parseData called");
	var lines:Array = result.split("\n");
	var firstLine:Boolean = true;
	for each ( var line:String in lines ) {
		// Skip the first line, which is titles.
		if (!firstLine) {
			var fields:Array = line.split("\t");
			// Event Name	Start Time	End Time	Latitude	Longitude	Venue Name	Street	City	Region	Postalcode	Country	Price	URL	Type	

			var venue:Venue = new Venue(fields[5], fields[6], fields[7], fields[8], fields[9], fields[10], parseFloat(fields[3]), parseFloat(fields[4]));
			_events.push(new MusicEvent(fields[0], fields[0], fields[1], fields[2], venue, fields[11], fields[12], fields[13]));
		} else {
			firstLine = false;
		}
	}
	trace("parseData done");
}

// yeah, why are we doing these loops every time?
// Because premature optimization... etc.
public function getMaxLat( ):Number {
	var maxLat:Number = -500.0;
	for each ( var mev:MusicEvent in _events ) {
		if (maxLat < mev.getVenue().getLat()) {
			maxLat = mev.getVenue().getLat();
		}
	}
	return maxLat;
}

public function getMinLat( ):Number {
	var minLat:Number = 500.0;
	for each ( var mev:MusicEvent in _events ) {
		if (minLat > mev.getVenue().getLat()) {
			minLat = mev.getVenue().getLat();
		}
	}
	return minLat;
}

public function getMiddleLat():Number {
	return getMinLat() + ((getMaxLat() - getMinLat()) / 2);
}

public function getMaxLong( ):Number {
	var maxLong:Number = -500.0;
	for each ( var mev:MusicEvent in _events ) {
		if (maxLong < mev.getVenue().getLong()) {
			maxLong = mev.getVenue().getLong();
		}
	}
	return maxLong;
}

public function getMinLong( ):Number {
	var minLong:Number = 500.0;
	for each ( var mev:MusicEvent in _events ) {
		if (minLong > mev.getVenue().getLong()) {
			minLong = mev.getVenue().getLong();
		}
	}
	return minLong;
}

public function getMiddleLong():Number {
	return getMinLong() + ((getMaxLong() - getMinLong()) / 2);
}
