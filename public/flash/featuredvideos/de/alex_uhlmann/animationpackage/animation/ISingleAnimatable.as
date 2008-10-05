import de.alex_uhlmann.animationpackage.animation.IAnimatable;
interface de.alex_uhlmann.animationpackage.animation.ISingleAnimatable extends IAnimatable {
	public function getStartValue(Void):Number;
	public function setStartValue(startValue:Number, optional:Boolean):Boolean;
	public function getCurrentValue(Void):Number;
	public function getEndValue(Void):Number;
	public function setEndValue(endValue:Number):Boolean;
}