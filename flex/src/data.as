// Data handler functions.
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;

import mx.collections.ArrayCollection;
import mx.utils.StringUtil;

// Contains all of our music events.  Doesn't change after being loaded.
// However, the event itself keeps track of whether it is 'displayed'
// or not, based on the filter.
private var _events:Array = new Array();

// Map of zip codes to neighborhoods.
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

// Map of genres to colors.
private var _genreColors:Object = {
	                               "Other":0x33CC33,
	                               "Unspecified":0x3333FF,
	                               "Folk":0xFF0066,
	                               "Jazz":0xCCCC99,
	                               "Performing Arts":0x996666,
	                               "World Music":0x666699,
	                               "Classical":0x66FF99,
	                               "Country":0x66FF66,
	                               "Alternative":0xCCFF66,
	                               "Blues":0x6666FF,
	                               "Pop/Rock":0x99FF00,
	                               "Pop":0x99FF99,
	                               "Rock":0x993333

}

private var _neighborhoodsInData:Array = new Array(); // Full list of neighborhoods in our data.
private var _neighborhoodsForControls:ArrayCollection = new ArrayCollection(); // Mapping of raw data to display string for the neighborhood.
private var _genres:Array = new Array(); // Full list of genres in our data.
private var _genresForControls:ArrayCollection = new ArrayCollection(); // Mapping of raw data to display string for the genre.
private var _minDate:Date = new Date(0); // Min date in our data.
private var _maxDate:Date = new Date(0); // Max date in our data.
private var _minPrice:Number = 0; // Min price in our data.
private var _maxPrice:Number = 0; // Max price in our data.
private var _dataInitialized:Boolean = false; // Whether or not the data is initialized.

[Embed(source="cleangenres.tsv", mimeType="application/octet-stream")]
private static const Data:Class;

// Initialize our data.
public function init():void {
	trace("init called");
	parseData(new Data().toString());
	initializeNeighborhoods();
	initializeGenres();
	initializeMap(getMiddleLat(), getMiddleLong(), _events);
	initializeDates();
	initializePrices();
	_dataInitialized = true;
	trace("init finished");
}

// Parse the data file, and load our MusicEvents and Venues.
private function parseData( result:String ):void {
	trace("parseData called");
	var lines:Array = result.split("\n");
	var firstLine:Boolean = true;
	for each ( var line:String in lines ) {
		// Skip the first line, which is titles.
		if (!firstLine) {
			var fields:Array = line.split("\t");
			var venue:Venue = new Venue(fields[7], fields[8], fields[9], fields[10], fields[11], fields[12], parseFloat(fields[5]), parseFloat(fields[6]));
			_events.push(new MusicEvent(fields[0], fields[2], fields[3], fields[4], venue, fields[13], fields[15], fields[22]));
		} else {
			firstLine = false;
		}
	}
	trace("parseData done");
}

// Initialize our neighborhood data.
private function initializeNeighborhoods():void {
	for each (var mev:MusicEvent in _events) {
		if (_neighborhoods[mev.getVenue().getZip()] != null && _neighborhoodsInData[mev.getVenue().getZip()] == null) {
			var neighborhoodDataForControls:Object = {data:mev.getVenue().getZip(), label:StringUtil.trim(_neighborhoods[mev.getVenue().getZip()])};
			_neighborhoodsForControls.addItem(neighborhoodDataForControls);
			_neighborhoodsInData[mev.getVenue().getZip()] = _neighborhoods[mev.getVenue().getZip()];
		}
	}
}

// Initialize our genre data.
private function initializeGenres():void {
	for each (var mev:MusicEvent in _events) {
		if (mev.getType() && _genres[mev.getType()] == null) {
			_genresForControls.addItem({data:mev.getType(), label:StringUtil.trim(mev.getType())});
			_genres[mev.getType()] = mev.getType();
		}
	}
}

// Initialize our date data.
private function initializeDates():void {
	_minDate = initializeMinDate();
	_maxDate = initializeMaxDate();
	initializeSelectedDates();
}

// Initialize our max date from our data.
private function initializeMaxDate():Date {
	var maxDate:Date = new Date(0);
	for each (var mev:MusicEvent in _events) {
		if (mev.getStartTime() != null && maxDate.valueOf() < mev.getStartTime().valueOf()) {
			maxDate = mev.getStartTime();
		}
	}
	return maxDate;
}

// Initialize our min date from our data.
private function initializeMinDate():Date {
	var minDate:Date = new Date(2199, 12, 31, 0, 0, 0);
	for each (var mev:MusicEvent in _events) {
		if (mev.getStartTime() != null && minDate.valueOf() > mev.getStartTime().valueOf()) {
			minDate = mev.getStartTime();
		}
	}
	return minDate;
}

// Initialize our price data.
private function initializePrices():void {
	_minPrice = initializeMinPrice();
	_maxPrice = initializeMaxPrice();
	initializeSelectedPrices();
}

// Initialize our min price data.
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

// Initialize our max price data.
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

// Get the min date present in our data.
public function getMinDate():Date {
	if (_dataInitialized) {
		return _minDate;
	}
	return null;
}

// Get the max date present in our data.
public function getMaxDate():Date {
	if (_dataInitialized) {
		return _maxDate;
	}
	return null;
}

// Get the min price present in our data.
public function getMinPrice():Number {
	return _minPrice;
}

// Get the max price present in our data.
public function getMaxPrice():Number {
	return _maxPrice;
}

// Get the max latitude in our data.
public function getMaxLat( ):Number {
	var maxLat:Number = -500.0;
	for each ( var mev:MusicEvent in _events ) {
		if (maxLat < mev.getVenue().getLat()) {
			maxLat = mev.getVenue().getLat();
		}
	}
	return maxLat;
}

// Get the min latitude in our data.
public function getMinLat( ):Number {
	var minLat:Number = 500.0;
	for each ( var mev:MusicEvent in _events ) {
		if (minLat > mev.getVenue().getLat()) {
			minLat = mev.getVenue().getLat();
		}
	}
	return minLat;
}

// Get the middle latitude in our data.
public function getMiddleLat():Number {
	return getMinLat() + ((getMaxLat() - getMinLat()) / 2);
}

// Get the max longitude in our data.
public function getMaxLong( ):Number {
	var maxLong:Number = -500.0;
	for each ( var mev:MusicEvent in _events ) {
		if (maxLong < mev.getVenue().getLong()) {
			maxLong = mev.getVenue().getLong();
		}
	}
	return maxLong;
}

// Get the min longitude in our data.
public function getMinLong( ):Number {
	var minLong:Number = 500.0;
	for each ( var mev:MusicEvent in _events ) {
		if (minLong > mev.getVenue().getLong()) {
			minLong = mev.getVenue().getLong();
		}
	}
	return minLong;
}

// Get the middle longitude in our data.
public function getMiddleLong():Number {
	return getMinLong() + ((getMaxLong() - getMinLong()) / 2);
}

// Get the genre color for the given genre.
public function getGenreColor(type:String):int {
	var color:int = 0x000000;
	if (type in _genreColors) {
		color = _genreColors[type];
	}
	return color;
}
