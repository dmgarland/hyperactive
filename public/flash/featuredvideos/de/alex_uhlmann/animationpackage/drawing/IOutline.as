import de.alex_uhlmann.animationpackage.IAnimationPackage;
interface de.alex_uhlmann.animationpackage.drawing.IOutline extends IAnimationPackage {
	public function animationStyle(duration:Number, easing:Object, callback:String):Void;
	public function animate(start:Number, end:Number):Void;
	public function animateBy(start:Number, end:Number):Void;
	public function lineStyle(lineThickness:Number, lineRGB:Number, lineAlpha:Number):Void;	
	public function draw(Void):Void;
	public function drawBy(Void):Void;
	public function getPenPosition(Void):Object;
	public function setPenPosition(p:Object):Void;
	public function clear(Void):Void;
}