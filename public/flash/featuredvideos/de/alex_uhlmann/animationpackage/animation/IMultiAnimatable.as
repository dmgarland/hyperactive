import de.alex_uhlmann.animationpackage.animation.IAnimatable;
interface de.alex_uhlmann.animationpackage.animation.IMultiAnimatable extends IAnimatable {
	public function getStartValues(Void):Array;
	public function setStartValues(startValues:Array, optional:Boolean):Boolean;
	public function getCurrentValues(Void):Array;
	public function getEndValues(Void):Array;
	public function setEndValues(endValues:Array):Boolean;	
}