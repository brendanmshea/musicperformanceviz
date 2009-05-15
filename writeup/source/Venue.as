// Bean to represent a venue.
package {
public class Venue {
	private var _venue:String;
	private var _street:String;
	private var _city:String;
	private var _region:String;
	private var _zip:String;
	private var _country:String;
	private var _lat:Number;
	private var _long:Number;

	public function Venue( venue:String, street:String, city:String, region:String, zip:String, country:String, lat:Number, long:Number) {
		_venue = venue;
		_street = street;
		_city = city;
		_region = region;
		_zip = zip;
		_country = country;
		_lat = lat;
		_long = long;
	}
	public function getVenue( ):String {
		return _venue;
	}
	public function getStreet( ):String {
		return _street;
	}
	public function getCity( ):String {
		return _city;
	}
	public function getRegion( ):String {
		return _region;
	}
	public function getZip( ):String {
		return _zip;
	}
	public function getCountry( ):String {
		return _country;
	}
	public function getLat( ):Number {
		return _lat;
	}
	public function getLong( ):Number {
		return _long;
	}

	public function toString():String {
		return "Venue: " + _venue;
	}
}
}