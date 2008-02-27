import de.alex_uhlmann.animationpackage.APCore;
import de.alex_uhlmann.animationpackage.utility.IVisitor;
import de.alex_uhlmann.animationpackage.utility.IVisitorElement;
import de.alex_uhlmann.animationpackage.utility.Animator;
import de.alex_uhlmann.animationpackage.utility.Pause;
import de.alex_uhlmann.animationpackage.utility.TimeTween;
import de.alex_uhlmann.animationpackage.utility.FrameTween;
import com.robertpenner.easing.*;

/**
* @class AnimationCore
* @author Alex Uhlmann
* @description  All classes in AnimationPackage that use animations inherit their 
* 			animationStyle properties from AnimationCore. If you don't specify 
* 			the animationStyle properties either with the animationStyle() method 
* 			or directly via the properties, the default animationStyle properties are used.
* 			AnimationCore gives you the opportunity to set and retrieve default properties 
* 			for animationStyle properties. 
* 			Here is how those default properties are defined by default:		
* 			<pre><blockquote>
* 			AnimationCore.duration_def = 1000;
*			AnimationCore.easing_def = Linear.easeNone;
*			AnimationCore.callback_def = null;	
* 			</pre></blockquote>
* 			Note that all default properties have the same name as their instance properties 
* 			but the suffix "_def". For more information about the callback property, take a look at the 
* 			APCore class documentation and the readme.htm > "Event Handling".
* 			<p>
* 			AnimationCore allows you to specify the tween-engine used by AnimationPackage. 
* 			Like discussed in the readme.htm under "Tween-engine" you can choose between time-based tweening 
* 			(INTERVAL), and frame-based tweening (FRAMES). By default time-based tweening is activated. 
* 			You can change the tween mode either globally for all animations in AnimationPackage or 
* 			seperatly for each instance. You change it globally with AnimationCore.setTweenModes() (see documentation below). 
* 			In INTERVAL mode you control the duration of animations with milliseconds. In FRAMES mode, by default,
* 			you control the duration of animations with frames. Since this might be a little cumbersome for some developers, 
* 			FRAMES mode can also accept milliseconds if you say so. See AnimationCore.setDurationModes for details.
* 			If you're using frame-based tweening and you're wondering why your animations are so 
* 			slow and sluggish, then check your movie's frame rate.
*  			</p>
* 			<p>
* 			Furthermore, AnimationCore stores functionality that is used by classes that use animations. 
* 			This includes protected functionality to stop, pause, resume, lock and unlock animations 
* 			and static pauseAll and resumeAll methods enable you to pause/resume all running animations.
* 			<p>
* @usage <tt>private class constructor</tt> 
*/
class de.alex_uhlmann.animationpackage.animation.AnimationCore 
													extends APCore 
													implements IVisitorElement{	
	
	/*static stardard properties*/
	/** 
	* @property AnimationCore.duration_def (Number)(static) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @property AnimationCore.easing_def (Function)(static) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @property AnimationCore.callback_def (String)(static) Function to invoke after animation. See APCore class.	
	* @property AnimationCore.INTERVAL (String)(static) Property that can be used to set the tween mode. See setTweenMode.
	* @property AnimationCore.FRAMES (String)(static) Property that can be used to set the tween mode. See setTweenMode.
	* @property AnimationCore.MS (String)(static) Property that can be used to set the duration mode. See setDurationMode.
	*/	
	public static var duration_def:Number = 1000;
	public static var easing_def:Function = Linear.easeNone;
	public static var callback_def:String = null;	
	public static var INTERVAL:String = "INTERVAL";
	public static var FRAMES:String = "FRAMES";	
	public static var MS:String = "MS";
	private static var tweenModes:String = AnimationCore.INTERVAL;
	private static var durationModes:String = AnimationCore.MS;
	private static var overwriteModes:Boolean = true;
	private static var equivalentsRemoved_static:Boolean = false;	
	public var duration:Number;
	public var easing:Function;
	public var callback:String;
	public var myAnimator:Animator;	
	/*used to flag animations not to dispatch events. Used by Animator.*/
	public var omitEvent:Boolean = false;	
	private var easingParams:Array = null;
	private var durationInFrames:Number;
	private var startInitialized:Boolean = false;
	private var startValue:Number;
	private var startValues:Array;
	private var endValue:Number;
	private var endValues:Array;
	private var currentValue:Number;
	private var currentValues:Array;	
	private var mc:MovieClip;
	private var mcs:Array;
	private var tweenMode:String = null;
	private var durationMode:String = null;	
	private var equivalentsRemoved:Boolean = null;
	private var overwriteProperty:String;
	private var rounded:Boolean = false;
	private var forceEndVal:Boolean = true;	
	private var locked:Boolean = false;	
	private var myPause:Pause;
	private var tweening:Boolean = false;
	private var paused:Boolean = false;
	private var initAnimation:Function;
	private var invokeAnimation:Function;
	
	private function AnimationCore(noEvents:Boolean) {
		super.init(noEvents);		
	}	
	
	/*initialisation for classes with one identifier to animate*/
	private function init():Void {
		if(arguments[0] instanceof Array) {
			var values:Array = arguments[0];
			arguments.shift();
			arguments.unshift(values.pop());				
			this.initAnimation.apply(this, arguments);
			this.setStartValue(values[0]);
		} else if(arguments.length > 0) {
			this.initAnimation.apply(this, arguments);
		}
	}
		
	public function run():Void {		
		this.init.apply(this, arguments);
		this.invokeAnimation(0, 100);		
	}
	
	public function animate(start:Number, end:Number):Void {		
		this.invokeAnimation(start, end);
	}	
	
	public function goto(percentage:Number):Void {
		this.invokeAnimation(percentage);
	}
	
	public function accept(visitor:IVisitor):Void {
		visitor.visit(this);
	}
	
	public function getStartValue(Void):Number {
		return this.startValue;
	}
	
	public function setStartValue(startValue:Number, optional:Boolean):Boolean {
		if(this.startInitialized == false || optional == null) {			
			this.startInitialized = true;			
			this.startValue = startValue;
			return true;
		}
		return false;
	}	
	
	public function getStartValues(Void):Array {
		return this.startValues;
	}
	
	public function setStartValues(startValues:Array, optional:Boolean):Boolean {
		if(this.startInitialized == false || optional != true) {			
			this.startInitialized = true;			
			this.startValues = startValues;			
			return true;
		}
		return false;
	}
	
	public function getEndValue(Void):Number {		
		return this.endValue;
	}
	
	public function setEndValue(endValue:Number):Boolean {
		this.endValue = endValue;
		return true;
	}	
	
	public function getEndValues(Void):Array {		
		return this.endValues;
	}
	
	public function setEndValues(endValues:Array):Boolean {		
		this.endValues = endValues;
		return true;
	}		
	
	public function getCurrentValue(Void):Number {		
		return this.currentValue;
	}
	
	public function getCurrentValues(Void):Array {		
		return this.currentValues;
	}
	
	public function getCurrentPercentage(Void):Number {
		var start:Number;
		var end:Number;
		var current:Number;
		/*
		* if any values is null, AnimationCore assumes 
		* that the animation has not yet started and therefore returns 0%.
		*/
		if(this.startValue == null) {
			/*
			* if start and end values are the same during animation
			* it's impossible to compute the current percentage.
			* Therefore, only compute values that have different start 
			* and end values.
			*/		
			var startValues:Array = this.getStartValues();
			if(startValues == null) {
				return 0;
			}
			var endValues:Array = this.getEndValues();
			if(endValues == null) {
				return 0;
			}
			var i:Number = startValues.length;
			while(--i>-1) {
				if(startValues[i] != endValues[i]) {					
					break;
				}
			}
			start = startValues[i];			
			end = endValues[i];
			if(this.getCurrentValues()[i] != null) {
				current = this.getCurrentValues()[i];
			} else {
				return 0;
			}
		} else {
			if(this.getStartValue() != null) {
				start = this.getStartValue();
			} else {
				return 0;
			}
			if(this.getEndValue() != null) {
				end = this.getEndValue();
			} else {
				return 0;
			}
			if(this.getCurrentValue() != null) {
				current = this.getCurrentValue();
			} else {
				return 0;
			}
		}
		
		if(start < end) {
			return (current - start) / (end - start) * 100;
		} else {
			return 100 - ((current - end) / (start - end) * 100);
		}
	}
	
	public function getDurationElapsed(Void):Number {		
		return this.myAnimator.getDurationElapsed();
	}
	
	public function getDurationRemaining(Void):Number {		
		return this.myAnimator.getDurationRemaining();
	}
	
	/*animationStyle, getter, setter*/
	public function animationStyle(duration:Number, easing:Object, callback:String):Void {                
		var temp;
		if(typeof(easing) == "string") {                        
			temp = easing;                        
			this.callback = temp;
			this.easing = AnimationCore.easing_def;
		} else if (easing == null) {                        
			this.easing = AnimationCore.easing_def;
			this.callback = callback;
		} else if (easing instanceof Array) {
			this.easing = easing[0];
			this.easingParams = easing.slice(1);
			this.callback = callback;
		} else {                        
			temp = easing;
			this.easing = temp;
			this.callback = callback;
		}		
		this.duration = (duration == null) ? AnimationCore.duration_def : duration;
		
		if(this.callback == null) {
			this.callback = AnimationCore.callback_def;
		}		
	}
	
	public function get movieclip():MovieClip {
		return this.mc;
	}
	
	public function set movieclip(mc:MovieClip):Void {
		this.mc = mc;
	}
	
	public function get movieclips():Array {
		return this.mcs;
	}
	
	public function set movieclips(mcs:Array):Void {
		this.mcs = mcs;
	}
	
	public function checkIfRounded(Void):Boolean {
		return this.rounded;
	}
	
	public function roundResult(rounded:Boolean):Void {
		this.rounded = rounded;
	}
	
	public function forceEnd(forceEndVal:Boolean):Void {
		this.forceEndVal = forceEndVal;
	}
	
	public function getOptimizationMode(Void):Boolean {		
		return this.equivalentsRemoved;
	}
	
	public function setOptimizationMode(optimize:Boolean):Void {		
		this.equivalentsRemoved = optimize;
	}

	/**
	* @method AnimationCore.getOptimizationModes
	* @description 	static, returns the optimization mode. 
	* 				See AnimationCore.setOptimizationModes for more information.
	* @usage   <tt>AnimationCore.getOptimizationModes();</tt>
	* @return String that specifies the tween mode. Either AnimationCore.INTERVAL or AnimationCore.FRAMES.
	*/
	public static function getOptimizationModes(Void):Boolean {
		return AnimationCore.equivalentsRemoved_static;
	}

	/**
	* @method AnimationCore.setOptimizationModes
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
	* 				Note that each IAnimatable class offers an instance method named setOptimizationMode 
	* 				(without the "s") that allows you to remove parts only of the 
	* 				animation instance that don't change during the animation.
	* @usage   <pre>AnimationCore.setOptimizationModes(optimize);</pre>
	* @param optimize (Boolean)
	*/
	public static function setOptimizationModes(optimize:Boolean):Void {
		AnimationCore.equivalentsRemoved_static = optimize;
	}
	
	public function getTweenMode(Void):String {
		if(this.tweenMode == null) {
			return AnimationCore.tweenModes;
		} else {
			return this.tweenMode;
		}
	}
	
	public function setTweenMode(tweenMode:String):Boolean {
		if(tweenMode == AnimationCore.INTERVAL) {
			this.tweenMode = tweenMode;
			this.durationMode = AnimationCore.MS;
		} else if(tweenMode == AnimationCore.FRAMES) {
			this.tweenMode = tweenMode;
			this.durationMode = AnimationCore.FRAMES;
		} else {
			return false;
		}
		return true;
	}	
	
	/**
	* @method AnimationCore.getTweenModes
	* @description 	static, returns the current tween mode, which is applied 
	* . 			if no tween mode is specified to the instance.
	* 				Please check with AnimationCore.setTweenModes for more information.
	* @usage   <tt>AnimationCore.getTweenModes();</tt>
	* @return String that specifies the tween mode. Either AnimationCore.INTERVAL or AnimationCore.FRAMES.
	*/
	public static function getTweenModes(Void):String {
		return AnimationCore.tweenModes;
	}
	
	/**
	* @method AnimationCore.setTweenModes
	* @description 	static, sets the current tween mode, which is applied 
	* . 			if no tween mode is specified to the instance. The following 
	* 				example shall demonstrate how AnimationCore.setTweenModes 
	* 				works in combination with IAnimatable.setTweenMode available 
	* 				on each IAnimatable instance.
	* 			<p>
	* 			Example 1: Note that the default is tween mode INTERVAL and duration mode MS.
	* 			<blockquote><pre>
	*			//change globally to frame based tweening 
	*			AnimationCore.setTweenModes(AnimationCore.FRAMES);
	*			
	*			//tween in 100 frames
	*			var myScale:Scale = new Scale(mc,150,150); 
	*			myScale.animationStyle(100, Circ.easeInOut); 
	*			myScale.animate(0,100);
	*			
	*			//override global tween mode with INTERVAL tweening on the IAnimatable instance Move.
	*			var myMove:Move = new Move(mc2,mc2._x+100,mc2._y); 
	*			myMove.setTweenMode(AnimationCore.INTERVAL);
	*			myMove.animationStyle(1000, Circ.easeInOut); 
	*			myMove.animate(0,100);
	*			
	*			//use the global frame based tweening with a local duration mode
	*			var myRotation:Rotation = new Rotation(mc3,360); 
	*			myRotation.setDurationMode(AnimationCore.MS);
	*			myRotation.animationStyle(duration, Circ.easeInOut); 
	*			myRotation.animate(0,100);
	*			</pre></blockquote>  
	*			<p>
	* 			Also see AnimationCore.setDurationModes for more information.
	* @usage   <tt>AnimationCore.setTweenModes();</tt> 	
	* @param t (String) Either AnimationCore.INTERVAL for time-based tweening or AnimationCore.FRAMES for frame-based tweening.
	* @returns   <code>true</code> if setting tween mode was successful, 
	*                  <code>false</code> if not successful.
	*/
	public static function setTweenModes(t:String):Boolean {
		if(t == AnimationCore.INTERVAL) {
			AnimationCore.tweenModes = t;
			AnimationCore.durationModes = AnimationCore.MS;
		} else if(t == AnimationCore.FRAMES) {
			AnimationCore.tweenModes = t;
			AnimationCore.durationModes = AnimationCore.FRAMES;
		} else {
			return false;
		}
		return true;
	}
	
	public function getDurationMode(Void):String {
		if(this.durationMode == null) {
			return AnimationCore.durationModes;
		} else {
			return this.durationMode;
		}
	}
		
	public function setDurationMode(durationMode:String):Boolean {
		
		var isTweenModeFrames:Boolean = (this.getTweenMode() == AnimationCore.FRAMES);
		var isDurationModeValid:Boolean = (durationMode == AnimationCore.MS || durationMode == AnimationCore.FRAMES);
		
		if(isTweenModeFrames && isDurationModeValid) {
			this.durationMode = durationMode;
			return true;
		}
		return false;
	}	
	
	/**
	* @method AnimationCore.getDurationModes
	* @description 	static, returns the current duration mode, which is applied 
	* . 			if no tween mode is specified to the instance.
	* @usage   <tt>AnimationCore.getDurationModes();</tt>
	* @return String that specifies the duration mode. Either AnimationCore.MS or AnimationCore.FRAMES.
	*/
	public static function getDurationModes(Void):String {		
		return AnimationCore.durationModes;
	}
	
	/**
	* @method AnimationCore.setDurationModes
	* @description 	static, sets the current duration mode. Only useful in tween mode AnimationCore.FRAMES. Only then 
	* 				you can set the duration mode from AnimationCore.FRAMES, which is the default, to AnimationCore.MS. This allows you 
	* 				to control animations with milliseconds in tween mode AnimationCore.FRAMES. Please note that AnimationPackage 
	* 				internally still has to convert your specified milliseconds to frames. This is done by guessing 
	* 				the frame rate (fps = frames per second) of your movie. Therefore, controlling animations with milliseconds in tween mode 
	* 				AnimationCore.FRAMES might not be accurate. Since AnimationPackage calculates the fps as soon as you use it 
	* 				for the first time, the example animation below, will start in a one second delay, since this is the time 
	* 				AnimationPackage needs to calculate the fps. 
	* 				Please check with AnimationCore.setTweenModes for more information.
	* 				<p>
	* 				Example 1:
	* 				<blockquote><pre>
	*				AnimationCore.setTweenModes(AnimationCore.FRAMES);
	*				AnimationCore.setDurationModes(AnimationCore.MS);
	*				var myRotation:Rotation = new Rotation(mc);
	*				myRotation.animationStyle(1500,Sine.easeInOut);
	*				myRotation.run(360);
	*				</pre></blockquote>
	* 				With <tt>APCore.setFPS()</tt> you can also set the fps manually. In this case or if 
	* 				you have used any class of AnimationPackage earlier (at least one second), then no 
	* 				start up time is required. See APCore for more information 
	* 				about watching, unwatching, setting and getting your movie's frame rate (fps).
	* @usage   <tt>AnimationCore.setDurationModes();</tt> 	
	* @param d (String) Either AnimationCore.MS for milliseconds or AnimationCore.FRAMES.
	* @returns   <code>true</code> if setting duration mode was successful, 
	*                  <code>false</code> if not successful.
	*/
	public static function setDurationModes(d:String):Boolean {		
		
		var isTweenModeFrames:Boolean = (AnimationCore.tweenModes == AnimationCore.FRAMES);
		var isDurationModeValid:Boolean = (d == AnimationCore.MS || d == AnimationCore.FRAMES);
				
		if(isTweenModeFrames && isDurationModeValid) {
			AnimationCore.durationModes = d;
			return true;
		}
		return false;
	}
	
	
	/**
	* @method AnimationCore.getOverwriteModes
	* @description 	static, see AnimationCore.setOverwriteModes for more information.
	* @usage   <tt>AnimationCore.getOverwriteModes();</tt>
	* @return Boolean
	*/	
	public static function getOverwriteModes(Void):Boolean {
		return AnimationCore.overwriteModes;
	}	
	
	
	/**
	* @method AnimationCore.setOverwriteModes
	* @description 	static, Since version 1.07, AnimationPackage by default stops instances, 
	* 				which animate on the same property/method and object. 
	* 				This might come in handy i.e. if you want quickly create button animations as in: 				<p>
	* 				Example 1:
	* 				<blockquote><pre>			
	*				mc.onRollOver = function() {
	*					var myScale:Scale = new Scale(this,150,150);
	*					myScale.animationStyle(500, Circ.easeOut);
	*					myScale.animate(0,100);	
	*				}
	*				
	*				mc.onRollOut = function() {
	*					var myScale:Scale = new Scale(this,50,50);
	*					myScale.animationStyle(500, Circ.easeIn);
	*					myScale.animate(0,100);
	*				}
	*				</pre></blockquote>
	*				If one button event triggers a Scale instance and another Scale instance 
	* 				is still animating on the same properties of movieclip mc, 
	* 				the currently animating Scale instance will be stopped. Previously you had to do 
	* 				this yourself to prevent flickering, which requires to hold state of both 
	* 				Scale instances and invoke the stop() method yourself.
	* 				<p>
	* 
	* 				Example 2: One way to create a button animation on several movieclips
	* 				<blockquote><pre>		
	*				mc.onRollOver = coolMenuRollOver;
	*				mc2.onRollOver = coolMenuRollOver;
	*				mc3.onRollOver = coolMenuRollOver;
	*				mc.onRollOut = coolMenuRollOut;
	*				mc2.onRollOut = coolMenuRollOut;
	*				mc3.onRollOut = coolMenuRollOut;
	*				
	*				function coolMenuRollOver() {
	*					var myScale:Scale = new Scale(this,150,150);
	*					myScale.animationStyle(500, Circ.easeOut);
	*					myScale.animate(0,100);
	*				}
	*				
	*				function coolMenuRollOut() {
	*					var myScale:Scale = new Scale(this,50,50);
	*					myScale.animationStyle(500, Circ.easeIn);
	*					myScale.animate(0,100);
	*				}
	*				</pre></blockquote>
	* 
	* 				In case you don't want this behaviour, set AnimationCore.setOverwriteModes 
	* 				to false. The default is true.
	* @usage   <tt>AnimationCore.setOverwriteModes(overwriteModes);</tt> 	
	* @param overwriteModes (Boolean)
	*/
	public static function setOverwriteModes(overwriteModes:Boolean):Void {
		AnimationCore.overwriteModes = overwriteModes;
	}

	/**
	* @method AnimationCore.pauseAll
	* @description 	static, pauses all running animations whether locked or unlocked.
	* @usage   <tt>AnimationCore.pauseAll();</tt> 	  
	*/
	public static function pauseAll(Void):Void {
		//time based tweening.
		TimeTween.pauseAll();
		//frame based tweening.
		FrameTween.pauseAll();
	}
	
	/**
	* @method AnimationCore.resumeAll
	* @description 	static, resumes all running animations whether locked or unlocked. 
	* @usage   <tt>AnimationCore.resumeAll();</tt> 	  
	*/
	public static function resumeAll(Void):Void {		
		//time based tweening.
		TimeTween.resumeAll();
		//frame based tweening.
		FrameTween.resumeAll();
	}
	
	public function isTweening(Void):Boolean {		
		return this.tweening;
	}
	
	public function isPaused(Void):Boolean {
		return this.paused;
	}
	
	public function stop(Void):Boolean {
		if(this.locked == true || this.tweening == false) {
			this.paused = false;
			return false;
		} else {
			this.tweening = false;
			this.paused = false;
			this.myAnimator.stopMe();
			return true;
		}
	}	
	
	public function pause(duration:Number):Boolean {
		if(this.locked == true || this.tweening == false) {			
			return false;
		} else {			
			this.tweening = false;
			this.paused = true;
			this.myAnimator.paused = true;
			if(duration != null) {	
				if(this.myPause == null) {
					this.myPause = new Pause();
				} else {					
					this.myPause.stop();
				}
				if(this.getTweenMode() == AnimationCore.INTERVAL) {
					this.myPause.waitMS(duration, this, "resume");
				} else if(this.getTweenMode() == AnimationCore.FRAMES) {
					if(this.getDurationMode() == AnimationCore.MS) {
						duration = APCore.milliseconds2frames(duration);
					}
					this.myPause.waitFrames(duration, this, "resume");
				}
			}			
			this.myAnimator.pauseMe();
			return true;
		}
	}
	
	public function resume(Void):Boolean {		
		if(this.locked == true || this.myAnimator.paused == false) {
			return false;
		} else {		
			this.tweening = true;
			this.paused = false;
			this.myAnimator.paused = false;
			this.myAnimator.resumeMe();
			return true;
		}
	}	
	
	public function lock(Void):Void {		
		if(this.locked == false) {
			this.locked = true;
		}
	}
	
	public function unlock(Void):Void {		
		if(this.locked == true) {
			this.locked = false;
		}
	}

	public function toString(Void):String {
		return "AnimationCore";
	}
}
