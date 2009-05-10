// ActionScript file
private function showAll(event:Event):void {
	for each (var mev:MusicEvent in _events) {
		if (mev.getDisplay() == false && event.target.selected) {
			showOnMap(mev);
			mev.setDisplay(true);
		}
		if (mev.getDisplay() == true && !event.target.selected) {
			hideOnMap(mev);
			mev.setDisplay(false);
		}
	}
}
