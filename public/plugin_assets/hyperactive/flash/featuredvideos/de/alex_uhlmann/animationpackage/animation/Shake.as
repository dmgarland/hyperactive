import de.alex_uhlmann.animationpackage.APCore;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.Pause;
/**
* @class Shake
* @description Shakes a movieclip with a specified power, optional specified rotation 
* 			in a specified time.
* 			<p>
* 			Example 1: shakes a movieclip 1 second with little power and without rotation. 		
* 			<blockquote><pre>
*			new Shake(mc).run(.1,2000);
*			</pre></blockquote>
* 			<p>
* 			Example 2: <a href="Shake_run_02.html">(Example .swf)</a> shakes a movieclip with a little more power and a little rotation
* 			2 seconds long. Then, shake it harder but without rotation. Both shake animations have a Trail effect attached.
* 			<blockquote><pre>			
* 			new Trail(mc).attach(250,40,4000);
*			new Shake(mc).run(.2,2000,2,"onCallback");	
*			myListener.onCallback = function() {	
*				new Shake(mc).run(.8,2000);
*			}
*			</pre></blockquote>		
* @usage <tt>var myShake:Shake = new Shake(mc);</tt> 
* @param mc (MovieClip) Movieclip to animate.
*/
class de.alex_uhlmann.animationpackage.animation.Shake 
											extends AnimationCore {	
	
	/*property inherited from AnimationCore*/
	/**
	* @property movieclip (MovieClip) Movieclip to animate.
	*/
	private var interval_ID:Number;
	private var interval_ID2:Number;
	private var rot:Number;
	private var loc_callback:String;
	private var milliseconds:Number;
	private var millisecondsOrig:Number;
	private var elapsedDuration:Number = 0;
	private var paused:Boolean = false;
	private var stopped:Boolean = false;
	private var finished:Boolean = false;
	private var startPause:Number;
	private var durationPaused:Number = 0;
	private var startTime:Number;
	private var power:Number;
	private var origin_x:Number;
	private var origin_y:Number;	
	private var origin_rot:Number;
	
	public function Shake(mc:MovieClip) {
		super();
		this.mc = mc;
	}
	
	/**
	* @method run
	* @description 	Shakes a movieclip with a specified power, optional specified rotation 
	* 			in a specified time.
	* 		
	* @usage   <pre>myShake.run(power, milliseconds, rot[, callback]);</pre>
	* 		<pre>myShake.run(power, milliseconds[, callback]);</pre>
	* 	  
	* @param power (Number) Power to shake mc. (0.1 for small shaking and maybe 1 for real shaking).
	* @param milliseconds (Number) Duration of shaking in milliseconds.
	* @param rot (Number) lets mc rotate while shaking. Optional.
	* @param callback (String) Function to invoke after animation. See APCore class.
	* @return void
	*/
	public function run():Void {
		
		var power:Number = arguments[0];
		var milliseconds:Number = arguments[1];
		var rot:Object = arguments[2];
		var callback:String = arguments[3];
		var temp;
		if (typeof(rot) == "string") {
			temp = rot;
			callback = temp;			
		} else if (typeof(rot) == "number") {
			temp = rot;
			this.rot = temp;
		}		
		this.loc_callback = callback;
		this.millisecondsOrig = this.milliseconds = milliseconds;		
		this.power = power;
		
		this.origin_x = this.mc._x;
		this.origin_y = this.mc._y;
		this.origin_rot = this.mc._rotation;
		this.dispatchEvent.apply(this, [ {type:"onStart"} ]);
		this.startTime = getTimer();
		this.initShakeInterval();
		this.initEndInterval();
	}
	
	private function initShakeInterval(Void):Void {		
		var parent:Object = this;
		var r1:Number, r2:Number;
		/*copy instance variables to local variables for the sake of performance.*/
		var mc_loc:MovieClip = this.mc;
		var power_loc:Number = this.power;
		var rot_loc:Number = this.rot;
		var origin_x_loc:Number = this.origin_x;
		var origin_y_loc:Number = this.origin_y;
		var origin_rot_loc:Number = this.origin_rot;
		this.tweening = true;
		this.finished = false;
		//shake it fast
		this.interval_ID = setInterval(function () {			
			//adapted from crazyl0rd @ EFnet
			r1 = (Math.round(Math.random()*10) < 5) ? -r1 : r1;
			r2 = (Math.round(Math.random()*10) < 5) ? -r2 : r2;		
			mc_loc._x = origin_x_loc+power_loc*r1;
			mc_loc._y = origin_y_loc+power_loc*r2;
		
			if (rot_loc != 0) 
				mc_loc._rotation = mc_loc._rotation-Math.random()*rot_loc+Math.random()*rot_loc;			
			updateAfterEvent();
		}, 10);
	}
	
	private function initEndInterval(Void):Void {
		var parent:Object = this;
		//enough shaking. Reset.
		this.interval_ID2 = setInterval(function () { 
			parent.tweening = false;
			parent.finished = true;
			parent.mc._x = parent.origin_x;
			parent.mc._y = parent.origin_y;
			parent.mc._rotation = parent.origin_rot;			
			clearInterval(parent.interval_ID);
			clearInterval(parent.interval_ID2);
			APCore.broadcastMessage(parent.loc_callback, parent);
			parent.dispatchEvent.apply(parent, [ {type:"onEnd", target:parent} ]);
		}, this.milliseconds);
	}
	
	public function stop(Void):Boolean {		
		if(super.stop() == true) {
			this.tweening = false;
			this.stopped = true;
			this.elapsedDuration = this.computeElapsedDuration();
			clearInterval(this.interval_ID);
			clearInterval(this.interval_ID2);	
			return true;
		} else {
			return false;
		}
	}
		
	public function pause(duration:Number):Boolean {		
		if(this.locked == true || this.tweening == false) {
			return false;
		} else {			
			this.tweening = false;
			this.paused = true;
			this.elapsedDuration = this.computeElapsedDuration();
			this.startPause = getTimer();
			if(duration != null) {
				var myPause:Pause = new Pause();				
				myPause.waitMS(duration, this, "resume");
			}
			clearInterval(this.interval_ID);
			clearInterval(this.interval_ID2);			
			return true;		
		}
	}
	
	public function resume(Void):Boolean {		
		if(this.locked == true || this.paused == false) {
			return false;
		} else {
			this.tweening = true;
			this.paused = false;
			this.milliseconds -= this.elapsedDuration;
			this.durationPaused += getTimer() - this.startPause;
			this.initShakeInterval();
			this.initEndInterval();
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
			r = this.millisecondsOrig - this.getDurationElapsed();
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
			return this.millisecondsOrig;
		} else {		
			return getTimer() - this.startTime - this.durationPaused;			
		}
	}	
	
	/*inherited from AnimationCore*/	
	
	/**
	* @method stop
	* @description 	stops the animation if not locked.
	* @usage   <tt>myInstance.stop();</tt> 
	* @returns <code>true</code> if instance was successfully stopped. 
	*                  <code>false</code> if instance could not be stopped, because it was locked.
	*/	
	
	/**
	* @method pause
	* @description 	pauses the animation if not locked. Call resume() to continue animation.
	* @usage   <tt>myInstance.pause();</tt> 	  
	* @param milliseconds (Number) optional property. Number of milliseconds to pause before continuing animation.
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
	* @description 	returns the elapsed time in milliseconds since the current tween started tweening.
	* @usage   <tt>myInstance.getDurationElapsed();</tt>
	* @return Number
	*/
	
	/**
	* @method getDurationRemaining
	* @description 	returns the remaining time in milliseconds since the current tween started tweening.
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
	* @usage   <pre>myShake.addEventListener(event, listener);</pre>
	* 		    <pre>myShake.addEventListener(event, listener, handler);</pre>
	* 	  
	*@param event (String) Event to subscribe listener to. GDispatcher specific feature allows to subscribe to all events from an event source if the string "ALL" is passed. 
	*@param listener (Object) The listener object to subscribe to the specified event.
	*@param handler (String) Optional. GDispatcher specific feature. The name of a function to call. This function will be called within the scope of the object specified in the second parameter.
	*/
	
	/**
	* @method removeEventListener
	* @description 	Removes a listener from a subscribed event.	
	* 		
	* @usage   <pre>myShake.removeEventListener(event, listener);</pre>
	* 		    <pre>myShake.removeEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myShake.removeAllEventListeners();</pre>
	* 		    <pre>myShake.removeAllEventListeners(event);</pre>
	* 	  
	*@param event (String) Event to remove all subscribed listeners from. If not specified, all listeners to any event will be removed.
	*/
	
	/*inherited from APCore*/
	/**
	* @method eventListenerExists
	* @description 	GDispatcher specific feature. Checks if a listener is already subscribed to a certain event.
	* 		
	* @usage   <pre>myShake.eventListenerExists(event, listener);</pre>
	* 			<pre>myShake.eventListenerExists(event, listener, handler);</pre>
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
		return "Shake";
	}
}