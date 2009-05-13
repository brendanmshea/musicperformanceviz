// ActionScript file
import com.google.maps.LatLng;
import com.google.maps.MapType;
import com.google.maps.controls.PositionControl;
import com.google.maps.controls.ZoomControl;
import com.google.maps.overlays.Marker;
import com.google.maps.overlays.MarkerOptions;
import com.google.maps.styles.FillStyle;

import flash.utils.Dictionary;

private var _middleLat:Number;
private var _middleLong:Number;
private var _isReady:Boolean = false;
private var _musicEvents:Array;
private var _mappedMarkers:Dictionary;

private function onMapReady(event:Event):void {
	this.map.setCenter(new LatLng(_middleLat, _middleLong), 13, MapType.NORMAL_MAP_TYPE);
	this.map.addControl(new ZoomControl());
	this.map.addControl(new PositionControl());
	_mappedMarkers = new Dictionary();
	for each (var mev:MusicEvent in _musicEvents) {
		var color:int = 0x000000;
		if (mev.getType() in _genreColors) {
			color = _genreColors[mev.getType()];
		}
		_mappedMarkers[mev.getId()] = new Marker(new LatLng(mev.getVenue().getLat(), mev.getVenue().getLong()),
		                              new MarkerOptions({hasShadow: true, fillStyle: new FillStyle({color: color})}));
		// In case the display property is already enabled, display the event.
		if (mev.getDisplay()) {
			this.map.addOverlay(_mappedMarkers[mev.getId()]);
		}
	}
	_isReady = true;
}

public function initializeMap(middleLat:Number, middleLong:Number, musicEvents:Array):void {
	_middleLat = middleLat;
	_middleLong = middleLong;
	_musicEvents = musicEvents;
}

public function showOnMap(musicEvent:MusicEvent):void {
	trace("showOnMap invoked for musicEvent " + musicEvent);
	if (_isReady) {
		this.map.addOverlay(_mappedMarkers[musicEvent.getId()]);
	}
}

public function hideOnMap(musicEvent:MusicEvent):void {
	trace("hideOnMap invoked for musicEvent " + musicEvent);
	if (_isReady) {
		this.map.removeOverlay(_mappedMarkers[musicEvent.getId()]);
	}
}