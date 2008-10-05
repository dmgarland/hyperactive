import de.alex_uhlmann.animationpackage.utility.Tween;

/*
* @class TimeTween
* @author Alex Uhlmann
* @description  Time-based tween engine. 
* 				
*/
class de.alex_uhlmann.animationpackage.utility.TimeTween extends Tween {		
	
	private static var activeTweens:Array = new Array();
	private static var interval:Number = 10;
	private static var startPauseAll:Number;	
	private static var intervalID : Number;
	private static var dispatcher : Object = new Object();
	
	private static function addTween(tween:TimeTween):Void {
		tween.id = activeTweens.length;
		activeTweens.push(tween);	
		if (intervalID == null) {
			dispatcher.dispatchTweens = dispatch;
			TimeTween.intervalID = setInterval(TimeTween.dispatcher, "dispatchTweens", TimeTween.interval);
		}		
	}
	
	private static function removeTweenAt(index:Number):Void {
		var tweens:Array = TimeTween.activeTweens;

		if(index >= tweens.length || index < 0 || index == null) {				
			return;
		}
		
		tweens.splice(index, 1);
		var i:Number;
		var len:Number = tweens.length;
		for (i = index; i < len; i++) {
			tweens[i].id--;
		}
		if (len == 0) {
			clearInterval(intervalID);
			delete intervalID;
		}
	}
	
	private static function dispatch(Void):Void {
		var tweens:Array = TimeTween.activeTweens;
		var i:Number;
		var len:Number = tweens.length;		
		for (i = 0; i < len; i++) { 
			tweens[i].doInterval();
		}
		updateAfterEvent();
	}
	
	public static function pauseAll():Void {
		TimeTween.startPauseAll = getTimer();
		clearInterval(TimeTween.intervalID);
		var tweens:Array = TimeTween.activeTweens;
		var i:Number = tweens.length;
		while(--i > -1) {
			tweens[i].isTweening = false;
		}
	}
	
	public static function resumeAll():Void {		
		TimeTween.intervalID = setInterval(TimeTween.dispatcher, "dispatchTweens", TimeTween.interval);
		var tweens:Array = TimeTween.activeTweens;
		var i:Number;
		var len:Number = tweens.length;
		for (i = 0; i < len; i++) {
			var myTween:TimeTween = tweens[i];
			if( !myTween.isTweening ) {
				myTween.startTime += (getTimer() - TimeTween.startPauseAll);
			}
			myTween.isTweening = true;
		}
	}
	
	public function TimeTween(listener:Object, 
							  start:Object, end:Object, duration:Number, 
							  easingParams:Array) {
		
		super(listener, start, end, duration, easingParams);		
	}	

	public function start():Void {	
		if(easingEquation == null) {
			easingEquation = defaultEasingEquation;
		}
		startTime = getTimer();
		if (this.duration == 0) {
			endTween();
		} else {
			TimeTween.addTween(this);
		}
		this.isTweening = true;
	}
	
	public function stop():Void {		
		TimeTween.removeTweenAt(this.id);
		this.isTweening = false;
	}
	
	public function pause():Void {		
		this.startPause = getTimer();
		delete TimeTween.activeTweens[this.id];
		this.isTweening = false;
	}
	
	public function resume():Void {
		this.startTime += (getTimer() - startPause);		
		TimeTween.activeTweens[this.id] = this;
		this.isTweening = true;
	}
	
	public function doInterval():Void {
		var curTime:Number = getTimer() - startTime;
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
		return "TimeTween";
	}
}