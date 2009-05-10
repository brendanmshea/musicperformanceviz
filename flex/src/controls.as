// ActionScript file
import mx.collections.ArrayCollection;
import mx.controls.LinkButton;
import mx.controls.Text;
import mx.managers.PopUpManager;

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
 
	/* Pass a reference to the Text control to the TitleWindow container so that the 
	   TitleWindow container can return data to the main application.
	*/
	multiCheckBoxPopup.selections=selectionList;        
 
	// Calculate position of TitleWindow in Application's coordinates.
	// Position it a bit down and to the right of the LinkButton control.
	var point:Point = new Point();
	point.x=0;
	point.y=0;        
	point=linkButton.localToGlobal(point);
	multiCheckBoxPopup.x=point.x + 120;
	multiCheckBoxPopup.y=point.y + 12; 
}
