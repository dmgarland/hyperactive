import de.alex_uhlmann.animationpackage.APCore;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.Pause;
import de.andre_michelle.events.FrameBasedInterval;
import de.andre_michelle.events.ImpulsDispatcher;
import ascb.util.Proxy;

/**
* @class Blink
* @author Alex Uhlmann
* @description Let a movieclip blink.	<p>		
* @usage <tt>var myBlink:Blink = new Blink(mc);</tt> 
* @param mc (MovieClip) Movieclip to animate.
*/
class de.alex_uhlmann.animationpackage.animation.Blink 
										extends AnimationCore {	
	
	/*animationStyle properties inherited from AnimationCore*/
	/** 
	* @property movieclip (MovieClip) Movieclip to animate.	
	* @property duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @property callback (String) Function to invoke after animation. See APCore class. 
	*/	
	private var invisiblePause:Pause;
	private var visiblePause:Pause;
	private var blinkPause:Pause;
	private var blinkMeID:Number;
	private var endBlinkID:Number;	
	private var speed:Number;
	private var interval:Number;	
	private var startTime:Number;
	private var startPause:Number;
	private var durationPaused:Number = 0;
	private var elapsedDuration:Number = 0;
	private var paused:Boolean = false;
	private var stopped:Boolean = false;
	private var finished:Boolean = false;
	private var blinkMode:String = null;
	private var framesDur:Number;
	private var durationInFrames:Number;
	private var durationOrig:Number;
	
	public function Blink(mc:MovieClip) {
		super();
		this.animationStyle();
		this.mc = mc;
	}	
	
	/**
	* @method blinkInterval
	* @description 	Every interval, the movieclip will be invisible 
	* 				and visible again till speed expires. 
	* 				This process stops when duration of animationStyle expires.
	* 			<p>
	* 			Example 1: Every second the movieclip is 100 milliseconds invisible. Lasts for 10 seconds.
	* 			<blockquote><pre>
	* 			var myBlink:Blink = new Blink(mc);
	* 			myBlink.animationStyle(10000);
	* 			myBlink.blinkInterval(1000,100);
	*			</pre></blockquote>
	* 			
	* 		
	* @usage   <pre>myBlink.blinkInterval(interval);</pre>
	* 		<pre>myBlink.blinkInterval(interval, speed);</pre>
	* 	  
	* @param interval (Number) Every interval in millisecond or frames the movieclip is set to invisible.
	* @param speed (Number) Optional. How long shall the movieclip be invisible. Defaults to 10 milliseconds.
	* @return void
	*/	
	public function blinkInterval(interval:Number, speed:Number):Void {		
		this.initAnimation(interval, speed);				
	}
	
	/**
	* @method blinkTimes
	* @description 	Force the number of blinks in a specified time and optionally specify 
	* 				the time the movieclip will be invisible.
	* 			<p>
	* 			Example 1: <a href="Blink_blinkTimes_01.html">(Example .swf)</a> let a movieclip blink 10 times in 10 seconds. Each blink the movieclip will be invisible for 500 milliseconds.
	* 			<blockquote><pre>
	*			var myBlink:Blink = new Blink(mc);
	*			myBlink.animationStyle(10000);
	*			myBlink.blinkTimes(10, 50);
	*			</pre></blockquote>
	* 			
	* 		
	* @usage   <pre>myBlink.blinkTimes(interval);</pre>
	* 		<pre>myBlink.blinkTimes(interval, speed);</pre>
	* 	  
	* @param interval (Number) Times the movieclip will blink.
	* @param speed (Number) Optional. How long shall the movieclip be invisible. Defaults to 10 milliseconds.
	* @return void
	*/
	public function blinkTimes(blinkNum:Number, speed:Number):Void {		
		this.initAnimation(this.duration / (blinkNum + 1), speed);
	}
	
	/**
	* @method blinkFast
	* @description 	blinks a movieclip as fast as possible for a certain amount of time or frames. 
	* 				Uses the frame-based ImpulsDispatcher for maximum speed. High frame rates recommended.
	* 				Doesn't support durationMode MS in frame-based tweening. In general, where preciseness is 
	* 				an issue you shouldn't use durationMode MS in frame-based tweening.
	* 			<p>
	* 			Example 1: <a href="Blink_blinkFast_01.html">(Example .swf)</a>
	* 			let a movieclip blink as fast as possible for one second (default). Frame rate is 31.
	* 			<blockquote><pre>
	*			var myBlink:Blink = new Blink(mc);
	*			myBlink.blinkFast()
	*			</pre></blockquote>
	* @usage   <pre>myBlink.blinkFast(duration);</pre>
	* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	*/
	public function blinkFast(duration):Void {		
		if(duration != null)this.duration = duration;
		this.tweening = true;
		this.finished = false;		
		this.durationOrig = this.duration;
		ImpulsDispatcher.addImpulsListener(this, "blinkSwitch");
		this.blinkMode = "FAST";
		this.blinkPause = new Pause();		
		if(this.getTweenMode() == AnimationCore.INTERVAL) {
			this.startTime = getTimer();
			this.blinkPause.waitMS(this.duration, this, "endBlink");
		} else if(this.getTweenMode() == AnimationCore.FRAMES) {
			this.startTime = FrameBasedInterval.frame;
			this.blinkPause.waitFrames(this.duration, this, "endBlink");			
		}	
	}
	
	private function blinkSwitch(Void):Void {
		var mc:MovieClip = this.mc;
		if(mc._visible == true) {
			mc._visible = false;
		} else {
			mc._visible = true;
		}
	}
	
	private function initAnimation(interval:Number, speed:Number):Void {		
		this.speed = (speed == null) ? 10 : speed;
		this.interval = (interval == null) ? 1000 : interval;
		this.durationInFrames = APCore.milliseconds2frames(this.duration);
		this.durationOrig = this.duration;
		this.tweening = true;
		this.finished = false;
		this.dispatchEvent.apply(this, [ {type:"onStart"} ]);		
		if(this.blinkMode == null) {
			if(this.getTweenMode() == AnimationCore.INTERVAL) {				
				this.startTime = getTimer();
				this.blinkMode = AnimationCore.MS;
			} else if(this.getTweenMode() == AnimationCore.FRAMES) {				
				this.startTime = FrameBasedInterval.frame;
				this.visiblePause = new Pause();
				this.blinkMode = AnimationCore.FRAMES;		
			}				
		}
		this.invokeAnimation();
	}
	
	private function invokeAnimation(Void):Void {
		this.invisiblePause = new Pause();
		if(this.blinkMode == AnimationCore.MS) {			
			var blinkWithMS:Function = Proxy.create(this, this.blinkWithMS);
			var endBlink:Function = Proxy.create(this, this.endBlink);
			this.blinkMeID = setInterval(blinkWithMS, this.interval);
			this.endBlinkID = setInterval(endBlink, this.duration);				
			
		} else if(this.blinkMode == AnimationCore.FRAMES) {			
			this.framesDur = this.duration;
			if(this.getDurationMode() == AnimationCore.MS) {
				var fps:Number = APCore.getFPS();
				if(fps == 0) {
					APCore.calculateFPS();
					APCore.addListener(this);					
				} else {
					this.onFPSCalculated(fps);					
				}				
			} else if(this.getDurationMode() == AnimationCore.FRAMES) {
				this.invokeFrameAnimation();
			}
		}		
	}
	
	private function blinkWithMS(Void):Void {		
		this.setInvisible(this.mc);
		this.invisiblePause.waitMS(this.speed, this, "setVisible", [this.mc]);
		updateAfterEvent();
	}
	
	private function onFPSCalculated(fps:Number):Void {		
		/*calculate frames with fps.*/
		APCore.removeListener(this);
		this.framesDur = APCore.milliseconds2frames(this.duration);
		this.speed = APCore.milliseconds2frames(this.speed);
		this.interval = APCore.milliseconds2frames(this.interval);
		this.invokeFrameAnimation();
	}
	
	private function invokeFrameAnimation(Void):Void {
		this.visiblePause.waitFrames(this.interval, this, "blinkWithFrames");
		this.blinkPause = new Pause();
		this.blinkPause.waitFrames(this.framesDur, this, "endBlink");
	}	
	
	private function blinkWithFrames(Void):Void {		
		this.setInvisible(this.mc);
		this.invisiblePause.addEventListener("onEnd", this);
		this.invisiblePause.waitFrames(this.speed, this, "setVisible", [this.mc]);
	}
	
	public function onEnd(eventObj:Object):Void {			
		this.invisiblePause.removeEventListener("onEnd", this);
		this.visiblePause.waitFrames(this.interval, this, "blinkWithFrames");
	}
	
	private function setVisible(mc):Void {		
		mc._visible = true;
	}
	
	private function setInvisible(mc):Void {
		mc._visible = false;
	}
	
	private function endBlink(Void):Void {		
		this.tweening = false;
		this.finished = true;
		this.clearBlink();
		this.setVisible(this.mc);
		APCore.broadcastMessage(this.callback, this);			
		this.dispatchEvent.apply(this, [ {type:"onEnd"} ]);
	}
	
	private function clearBlink(Void):Void {		
		if(this.blinkMode == AnimationCore.MS) {
			clearInterval(this.blinkMeID);
			clearInterval(this.endBlinkID);
		} else if(this.blinkMode == AnimationCore.FRAMES) {
			this.invisiblePause.stop();
			this.visiblePause.stop();
		} else if(this.blinkMode == "FAST") {			
			ImpulsDispatcher.removeImpulsListener(this);			
		}
	}
	
	public function stop(Void):Boolean {		
		if(super.stop() == true) {			
			this.stopped = true;
			this.elapsedDuration = this.computeElapsedDuration();
			this.clearBlink();
			return true;
		} else {
			return false;
		}	
	}
		
	public function pause(duration:Number):Boolean {		
		if(super.pause(duration) == false) {
			return false;
		}
		this.tweening = false;
		this.paused = true;
		this.elapsedDuration = this.computeElapsedDuration();
		
		if(this.getTweenMode() == AnimationCore.INTERVAL) {				
			this.startPause = getTimer();
		} else if(this.getTweenMode() == AnimationCore.FRAMES) {				
			this.startPause = FrameBasedInterval.frame;
		}
		
		if(this.blinkMode == AnimationCore.MS) {			
			clearInterval(this.blinkMeID);
			clearInterval(this.endBlinkID);
		} else if(this.blinkMode == AnimationCore.FRAMES) {			
			this.invisiblePause.pauseMe();			
			this.visiblePause.pauseMe();
			this.blinkPause.pauseMe();			
		} else if(this.blinkMode == "FAST") {			
			this.blinkPause.pauseMe();
			ImpulsDispatcher.removeImpulsListener(this);
		}
		return true;	
	}
	
	public function resume(Void):Boolean {		
		if(this.locked == true || this.paused == false) {
			return false;
		} else {
			this.tweening = true;
			this.paused = false;
			this.duration -= this.elapsedDuration;			
			if(this.getTweenMode() == AnimationCore.INTERVAL) {				
				this.durationPaused += getTimer() - this.startPause;
			} else if(this.getTweenMode() == AnimationCore.FRAMES) {				
				this.durationPaused += FrameBasedInterval.frame - this.startPause;
			}		
			if(this.blinkMode == AnimationCore.MS) {				
				this.invokeAnimation();
			} else if(this.blinkMode == AnimationCore.FRAMES) {				
				this.invisiblePause.resume();			
				this.visiblePause.resume();
				this.blinkPause.resume();
			} else if(this.blinkMode == "FAST") {				
				this.blinkPause.resume();
				ImpulsDispatcher.addImpulsListener(this , "blinkSwitch");
			}
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
	
	/*inherited from AnimationCore*/
	/**
	* @method animationStyle
	* @description 	set the animation style properties for your animation.
	* 		
	* @usage   <pre>myBlink.animationStyle(duration);</pre>
	* 		<pre>myBlink.animationStyle(duration, callback);</pre>
	* 	  
	* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @param callback (String) Function to invoke after animation. See APCore class.
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
	* @usage   <pre>myBlink.addEventListener(event, listener);</pre>
	* 		    <pre>myBlink.addEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myBlink.removeEventListener(event, listener);</pre>
	* 		    <pre>myBlink.removeEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myBlink.removeAllEventListeners();</pre>
	* 		    <pre>myBlink.removeAllEventListeners(event);</pre>
	* 	  
	*@param event (String) Event to remove all subscribed listeners from. If not specified, all listeners to any event will be removed.
	*/
	
	/*inherited from APCore*/
	/**
	* @method eventListenerExists
	* @description 	GDispatcher specific feature. Checks if a listener is already subscribed to a certain event.
	* 		
	* @usage   <pre>myBlink.eventListenerExists(event, listener);</pre>
	* 			<pre>myBlink.eventListenerExists(event, listener, handler);</pre>
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
		return "Blink";
	}
}