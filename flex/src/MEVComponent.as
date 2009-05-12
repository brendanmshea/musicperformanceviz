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

			var circleSize:uint = randomNumber(2, 50); // e.getPrice();
			var circleX:uint = randomNumber(circleSize, c.width - circleSize); //scaleXToCanvas(mev, this.graph);
			var circleY:uint = randomNumber(circleSize, c.height - circleSize); //scaleYToCanvas(mev, this.graph);

			var circle:Shape = new Shape();
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
			Alert.show(mev.getEventName());
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