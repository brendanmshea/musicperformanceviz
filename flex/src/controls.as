// ActionScript file
import mx.collections.ArrayCollection;
import mx.controls.LinkButton;
import mx.controls.Text;
import mx.managers.PopUpManager;

private var _neighborhoodFilters:ArrayCollection = new ArrayCollection();
private var _genreFilters:ArrayCollection = new ArrayCollection();

private function recordNeighborhood(zip:String, selected:Boolean):void {
	_neighborhoodFilters.addItem({zip:zip, selected:selected});
}

private function initializeNeighborhoodFilters():void {
	_neighborhoodFilters = new ArrayCollection();
}

private function recordGenre(genre:String, selected:Boolean):void {
	_genreFilters.addItem({genre:genre, selected:selected});
}

private function initializeGenreFilters():void {
	_genreFilters = new ArrayCollection();
}

private function runAllFilters():void {
	for each (var mev:MusicEvent in _events) {
		// Neighborhood filter.
		var inZip:Boolean = false;
		for each (var zipFilter:Object in _neighborhoodFilters) {
			if (mev.getVenue().getZip() == zipFilter.zip && zipFilter.selected) {
				inZip = true;
			}
		}
		// Genre filter.
		var inGenre:Boolean = false;
		for each (var genreFilter:Object in _genreFilters) {
			if (mev.getType() == genreFilter.genre && genreFilter.selected) {
				inGenre = true;
			}
		}
		setDisplay(mev, (inZip && inGenre));
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
	multiCheckBoxSelect(linkButton, selectionList, _neighborhoodsForControls,
	                    initializeNeighborhoodFilters, recordNeighborhood, runAllFilters);
}

private function genreSelect(linkButton:LinkButton, selectionList:Text):void {
	multiCheckBoxSelect(linkButton, selectionList, _genresForControls,
	                    initializeGenreFilters, recordGenre, runAllFilters);
}

private function multiCheckBoxSelect(linkButton:LinkButton,
                                     selectionList:Text,
                                     dataProvider:ArrayCollection,
                                     callbackOnInitialize:Function,
                                     callbackOnRecord:Function,
                                     callbackOnComplete:Function):void {
	/* Open the TitleWindow container.
	   Cast the return value of the createPopUp() method
	   to our generic MultiCheckBoxWindow, the name of the 
	   component containing the TitleWindow container.
	*/
	var multiCheckBoxPopup:MultiCheckBoxWindow = 
		MultiCheckBoxWindow(PopUpManager.createPopUp(this, MultiCheckBoxWindow, true));

	// Different data providers could be passed in to this showWindow function.
	multiCheckBoxPopup.dataProvider = dataProvider;

	multiCheckBoxPopup.callbackOnInitialize = callbackOnInitialize;
	multiCheckBoxPopup.callbackOnRecord = callbackOnRecord;
	multiCheckBoxPopup.callbackOnComplete = callbackOnComplete;
 
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
