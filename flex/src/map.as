// Mapping methods.
import com.google.maps.InfoWindowOptions;
import com.google.maps.LatLng;
import com.google.maps.MapMouseEvent;
import com.google.maps.MapType;
import com.google.maps.controls.PositionControl;
import com.google.maps.controls.ZoomControl;
import com.google.maps.overlays.Marker;
import com.google.maps.overlays.MarkerOptions;
import com.google.maps.styles.FillStyle;

import flash.events.Event;
import flash.utils.Dictionary;

private var _middleLat:Number; // Latitude for our map starting center.
private var _middleLong:Number; // Longitude for our map starting center.
private var _isReady:Boolean = false; // Indicate if our map is ready for use.
private var _musicEvents:Array; // Our music events.
private var _mappedMarkers:Dictionary; // Our music event markers.

// Initialize our map, and all the markers for our events.
// (The markers are then added or removed from the map
// by the filters in controls.as.)
private function onMapReady(event:Event):void {
	this.map.setCenter(new LatLng(_middleLat, _middleLong), 13, MapType.NORMAL_MAP_TYPE);
	this.map.addControl(new ZoomControl());
	this.map.addControl(new PositionControl());
	_mappedMarkers = new Dictionary();
	for each (var mev:MusicEvent in _musicEvents) {
		_mappedMarkers[mev.getId()] = createMarker(mev);
		// In case the display property is already enabled, display the event.
		if (mev.getDisplay()) {
			this.map.addOverlay(_mappedMarkers[mev.getId()]);
		}
	}
	_isReady = true;
}

// Create a marker for a MusicEvent.
public function createMarker(mev:MusicEvent):Marker {
	var color:int = getGenreColor(mev.getType());
	var latLng:LatLng = new LatLng(mev.getVenue().getLat(), mev.getVenue().getLong())
	var marker:Marker = new Marker(latLng,
	                    new MarkerOptions({clickable: true, hasShadow: true, fillStyle: new FillStyle({color: color})}));
	marker.addEventListener(MapMouseEvent.CLICK, function(e:MapMouseEvent):void {
		var title:String = mev.getEventName() + " " + mev.getVenue().getZip();
   		var info:String =
   			mev.getVenue().getVenue() + "<br/>"
			+ "<a href='" + mev.getVenueUrl() + "'>" + mev.getVenueUrl() + "</a><br/>"
   		    + mev.getDisplayPrice() + "<br/>"
			+ formatDate(mev.getStartTime()) + "<br/>"
			+ "<a href='" + mev.getEventUrl() + "'>" + mev.getEventUrl() + "</a><br/>"
			;
		marker.openInfoWindow(new InfoWindowOptions({title: title, contentHTML:info}));
	});

	marker.addEventListener(MapMouseEvent.ROLL_OVER, function(e:MapMouseEvent):void {
		highlightGenreAndNeighborhood(mev);
	});

	marker.addEventListener(MapMouseEvent.ROLL_OUT, function(e:MapMouseEvent):void {
		unhighlightGenreAndNeighborhood(mev);
	});
	return marker;
}

// Initialize our map fields.
public function initializeMap(middleLat:Number, middleLong:Number, musicEvents:Array):void {
	_middleLat = middleLat;
	_middleLong = middleLong;
	_musicEvents = musicEvents;
}

// Show the marker for the given MusicEvent on the map.
public function showOnMap(musicEvent:MusicEvent):void {
	trace("showOnMap invoked for musicEvent " + musicEvent);
	if (_isReady) {
		this.map.addOverlay(_mappedMarkers[musicEvent.getId()]);
	}
}

// Hide the marker for the given MusicEvent from the map.
public function hideOnMap(musicEvent:MusicEvent):void {
	trace("hideOnMap invoked for musicEvent " + musicEvent);
	if (_isReady) {
		this.map.removeOverlay(_mappedMarkers[musicEvent.getId()]);
	}
}