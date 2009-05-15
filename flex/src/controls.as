// Control handlers and helper methods.
import flash.events.Event;
import flash.geom.Rectangle;

import mx.collections.ArrayCollection;
import mx.controls.LinkButton;
import mx.managers.PopUpManager;

// Our selected filters.

private var _neighborhoodFilters:ArrayCollection = new ArrayCollection(); // Neighborhood filters
private var _genreFilters:ArrayCollection = new ArrayCollection(); // Genre filters
private var _minSelectedDate:Date = new Date(0); // Date filters
private var _maxSelectedDate:Date = new Date(0);
private var _minSelectedPrice:Number = 0; // Price filters
private var _maxSelectedPrice:Number = 0;
private var _showNoPrice:Boolean = false;

// Add or remove the given neighborhood filters.
private function recordNeighborhood(zip:String, selected:Boolean):void {
	_neighborhoodFilters.addItem({zip:zip, selected:selected});
}

// Initialize the neighborhood filters.
private function initializeNeighborhoodFilters():void {
	_neighborhoodFilters = new ArrayCollection();
}

// Add or remove the given genre filter.
private function recordGenre(genre:String, selected:Boolean):void {
	_genreFilters.addItem({genre:genre, selected:selected});
}

// Initialize the genre filters.
private function initializeGenreFilters():void {
	_genreFilters = new ArrayCollection();
}

// Run all of our filters, setting the display property on each MusicEvent,
// and displaying it on the map and graph.
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
		    _minSelectedDate.valueOf() <= mev.getStartTime().valueOf() &&
		    _maxSelectedDate.valueOf() >= mev.getStartTime().valueOf()) {
			inTime = true;
		}
		// Price filter.
		var inPrice:Boolean = false;
		if (mev.getPrice() >= 0 &&
		    _minSelectedPrice <= mev.getPrice() &&
		    _maxSelectedPrice >= mev.getPrice()) {
			inPrice = true;
		}
		if (_showNoPrice && mev.getPrice() < 0) {
			inPrice = true;
		}
		setDisplay(mev, (inZip && inGenre && inTime && inPrice));
	}
	redrawCircles();
}

// Set the display property on the given MusicEvent, and
// show it on the map and graph.
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

private function hideInfoBox():void {
	eventDescriptionBox.setVisible(false);
}

private function getSelectedNeighborhoods():ArrayCollection {
	var selectedNeighborhoods:ArrayCollection = new ArrayCollection();
	for each (var zipFilter:Object in _neighborhoodFilters) {
			if (zipFilter.selected) {
				selectedNeighborhoods.addItem(zipFilter);
			}
		}
	return selectedNeighborhoods;
}

// Display the neighborhood select multi-check box.
private function neighborhoodSelect(linkButton:LinkButton, canvas:Canvas):void {
	multiCheckBoxSelect(linkButton, _neighborhoodsForControls,
	                    initializeNeighborhoodFilters, recordNeighborhood, runAllFilters,
	                    function(item:String):int { return 0x000000 },
	                    canvas);
}

// Display the genre select multi-check box.
private function genreSelect(linkButton:LinkButton, canvas:Canvas):void {
	multiCheckBoxSelect(linkButton, _genresForControls,
	                    initializeGenreFilters, recordGenre, runAllFilters,
	                    function(item:String):int {
	                    	return getGenreColor(item);
	                    },
	                    canvas);
}

// Display a generic multi-check box.
private function multiCheckBoxSelect(linkButton:LinkButton,
                                     dataProvider:ArrayCollection,
                                     callbackOnInitialize:Function,
                                     callbackOnRecord:Function,
                                     callbackOnComplete:Function,
                                     itemColor:Function,
                                     labelCanvas:Canvas):void {
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
	multiCheckBoxPopup.itemColor = itemColor;
	multiCheckBoxPopup.canvas = labelCanvas;
 
	// Calculate position of TitleWindow in Application's coordinates.
	// Position it a bit up and to the right of the LinkButton control.
	var point:Point = new Point();
	point.x=0;
	point.y=0;        
	point=linkButton.localToGlobal(point);
	multiCheckBoxPopup.x=point.x - 100;
	multiCheckBoxPopup.y=point.y - 300;
}

// Draw our dual drag slider labels.
private function getSliderLabels(amount:Number, numberOfLabels:Number):Array
{
	var tmpArray:Array = new Array();
	tmpArray.push("");
	return tmpArray;
}

// Return the 'data tip' that is displayed when the time slider is used.
private function timeDataTipFunction(value:String):String
{
	return formatDate(calculateDateFromSlider(Number(value)));
}

// Return the 'data tim' that is displayed when the price slider is used.
private function priceDataTipFunction(value:String):String
{
	return formatPrice(calculatePriceFromSlider(Number(value)));
}

// Handler for a change on the time slider.
private function timeSliderChangeEvent(event:Event):void
{
	_minSelectedDate = calculateDateFromSlider(event.target.values[0]);
	_maxSelectedDate = calculateDateFromSlider(event.target.values[1]);
	timeSelected.text = "Time: from " + formatDate(_minSelectedDate) + " to " + formatDate(_maxSelectedDate);
	runAllFilters();
}

