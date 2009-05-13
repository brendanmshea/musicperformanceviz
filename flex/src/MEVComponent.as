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
	public function MEVComponent(p_mev: MusicEvent, c: Canvas) {
		super();
		mev = p_mev;

		var circle:Shape = new Shape();

		var circleSize:uint = p_mev.getPrice(); // randomNumber(2, 50);
		if (p_mev.getPrice() == 0) {
			circleSize = 3;
			circle.graphics.lineStyle(4, 0x33FF00, 0.8);
		}
		var circleX:uint = randomNumber(circleSize, c.width - circleSize); //scaleXToCanvas(mev, this.graph);
		var circleY:uint = randomNumber(circleSize, c.height - circleSize); //scaleYToCanvas(mev, this.graph);

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
		
	public function randomNumber(low:Number=0, high:Number=100):Number
	{
		var low:Number = low;
		var high:Number = high;
			
		return Math.floor(Math.random() * (1+high-low)) + low;
	}

}
}