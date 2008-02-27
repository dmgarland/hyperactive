import de.alex_uhlmann.animationpackage.IAnimationPackage;
interface de.alex_uhlmann.animationpackage.drawing.IDrawable extends IAnimationPackage {
	public function lineStyle(lineThickness:Number, lineRGB:Number, lineAlpha:Number):Void;
	public function fillStyle(fillRGB:Number, fillAlpha:Number):Void;
	public function gradientStyle(fillType:String, colors:Array, alphas:Array, ratios:Array, matrix:Object):Void;
	public function draw(Void):Void;
	public function drawBy(Void):Void;
	public function setRegistrationPoint(registrationObj:Object):Void;
	public function clear(Void):Void;
}