// Handler for a change on the price slider.
private function priceSliderChangeEvent(event:Event):void
{
	_minSelectedPrice = calculatePriceFromSlider(event.target.values[0]);
	_maxSelectedPrice = calculatePriceFromSlider(event.target.values[1]);
	priceSelected.text = "Price: from " + formatPrice(_minSelectedPrice) + " to " + formatPrice(_maxSelectedPrice);
	runAllFilters();
}

// Translate the date slider value to a Date.
private function calculateDateFromSlider(value:Number):Date {
	// The slider goes from 0 to 100.  Figure out the date
	// from the number given by scaling.
	if (getMaxDate() != null && getMinDate() != null) {
		var dateBits:Number = (getMaxDate().valueOf() - getMinDate().valueOf()) / 100.0;
		return new Date(getMinDate().valueOf() + (dateBits * value));
	}
	return null;
}

// Translate the price slider value to a price.
private function calculatePriceFromSlider(value:Number):Number {
	// The slider goes from 0 to 100.  Figure out the price
	// from the number given by scaling.
	var priceBits:Number = (getMaxPrice() - getMinPrice()) / 100.0;
	return getMinPrice() + (priceBits * value);
}

// Handler for when the 'no price' checkbox state is changed.
private function noPriceChangeEvent():void
{
	_showNoPrice = noPrice.selected;
	runAllFilters();
}

// Initialize the dates selected on the date slider.
private function initializeSelectedDates():void {
	_minSelectedDate = calculateDateFromSlider(0);
	_maxSelectedDate = calculateDateFromSlider(10);
	timeSelected.text = "Time: from " + formatDate(_minSelectedDate) + " to " + formatDate(_maxSelectedDate);
}

// Initialize the prices selected on the price slider.
private function initializeSelectedPrices():void {
	_minSelectedPrice = calculatePriceFromSlider(0);
	_maxSelectedPrice = calculatePriceFromSlider(25);
	priceSelected.text = "Price: from " + formatPrice(_minSelectedPrice) + " to " + formatPrice(_maxSelectedPrice);
}

// Highlights for genre and neighborhood.
public static function highlightGenreAndNeighborhood(mev:MusicEvent):void {
	// Highlight the genre...
	var genreLabel:Label = Application.application.genreSelections.getChildByName(mev.getType());
	genreLabel.setStyle("color", 0x00FFCC);
	// ...and the Neighborhood.
	var neighborhoodLabel:Label = Application.application.neighborhoodsSelections.getChildByName(mev.getVenue().getZip());
	neighborhoodLabel.setStyle("color", 0x00FFCC);
}

// ...and corresponding unhighlight.
private static function unhighlightGenreAndNeighborhood(mev:MusicEvent):void {
	// Highlight the genre...
	var genreLabel:Label = Application.application.genreSelections.getChildByName(mev.getType());
	genreLabel.setStyle("color", 0x000000);
	// ...and the Neighborhood.
	var neighborhoodLabel:Label = Application.application.neighborhoodsSelections.getChildByName(mev.getVenue().getZip());
	neighborhoodLabel.setStyle("color", 0x000000);
}

// Format the given date as a string.
private function formatDate(date:Date):String {
	if (date == null) {
		return "";
	}
	var amOrPm:String = "AM";
	var hours:String = String(date.getHours());
	var minutes:String = String(date.getMinutes());
	if (date.getHours() > 12) {
		hours = String(date.getHours() - 12);
		amOrPm = "PM";
	}
	if (date.getHours() == 0) {
		hours = "12";
	}
	if (date.getMinutes() == 0) {
		minutes = "00";
	}
	if (date.getMinutes() >= 1 && date.getMinutes() <= 9) {
		minutes = "0" + String(date.getMinutes());
	}
	return date.getMonth() + "/" + date.getDate() + " " + hours + ":" + minutes + " " + amOrPm;
}

// Format the given price as a string.
private function formatPrice(price:Number):String {
	var decimalPl:Number = 2;
	var currencySymbol:String = "$";
	var decimalDelim:String = ".";

 	// Split the number into the whole and decimal (fractional) portions.
	var parts:Array = String(price).split(".");

	// Truncate or round the decimal portion, as directed.
    parts[1] = String(parts[1]).substr(0, 2);

	// Ensure that the decimal portion has the number of digits indicated. 
	// Requires the zeroFill(  ) method defined in Recipe 5.4.
	if (Number(parts[1]) < 10 && Number(parts[1]) > 0) {
		parts[1] = parts[1] + "0";
	}
	if (Number(parts[1]) == 0 || parts[1] == "NaN" || parts[1] == "un") {
		parts[1] = "00";
	}

	// Add a currency symbol and use String.join(  ) to merge the whole (dollar)
	// and decimal (cents) portions using the designated decimal delimiter.
	var output:String = currencySymbol + parts.join(decimalDelim);
	return output;
}