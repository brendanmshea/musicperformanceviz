// ActionScript file
import com.google.maps.LatLng;
import com.google.maps.MapType;

private var _middleLat:Number;
private var _middleLong:Number;

private function onMapReady(event:Event):void {
	this.map.setCenter(new LatLng(_middleLat, _middleLong), 14, MapType.NORMAL_MAP_TYPE);}

public function initializeMap(middleLat:Number, middleLong:Number):void {
	_middleLat = middleLat;
	_middleLong = middleLong;
}