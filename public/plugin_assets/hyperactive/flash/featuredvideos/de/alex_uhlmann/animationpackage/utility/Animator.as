import de.alex_uhlmann.animationpackage.APCore;
import de.alex_uhlmann.animationpackage.animation.IAnimatable;
import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.IMultiAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.TweenAction;
import de.alex_uhlmann.animationpackage.utility.Tween;
import de.alex_uhlmann.animationpackage.utility.TimeTween;
import de.alex_uhlmann.animationpackage.utility.FrameTween;
import de.andre_michelle.events.FrameBasedInterval;

/**
* @class Animator
* @author Alex Uhlmann
* @description  Animator combines user defined property(ies) or method(s), tween-engines and 
* 			AnimationPackage. It allows to create custom animations easily.
* 			Animator is used by most classes in AnimationPackage that use animations.
* 			The tween engine used is either de.alex_uhlmann.animationpackage.utility.TimeTween or de.alex_uhlmann.animationpackage.utility.FrameTween 
* 			based on Andre Michelle's FrameBasedInterval and ImpulsDispatcher.	 
* 			Animator can handle single and multiple properties and single and multiple methods.
* 			<p>
* 			Example 1: To emulate the ColorBrightness class. 		
* 			<blockquote><pre>
*			var myAnimator:Animator = new Animator();
*			myAnimator.animationStyle(5000, Elastic.easeOut, "onCallback");
*			var myColorFX:ColorFX = new ColorFX(mc);
*			myAnimator.caller = this;
*			myAnimator.start = [myColorFX.getBrightness()];
*			myAnimator.end = [50];
*			myAnimator.setter = [[myColorFX,"setBrightness"]];
*			myAnimator.run();	
*			</pre></blockquote>
* 			Take a look at some other classes of AnimationPackage, most of them use 
* 			Animator internally. ColorTransform and ColorDodge i.e.<p>
* 			Animator also might come in handy to animate different properties of shapes 
* 			offered by the drawing package. Take a look at the 
* 			Rectangle class documentation for an example. 
* 			<p>	
* 			Example 1: <a href="Animator_01.html">(Example .swf)</a> If the start and end arrays 
* 			are longer than the setter array than Animator figures that you want all the properties 
* 			send to one function. Do crazy shape manipulations.
* 			<blockquote><pre>
*			var myStar:Star = new Star(330,200,50,60,6)
*			myStar.lineStyle();
*			myStar.fillStyle(0x9C3031);
*			myStar.draw();
*			
*			var myAnimator:Animator = new Animator();
*			myAnimator.animationStyle(5000,Circ.easeInOut);
*			myAnimator.start = [50,60];
*			myAnimator.end = [0,200];
*			//Try this one for yourself. A negative innerRadius parameter results in more complex star. 
*			//This Bug of the Star class is actually a feature and will not be fixed. ( ;
*			//myAnimator.end = [-125,200];
*			myAnimator.setter = [[this,"morph"]];
*			myAnimator.run();
*			
*			function morph(innerRadius:Number,outerRadius:Number) {
*				myStar.setInnerRadius(innerRadius);
*				myStar.setOuterRadius(outerRadius);	
*				myStar.draw();
*			}	
*			</pre></blockquote>
* 			<p>
* 			Example 1: <a href="Animator_02.html">(Example .swf)</a> This examples illustrates how 
* 			you can animate more complex drawing created with the Drawer class. If you create a 
* 			more imaginary drawing, which might even make some sense, please let me know. 
* 			I would be happy to replace it with my ugly one here. ( ;
* 			<blockquote><pre>
*			var myCubicCurve:CubicCurve = new CubicCurve(0,0,60,100,260,80,320,0);
*			var myLine:Line = new Line(320,0,0,0);
*			
*			var myDraw_mc:MovieClip = this.createEmptyMovieClip("draw_mc",999);
*			var myDrawer:Drawer = new Drawer(myDraw_mc);
*			myDrawer.addChild(myLine);
*			myDrawer.addChild(myCubicCurve);
*			myDrawer.drawBy();
*			myDrawer.fillStyle(0xff0000);
*			myDrawer.fill();
*			
*			var myAnimator:Animator = new Animator();
*			myAnimator.animationStyle(4000,Elastic.easeInOut);
*			myAnimator.start = [100,260,80];
*			myAnimator.end = [310,450,150];
*			myAnimator.setter = [[this,"morph"]];
*			myAnimator.run();
*			
*			function morph(y2:Number,x3:Number,y3:Number) {
*				myCubicCurve.setY2(y2);
*				myCubicCurve.setX3(x3);
*				myCubicCurve.setY3(y3);
*				myDrawer.clear();
*				myDrawer.drawBy();
*				myDrawer.fill();
*			}
*			</pre></blockquote>
* 			<p>
* 			Under the hood, to assign values to method(s) and/or property(ies), Animator 
* 			uses the optimized TweenAction class.
* 
* @usage <tt>var myAnimator:Animator = new Animator();</tt> 
*/
class de.alex_uhlmann.animationpackage.utility.Animator 
											extends AnimationCore 
											implements ISingleAnimatable, 
													IMultiAnimatable {		
	
	/** 
	* @property caller (Object) Object that calls the Animator. 
	* 					Used in first return value of callback.
	* @property start (Array) Array of value or values to start animation with.
	* @property end (Array) Targeted amount or amounts to animate to.
	* @property setter (Array) 2 dimensional array. First dimension holds an object as the first element and the corresponding function or property as the second element as a String. See run().
	* @property multiStart (Array) Same API as start. When multiple animation targets (i.e. movieclips) are animated, multiStart makes sure different start values are considered. It replaces start. See other IAnimatable classes for examples on implementation. i.e. the Move class.
	* @property multiSetter (Array) Same API as setter. When multiple animation targets (i.e. movieclips) are animated, multiSetter replaces setter. See other IAnimatable classes for examples on implementation. i.e. the Move class.
	*
	* @property duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @property easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @property callback (String) Function to invoke after animation. See APCore class. 
	*/
	public static var animations:Object;
	public var caller:Object;
	public var start:Array;
	public var end:Array;
	public var setter:Array;
	public var multiStart:Array;
	public var multiSetter:Array;
	public var myTween:Tween;
	private var startPause:Number;
	private var pausedTime:Number = 0;
	private var elapsedDuration:Number = 0;
	public var paused:Boolean = false;
	public var stopped:Boolean = false;
	public var finished:Boolean = false;
	private var arrayMode:Boolean;
	private var arrayLength:Number;
	/*relaxed type to accommodate numbers or arrays*/
	private var initVal;
	private var endVal;
	private var identifierToken:Number = 2;
	private var startPerc:Number;
	private var endPerc:Number;
	private var hiddenCaller:Object;
	private var perc:Number;	
	
	public function Animator() {
		super();
		this.animationStyle();
	}
	
	/**
	* @method run
	* @description 	send a custom method or methods to animate in a specified time 
	* 			and easing equation.			
	* 			
	* 		
	* @usage   <pre>myAnimator.run();</pre>
	* 		<pre>myAnimator.run(duration);</pre>
	*		<pre>myAnimator.run(duration, callback);</pre>
	* 		<pre>myAnimator.run(duration, easing, callback);</pre>
	* 	  
	* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @param callback (String) Function to invoke after Animator
	* @return void
	*/
	public function run():Void {
				
		if (arguments.length > 0) {
			this.animationStyle(arguments[0], arguments[1], arguments[2]);
		} else {
			this.animationStyle(this.duration, this.easing, this.callback);
		}		
		if(this.initAnimator() == false) {
			return;
		}
		this.initAnimation(0, 100);
	}

	/**
	* @method animate
	* @description 	similar to the run() method. Offers start and end parameters.
	* @usage   <pre>myInstance.animate(start, end);</pre> 	  
	* @param start (Number) start value. Percentage.
	* @param end (Number) end value. Percentage.
	* @return void
	*/	
	public function animate(start:Number, end:Number):Void {
		
		if(this.initAnimator() == false) {
			return;
		}
		
		this.initAnimation(start, end);
	}
	
	/**
	* @method goto
	* @description 	jumps to a specific step of the animation and stays there.
	* @usage   <pre>myInstance.goto(percentage);</pre>
	* @param percentage (Number) Percentage value of the animation.
	* @return void
	*/	
	public function goto(percentage:Number):Void {
		
		if(this.initAnimator() == false) {
			return;
		}
		
		//percentage = Math.round(percentage);
		this.perc = percentage;
		
		/*
		* goto would usually only dispatch onUpdate events. The 
		* following is done to dispatch all events depending on 
		* the state of the animation.
		* Prevent event dispatching of TweenAction 
		* with temporalily overwriting the caller property 
		* with a clone object of Animator. Fetch onUpdate events 
		* of the clone, modify them accordingly and dispatch them to the caller.
		*/
		this.hiddenCaller = this.caller;
		var hiddenAnimator:Animator = this.cloneAnimator(this);
		if(!this.caller.omitEvent) {
			hiddenAnimator.addEventListener("onUpdate", this);
		}
		this.caller = hiddenAnimator;

		this.initStartEndValues(percentage);		
		var myTweenAction:TweenAction = this.initTweenAction();
		/*this is usually done in TweenAction*/
		if(!this.arrayMode) {
			this.hiddenCaller.currentValue = this.initVal;
		} else {
			this.hiddenCaller.currentValues = this.initVal;
		}
			
		myTweenAction[this.retrieveSetters().update](this.initVal);	
		this.caller = this.hiddenCaller;
	}
	
	/*
	private function between(num:Number, min:Number, max:Number):Boolean {
		return (num > min && num < max);
	}
	*/
	
	private function cloneAnimator(animator:Animator):Animator {
		var cloneObj:Animator = new Animator();
		cloneObj.omitEvent = animator.omitEvent;
		cloneObj.caller = animator.caller;
		cloneObj.start = animator.start;	
		cloneObj.end = animator.end;
		cloneObj.setter = animator.setter;
		cloneObj.multiStart = animator.multiStart;
		cloneObj.multiSetter = animator.multiSetter;
		cloneObj.roundResult(animator.caller.rounded);
		return cloneObj;
	}	

	private function onUpdate(e:Object) {		
		e.target = this.hiddenCaller;
		if(this.perc == 0) {
			e.type = "onStart";
			this.dispatch(e);
		} else if(this.perc == 100) {
			e.type = "onEnd";
			this.dispatch(e);
		} else {
			this.dispatch(e);				
		}	
	}

	private function dispatchOnStart() {
		if(!this.arrayMode) {
			this.caller.currentValue = this.initVal;
		} else {
			this.caller.currentValues = this.initVal;
		}
		
		this.caller.dispatchEvent.apply(this.caller, [ {type:"onStart", 
															target: this.caller, 
															value: this.initVal} ]);													
	}
	
	private function dispatch(e:Object) {		
		this.hiddenCaller.dispatchEvent.apply(this.hiddenCaller, [ e ]);		
	}	
	
	private function initAnimator(Void):Boolean {
		
		//initialize caller.
		if(this.caller == null) {
			this.caller = this;
		}
		
		//check if multiple animation targets have been supplied
		if(this.multiSetter != null) {
			this.createMultiSetter(this.multiSetter);
		}
		
		//deletion of equivalent values.
		if(this.caller.equivalentsRemoved == true) {			
			if(this.splitEquivalents() == "ALL") {
				return false;
			}
		}
		if(AnimationCore.equivalentsRemoved_static == true 
						&& this.caller.equivalentsRemoved == null) {
		
			if(this.splitEquivalents() == "ALL") {
				return false;
			}
		}
		
		saveAnimation();
		
		//initialize start/end values.
		var len:Number = this.end.length;
		if(this.start.length != len) {
			return false;
		}
		this.startInitialized = false;
		if(len > 1) {
			this.arrayMode = true;
			this.initVal = this.start;
			this.endVal = this.end;
			this.setStartValues(this.initVal);
			this.setEndValues(this.endVal);
		} else {
			this.arrayMode = false;
			this.initVal = this.start[0];
			this.endVal = this.end[0];
			this.setStartValue(this.initVal);
			this.setEndValue(this.endVal);	
		}
		
		this.arrayLength = len;
		return true;
	}
	
	private function saveAnimation(Void):Void {
		if(AnimationCore.getOverwriteModes()) {
			var i:Number = this.setter.length;
			while(--i>-1) {
				var key:String = makeKey(this.setter[i]);
				if(key == "0")return;
				if(Animator.animations == null) {
					Animator.animations = new Object();
				}
				if(Animator.animations[key] != null) {
					var animation:IAnimatable = Animator.animations[key];
					animation.stop();
				}
				Animator.animations[key] = this.caller;
			}
		}
	}
	
	private function makeKey(setter:Array):String {
		var o:String;
		if(typeof(setter[0]) == "movieclip") {
			o = String(setter[0]);
		} else {
			if(this.caller.overwriteProperty == null) {
				return "0";
			} else {
				o = setter[0][this.caller.overwriteProperty]; 
			}
		}
		return (o + setter[1]);
	}
	
	public function deleteAnimation(Void):Void {		
		if(Animator.animations == null) {
			return;
		}
		var i:Number = this.setter.length;
		while(--i>-1) {
			var key:String = makeKey(this.setter[i]);
			if(key == "0")return;
			delete Animator.animations[key];
		}
	}
	
	/*
	* deletion of equivalent values. Returns "NONE" to indicate 
	* that zero values have been removed. "SOME" that some have been 
	* removed and "ALL" that all have been removed.
	*/
	private function splitEquivalents(Void):String {
		/*extract values that won't animate*/
		var len:Number = this.end.length;
		var i:Number = len;		
		while(--i>-1) {
			if(this.start[i] == this.end[i]) {
				this.start.splice(i,1);
				this.end.splice(i,1);
				this.setter.splice(i,1);
			}
		}
		if(this.start.length == 0) {
			this.caller["dispatchEvent"]({type:"onEnd", target:this.caller, value: null});
			return "ALL";
		} else if(this.end.length == len) {
			return "NONE";
		} else if(this.end.length < len) {
			return "SOME";
		}
	}	

	public function hasEquivalents(Void):Boolean {
		var hasEquivalentsBool:Boolean;

		var splitResult:String = simulateSplitEquivalents();
		if(splitResult == "NONE") {
			hasEquivalentsBool = false;
		} else {
			hasEquivalentsBool = true;
		}
		
		return hasEquivalentsBool;
	}
	
	private function simulateSplitEquivalents(Void):String {
		var startLen:Number = this.start.length;
		var endLen:Number = this.end.length;
		var setterLen:Number = this.setter.length;
		var len:Number = this.end.length;
		var i:Number = len;		
		while(--i>-1) {
			if(this.start[i] == this.end[i]) {
				startLen--;
				endLen--;
				setterLen--;
			}
		}
		if(startLen == 0) {
			return "ALL";
		} else if(endLen == len) {
			return "NONE";
		} else if(endLen < len) {
			return "SOME";
		}
	}
	
	private function initAnimation(start:Number, end:Number):Void {
		
		this.startPerc = start;
		this.endPerc = end;
		if(this.caller.getTweenMode() == AnimationCore.INTERVAL) {
			this.invokeAnimation(start, end);
		} else if(this.caller.getTweenMode() == AnimationCore.FRAMES) {
			prepareForDurationMode(start, end);
		}
	}
	
	private function prepareForDurationMode(start:Number, end:Number):Void {		
		if(this.caller.getDurationMode() == AnimationCore.MS) {
			prepareForDurationModeMS();
		} else if(this.caller.getDurationMode() == AnimationCore.FRAMES) {
			prepareForDurationModeFRAMES(start, end);
		}
	}
	
	private function prepareForDurationModeMS():Void {		
		var fps:Number = APCore.getFPS();
		if(fps == 0) {
			APCore.calculateFPS();
			APCore.addListener(this);					
		} else {
			this.onFPSCalculated(fps);					
		}
	}	
	
	private function prepareForDurationModeFRAMES(start:Number, end:Number):Void {		
		this.durationInFrames = this.duration;
		this.invokeAnimation(start, end);
	}	
	
	private function onFPSCalculated(fps:Number):Void {		
		/*calculate frames with fps.*/
		APCore.removeListener(this);
		this.durationInFrames = APCore.milliseconds2frames(this.duration);		
		this.invokeAnimation(this.startPerc, this.endPerc);
	}

	private function invokeAnimation(start:Number, end:Number):Void {
			
		this.finished = false;		
		/*important for pause/resume/stop*/
		if(this.caller == this) {
			this.myAnimator = this;
		}		
		this.caller.tweening = true;
		
		this.initStartEndValues(start, end);
		var myTweenAction:TweenAction = this.initTweenAction();
		
		if(this.caller.getTweenMode() == AnimationCore.INTERVAL) {
			initializeTimeTween(myTweenAction);
		} else if(this.caller.getTweenMode() == AnimationCore.FRAMES) {
			initializeFrameTween(myTweenAction);
		}
		
		var setterObj:Object = this.retrieveSetters();
		
		this.myTween.setTweenHandlers(setterObj.update, 
								setterObj.end);
		this.myTween.easingEquation = this.easing;
		this.myTween.start();
		this.dispatchOnStart();
	}
	
	private function initializeTimeTween(myTweenAction:TweenAction):Void {
		this.myTween = new TimeTween(myTweenAction, 
								this.initVal, 
								this.endVal, 
								this.duration, 
								this.caller.easingParams);	
	}
	
	private function initializeFrameTween(myTweenAction:TweenAction):Void {
		this.myTween = new FrameTween(myTweenAction, 
								this.initVal, 
								this.endVal, 
								this.durationInFrames, 
								this.caller.easingParams);
	}	
	
	private function initStartEndValues(start:Number, end:Number):Void {

		if(this.arrayLength > 1) {
			
			var startRelArr:Array = [];
			var endRelArr:Array = [];
			var i:Number;
			var len:Number = this.arrayLength;
			for(i = 0; i < len; i++) {				
				startRelArr.push(start / 100 * (this.endValues[i] - this.startValues[i]) + this.startValues[i]);
				endRelArr.push(end / 100 * (this.endValues[i] - this.startValues[i]) + this.startValues[i]);
			}
			this.initVal = startRelArr;
			this.endVal = endRelArr;			

		} else {			
			var dif:Number = this.endValue - this.startValue;
			var startRel:Number = start / 100 * dif + this.startValue;		
			var endRel:Number = end / 100 * dif + this.startValue;
			this.initVal = startRel;
			this.endVal = endRel;
		}
	}
	
	private function initTweenAction(Void):TweenAction {
		var scope:Object = this.setter[0][0];
		var targetStr:String = this.setter[0][1];
		var identifier:Function = scope[targetStr];
		var myTweenAction:TweenAction = new TweenAction(this, 
												this.initVal, 
												this.endVal);
		if(this.arrayMode == false) {
			myTweenAction.initSingleMode(scope, targetStr, identifier);
		} else {
			myTweenAction.initMultiMode(this.arrayLength);
		}
		return myTweenAction;
	}
	
	private function retrieveSetters(Void):Object {
		
		/* 
		* Choose the most suitable callback method of TweenAction.
		* Optimized, less readable code.
		* o = onTweenUpdateOnce
		* m = onTweenUpdateMulitple
		* e = onTweenEnd
		* 2 = rounds the result
		* p = only properties
		* m = only methods
		* mu = multiple parameters
		* mu2 = rounded multiple parameters
		*/
		/*first compute identifierTokens for another abstration*/
		this.computeSetters();
		
		var setterObj:Object = new Object();
		
		if(this.arrayMode == false) {			
			if(!this.caller.rounded) {
				if(this.identifierToken == 0) {
					setterObj.update = "op";
				} else if(this.identifierToken == 1) {
					setterObj.update = "om";
				} else {
					setterObj.update = "o";
				}
			} else {
				if(this.identifierToken == 0) {
					setterObj.update = "o2p";
				} else if(this.identifierToken == 1) {
					setterObj.update = "o2m";
				} else {
					setterObj.update = "o2";
				}
			}			
		} else {
			if(!this.caller.rounded) {				
				if(this.identifierToken == 0) {
					setterObj.update = "mp";
				} else if(this.identifierToken == 1) {
					setterObj.update = "mm";
				} else if(this.identifierToken == 2) {
					setterObj.update = "m";
				} else {
					setterObj.update = "mu";
				}
			} else {
				if(this.identifierToken == 0) {
					setterObj.update = "m2p";
				} else if(this.identifierToken == 1) {					
					setterObj.update = "m2m";
				} else if(this.identifierToken == 2) {
					setterObj.update = "m2";
				}else {
					setterObj.update = "mu2";
				}
			}
		}
		setterObj.end = "e";
		return setterObj;
	}
	
	private function computeSetters(Void):Void {
		var scope:Object = this.setter[0][0];
		var targetStr:String = this.setter[0][1];
		var identifier:Function = scope[targetStr];
		/*
		* initialize TweenAction and check if either only properties, only methods or both are used. 
		* Needed for optimisation. The corresponding callback method of TweenAction 
		* will be chosen later in retrieveSetters.
		*/
		if(this.arrayMode == false) {
			this.checkIfFunction(identifier);			
		} else {
			/*
			* if there are more values to animate than setters, Animator assigns a 
			* special callback method of TweenAction, 
			* which sends all animated values to the first setter.
			*/
			if(this.setter.length < this.arrayLength) {
				this.identifierToken = 3;
			} else {		
				var i:Number = this.setter.length-1;
				var result:Boolean = this.checkIfFunction(this.setter[i][0][this.setter[i][1]]);
				while(--i>-1) {
					if(this.checkIfFunction(this.setter[i][0][this.setter[i][1]]) != result) {
						this.identifierToken = 2;
						break;
					}
				}
			}	
		}
	}
	
	/*
	* 0 = Property
	* 1 = Method
	* 2 = Both
	* 3 = multiple parameters
	*/
	private function checkIfFunction(identifier:Function):Boolean {		
		if(typeof(identifier) != "number") {
			this.identifierToken = 1;
			return true;
		} else {
			this.identifierToken = 0;
			return false;
		}
	}	

	private function createMultiSetter(setter:Array):Void {
		/*
		* if the multiStart property is defined, Animator fills 
		* the start parameter with the return values of the methods or
		* properties of the multiStart Array.
		* This way each IAnimatable user class can present different 
		* start values to Animator for each animation target with setting 
		* the multiStart and multiSetter properties.
		*/
		var init:Boolean;
		var startVal:Array;
		var startValue:Number;
		var startTargetStr:String;
		if(this.multiStart == null) {
			init = false;
			startVal = this.start;
		} else {			
			init = true;
		}
		var s:Array = this.start = [];
		var endVal:Array = this.end;
		var endValue:Number;
		var e:Array = this.end = [];
		var se:Array = this.setter = [];
		var scopes:Array;
		var len1:Number = setter.length;	
		var i:Number = len1;
		while(--i>-1) {
			if(init) {
				startTargetStr = this.multiStart[i];
			} else {
				startValue = startVal[i];
			}
			endValue = endVal[i];
			scopes = setter[i][0];
			var targetStr:String = setter[i][1];
			var len2:Number = scopes.length;	
			var j:Number = len2;
			while(--j>-1) {
				var scope:Object = scopes[j];				
				if(init) {
					if(this.checkIfFunction(scope[startTargetStr])) {
						s.unshift(scope[startTargetStr]());
					} else {
						s.unshift(scope[startTargetStr]);
					}
				} else {
					s.unshift(startValue);					
				}
				e.unshift(endValue);
				se.unshift([scope,targetStr]);
			}			
		}	
		if(scopes.length == 0) {			
			this.caller.setStartValue(s);
			this.caller.setEndValue(e);
			this.caller.setStartValues(undefined);
			this.caller.setEndValues(undefined);
			this.caller.setCurrentValues(undefined);
		} else {
			this.caller.setStartValues(s);
			this.caller.setEndValues(e);
			this.caller.setStartValue(undefined);
			this.caller.setEndValue(undefined);
			this.caller.setCurrentValue(undefined);
		}
	}
	
	public function getDurationElapsed(Void):Number {		
		if(this.paused == true || this.stopped == true) {
			return this.elapsedDuration;
		} else {
			return this.computeElapsedDuration();
		}
	}
	
	public function getDurationRemaining(Void):Number {
		var r:Number;
		if(this.stopped == false) {
			if(this.caller.getTweenMode() == AnimationCore.INTERVAL) {
				r = this.duration - this.getDurationElapsed();
			} else if(this.caller.getTweenMode() == AnimationCore.FRAMES) {
				if(this.caller.getDurationMode() == AnimationCore.MS) {	
					r = this.duration - this.getDurationElapsed();
					if(this.finished == true) {
						r = 0;
					}
				} else {
					r = this.durationInFrames - this.getDurationElapsed();
				}
			}
			if(r < 0) {
				r = 0;
			}
		} else {
			r = 0;
		}
		if(isNaN(r)) {
			return undefined;
		} else {
			return r;
		}
	}
	
	private function computeElapsedDuration(Void):Number {
		var r:Number;
		if(this.finished == true) {
			r = this.duration;
		} else {
			if(this.caller.getTweenMode() == AnimationCore.INTERVAL) {
				r = getTimer() - this.myTween.startTime;
			} else if(this.caller.getTweenMode() == AnimationCore.FRAMES) {
				if(this.caller.getDurationMode() == AnimationCore.MS) {
					r = APCore.fps * (FrameBasedInterval.frame - this.myTween.startTime);			
				} else {
					r = FrameBasedInterval.frame - this.myTween.startTime;
				}		
			}
		}
		if(isNaN(r)) {
			return undefined;
		} else {
			return r;
		}
	}

	public function stopMe(Void):Void {		
		this.elapsedDuration = this.computeElapsedDuration();
		this.myTween.stop();
		deleteAnimation();
		this.stopped = true;
	}
	
	public function pauseMe(Void):Void {	
		this.elapsedDuration = this.computeElapsedDuration();
		this.myTween.pause();
	}
	
	public function resumeMe(Void):Void {		
		this.myTween.resume();
	}
	
	/*inherited from AnimationCore*/
	/**
	* @method animationStyle
	* @description 	set the animation style properties for your animation.
	* 			Notice that if your easing equation supports additional parameters you 
	* 			can send those parameters with the easing parameter in animationStyle.
	* 			You have to send an Array as easing parameter. The first 
	* 			element has to be the easing equation in Robert Penner style. The 
	* 			following parameters can be your additional parameters. i.e.:
	* 			<blockquote><pre>
	*			var myRotation:Rotation = new Rotation(mc);
	*			myRotation.animationStyle(2000,[Back.easeOut,4]);
	*			myRotation.run(360);
	*			</pre></blockquote>
	* 			See also "Customizable easing equations" in readme for more information.
	* 		
	* 		
	* @usage   <pre>myAnimator.animationStyle(duration);</pre>
	* 		<pre>myAnimator.animationStyle(duration, callback);</pre>
	* 		<pre>myAnimator.animationStyle(duration, easing, callback);</pre>
	* 	  
	* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @param callback (String) Function to invoke after animation. See APCore class.
	*/
	
	/**
	* @method roundResult
	* @description 	rounds animation results to integers. (might be usefull for animating pixelfonts). Default is false.		
	* @usage   <pre>myInstance.roundResult(event, listener);</pre>
	*@param rounded (Boolean) <code>true</code> rounds the result. Animates with integers. Less accuracy.
	*                  				<code>false</code> animates with floating point numbers.
	*/
	
	/**
	* @method forceEnd
	* @description 	Flash does not guaranteed that time-based tweening will reach 
	* 			the end value(s) of your animation. By default AnimationPackage 
	* 			guarantees that the end value(s) will be reached. The forceEnd 
	* 			method allows you to disable this guarantee and only accept 
	* 			the values from your easing equation. In certain situations this can 
	* 			lead to a smoother ending of the animation. Notice that in frame-based 
	* 			tweening the end value(s) will always be reached.		
	* @usage   <pre>myInstance.forceEnd(forceEndVal);</pre>
	*@param forceEndVal (Boolean) <code>true</code> or <code>false</code>.
	*/
	
	/**
	* @method getOptimizationMode
	* @description 	returns the optimization mode. See setOptimizationMode for more information. 
	* @usage   <tt>getOptimizationMode();</tt>
	* @return Boolean
	*/	
	
	/**
	* @method setOptimizationMode
	* @description 	Allows to explicitly remove parts of the animation that don't change during 
	* 				the animation. 
	* 				This can add additional performance to your animation. Note that 
	* 				setting this method to true has side effects. If all start and end values match, 
	* 				the animation won't start and will immediatly invoke an onEnd event. 
	* 				The order of values returned by getStartValue(s), getCurrentValue(s), 
	* 				getEndValue(s) and the value property of the eventObject returned 
	* 				by EventDispatcher might change if you set this method to true. You can 
	* 				still retrieve the parts of the animation that are actually animated 
	* 				if you access the Animator instance of your animation class via 
	* 				myAnimator. Ask <code>myInstance.myAnimator.setter</code> to retrieve 
	* 				all currently animated parts of the animation. See Animator 
	* 				documentation. Of cource, if you know your input values you would 
	* 				probably look at them.<p>
	* 				Note that the AnimationCore class offers a static setOptimizationModes method 
	* 				(note the last "s" at the end) that allows you to remove parts of 
	* 				'all' your animations that don't change during the animation.
	* @usage   <pre>myInstance.setOptimizationMode(optimize);</pre>
	* @param optimize (Boolean)
	*/
	
	/**
	* @method getTweenMode
	* @description 	returns the current tween mode used by the instance. 
	* 				Please check with AnimationCore.setTweenModes for more information.
	* @usage   <tt>getTweenMode();</tt>
	* @return String that specifies the tween mode. Either AnimationCore.INTERVAL or AnimationCore.FRAMES.
	*/
	
	/**
	* @method setTweenMode
	* @description 	sets the current tween mode used by the instance. 
	* 				Please check with AnimationCore.setTweenModes for more information.
	* @usage   <tt>setTweenMode();</tt> 	
	* @param t (String) Either AnimationCore.INTERVAL for time-based tweening or AnimationCore.FRAMES for frame-based tweening.
	* @returns   <code>true</code> if setting tween mode was successful, 
	*                  <code>false</code> if not successful.
	*/
	
	/**
	* @method getDurationMode
	* @description 	returns the current duration mode used by the instance.
	* 				Please check with AnimationCore.setTweenModes for more information.
	* @usage   <tt>getDurationMode();</tt>
	* @return String that specifies the duration mode. Either AnimationCore.MS or AnimationCore.FRAMES.
	*/
	
	/**
	* @method setDurationMode
	* @description 	sets the current duration mode used by the instance. 
	* 				Please check with AnimationCore.setTweenModes for more information.
	* @usage   <tt>setDurationMode();</tt> 	
	* @param d (String) Either AnimationCore.MS for milliseconds or AnimationCore.FRAMES.
	* @returns   <code>true</code> if setting duration mode was successful, 
	*                  <code>false</code> if not successful.
	*/
	
	/**
	* @method stop
	* @description 	stops the animation if not locked..
	* @usage   <tt>myInstance.stop();</tt> 
	* @returns <code>true</code> if instance was successfully stopped. 
	*                  <code>false</code> if instance could not be stopped, because it was locked.
	*/	
	
	/**
	* @method pause
	* @description 	pauses the animation if not locked. Call resume() to continue animation.
	* @usage   <tt>myInstance.pause();</tt> 	  
	* @param duration (Number) optional property. Number of milliseconds or frames to pause before continuing animation.
	* @returns <code>true</code> if instance was successfully paused. 
	*                  <code>false</code> if instance could not be paused, because it was locked.
	*/	
	
	/**
	* @method resume
	* @description 	continues the animation if not locked. 
	* @usage   <tt>myInstance.resume();</tt> 	
	* @returns <code>true</code> if instance was successfully resumed. 
	*                  <code>false</code> if instance could not be resumed, because it was locked.
	*/
	
	/**
	* @method lock
	* @description 	locks the animation to prevent pausing, resuming and stopping. Default is unlocked.
	* @usage   <tt>myInstance.lock();</tt> 	  
	*/	
	
	/**
	* @method unlock
	* @description 	unlocks the animation to allow pausing, resuming and stopping. Default is unlocked.
	* @usage   <tt>myInstance.unlock();</tt> 	  
	*/	
	
	/**
	* @method isTweening
	* @description 	checks if the instance is currently animated.
	* @usage   <tt>myInstance.isTweening();</tt> 	
	* @returns   <code>true</code> if instance is tweening, 
	*                  <code>false</code> if instance is not tweening.
	*/
	
	/**
	* @method getStartValue
	* @description 	returns the original, starting value of the current tween. 
	* @usage   <tt>myInstance.getStartValue();</tt>
	* @return Number
	*/
	
	/**
	* @method getStartValues
	* @description 	returns the original, starting values of the current tween.
	* @usage   <tt>myInstance.getStartValues();</tt>
	* @return (Array)
	*/

	/**
	* @method getEndValue
	* @description 	returns the targeted value of the current tween. 
	* @usage   <tt>myInstance.getEndValue();</tt>
	* @return Number
	*/
	
	/**
	* @method getEndValues
	* @description 	returns the targeted values of the current tween.
	* @usage   <tt>myInstance.getEndValues();</tt>
	* @return (Array)
	*/	
	
	/**
	* @method getCurrentValue
	* @description 	returns the current value of the current tween. 
	* @usage   <tt>myInstance.getCurrentValue();</tt>
	* @return Number
	*/
	
	/**
	* @method getCurrentValues
	* @description 	returns the current values of the current tween.
	* @usage   <tt>myInstance.getCurrentValues();</tt>
	* @return (Array)
	*/
	
	/**
	* @method getCurrentPercentage
	* @description 	returns the current state of the animation in percentage. 
	* 				Especially usefull in combination with goto().
	* @usage   <tt>myInstance.getCurrentPercentage();</tt>
	* @return Number
	*/	
	
	/**
	* @method getDurationElapsed
	* @description 	returns the elapsed time or frames since the current tween started tweening.
	* @usage   <tt>myInstance.getDurationElapsed();</tt>
	* @return Number
	*/
	
	/**
	* @method getDurationRemaining
	* @description 	returns the remaining time or frames since the current tween started tweening.
	* @usage   <tt>myInstance.getDurationRemaining();</tt>
	* @return Number
	*/	
	
	/*inherited from APCore*/
	/**
	* @method addEventListener
	* @description 	Subscribe to a predefined event. The following standard EventDispatcher events are broadcasted<p>
	* 			<b>onStart</b>, broadcasted when animation starts.<br>
	*			<b>onUpdate</b>, broadcasted when animation updates.<br>
	*			<b>onEnd</b>, broadcasted when animation ends.<p>
	* 			The even object returned, contains the following properties:<p>
	* 			<b>type</b> (String) event broadcasted.<br>
	*			<b>target</b> (Object) event source.<br>
	* 		
	* @usage   <pre>myAnimator.addEventListener(event, listener);</pre>
	* 		    <pre>myAnimator.addEventListener(event, listener, handler);</pre>
	* 	  
	*@param event (String) Event to subscribe listener to. GDispatcher specific feature allows to subscribe to all events from an event source if the string "ALL" is passed. 
	*@param listener (Object) The listener object to subscribe to the specified event.
	*@param handler (String) Optional. GDispatcher specific feature. The name of a function to call. This function will be called within the scope of the object specified in the second parameter.
	*/
	
	/*inherited from APCore*/
	/**
	* @method removeEventListener
	* @description 	Removes a listener from a subscribed event.	
	* 		
	* @usage   <pre>myAnimator.removeEventListener(event, listener);</pre>
	* 		    <pre>myAnimator.removeEventListener(event, listener, handler);</pre>
	* 	  
	*@param event (String) Event to remove subscribed listener from. GDispatcher specific feature allows to remove subscribtion to all events if the string "ALL" is passed. Works only if listener has been subscribed via the "ALL" string in addEventListener.
	*@param listener (Object) The listener object to unsubscribe from the specified event.
	*@param handler (String) Optional. GDispatcher specific feature. Only needed if the listener has been subscribed with a handler function.
	*/
	
	/*inherited from APCore*/
	/**
	* @method removeAllEventListeners
	* @description 	GDispatcher specific feature. Removes all listeners for a specific event, or for all events.
	* 		
	* @usage   <pre>myAnimator.removeAllEventListeners();</pre>
	* 		    <pre>myAnimator.removeAllEventListeners(event);</pre>
	* 	  
	*@param event (String) Event to remove all subscribed listeners from. If not specified, all listeners to any event will be removed.
	*/
	
	/*inherited from APCore*/
	/**
	* @method eventListenerExists
	* @description 	GDispatcher specific feature. Checks if a listener is already subscribed to a certain event.
	* 		
	* @usage   <pre>myAnimator.eventListenerExists(event, listener);</pre>
	* 			<pre>myAnimator.eventListenerExists(event, listener, handler);</pre>
	* 	  
	*@param event (String) Event to check subscription.
	*@param listener (Object) The listener object to check subscription.
	*@param handler (String) The handler function to check subscription.	
	*@returns <code>true</code> if event exists on listener. 
	*                  <code>false</code> if event doesn't exist on listener. 
	*/
	
	/**
	* @method getID
	* @description 	returns a unique ID of the instance. Usefull for associative arrays.
	* @usage   <tt>myInstance.getID();</tt>
	* @return Number
	*/
	
	/**
	* @method toString
	* @description 	returns the name of the class.
	* @usage   <tt>myInstance.toString();</tt>
	* @return String
	*/	
	public function toString(Void):String {
		return "Animator";
	}
}