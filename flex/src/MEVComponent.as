package
{
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import flash.events.MouseEvent;

	public class MEVComponent extends UIComponent
	{
		internal var mev: MusicEvent;
		public function MEVComponent(p_mev: MusicEvent) {
			super();
			mev = p_mev;

			addEventListener(MouseEvent.MOUSE_OVER, handleHover);
			addEventListener(MouseEvent.MOUSE_OUT, handleUnHover);
			addEventListener(MouseEvent.CLICK, handleClick);
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
		
	}
}