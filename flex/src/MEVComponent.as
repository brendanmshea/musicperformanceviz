package
{
	import mx.controls.Alert;
	import mx.core.UIComponent;

	public class MEVComponent extends UIComponent
	{
		internal var mev: MusicEvent;
		public function MEVComponent(p_mev: MusicEvent) {
			super();
			mev = p_mev;
		}

		public function handleClick():void {
			Alert.show(mev.getEventName());
		}
		
		public function handleHover():void {
			alpha = 1.8;
		}
		
		public function handleUnHover():void {
			alpha = 1.0;
		}
		
	}
}