// gonna put all the stuff for drawing and showing circles in here.
import mx.containers.Canvas;

// hm.  this doesn't actually draw anything, maybe a "canvas" isn't something to be painted on :-)
private function drawSomeStuff(canvas: Canvas): void {
	var squareSize:uint = 100;
	var square:Shape = new Shape();
	square.graphics.beginFill(0xFF0000, 0.5);
	square.graphics.drawRect(0, 0, squareSize, squareSize);
	square.graphics.beginFill(0x00FF00, 0.5);
	square.graphics.drawRect(200, 0, squareSize, squareSize);
	square.graphics.beginFill(0x0000FF, 0.5);
	square.graphics.drawRect(400, 0, squareSize, squareSize);
	square.graphics.endFill();
	canvas.addChild(square);

}
