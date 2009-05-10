package {
public class Venue {
  private var _venue:String;
  private var _street:String;
  private var _city:String;
  private var _region:String;
  private var _zip:String;
  private var _country:String;
  private var _lat:String;
  private var _long:String;

  public function Venue( venue:String, street:String, city:String, region:String, zip:String, country:String, lat:String, long:String) {
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
  public function getLat( ):String {
    return _lat;
  }
  public function getLong( ):String {
    return _long;
  }
  
  	public function toString():String {
		return "Venue: " + _venue;
	}
}
}