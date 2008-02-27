import de.alex_uhlmann.animationpackage.IAnimationPackage;
interface de.alex_uhlmann.animationpackage.animation.IAnimatable extends IAnimationPackage {
	public function run():Void;	
	public function animate(start:Number, end:Number):Void;
	public function goto(percentage:Number):Void;
	public function animationStyle(duration:Number, easing:Object, callback:String):Void;
	public function roundResult(rounded:Boolean):Void;
	public function forceEnd(forceEndVal:Boolean):Void;
	public function getOptimizationMode(Void):Boolean;
	public function setOptimizationMode(optimize:Boolean):Void;
	public function getTweenMode(Void):String;
	public function setTweenMode(tweenMode:String):Boolean;
	public function getDurationMode(Void):String;
	public function setDurationMode(durationMode:String):Boolean;
	public function stop(Void):Boolean;
	public function pause(duration:Number):Boolean;
	public function resume(Void):Boolean;
	public function lock(Void):Void;
	public function unlock(Void):Void;
	public function isTweening(Void):Boolean;
	public function isPaused(Void):Boolean;
	public function getDurationElapsed(Void):Number;
	public function getDurationRemaining(Void):Number;
	public function getCurrentPercentage(Void):Number;
}
