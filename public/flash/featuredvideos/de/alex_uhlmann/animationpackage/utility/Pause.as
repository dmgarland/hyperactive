import de.alex_uhlmann.animationpackage.APCore;
import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.andre_michelle.events.FrameBasedInterval;
import de.andre_michelle.events.ImpulsDispatcher;

/**
* @class Pause
* @author Alex Uhlmann
* @description Take a break and do something afterwards. <p>		
* 			You can invoke any function if you specify the scope param. If you don't specify 
* 			it, then Pause will invoke the callback to all listeners of APCore.	
* 			If no listener was specified, Pause will invoke	the callback on itself. 
* 			Pause implements the IAnimatable interface and therefore can be used just 
* 			like any other IAnimatable class (i.e. in composite classes like Sequence or 
* 			with constructor initialization, animate and run methods). Nevertheless, 
* 			the examples below use the waitMS and waitFrames methods to pause with Pause.
* 			<p>
*			Use waitMS to wait a certain amount of time (in milliseconds)
* 			and call a function afterwards.
* 			<p>
* 			Example 1: subscribe a listener to all events from AnimationPackage (APCore), 
* 			and setup the onStart and onCallback functions. Use the Pause class 
* 			to wait one second and send the onStart event. Inside onStart 
* 			use Pause to wait again and send the onCallback event, 
* 			this time with two specified parameters. Inside onCallback, wait again. 
* 			Then, invoke a custom function (fooFunc) in _root scope. Send two parameters.
* 			<blockquote><pre>	
* 			APCore.initialize();
*			var myListener:Object = new Object();
*			APCore.addListener(myListener);
* 			new Pause().waitMS(1000,"onStart");
*			myListener.onStart = function() {	
*				trace("onStart "+arguments);
*				new Pause().waitMS(1000, "onCallback", ["foo", "bar"]);
*			}
*			
*			myListener.onCallback = function(source, params) {
*				trace("onCallback "+arguments);	
*				new Pause().waitMS(1000, _root, "fooFunc", ["foo", "bar"]);
*			}
*			
*			function fooFunc(bar:String, foo:String) {
*				trace("fooFunc "+arguments);
*			}
*			</pre></blockquote>	
* 			
*			Example 2: Do the same like above, just with frames. 
* 			Use waitFrames to wait a certain amount of time (in frames)
*			and call a function afterwards.
* 			<blockquote><pre>
* 			APCore.initialize();
*			var myListener:Object = new Object();
*			APCore.addListener(myListener);
*			new Pause().waitFrames(10,"onStart");
*			myListener.onStart = function() {	
*				trace("onStart "+arguments);
*				new Pause().waitFrames(10, "onCallback", ["foo", "bar"]);
*			}
*			myListener.onCallback = function(source, params) {
*				trace("onCallback "+arguments);	
*				new Pause().waitFrames(10, _root, "fooFunc", ["foo", "bar"]);
*			}
*			function fooFunc(bar:String, foo:String) {
*				trace("fooFunc "+arguments);
*			}
*			</pre></blockquote> 
* 
* 
* 
* @usage 
* 		<pre>var myPause:Pause = new Pause();</pre>
*		<pre>var myPause:Pause = new Pause(type, duration, callbackParam);</pre>
* 		<pre>var myPause:Pause = new Pause(type, duration, callbackParam, param);</pre>
*		<pre>var myPause:Pause = new Pause(type, duration, scope, callbackParam);</pre>
* 		<pre>var myPause:Pause = new Pause(type, duration, scope, callbackParam, param);</pre>
* @param type (String) Type of Pause. Either MS for time based pausing or FRAME for frame based pausing.
* @param duration (Number) The duration to be paused. 
* @param scope (Object) scope of callbackParam.
* @param callbackParam (String) Function to invoke after animation.
* @param param (Array) Parameters to send to callbackParam.
*/
class de.alex_uhlmann.animationpackage.utility.Pause 
										extends AnimationCore
										implements ISingleAnimatable {		
	
	
	/** 
	* @property duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	*/
	
	private static var refs:Object;
	private var type:String;
	private var scope:Object;
	private var param:Array;
	private var interval_ID:Object;
	private var pauseMode:String;
	private var startTime:Number;
	
	private var elapsedDuration:Number = 0;
	private var stopped:Boolean = false;
	private var finished:Boolean = false;
	private var startPause:Number;
	private var durationPaused:Number = 0;
	private var durationOrig:Number;
	//used for invoking an onUpdate event.
	private var elapsedDurationSaved:Number;
	
	public function Pause() {
		super();
		/*
		* don't let the garbage collector delete the instance 
		* if invoked only via constructor. Save a reference.
		*/
		if(Pause.refs == null) {
			Pause.refs = new Object();
		}
		Pause.refs[this.getID()] = this;
		
		if(arguments.length > 0) {			
			this.init.apply(this, arguments);
		}
	}
	
	private function init():Void {		
		
		if(arguments.length == 0) {
			return;
		}
		this.type = arguments[0];
		var duration:Number = arguments[1];
		var scope:Object = arguments[2];
		var callbackParam:Object = arguments[3];
		var param:Array = arguments[4];
		/*handles APCore call with and without parameters*/
		if(typeof(scope) == "string") {
			var temp = callbackParam;			
			param = temp;
			temp = scope;
			this.callback = temp;
			delete scope;	
		} else {
			this.scope = scope;
			var temp = callbackParam;			
			this.callback = temp;
			this.param = param;			
		}
		
		if(this.type == AnimationCore.MS) {				
			this.duration = this.durationOrig = duration;		
		} else if(this.type == AnimationCore.FRAMES) {				
			this.duration = this.durationOrig = Math.round(duration);		
		}
	}
	
	private function invokeAnimation(start:Number, end:Number):Void {		
		this.startInitialized = false;
		
		if(this.type == AnimationCore.MS) {				
			if(end != null) {
				start = start / 100 * this.duration;
				this.startTime = getTimer() + start;
				end = end / 100 * this.duration;
				this.duration = end;
				this.paused = false;				
				this.initMSInterval();
				ImpulsDispatcher.addImpulsListener(this, "dispatchUpdate");
			} else {
				start = start / 100 * this.duration;
				this.paused = true;
				this.elapsedDuration = start;
				this.dispatchUpdate();
			}			
			
		} else if(this.type == AnimationCore.FRAMES) {				
			if(end != null) {
				start = start / 100 * this.duration;
				this.startTime = FrameBasedInterval.frame + start;
				end = end / 100 * this.duration;
				this.duration = end;
				this.paused = false;				
				this.initFramesInterval();
				ImpulsDispatcher.addImpulsListener(this, "dispatchUpdate");
			} else {
				start = start / 100 * this.duration;
				this.paused = true;
				this.elapsedDuration = start;
				this.dispatchUpdate();
			}
		}
	}
	
	public function dispatchUpdate(Void):Void {
		var durationElapsed:Number = this.getDurationElapsed();
		if(this.elapsedDurationSaved != durationElapsed) {
			if(durationElapsed == 0) {
				this.dispatchEvent.apply(this, [ {type:"onStart"} ]);
			} else if(this.finished) {
				this.dispatchEvent.apply(this, [ {type:"onEnd"} ]);
			} else {
				this.dispatchEvent.apply(this, [ {type:"onUpdate"} ]);
			}
		}
		this.elapsedDurationSaved = durationElapsed;
	}
	
	/**
	* @method run
	* @description 	Rotates a movieclip from its the current _rotation property value 
	* 			to a specified amount in a specified time and easing equation.
	* 		
	* @usage   
	* 		<pre>myInstance.run();</pre>
	*		<pre>myInstance.(type, duration, callbackParam);</pre>
	* 		<pre>myInstance.(type, duration, callbackParam, param);</pre>
	*		<pre>myInstance.(type, duration, scope, callbackParam);</pre>
	* 		<pre>myInstance.(type, duration, scope, callbackParam, param);</pre>
	* 	  
	* @param type (String) Type of Pause. Either MS for time based pausing or FRAME for frame based pausing.
	* @param duration (Number) The duration to be paused. 
	* @param scope (Object) scope of callbackParam.
	* @param callbackParam (String) Function to invoke after animation.
	* @param param (Array) Parameters to send to callbackParam.
	* @return void
	*/
	
	/**
	* @method animate
	* @description 	similar to the run() method. Offers start and end parameters.
	* @usage   <pre>myInstance.animate(start, end);</pre> 	  
	* @param start (Number) start value. Percentage.
	* @param end (Number) end value. Percentage.
	* @return void
	*/
	
	/**
	* @method goto
	* @description 	jumps to a specific step of the animation and stays there.
	* @usage   <pre>myInstance.goto(percentage);</pre>
	* @param percentage (Number) Percentage value of the animation.
	* @return void
	*/	
	
	/**
	* @method waitMS
	* @description	
	* 		
	* @usage   <pre>myPause.waitMS(milliseconds, callbackParam);</pre>
	* 		<pre>myPause.waitMS(milliseconds, callbackParam, param);</pre>
	*		<pre>myPause.waitMS(milliseconds, scope, callbackParam);</pre>
	* 		<pre>myPause.waitMS(milliseconds, scope, callbackParam, param);</pre>
	* 	  
	* @param milliseconds (Number) milliseconds to wait
	* @param scope (Object) scope of callbackParam.
	* @param callbackParam (String) Function to invoke after animation.
	* @param param (Array) Parameters to send to callbackParam.
	* @return void
	*/
	public function waitMS(milliseconds:Number, scope:Object, 
							callbackParam:Object, param:Array):Void {
		this.init(AnimationCore.MS, 
					milliseconds, 
					scope, 
					callbackParam, 
					param);
					
		this.invokeAnimation(0,100);
	}
	
	private function initMSInterval(Void):Void {		
		this.pauseMode = "INTERVAL";		
		this.tweening = true;
		this.finished = false;
		clearInterval(Number(this.interval_ID));
		this.interval_ID = setInterval(this, "clearPause", this.duration);
		this.dispatchEvent.apply(this, [ {type:"onStart"} ]);
	}
	
	/**
	* @method waitFrames
	* @description
	* 		
	* @usage   <pre>myPause.waitFrames(milliseconds, callbackParam);</pre>
	* 		<pre>myPause.waitFrames(milliseconds, callbackParam, param);</pre>
	*		<pre>myPause.waitFrames(milliseconds, scope, callbackParam);</pre>
	* 		<pre>myPause.waitFrames(milliseconds, scope, callbackParam, param);</pre>
	* 	  
	* @param milliseconds (Number) milliseconds to wait
	* @param scope (Object) scope of callbackParam.
	* @param callbackParam (String) Function to invoke after animation.
	* @param param (Array) Parameters to send to callbackParam.
	* @return void
	*/
	public function waitFrames(frames:Number, scope:Object, 
								callbackParam:Object, param:Array):Void {
		this.init("FRAMES", 
					frames, 
					scope, 
					callbackParam, 
					param);
					
		this.invokeAnimation(0,100);
	}
	
	private function initFramesInterval(Void):Void {		
		this.pauseMode = "FRAMES";		
		this.tweening = true;
		this.finished = false;
		this.interval_ID = FrameBasedInterval.addInterval(this, 
													"clearPause", 
													this.duration);
		this.dispatchEvent.apply(this, [ {type:"onStart"} ]);	
	}
	
	private function clearPause(Void):Void {
		this.tweening = false;
		this.finished = true;		
		clearInterval(Number(this.interval_ID));
		FrameBasedInterval.removeInterval(this.interval_ID);
		this.switchCallback(this.scope, this.callback, this.param);
	}	
	
	private function switchCallback(scope:Object, 
									callback:String, 
									param:Array):Void {		
		if(scope == null) {			
			this.invokeAPCallback(callback, param);
		} else {
			this.invokeCallback(scope, callback, param);
		}
	}
	
	private function invokeAPCallback(callback:String, param:Array):Void {		
		if(param == null) {		
			APCore.broadcastMessage(callback, this);
			this.dispatchEvent.apply(this, [ {type:"onEnd"} ]);
		} else {				
			APCore.broadcastMessage(callback, this, param);
			this.dispatchEvent.apply(this, [ {type:"onEnd", parameters:param} ]);
		}
		delete Pause.refs[this.getID()];
	}
		
	private function invokeCallback(scope:Object, 
									callback:String, 
									param:Array):Void {		
		scope[callback].apply(scope, param);
		this.dispatchEvent.apply(this, [ {type:"onEnd", parameters:param} ]);
		delete Pause.refs[this.getID()];
		ImpulsDispatcher.removeImpulsListener(this);
	}
	
	public function stop(Void):Boolean {		
		if(super.stop() == true) {
			this.stopped = true;
			this.elapsedDuration = this.computeElapsedDuration();
			if(this.pauseMode == "INTERVAL") {				
				clearInterval(Number(this.interval_ID));
			} else if(this.pauseMode == "FRAMES") {				
				FrameBasedInterval.removeInterval(this.interval_ID);	
			}
			ImpulsDispatcher.removeImpulsListener(this);
			return true;
		} else {
			return false;
		}
	}
	
	/*
	* pause would be an illegal identifier, 
	* because Pause is the class and Flash Player 6 
	* cannot differ lower and upper cases at runtime.
	*/
	public function pauseMe(duration:Number):Boolean {
		if(super.pause(duration) == false) {			
			return false;
		}
		this.paused = true;
		this.elapsedDuration = this.computeElapsedDuration();	
		if(this.pauseMode == "INTERVAL") {
			this.startPause = getTimer();
			clearInterval(Number(this.interval_ID));
		} else if(this.pauseMode == "FRAMES") {			
			this.startPause = FrameBasedInterval.frame;
			FrameBasedInterval.removeInterval(this.interval_ID);	
		}
		ImpulsDispatcher.removeImpulsListener(this);
		return true;
	}
	
	public function resume(Void):Boolean {
		if(this.locked == true) {
			return false;
		} else {
			this.tweening = true;
			this.paused = false;
			this.duration -= this.elapsedDuration;
			if(this.getTweenMode() == AnimationCore.INTERVAL) {				
				this.durationPaused += getTimer() - this.startPause;
				this.initMSInterval();
			} else if(this.getTweenMode() == AnimationCore.FRAMES) {
				this.durationPaused += FrameBasedInterval.frame 
										- this.startPause;
				this.initFramesInterval();
			}
			ImpulsDispatcher.addImpulsListener(this, "dispatchUpdate");
			return true;
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
			if(this.getTweenMode() == AnimationCore.INTERVAL) {
				r = this.durationOrig - this.getDurationElapsed();
			} else if(this.getTweenMode() == AnimationCore.FRAMES) {
				if(this.getDurationMode() == AnimationCore.MS) {	
					r = this.durationOrig - this.getDurationElapsed();
					if(this.finished == true) {
						r = 0;
					}
				} else {
					r = this.durationOrig - this.getDurationElapsed();
				}
			}			
			if(r < 0) {
				r = 0;
			}
		} else {
			r = 0;
		}
		return r;
	}
	
	private function computeElapsedDuration(Void):Number {
		if(this.finished == true) {
			return this.durationOrig;
		} else {		
			if(this.getTweenMode() == AnimationCore.INTERVAL) {
				return getTimer() - this.startTime - this.durationPaused;
			} else if(this.getTweenMode() == AnimationCore.FRAMES) {
				if(this.getDurationMode() == AnimationCore.MS) {
					return APCore.fps * (FrameBasedInterval.frame - this.startTime - this.durationPaused);			
				} else {
					return FrameBasedInterval.frame - this.startTime - this.durationPaused;
				}		
			}
		}
	}
	
	public function getStartValue(Void):Number {		
		return 0;
	}	
	
	public function getEndValue(Void):Number {		
		return this.durationOrig;
	}	
	
	public function getCurrentValue(Void):Number {		
		return this.getDurationElapsed();
	}
	
	public function getCurrentPercentage(Void):Number {		
		return this.getDurationElapsed() / this.durationOrig * 100;
	}
	
	/**
	* @method stop
	* @description 	stops the animation if not locked..
	* @usage   <tt>myInstance.stop();</tt> 
	* @returns <code>true</code> if instance was successfully stopped. 
	*                  <code>false</code> if instance could not be stopped, because it was locked.
	*/	
	
	/**
	* @method pauseMe
	* @description 	pauses the animation if not locked. Call resume() to continue animation.
	* @usage   <tt>myInstance.pauseMe();</tt> 	  
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
	*			<b>onEnd</b>, broadcasted when animation ends.<p>
	* 			The even object returned, contains the following properties:<p>
	* 			<b>type</b> (String) event broadcasted.<br>
	*			<b>target</b> (Object) event source.<br>
	* 		
	* @usage   <pre>myPause.addEventListener(event, listener);</pre>
	* 		    <pre>myPause.addEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myPause.removeEventListener(event, listener);</pre>
	* 		    <pre>myPause.removeEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myPause.removeAllEventListeners();</pre>
	* 		    <pre>myPause.removeAllEventListeners(event);</pre>
	* 	  
	*@param event (String) Event to remove all subscribed listeners from. If not specified, all listeners to any event will be removed.
	*/
	
	/*inherited from APCore*/
	/**
	* @method eventListenerExists
	* @description 	GDispatcher specific feature. Checks if a listener is already subscribed to a certain event.
	* 		
	* @usage   <pre>myPause.eventListenerExists(event, listener);</pre>
	* 			<pre>myPause.eventListenerExists(event, listener, handler);</pre>
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
		return "Pause";
	}
}
