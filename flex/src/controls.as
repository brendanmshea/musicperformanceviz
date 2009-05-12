// ActionScript file
import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.controls.LinkButton;
import mx.controls.Text;
import mx.managers.PopUpManager;

private var _neighborhoodFilters:ArrayCollection = new ArrayCollection();
private var _genreFilters:ArrayCollection = new ArrayCollection();
private var _minSelectedDate:Date = new Date(0);
private var _maxSelectedDate:Date = new Date(0);

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
		// Time filter.
		var inTime:Boolean = false;
		if (_minSelectedDate != null && _maxSelectedDate != null && mev.getStartTime() != null &&
		    _minSelectedDate.valueOf() < mev.getStartTime().valueOf() &&
		    _maxSelectedDate.valueOf() > mev.getStartTime().valueOf()) {
			inTime = true;
		}
		setDisplay(mev, (inZip && inGenre && inTime));
	}
}

private function setDisplay(mev:MusicEvent, selected:Boolean):void {
	if (mev.getDisplay() == false && selected) {
		showOnMap(mev);
		drawEventCircle(mev);
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

//basic function to create the labels for our slider based on minimum and maximum values of slider, and number of labels to show
private function getSliderLabels(amount:Number, numberOfLabels:Number):Array
{
	var interval:Number = amount / (numberOfLabels - 1);
	var tmpArray:Array = new Array();
	var labelCounter:Number = timeSlider.minimum; 
	var loopCounter:Number = 0;

	while(loopCounter <= amount)
	{
		tmpArray.push(Math.round(labelCounter));
		labelCounter += interval;
		loopCounter += interval;
	}
	return tmpArray;
}

private function timeDataTipFunction(value:String):String
{
	return formatDate(calculateDateFromSlider(Number(value)));
}

private function priceDataTipFunction(value:String):String
{
	return "The price is " + Number(value).toPrecision(1);
}

private function timeSliderChangeEvent(event:Event, text1:Text, text2:Text):void
{
	_minSelectedDate = calculateDateFromSlider(event.target.values[0]);
	_maxSelectedDate = calculateDateFromSlider(event.target.values[1]);
	text1.text = formatDate(_minSelectedDate);
	text2.text = formatDate(_maxSelectedDate);
	runAllFilters();
}

private function priceSliderChangeEvent(event:Event, text1:Text, text2:Text):void
{
	text1.text = Number(event.target.values[0]).toPrecision(2);
	text2.text = Number(event.target.values[1]).toPrecision(2);
}

private function calculateDateFromSlider(value:Number):Date {
	// The slider goes from 0 to 100.  Figure out the date
	// from the number given by scaling.
	if (getMaxDate() != null && getMinDate() != null) {
		var dateBits:Number = (getMaxDate().valueOf() - getMinDate().valueOf()) / 100.0;
		return new Date(getMinDate().valueOf() + (dateBits * value));
	}
	return null;
}

private function initializeSelectedDates():void {
	_minSelectedDate = calculateDateFromSlider(25);
	_maxSelectedDate = calculateDateFromSlider(75);
	minTimeSelected.text = formatDate(_minSelectedDate);
	maxTimeSelected.text = formatDate(_maxSelectedDate);
}

private function formatDate(date:Date):String {
	if (date == null) {
		return "";
	}
	return date.getMonth() + "/" + date.getDate() + "/" + date.getFullYear() + " " + date.getHours() + ":" + date.getMinutes();
}
