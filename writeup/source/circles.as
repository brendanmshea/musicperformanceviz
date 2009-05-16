import mx.controls.Label;
import mx.core.UIComponent;

private function redrawCircles():void {
	trace("redrawing");
	while(graph.numChildren){ graph.removeChildAt(0) } // throw them all away, first

	var selectedNeighborhoods:ArrayCollection = getSelectedNeighborhoods();

	var hoodinfo:Dictionary = new Dictionary();

	var count:uint = 1; // temporarily keep track of number of neighborhoods, to calculate the cluster centers
	for each (var hood:Object in selectedNeighborhoods) {
			var ccenter:Object = getClusterCenter(count++, selectedNeighborhoods.length, graph);
			hoodinfo[hood.neighborhood] = {eventcount:0, ccenter:ccenter};

			trace("trying to label " + hood.neighborhood + " with: " + hood.neighborhood);
			var comp:UIComponent = new UIComponent();
			var label:Label = new Label();
			label.text = hood.neighborhood;
			graph.addChild(label);
			label.setStyle("color", 0x777777);
			label.setStyle("fontSize", 24);
			label.validateNow(); // need to do this so it can tell use the textWidth
			label.move(ccenter.x - label.textWidth / 2, ccenter.y - 50);
			addChild(comp);
		}

	// now go through all the events
	for each (var mev:MusicEvent in _events) {
			if (mev.getDisplay()) { // and draw them only if they're supposed to be visible
				var neighborhood:String = _neighborhoods[mev.getVenue().getZip()];
				trace("display circle for neighborhood " + neighborhood);
				hoodinfo[neighborhood].eventcount++; // track how many events are in this neighborhood
				//				trace("showing " + mev.getEventName() + " - " + hoodinfo[zip] + "th in " + zip);
				new MEVComponent(mev, getGenreColor(mev.getType()), graph, hoodinfo[neighborhood].eventcount, hoodinfo[neighborhood].ccenter,
				                 highlightGenreAndNeighborhood, unhighlightGenreAndNeighborhood, formatDate);
			}
		}
}

private function getClusterCenter(which:Number, total:Number, c:Canvas):Object {
	//	trace("w/t " + which + ", " + total);
			
	var scalex:Number = getClusterCenterX(which, total);
	var scaley:Number = getClusterCenterY(which, total);

	//	trace("scale " + scalex + ", " + scaley);

	return {x:Math.floor(c.width * scalex), y:Math.floor(c.height * scaley)};
}

private function getClusterCenterX(which:Number, total:Number):Number {
	if (total == 1) {
		return 0.5;
	}
	if (total == 2) {
		return 0.333 * which;
	}

	if (total == 3) {
		return 1/6 + 1/3 * (which - 1);
	}

	var segments:Number = Math.ceil((total + 1) * 2 / 3);
	var slot:Number = Math.round(which * 2 / 3);

	//	trace("which/total " + which + "/" + total + " => " + "slot/segments" + slot + "/" + segments);

	return slot / segments;
}

private function getClusterCenterY(which:Number, total:Number):Number {
	if (total < 4) {
		return 0.5;
	}
	
	if (which % 3 == 0) {
		return 0.5;
	}
	
	if (which % 3 == 1) {
		return 0.25;
	}
	
	return 0.75;
}

