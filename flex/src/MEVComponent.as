package
{
import mx.controls.Alert;
import mx.core.UIComponent;
import flash.display.Shape;
import flash.events.MouseEvent;
import mx.containers.Canvas;

public class MEVComponent extends UIComponent
{
	internal var mev: MusicEvent;
	public function MEVComponent(p_mev: MusicEvent, c: Canvas, nth:Number, ccenter:Object) {
		super();
		mev = p_mev;

		var circle:Shape = new Shape();

		var circleSize:uint = Math.sqrt(p_mev.getPrice()) + 3;
		if (p_mev.getPrice() == 0) {
			circleSize = 3;
			circle.graphics.lineStyle(4, 0x33FF00, 0.8);
		}

		//		trace("at " + ccenter.x + ", " + ccenter.y);

		var offset:Object = getOffset(nth);
		var circleX:uint = ccenter.x + offset.x;
		var circleY:uint = ccenter.y + offset.y;

		circle.graphics.beginFill(0xFF0000, 0.5);
		circle.graphics.drawCircle(circleX, circleY, circleSize);
		circle.graphics.endFill();

		addChild(circle);

		addEventListener(MouseEvent.MOUSE_OVER, handleHover);
		addEventListener(MouseEvent.MOUSE_OUT, handleUnHover);
		addEventListener(MouseEvent.CLICK, handleClick);

		c.addChild(this);
	}

	private function handleClick(event:MouseEvent):void {
		Alert.show(mev.getEventName() + " - " + mev.getPrice());
	}
		
	private function handleHover(event:MouseEvent):void {
		alpha = 1.8;
	}
		
	private function handleUnHover(event:MouseEvent):void {
		alpha = 1.0;
	}
		
	public function randomNumber(low:Number=0, high:Number=100):Number {
		var low:Number = low;
		var high:Number = high;
			
		return Math.floor(Math.random() * (1+high-low)) + low;
	}
		
	private function getOffset(nth:Number):Object {
		var inFirstRing:uint = 6; // number in the inner ring
		var ringFactor:uint = 1; // how many times as many per ring
		var ringNum:uint = Math.ceil(nth/inFirstRing) / ringFactor;
		var radius:uint = 10 * ringNum;

		//		trace("radius: "+ radius);
		return {x:radius * Math.cos(nth / Math.PI), y:radius * Math.sin(nth / Math.PI)};
	}

}
}