private function redrawCircles():void {
	trace("redrawing");
	var selectedNeighborhoods:ArrayCollection = getSelectedNeighborhoods();

	var hoodinfo:Dictionary = new Dictionary();
	var hoodindex:Dictionary = new Dictionary();

	var count:uint = 1;
	for each (var hood:Object in selectedNeighborhoods) {
			hoodinfo[hood.zip] = 0;
			hoodindex[hood.zip] = count++;
		}

	while(graph.numChildren){ graph.removeChildAt(0) } // throw them all away, first

	for each (var mev:MusicEvent in _events) {
			if (mev.getDisplay()) {
				var zip:String = mev.getVenue().getZip();
				hoodinfo[zip] += 1;
				//				trace("showing " + mev.getEventName() + " - " + hoodinfo[zip] + "th in " + zip);
				// now add the ones that are supposed to be visible
				new MEVComponent(mev, graph, hoodinfo[zip], 
												 getClusterCenter(hoodindex[zip], selectedNeighborhoods.length, graph));
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

