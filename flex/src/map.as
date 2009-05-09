// ActionScript file
import mx.controls.Alert;
import com.google.maps.LatLng;
import com.google.maps.Map;
import com.google.maps.MapEvent;
import com.google.maps.MapType;

private function onMapReady(event:Event):void {
	this.map.setCenter(new LatLng(42.4262,-71.1382), 15, MapType.NORMAL_MAP_TYPE);
}