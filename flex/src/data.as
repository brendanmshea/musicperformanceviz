import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;

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
	trace("completeHandler done");
}

public function parseData( result:Object ):void {
	trace("parseData called");
 	var lines:Array = result.split("\n");
	var firstLine:Boolean = true;
	for each ( var line:String in lines ) {
		// Skip the first line, which is titles.
		if (!firstLine) {
			var fields:Array = line.split("\t");
			// Event Name	Start Time	End Time	Latitude	Longitude	Venue Name	Street	City	Region	Postalcode	Country	Price	URL	Type	

			var venue:Venue = new Venue(fields[5], fields[6], fields[7], fields[8], fields[9], fields[10], fields[3], fields[4]);
			_events.push(new MusicEvent(fields[0], fields[0], fields[1], fields[2], venue, fields[11], fields[12], fields[13]));
		} else {
			firstLine = false;
		}
	}
 	trace("parseData done");
}
