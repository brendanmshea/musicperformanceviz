private var _events:Array = new Array();

public function parseData( result:Object ):void {
  var lines:Array = result.split("\n");

  for each ( var line:String in lines ) {
    var fields:Array = line.split("\t");
    // Event Name	Start Time	End Time	Latitude	Longitude	Venue Name	Street	City	Region	Postalcode	Country	Price	URL	Type	
    
    var venue:Venue = new Venue(fields[5], fields[6], fields[7], fields[8], fields[9], fields[10], parseFloat(fields[3]), parseFloat(fields[4]));
    _events.push(new MusicEvent(fields[0], fields[0], fields[1], fields[2], venue, fields[11], fields[12], fields[13]));
  }
}
