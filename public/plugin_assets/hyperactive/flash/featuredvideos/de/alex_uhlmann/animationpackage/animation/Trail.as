import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.animation.Alpha;

/**
* @class Trail
* @author Alex Uhlmann
* @description  Simulates a trail effect on animated movieclips. Attaches the trail to a movieclip. 
* 			If null is specified the animation will be infinite.
* 			<p> 
* 			Example 1: <a href="Trail_attach_01.html">(Example .swf)</a> Attach a small trail to a back and forth moving movieclip. The trail will expire in 10 seconds.
* 			<blockquote><pre>			
*			mc._x = 150;
*			mc._y = 200;
*			var myMove:Move = new Move(mc);
*			myMove.animationStyle(2000,Expo.easeInOut,"onCallback");
*			myMove.run(500,mc._y);
*			new Trail(mc).attach(50,40,10000);
*			myListener.onCallback = function()
*			{
*				myMove.callback = "onCallback2";
*				myMove.run(150,mc._y);
*			}
*			myListener.onCallback2 = function()
*			{	
*				myMove.callback = "onCallback";	
*				myMove.run(500,mc._y);
*			}
*			</pre></blockquote>  			
* 			Example 2: <a href="Trail_attach_02.html">(Example .swf)</a> attaches a longer trail to a rotating movieclip. Note: if no duration property is 
* 			specified, the default duration property is used. The default property of duration is 1000. See AnimationCore.
* 			<blockquote><pre>	
* 			new Rotation(mc).run(360);
*			new Trail(mc).attach(250,40);
* 			</pre></blockquote>
* 			Take a look to MoveOnCurve for another example.
* 			<p>		
* 			There are two ways to use this class. One way is to specify 
* 			the duration property outside the current method, 
* 			either with setting the property directly 
* 			or with the animationStyle() method like it is used in 
* 			de.alex_uhlmann.animationpackage.drawing.
* 			<p>
*		
* @usage <tt>var myTrail:Trail = new Trail(mc);</tt> 
* @param mc (MovieClip) Movieclip to simulate a trail effect on.
*/
class de.alex_uhlmann.animationpackage.animation.Trail 
												extends AnimationCore {	
	
	/*animationStyle properties inherited from AnimationCore*/
	/** 
	* @property movieclip (MovieClip) Movieclip to simulate a trail effect on.
	* @property duration (Number) Duration of animation in milliseconds.
	*/
	private static var refs:Object;
	private var instancesArr:Array;
	private var startTime:Number;
	private var startPause:Number;
	private var durationPaused:Number = 0;
	private var elapsedDuration:Number = 0;
	private var paused:Boolean = false;
	private var stopped:Boolean = false;
	private var finished:Boolean = false;	
	private var interval_ID:Number;
	private var interval_ID2:Number;
	private var decay:Number;
	private var startAlpha:Number;
	private var durationOrig:Number;
	private var p:Array;
	private var v:Array;
	
	public function Trail(mc:MovieClip) {
		super();
		this.mc = mc;
		/*don't let the garbage collector delete the instance if invoked only via constructor. Save a reference.*/
		if(Trail.refs == null) {
			Trail.refs = new Object();
		}
		Trail.refs[this.getID()] = this;
	}	
	
	/**
	* @method attach
	* @description  		
	* @usage 	<pre>myTrail.attach(decay, startAlpha);</pre>
	*		<pre>myTrail.attach(decay, startAlpha, milliseconds);</pre>
	* 	  
	* @param decay (Number) fade out time in milliseconds or frames.
	* @param startAlpha (Number) the _alpha value the dublicated instances shall start to fade out.
	* @param milliseconds (Number) Duration of animation in milliseconds. If null is specified the animation will be infinite.
	* @return void
	*/
	/*It isn't possible to duplicate textfields and container mc's.*/
	public function attach(decay:Number, startAlpha:Number, 
						   milliseconds:Number):Void {
							   
		var paramLen:Number = 2;
		if (arguments.length > paramLen) {
			if(milliseconds !== null) {
				this.animationStyle(milliseconds);
			} else {
				this.duration = null;
			}
		} else {
			this.animationStyle();
		}
		this.tweening = true;
		this.finished = false;

		this.startTime = getTimer();	
		this.instancesArr = new Array();
		this.p = ["_rotation", "_xscale", "_yscale", "_x", "_y"];
		this.v = [this.mc._rotation, this.mc._xscale, this.mc._yscale, this.mc._x, this.mc._y];
		this.decay = decay;
		this.startAlpha = startAlpha;
		this.dispatchEvent.apply(this, [ {type:"onStart"} ]);
		
		this.interval_ID = setInterval(this, "run", 10, this.mc, decay, startAlpha, this.p, this.v);
		
		if(this.duration != null) {
			this.interval_ID2 = setInterval(this, "remove", this.duration);
		}		
		this.durationOrig = this.duration;
	}
	
	private function run():Void {
		
		var mc:MovieClip = arguments[0];
		var decay:Number = arguments[1];
		var startAlpha:Number = arguments[2];
		var p:Array = arguments[3];
		var v:Array = arguments[4];
		var i:Number = 5;
		while(--i>-1) {
			if (v[i] != mc[p[i]]) {		
				/*Flash Player 7 feature disabled*/
				//dp = loc_mc._parent.getNextHighestDepth();	
				var dp:Number = this.getNextDepth(mc._parent);				
				var targ:MovieClip = mc.duplicateMovieClip("apBlur"+dp+"_mc", dp);	
				targ._alpha = startAlpha;
				var myAlpha:Alpha = new Alpha(targ, 0, decay);
				this.instancesArr.push(myAlpha);
				myAlpha.addEventListener("onEnd", this);
				myAlpha.animate(0, 100);
				break;
			}
		}
		this.v = [mc._rotation, mc._xscale, mc._yscale, mc._x, mc._y];
		updateAfterEvent();
	}	
	
	/**
	* @method remove
	* @description 	offers the opportunity to remove an attached Trail. In particular, this might be 
	* 				useful if a trail is of infinite length (if null is specified for milliseconds).
	* @usage   <pre>myInstance.remove();</pre> 	  
	* @return void
	*/	
	public function remove(Void):Void {
		this.tweening = false;
		this.finished = true;		
		this.dispatchEvent.apply(this, [ {type:"onEnd", target:this} ]);
		clearInterval(this.interval_ID);
		clearInterval(this.interval_ID2);
		delete Trail.refs[this.getID()];
	}	
	
	public function onEnd(eventObj:Object):Void {		
		eventObj.target.movieclip.removeMovieClip();
		this.instancesArr.shift();
		delete eventObj.target;		
	}
	
	public function stop(Void):Boolean {		
		if(this.locked == false && this.tweening == true) {
			this.tweening = false;		
			this.stopped = true;
			this.elapsedDuration = this.computeElapsedDuration();
			var i:Number;
			var len:Number = this.instancesArr.length;		
			for (i=0; i<len; i++) {			
				this.instancesArr[i].stop();			
			}
			clearInterval(this.interval_ID);
			clearInterval(this.interval_ID2);
			return true;
		} else {
			return false;
		}
	}
		
	public function pause(duration:Number):Boolean {	
		if(this.locked == false && this.tweening == true) {
			this.tweening = false;
			this.paused = true;
			this.elapsedDuration = this.computeElapsedDuration();
			this.startPause = getTimer();
			var i:Number;
			var len:Number = this.instancesArr.length;			
			for (i=0; i<len; i++) {
				this.instancesArr[i].pause();
			}
			clearInterval(this.interval_ID);
			clearInterval(this.interval_ID2);
			return true;
		} else {
			return false;
		}
	}
	
	public function resume(Void):Boolean {		
		if(this.locked == false && this.paused == true) {
			this.tweening = true;
			this.paused = false;
			var i:Number;
			var len:Number = this.instancesArr.length;		
			for (i=0; i<len; i++) {
				this.instancesArr[i].resume();	
			}			
			this.durationPaused += getTimer() - this.startPause;
			this.interval_ID = setInterval(this, "run", 10, this.mc, this.decay, this.startAlpha, this.p, this.v);
			if(this.duration != null) {
				this.duration -= this.elapsedDuration;				
				this.interval_ID2 = setInterval(this, "remove", this.duration);				
			}
			return true;
		} else {
			return false;
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
			r = this.durationOrig - this.getDurationElapsed();
			if(r < 0) {
				r = 0;
			}
		} else {
			r = 0;
		}
		if(isNaN(r)) {			
			r = Infinity;
		} 
		return r;
	}
	
	private function computeElapsedDuration(Void):Number {
		if(this.finished == true) {
			return this.durationOrig;
		} else {		
			return getTimer() - this.startTime - this.durationPaused;			
		}
	}
	
	/*inherited from AnimationCore*/
	/**
	* @method animationStyle
	* @description 	set animation setting for animation.
	* 		
	* @usage   <pre>myTrail.animationStyle(milliseconds);</pre>
	* 	  
	* @param milliseconds (Number) Duration of animation in milliseconds.	
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
	* @usage   <pre>myTrail.addEventListener(event, listener);</pre>
	* 		    <pre>myTrail.addEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myTrail.removeEventListener(event, listener);</pre>
	* 		    <pre>myTrail.removeEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myTrail.removeAllEventListeners();</pre>
	* 		    <pre>myTrail.removeAllEventListeners(event);</pre>
	* 	  
	*@param event (String) Event to remove all subscribed listeners from. If not specified, all listeners to any event will be removed.
	*/
	
	/*inherited from APCore*/
	/**
	* @method eventListenerExists
	* @description 	GDispatcher specific feature. Checks if a listener is already subscribed to a certain event.
	* 		
	* @usage   <pre>myTrail.eventListenerExists(event, listener);</pre>
	* 			<pre>myTrail.eventListenerExists(event, listener, handler);</pre>
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
		return "Trail";
	}
}