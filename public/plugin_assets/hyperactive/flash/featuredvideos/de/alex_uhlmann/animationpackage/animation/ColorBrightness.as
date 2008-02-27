import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.IMultiAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.Animator;
import de.alex_uhlmann.animationpackage.utility.ColorFX;

/**
* @class ColorBrightness
* @author Alex Uhlmann
* @description Manipulates the brightness of a movieclip or a number of movieclips 
* 			with help of ColorFX class, 
* 			which extends the build-in Color class. Value range is like 
* 			the Flash IDE's property inspector.<p>		
* 			You can specify the duration, easing equation and callback properties 
* 			either with setting the properies directly or with the animationStyle() method 
* 			like it is used in de.alex_uhlmann.animationpackage.drawing.
* 			<p>
* 			Example 1:
* 			<blockquote><pre>			
*			var myColorBrightness:ColorBrightness = new ColorBrightness(mc);
*			myColorBrightness.animationStyle(3000,Quad.easeOut,"onCallback");
*			myColorBrightness.run(50);
*			</pre></blockquote>  			
* 			Example 2: The alternative way is shorter. The same like above in one line.
* 			<blockquote><pre>	
* 			new ColorBrightness(mc).run(50,3000,Quad.easeOut,"onCallback");
* 			</pre></blockquote>
* 			Example 3: You can also specify the properties via the constructor. 
* 			This might come in handy if you're using the Sequence or Parallel class.  
* 			Take a look at their class documentations for more information. 
* 			The animate() method and its start and end percentage parameters might also be useful. 
* 			<blockquote><pre>	
* 			var myColorBrightness:ColorBrightness = new ColorBrightness(mc,-50,1000,Circ.easeInOut,"onCallback");
* 			myColorBrightness.animate(0,100);
* 			</pre></blockquote>
* 			Example 4: By default, the start value of your animation is the current value. You can explicitly 
* 			define the start values either via the setStartValue or run method or via the constructor. Here is one 
* 			example for the constructor solution. This also might come in handy using composite classes, like 
* 			Sequence.
* 			<blockquote><pre>
* 			var myColorBrightness:ColorBrightness = new ColorBrightness(mc,[-100,100],3000,Quad.easeOut);
* 			myColorBrightness.run();
* 			</pre></blockquote>	
* 			<p>
* 			Example 5: Brighten up a movieclip to value 50 in 1 second using linear easing. 		
* 			<blockquote><pre>
*			new ColorBrightness(mc).run(50,1000);
*			</pre></blockquote>
* 			<p>
* 			Example 6: <a href="ColorBrightness_run_02.html">(Example .swf)</a> Brighten a movieclip to its minima and maxima in 4 seconds 
* 			using Sine easing. Note that I nullify the callback property, 
* 			which would call the onCallback method again.
* 			<blockquote><pre>			
*			var myColorBrightness:ColorBrightness = new ColorBrightness(mc);
*			myColorBrightness.animationStyle(2000,Sine.easeOut,"onCallback");
*			myColorBrightness.run(-100);
*			myListener.onCallback = function() {	
*				myColorBrightness.callback = null;
*				myColorBrightness.run(100);	
*			}
*			</pre></blockquote>
* 			Example 7: To animate many movieclips the same way, this class also accepts 
* 			an Array of movieclips instead of one movieclip. This way yields to a better performance than 
* 			creating a new class instance for each movieclip you want to animate. Different 
* 			start values of your movieclip properties are considered when animating multiple movieclips 
* 			within one animation instance.
* 			<blockquote><pre>
* 			var mcs:Array = new Array(mc1,mc2,mc3);
*			var myColorFX:ColorFX = new ColorFX(mc);
*			myColorFX.setBrightness(50);
*			
*			var myColorBrightness:ColorBrightness = new ColorBrightness(mcs);
*			myColorBrightness.animationStyle(2000,Sine.easeOut,"onCallback");
*			
*			myColorBrightness.run(-100);
*			myListener.onCallback = function() {	
*				myColorBrightness.callback = null;
*				myColorBrightness.run(100);	
*			}
* 			</pre></blockquote>
* 
* @usage 
* 		<pre>var myColorBrightness:ColorBrightness = new ColorBrightness(mc);</pre>
* 		<pre>var myColorBrightness:ColorBrightness = new ColorBrightness(mc, amount);</pre>
* 		<pre>var myColorBrightness:ColorBrightness = new ColorBrightness(mc, amount, duration);</pre>
*		<pre>var myColorBrightness:ColorBrightness = new ColorBrightness(mc, amount, duration, callback);</pre>
* 		<pre>var myColorBrightness:ColorBrightness = new ColorBrightness(mc, amount, duration, easing, callback);</pre>
*		<pre>var myColorBrightness:ColorBrightness = new ColorBrightness(mc, values);</pre> 
* 		<pre>var myColorBrightness:ColorBrightness = new ColorBrightness(mc, values, duration, callback);</pre> 
* 		<pre>var myColorBrightness:ColorBrightness = new ColorBrightness(mc, values, duration, easing, callback);</pre> 
* 		<pre>var myColorBrightness:ColorBrightness = new ColorBrightness(mcs);</pre>
* 		<pre>var myColorBrightness:ColorBrightness = new ColorBrightness(mcs, amount);</pre>
* 		<pre>var myColorBrightness:ColorBrightness = new ColorBrightness(mcs, amount, duration);</pre>
*		<pre>var myColorBrightness:ColorBrightness = new ColorBrightness(mcs, amount, duration, callback);</pre>
* 		<pre>var myColorBrightness:ColorBrightness = new ColorBrightness(mcs, amount, duration, easing, callback);</pre>
*		<pre>var myColorBrightness:ColorBrightness = new ColorBrightness(mcs, values);</pre> 
* 		<pre>var myColorBrightness:ColorBrightness = new ColorBrightness(mcs, values, duration, callback);</pre> 
* 		<pre>var myColorBrightness:ColorBrightness = new ColorBrightness(mcs, values, duration, easing, callback);</pre> 
* 
* @param mc (MovieClip) Movieclip to animate.
* @param mcs (Array) array of movieclips to animate.
* @param amount (Number) Targeted brigthness value (like in the Flash IDE's Effects panel) to animated to. 
* @param values (Array) optional start and end values.
* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
* @param callback (String) Function to invoke after animation 
*/
class de.alex_uhlmann.animationpackage.animation.ColorBrightness 
										extends AnimationCore 
										implements ISingleAnimatable,
													IMultiAnimatable {
	
	/*animationStyle properties inherited from AnimationCore*/
	/** 
	* @property movieclip (MovieClip) Movieclip to animate.
	* @property movieclips (Array) Array of Movieclips to animate.
	* @property duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @property easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @property callback (String) Function to invoke after animation. See AnimationCore class. 
	*/
	private var myColorFX:ColorFX;
	private var overwriteProperty:String = "movieclip";
	
	public function ColorBrightness() {
		super();
		if(typeof(arguments[0]) == "movieclip") {
			this.mc = arguments[0];
			this.myColorFX = new ColorFX(this.mc);
		} else {
			this.mcs = arguments[0];
			this.myColorFX = new ColorFX(this.mcs[0]);
		}	
		if(arguments.length > 1) {
			arguments.shift();
			this.init.apply(this, arguments);
		}
	}
	
	private function initAnimation(amount:Number, duration:Number, easing:Object, callback:String):Void {		
		if (arguments.length > 1) {			
			this.animationStyle(duration, easing, callback);
		} else {
			this.animationStyle(this.duration, this.easing, this.callback);
		}
		this.setStartValue(this.myColorFX.getBrightness(), true);
		this.setEndValue(amount);
	}
	
	private function invokeAnimation(start:Number, end:Number):Void {		
		this.startInitialized = false;
		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		this.myAnimator.end = [this.endValue];
		
		if(this.mc != null) {
			this.myAnimator.start = [this.startValue];
			this.myAnimator.setter = [[this.myColorFX,"setBrightness"]];
		} else {
			
			var myColorFXs:Array = [];
			var len:Number = this.mcs.length;	
			var i:Number = len;
			while(--i>-1) {
				myColorFXs[i] = new ColorFX(this.mcs[i]);
			}
			
			this.myAnimator.multiStart = ["getBrightness"];										
			this.myAnimator.multiSetter = [[myColorFXs,"setBrightness"]];			
		}

		if(end != null) {
			this.myAnimator.animationStyle(this.duration, this.easing, this.callback);
			this.myAnimator.animate(start, end);
		} else {
			this.myAnimator.goto(start);
		}
	}
	
	/**
	* @method run
	* @description 
	* 		
	* @usage    
	* 		<pre>myColorBrightness.run();</pre>
	* 		<pre>myColorBrightness.run(amount);</pre>
	* 		<pre>myColorBrightness.run(amount, duration);</pre>
	* 		<pre>myColorBrightness.run(amount, duration, callback);</pre>
	*		<pre>myColorBrightness.run(amount, duration, easing, callback);</pre>
	* 		<pre>myColorBrightness.run(values, duration);</pre>
	* 		<pre>myColorBrightness.run(values, duration, callback);</pre>
	*		<pre>myColorBrightness.run(values, duration, easing, callback);</pre>
	* 
	* @param amount (Number) Targeted brigthness value (like in the Flash IDE's Effects panel) to animated to. 
	* @param values (Array) optional start and end values.
	* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @param callback (String) Function to invoke after animation
	* @return void
	*/
	
	/**
	* @method animate
	* @description 	similar to the run() method. Offers start and end parameters.
	* @usage   <pre>myColorBrightness.animate(start, end);</pre> 	  
	* @param start (Number) start value. Percentage.
	* @param end (Number) end value. Percentage.
	* @return void
	*/
	
	/**
	* @method goto
	* @description 	jumps to a specific step of the animation and stays there.
	* @usage   <pre>instance.goto(percentage);</pre>
	* @param percentage (Number) Percentage value of the animation.
	* @return void
	*/	
	
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
	* @usage   <pre>myInstance.animationStyle(duration);</pre>
	* 		<pre>myInstance.animationStyle(duration, callback);</pre>
	* 		<pre>myInstance.animationStyle(duration, easing, callback);</pre>
	* 	  
	* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @param callback (String) Function to invoke after animation. See APCore class.
	*/
	
	/**
	* @method roundResult
	* @description 	rounds animation results to integers. (might be usefull for animating pixelfonts). Default is false.		
	* @usage   <pre>myInstance.roundResult(rounded);</pre>
	*@param rounded (Boolean) <code>true</code> rounds the result. Animates with integers. Less accuracy. <code>false</code> animates with floating point numbers.
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
	* @param duration (Number) optional property. Number of duration to pause before continuing animation.
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
	* @method setStartValue
	* @description 	sets the original, starting value of the current tween. 
	* @usage   <tt>myInstance.setStartValue(startValue);</tt>
	* @param startValue (Number)	
	* @return Boolean, indicates if the assignment was performed.
	*/	
	
	/**
	* @method getEndValue
	* @description 	returns the targeted value of the current tween. 
	* @usage   <tt>myInstance.getEndValue();</tt>
	* @return Number
	*/
	
	/**
	* @method setEndValue
	* @description 	sets the targeted value of the current tween. 
	* @usage   <tt>myInstance.setEndValue(endValue);</tt>
	* @param endValue (Number)	
	* @return Boolean, indicates if the assignment was performed.
	*/	

	/**
	* @method getCurrentValue
	* @description 	returns the current value of the current tween. 
	* @usage   <tt>myInstance.getCurrentValue();</tt>
	* @return Number
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
	*			<b>value</b> (Number) value to animate.<p>
	* 		
	* @usage   <pre>myColorBrightness.addEventListener(event, listener);</pre>
	* 		    <pre>myColorBrightness.addEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myColorBrightness.removeEventListener(event, listener);</pre>
	* 		    <pre>myColorBrightness.removeEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myColorBrightness.removeAllEventListeners();</pre>
	* 		    <pre>myColorBrightness.removeAllEventListeners(event);</pre>
	* 	  
	*@param event (String) Event to remove all subscribed listeners from. If not specified, all listeners to any event will be removed.
	*/
	
	/*inherited from APCore*/
	/**
	* @method eventListenerExists
	* @description 	GDispatcher specific feature. Checks if a listener is already subscribed to a certain event.
	* 		
	* @usage   <pre>myColorBrightness.eventListenerExists(event, listener);</pre>
	* 			<pre>myColorBrightness.eventListenerExists(event, listener, handler);</pre>
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
		return "ColorBrightness";
	}
}