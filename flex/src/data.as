import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;

import mx.collections.ArrayCollection;
import mx.utils.StringUtil;

// Contains all of our music events.  Doesn't change after being loaded.
// However, the event itself keeps track of whether it is 'displayed'
// or not, based on the filter.
private var _events:Array = new Array();

private var _neighborhoods:Object = {
                                     "01770":"Sherborn",
                                     "02115":"Boston",
                                     "02137":"Readville",
                                     "02138":"Harvard Square",
                                     "02139":"Inman Square",
                                     "02140":"Porter Square",
                                     "02141":"East Cambridge",
                                     "02142":"Kendall Square",
                                     "02143":"East Somerville",
                                     "02144":"West Somerville",
                                     "02145":"Winter Hill",
                                     "02148":"Malden",
                                     "02149":"Everett",
                                     "02150":"Chelsea",
                                     "02151":"Revere Beach",
                                     "02152":"Winthrop",
                                     "02153":"Tufts University",
                                     "02154":"East Cambridge",
                                     "02155":"Medford",
                                     "02156":"West Medford",
                                     "02163":"Soldiers Field"

                                     }

private var _neighborhoodsInData:Array = new Array();
private var _neighborhoodsForControls:ArrayCollection = new ArrayCollection();
private var _genres:Array = new Array();
private var _genresForControls:ArrayCollection = new ArrayCollection();
private var _minDate:Date = new Date(0);
private var _maxDate:Date = new Date(0);
private var _minPrice:Number = 0;
private var _maxPrice:Number = 0;
private var _dataInitialized:Boolean = false;

public function init():void {
	trace("init called");
	var loader:URLLoader = new URLLoader();
    loader.addEventListener(Event.COMPLETE, completeHandler);
	var request:URLRequest = new URLRequest("enriched.tsv");
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
	initializeNeighborhoods();
	initializeGenres();
	initializeMap(getMiddleLat(), getMiddleLong(), _events);
	initializeDates();
	initializePrices();
	_dataInitialized = true;
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
			var venue:Venue = new Venue(fields[7], fields[8], fields[9], fields[10], fields[11], fields[12], parseFloat(fields[5]), parseFloat(fields[6]));
			_events.push(new MusicEvent(fields[0], fields[2], fields[3], fields[4], venue, fields[13], fields[15], fields[16]));
		} else {
			firstLine = false;
		}
	}
	trace("parseData done");
}

private function initializeNeighborhoods():void {
	for each (var mev:MusicEvent in _events) {
		trace("looking up " + mev.getVenue().getZip());
		if (_neighborhoods[mev.getVenue().getZip()] != null && _neighborhoodsInData[mev.getVenue().getZip()] == null) {
			trace("adding " + mev.getVenue().getZip());
			var neighborhoodDataForControls:Object = {data:mev.getVenue().getZip(), label:StringUtil.trim(_neighborhoods[mev.getVenue().getZip()])};
			_neighborhoodsForControls.addItem(neighborhoodDataForControls);
			_neighborhoodsInData[mev.getVenue().getZip()] = _neighborhoods[mev.getVenue().getZip()];
		}
	}
}

private function initializeGenres():void {
	for each (var mev:MusicEvent in _events) {
		if (_genres[mev.getType()] == null) {
			_genresForControls.addItem({data:mev.getType(), label:StringUtil.trim(mev.getType())});
			_genres[mev.getType()] = mev.getType();
		}
	}
}

private function initializeDates():void {
	_minDate = initializeMinDate();
	_maxDate = initializeMaxDate();
	initializeSelectedDates();
}

private function initializeMaxDate():Date {
	var maxDate:Date = new Date(0);
	for each (var mev:MusicEvent in _events) {
		if (mev.getStartTime() != null && maxDate.valueOf() < mev.getStartTime().valueOf()) {
			maxDate = mev.getStartTime();
		}
	}
	return maxDate;
}

private function initializeMinDate():Date {
	var minDate:Date = new Date(2199, 12, 31, 0, 0, 0);
	for each (var mev:MusicEvent in _events) {
		if (mev.getStartTime() != null && minDate.valueOf() > mev.getStartTime().valueOf()) {
			minDate = mev.getStartTime();
		}
	}
	return minDate;
}

private function initializePrices():void {
	_minPrice = initializeMinPrice();
	_maxPrice = initializeMaxPrice();
	initializeSelectedPrices();
}

private function initializeMinPrice():Number {
	var minPrice:Number = 1000;
	for each (var mev:MusicEvent in _events) {
		if (mev.getPrice() >= 0 &&
		    minPrice > mev.getPrice()) {
			minPrice = mev.getPrice();
		}
	}
	return minPrice;
}

private function initializeMaxPrice():Number {
	var maxPrice:Number = -10;
	for each (var mev:MusicEvent in _events) {
		if (mev.getPrice() >= 0 &&
		    maxPrice < mev.getPrice()) {
			maxPrice = mev.getPrice();
		}
	}
	return maxPrice;
}

public function getMinDate():Date {
	if (_dataInitialized) {
		return _minDate;
	}
	return null;
}

public function getMaxDate():Date {
	if (_dataInitialized) {
		return _maxDate;
	}
	return null;
}

public function getMinPrice():Number {
	return _minPrice;
}

public function getMaxPrice():Number {
	return _maxPrice;
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
