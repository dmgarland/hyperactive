import de.alex_uhlmann.animationpackage.APCore;
import de.alex_uhlmann.animationpackage.utility.Tween;
import de.andre_michelle.events.FrameBasedInterval;
import de.andre_michelle.events.ImpulsDispatcher;

/*
* @class FrameTween
* @author Alex Uhlmann
* @description  Frame-based tween engine. 
* 				FrameTween uses André Michelle's FrameBasedInterval and ImpulsDispatcher classes 
* 				for efficient frame tweening. Frame based tweening is faster and more accurate than time based tweening.
*/
class de.alex_uhlmann.animationpackage.utility.FrameTween extends Tween {		
	
	private static var activeTweens:Array = new Array();
	private static var interval:Number = 10;
	private static var startPauseAll:Number;	
	private static var intervalID : Number;
	private static var dispatcher : Object = new Object();
	
	private static function addTween(tween:FrameTween):Void {
		tween.id = activeTweens.length;
		activeTweens.push(tween);	
		if (intervalID == null) {
			if(!ImpulsDispatcher._timeline) {						
				ImpulsDispatcher.initialize(APCore.getCentralMC());				
			}
			dispatcher.dispatchTweens = dispatch;
			ImpulsDispatcher.addImpulsListener(dispatcher, "dispatchTweens");
			intervalID = 1;
		}
	}
	
	private static function removeTweenAt(index:Number):Void {
		var tweens:Array = FrameTween.activeTweens;

		if(index >= tweens.length || index < 0 || index == null) {				
			return;
		}
		
		FrameBasedInterval.removeInterval(tweens[index].frameIntervalToken);
		tweens.splice(index, 1);
		var i:Number;
		var len:Number = tweens.length;
		for (i = index; i < len; i++) {
			tweens[i].id--;
		}
		if (len == 0) {
			intervalID = null;
		}
	}
	
	private static function dispatch(Void):Void {
		var tweens:Array = FrameTween.activeTweens;
		var i:Number;
		var len:Number = tweens.length;		
		for (i = 0; i < len; i++) { 
			tweens[i].doInterval();
		}
	}
	
	private var frameIntervalToken:Object;
	
	public function FrameTween(listener:Object, 
							  start:Object, end:Object, duration:Number, 
							  easingParams:Array) {			
		
		super(listener, start, end, duration, easingParams);
	}
	
	public function start():Void {			
		if(easingEquation == null) {
			easingEquation = defaultEasingEquation;
		}
		if (this.duration == 0) {
			endTween();
		} else {				
			FrameTween.addTween(this);
			this.frameIntervalToken = FrameBasedInterval.addInterval(this, "onFrameEnd", duration);			
		}
		this.startTime = this.frameIntervalToken.startFrame;
		this.isTweening = true;
	}
	
	public function stop():Void {
		FrameTween.removeTweenAt(this.id);
		this.isTweening = false;
	}
	
	public function pause():Void {
		startPause = FrameBasedInterval.frame;
		delete FrameTween.activeTweens[this.id];
		this.isTweening = false;
	}
	
	public function resume():Void {
		var pausedTime:Number = FrameBasedInterval.frame - this.startPause;
		this.startTime += pausedTime;
		FrameTween.activeTweens[this.id] = this;
		this.isTweening = true;
	}		

	public static function pauseAll():Void {
		ImpulsDispatcher.pause();
		var tweens:Array = FrameTween.activeTweens;
		var i:Number = tweens.length;
		while(--i > -1) {
			tweens[i].isTweening = false;
		}
	}
	
	public static function resumeAll():Void {
		ImpulsDispatcher.resume();
		var tweens:Array = FrameTween.activeTweens;
		var i:Number = tweens.length;
		while(--i > -1) {
			tweens[i].isTweening = true;
		}
	}
	
	private function doInterval():Void {
		var curTime:Number = FrameBasedInterval.frame - startTime;			
		var curVal:Object;
		if(easingParams == null) {
			curVal = getCurVal(curTime);
		} else {
			curVal = getCurVal2(curTime);
		}
		if (curTime >= duration) {			
			endTween(curVal);
		} else {
			if (updateMethod != null) {
				listener[updateMethod](curVal);
			} else {
				listener.onTweenUpdate(curVal);
			}
		}
	}

	public function toString(Void):String {
		return "FrameTween";
	}
}