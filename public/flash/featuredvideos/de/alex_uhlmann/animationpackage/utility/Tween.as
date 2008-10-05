
/*
* @class Tween
* @author Alex Uhlmann
* @description  Base class for time based and frame based tween engines. 	
*/
dynamic class de.alex_uhlmann.animationpackage.utility.Tween {		

	public var listener:Object;
	//startValue and endValue need to support Number and Array values.
	public var startValue:Object;
	public var endValue:Object;
	public var duration:Number = 1000;
	public var easingEquation:Function;
	public var updateMethod:String;
	public var endMethod:String;
	public var arrayMode:Boolean = false;
	public var id:Number;
	public var easingParams:Array;
	public var lastVal:Number;
	public var startTime:Number;
	public var isTweening:Boolean;
	public var isPaused:Boolean;
	public var stop:Function;
	private var startPause:Number;	
	
	public function Tween(listener:Object, 
						startValue:Object, endValue:Object, duration:Number, 
						easingParams:Array) {			
		
		if(listener == null ) {
			return;
		}
		if (typeof(startValue) != "number") {
			arrayMode = true;
		}

		this.listener = listener;
		
		this.startValue = startValue;
		this.endValue = endValue;
		if(duration != null) {
			this.duration = duration;
		}
		this.easingParams = easingParams;
		this.isTweening = false;
		this.isPaused = false;
	}
	
	public function getCurVal(curTime:Number):Object {
		if (arrayMode) {
			var returnArray:Array = new Array();
			var i:Number;
			var len:Number = startValue.length;
			for (i = 0; i < len; i++) {
				returnArray[i] = easingEquation(curTime, 
												startValue[i], 
												endValue[i] - startValue[i], 
												duration);
			}
			return returnArray;
		}
		else {
			return easingEquation(curTime, 
								  startValue, 
								  Number(endValue) - Number(startValue), 
								  duration);		
		}
	}		
	
	public function getCurVal2(curTime:Number):Object {
		if (arrayMode) {
			var returnArray:Array = new Array();
			var i:Number;
			var len:Number = startValue.length;
			for (i = 0; i < len; i++) {	
				returnArray[i] = easingEquation.apply(null, [curTime, 
															 startValue[i], 
															 endValue[i] - startValue[i], 
															 duration].concat(this.easingParams));
			}
			return returnArray;
		}
		else {			
			return easingEquation.apply(null, [curTime, 
											   startValue, 
											   Number(endValue) - Number(startValue), 
											   duration].concat(this.easingParams));
		}
	}
	
	public function setTweenHandlers(update:String, endValue:String):Void {
		updateMethod = update;
		endMethod = endValue;
	}
	
	//defaults to sin
	public function defaultEasingEquation(t:Number, b:Number, c:Number, d:Number):Number {
		return c/2 * ( Math.sin( Math.PI * (t/d-0.5) ) + 1 ) + b;
	}
	
	private function endTween(v:Object):Void {
		if (endMethod != null) {
			listener[endMethod](v);
		} else {
			listener.onTweenEnd(v);
		}
		this.stop();
	}	

	public function toString(Void):String {
		return "Tween";
	}
}