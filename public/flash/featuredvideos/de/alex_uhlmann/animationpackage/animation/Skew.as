import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.Animator;

/**
* @class Skew
* @author Alex Uhlmann
* @description  Skews a movieclip like in the Flash IDE's transform panel.<p>	
* 			You can specify the duration, easing equation and callback properties 
* 			either with setting the properies directly or with the animationStyle() method 
* 			like it is used in de.alex_uhlmann.animationpackage.drawing.
* 			<p>
* 			Example 1:
* 			<blockquote><pre>			
*			var mySkew:Skew = new Skew(mc.inner_mc);
*			mySkew.animationStyle(1000,Sine.easeInOut,"onCallback");
*			mySkew.skewHorizontal(30);
*			</pre></blockquote>  			
* 			Example 2: The alternative way is shorter. The same like above in one line.
* 			<blockquote><pre>	
* 			new Skew(mc.inner_mc).skewHorizontal(30,1000,Sine.easeInOut,"onCallback");
* 			</pre></blockquote>		
*  			Example 3: You can also specify the properties via the constructor. 
* 			This might come in handy if you're using the Sequence or Parallel class.  
* 			Take a look at their class documentations for more information. 
* 			The animate() method and its start and end percentage parameters might also be useful. 
* 			<blockquote><pre>
* 			var mySkew:Skew = new Skew(mc.inner_mc,"HORIZ",30,1000,Sine.easeInOut,"onCallback");
* 			mySkew.animate(0,100);
* 			</pre></blockquote>
* 			Example 4: By default, the start value of your animation is the current value. You can explicitly 
* 			define the start values either via the setStartValue or run method or via the constructor. Here is one 
* 			example for the constructor solution. This also might come in handy using composite classes, like 
* 			Sequence.
*			<blockquote><pre>
*			var mySkew:Skew = new Skew(mc.inner_mc,"HORIZ",[-30,30],2000,Sine.easeInOut);
*			mySkew.skewHorizontal();
* 			</pre></blockquote>	
* @usage <pre>var mySkew:Skew = new Skew(inner_mc);</pre>
* 		<pre>var mySkew:Skew = new Skew(inner_mc, type, degree);</pre>
* 		<pre>var mySkew:Skew = new Skew(inner_mc, type, degree, duration);</pre>
*		<pre>var mySkew:Skew = new Skew(inner_mc, type, degree, duration, callback);</pre>
* 		<pre>var mySkew:Skew = new Skew(inner_mc, type, degree, duration, easing, callback);</pre>
*		<pre>var mySkew:Skew = new Skew(inner_mc,type, values);</pre> 
* 		<pre>var mySkew:Skew = new Skew(inner_mc,type, values, duration, callback);</pre> 
* 		<pre>var mySkew:Skew = new Skew(inner_mc,type, values, duration, easing, callback);</pre> 
*  
* @param inner_mc (MovieClip) Movieclip to animate. Movieclip must have a parent clip.
* @param type (String) Type of skew. Choose between  HORIZ for horizontal skew or VERT for vertical skew.
* @param degree (Number) Targeted degree to skew to.
* @param values (Array) optional start and end values.
* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
* @param callback (String) Function to invoke after animation. See AnimationCore class.
*/
class de.alex_uhlmann.animationpackage.animation.Skew 
										extends AnimationCore 
										implements ISingleAnimatable {	
	
	/*animationStyle properties inherited from AnimationCore*/
	/** 
	* @property Skew.HORIZ (String)(static) Property that can be used to set the skew mode.
	* @property Skew.VERT (String)(static) Property that can be used to set the skew mode.
	* @property movieclip (MovieClip) Movieclip to animate. Movieclip must have a parent clip.
	* @property duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @property easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @property callback (String) Function to invoke after animation. See APCore class. 
	*/
	public static var HORIZ:String = "HORIZ";
	public static var VERT:String = "VERT";	
	private var outer_mc:MovieClip;
	private var type:String;
	private var skew:Number;
	
	public function Skew() {
		super();
		this.mc = arguments[0];
		this.outer_mc = this.mc._parent;
		if(arguments.length > 1) {
			arguments.shift();
			this.init.apply(this, arguments);
		}
	}
	
	private function init():Void {		
		if(arguments[1] instanceof Array) {				
			var values:Array = arguments[1];
			var endValue:Number = values.slice(-1)[0];				
			arguments.splice(1, 1, endValue);
			this.initAnimation.apply(this, arguments);				
			this.setStartValue(values[0]);				
		} else if(arguments.length > 1) {				
			this.initAnimation.apply(this, arguments);
		}
	}
	
	private function initAnimation(type:String, skew:Number, duration:Number, easing:Object, callback:String):Void {		
		if (arguments.length > 2) {			
			this.animationStyle(duration, easing, callback);
		} else {
			this.animationStyle(this.duration, this.easing, this.callback);
		}
		this.type = type;
		var skewKind:String = getFunctionStr(type);
		if (this.mc._rotation == 0) {
			this["set"+skewKind](0);
		}
		this.setStartValue(this["get"+skewKind](), true);		
		this.setEndValue(skew);
		this.skew = skew;
	}
	
	private function invokeAnimation(start:Number, end:Number):Void {		
		this.startInitialized = false;
		//determine kind of skew
		var skewKind:String = getFunctionStr(this.type);
		
		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		this.myAnimator.start = [this.startValue];
		this.myAnimator.end = [this.endValue];
		this.myAnimator.setter = [[this,"set"+skewKind]];	
		if(end != null) {			
			this.myAnimator.animationStyle(this.duration, this.easing, this.callback);
			this.myAnimator.animate(start, end);
		} else {
			this.myAnimator.goto(start);
		}
	}
	
	private function getFunctionStr(type:String):String {
		var skewKind:String;
		if(type == Skew.HORIZ) {			
			skewKind = "HorizontalSkew";
		} else if (type == Skew.VERT) {
			skewKind = "VerticalSkew";  
		}
		return skewKind;
	}	
	
	/**
	* @method skewHorizontal	 
	* @description 	Skews a movieclip horizontally from its current slope 
	* 			to a specified slope in a specified time and easing equation.
	* 			Note: only movieclips that are contained by another movieclip 
	* 			can be skewed.
	* 			<p>
	* 			Example 1: skew a movieclip 360 degrees horizontally in 1 second 
	* 			using linear easing. 		
	* 			<blockquote><pre>
	*			new Skew(mc.inner_mc).skewHorizontal(360,1000);
	*			</pre></blockquote>
	* 			<p>
	* 			Example 2: <a href="Skew_skewHorizontal_02.html">(Example .swf)</a> skews a movieclip 30 degrees horizontally first clockwise, 
	* 			then counterclockwise, and then back to normal. Each animation takes 1 
	* 			second using Sine easing.
	* 			<blockquote><pre>
	*			var mySkew:Skew = new Skew(mc.inner_mc);
	*			mySkew.skewHorizontal(30,1000,Sine.easeInOut,"onCallback");	
	*			myListener.onCallback = function() {		
	*				mySkew.skewHorizontal(-30,1000,Sine.easeInOut,"onCallback2");
	*			}
	*			myListener.onCallback2 = function() {		
	*				mySkew.skewHorizontal(0,1000,Sine.easeInOut);
	*			}
	*			</pre></blockquote>
	* 		
	* @usage   
	* 		<pre>mySkew.skewHorizontal();</pre>
	* 		<pre>mySkew.skewHorizontal(degree);</pre>
	* 		<pre>mySkew.skewHorizontal(degree, duration);</pre>
	*		<pre>mySkew.skewHorizontal(degree, duration, callback);</pre>
	* 		<pre>mySkew.skewHorizontal(degree, duration, easing, callback);</pre>
	* 		<pre>mySkew.skewHorizontal(values, duration);</pre>
	* 		<pre>mySkew.skewHorizontal(values, duration, callback);</pre>
	*		<pre>mySkew.skewHorizontal(values, duration, easing, callback);</pre>
	*  	  
	* @param degree (Number) Targeted degree to skew to.
	* @param values (Array) optional start and end values.
	* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @param callback (String) Function to invoke after animation. See APCore class.
	* @return void
	*/
	public function skewHorizontal(Void):Void {		
		this.type = Skew.HORIZ;
		arguments.unshift(this.type);		
		this.run.apply(this,arguments);
	}
		
	/**
	* @method skewVertical	 
	* @description 	Skews a movieclip vertically from its the current slope 
	* 			to a specified slope in a specified time and easing equation.
	* 			Note: only movieclips that are contained by another movieclip 
	* 			can be skewed.
	* 			<p>
	* 			Example 1: skew a movieclip 360 degrees vertically in 1 second 
	* 			using linear easing. 		
	* 			<blockquote><pre>
	*			new Skew(mc.inner_mc).skewVertical(360,1000);
	*			</pre></blockquote>
	* 			<p>
	* 			Example 2: <a href="Skew_skewVertical_02.html">(Example .swf)</a> skews a movieclip 30 degrees vertically first clockwise, 
	* 			then counterclockwise, and then back to normal. Each animation takes 1 
	* 			second using Sine easing.
	* 			<blockquote><pre>
	*			new Skew(mc.inner_mc).skewVertical(30,1000,Sine.easeInOut,"onCallback");	
	*			myListener.onCallback = function() {		
	*				new Skew(mc.inner_mc).skewVertical(-30,1000,Sine.easeInOut,"onCallback2");
	*			}
	*			myListener.onCallback2 = function() {		
	*				new Skew(mc.inner_mc).skewVertical(0,1000,Sine.easeInOut);
	*			}
	*			</pre></blockquote>
	* 		
	* @usage   
	* 		<pre>mySkew.skewVertical();</pre>
	* 		<pre>mySkew.skewVertical(degree);</pre>
	* 		<pre>mySkew.skewVertical(degree, duration);</pre>
	*		<pre>mySkew.skewVertical(degree, duration, callback);</pre>
	* 		<pre>mySkew.skewVertical(degree, duration, easing, callback);</pre>
	* 		<pre>mySkew.skewVertical(values, duration);</pre>
	* 		<pre>mySkew.skewVertical(values, duration, callback);</pre>
	*		<pre>mySkew.skewVertical(values, duration, easing, callback);</pre>
	*  	  
	* @param degree (Number) Targeted degree to skew to.
	* @param values (Array) optional start and end values.
	* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @param callback (String) Function to invoke after animation. See APCore class.
	* @return void
	*/
	public function skewVertical(Void):Void {		
		this.type = "VERT";
		arguments.unshift(this.type);
		this.run.apply(this,arguments);
	}	
	
	/**
	* @method animate
	* @description 	similar to the skewHorizontal() and skewVertical() methods. Offers start and end parameters.
	* @usage   <pre>mySkew.animate(start, end);</pre> 	  
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
	
	private function getHorizontalSkew(Void):Number {
		return this.getSkew();
	}	
	
	private function setHorizontalSkew(amount:Number):Void {		
		this.setSkew(amount, Skew.HORIZ);
	}	
	
	private function getVerticalSkew(Void):Number {
		return this.getSkew();
	}	
	
	private function setVerticalSkew(amount:Number):Void {
		this.setSkew(amount, Skew.VERT);
	}		
	
	private function getSkew(Void):Number {
		//CLUNKY
		var skew:Number;
		var mc:MovieClip = this.outer_mc;
		if(mc._rotation >= 0){
			skew = 2*(mc._rotation-45);
		}
		else{
			//skew = 2*(180+mc._rotation+180-45);
			skew = 2*(315+mc._rotation);		
		}
		return skew;
	}
	
	private function setSkew(amount:Number, type:String):Void {
		var h_skew:Number;
		var v_skew:Number;
		if(type == Skew.HORIZ) {
			h_skew = amount;
			v_skew = 0;	
		}
		else if (type == Skew.VERT) {
			h_skew = 0;
			v_skew = amount;			
		}
		var mc:MovieClip = this.outer_mc;
		var inner_mc:MovieClip = this.mc;
		var x0:Number = mc._x;
		var y0:Number = mc._y;
		var x_offset:Number = 0;
		var y_offset:Number = 0;				
		//nacho@yestoall.com (http://flashAPI.yestoall.com) and Andres Sebastian Yañez Duran (lifaros@yahoo.com)
		inner_mc._x = 0.5*Math.SQRT2*(-x_offset-y_offset);
		inner_mc._y = 0.5*Math.SQRT2*(x_offset-y_offset);
		inner_mc._rotation = -45;
		mc._rotation = 45+(h_skew+v_skew)/2;	
		mc._yscale = Math.sin((90+h_skew-v_skew)*0.5*(Math.PI/180))*Math.SQRT2*100;
		mc._xscale = Math.cos((90+h_skew-v_skew)*0.5*(Math.PI/180))*Math.SQRT2*100;
		mc._x = x0 + x_offset;
		mc._y = y0 + y_offset;
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
	* @description 	returns the original, starting value of the current tween. In degrees.
	* @usage   <tt>myInstance.getStartValue();</tt>
	* @return Number
	*/
	
	/**
	* @method setStartValue
	* @description 	sets the original, starting value of the current tween. In degrees.
	* @usage   <tt>myInstance.setStartValue(startValue);</tt>
	* @param startValue (Number)	
	* @return Boolean, indicates if the assignment was performed.
	*/	
	
	/**
	* @method getEndValue
	* @description 	returns the targeted value of the current tween. In degrees.
	* @usage   <tt>myInstance.getEndValue();</tt>
	* @return Number
	*/
	
	/**
	* @method setEndValue
	* @description 	sets the targeted value of the current tween. In degrees.
	* @usage   <tt>myInstance.setEndValue(endValue);</tt>
	* @param endValue (Number)	
	* @return Boolean, indicates if the assignment was performed.
	*/	

	/**
	* @method getCurrentValue
	* @description 	returns the current value of the current tween. In degrees.
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
	* @usage   <pre>mySkew.addEventListener(event, listener);</pre>
	* 		    <pre>mySkew.addEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>mySkew.removeEventListener(event, listener);</pre>
	* 		    <pre>mySkew.removeEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>mySkew.removeAllEventListeners();</pre>
	* 		    <pre>mySkew.removeAllEventListeners(event);</pre>
	* 	  
	*@param event (String) Event to remove all subscribed listeners from. If not specified, all listeners to any event will be removed.
	*/
	
	/*inherited from APCore*/
	/**
	* @method eventListenerExists
	* @description 	GDispatcher specific feature. Checks if a listener is already subscribed to a certain event.
	* 		
	* @usage   <pre>mySkew.eventListenerExists(event, listener);</pre>
	* 			<pre>mySkew.eventListenerExists(event, listener, handler);</pre>
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
		return "Skew";
	}
}