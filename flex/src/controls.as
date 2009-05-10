// ActionScript file
import flash.events.Event;

import mx.controls.LinkButton;
import mx.controls.Text;
import mx.managers.PopUpManager;

private function showAll(event:Event):void {
	for each (var mev:MusicEvent in _events) {
		setDisplay(mev, event.target.selected);
	}
}

private function recordNeighborhood(zip:String, selected:Boolean):void {
	for each (var mev:MusicEvent in _events) {
		if (mev.getVenue().getZip() == zip) {
			setDisplay(mev, selected);
		}
	}
}

private function setDisplay(mev:MusicEvent, selected:Boolean):void {
	if (mev.getDisplay() == false && selected) {
		showOnMap(mev);
		mev.setDisplay(true);
	}
	if (mev.getDisplay() == true && !selected) {
		hideOnMap(mev);
		mev.setDisplay(false);
	}
}

private function neighborhoodSelect(linkButton:LinkButton, selectionList:Text):void {
	trace("Called neighborhoodSelect");
	/* Open the TitleWindow container.
	   Cast the return value of the createPopUp() method
	   to our generic MultiCheckBoxWindow, the name of the 
	   component containing the TitleWindow container.
	*/
	var multiCheckBoxPopup:MultiCheckBoxWindow = 
		MultiCheckBoxWindow(PopUpManager.createPopUp( this, MultiCheckBoxWindow , true));

	// Different data providers could be passed in to this showWindow function.
	multiCheckBoxPopup.dataProvider = _neighborhoodsForControls;

	multiCheckBoxPopup.callbackOnRecord = recordNeighborhood;
 
	/* Pass a reference to the Text control to the TitleWindow container so that the 
	   TitleWindow container can return data to the main application.
	*/
	multiCheckBoxPopup.selections=selectionList;        
 
	// Calculate position of TitleWindow in Application's coordinates.
	// Position it a bit up and to the right of the LinkButton control.
	var point:Point = new Point();
	point.x=0;
	point.y=0;        
	point=linkButton.localToGlobal(point);
	multiCheckBoxPopup.x=point.x + 120;
	multiCheckBoxPopup.y=point.y - 40; 
}
