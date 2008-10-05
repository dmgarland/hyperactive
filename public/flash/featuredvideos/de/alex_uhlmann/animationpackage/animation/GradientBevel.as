import de.alex_uhlmann.animationpackage.animation.IMultiAnimatable;
import de.alex_uhlmann.animationpackage.animation.Filter;
import flash.filters.BitmapFilter;
import flash.filters.GradientBevelFilter;

/**
* @class GradientBevel
* @author Alex Uhlmann
* @description  Manipulates the GradientBevelFilter of a movieclip 
* 			or a number of movieclips.
* 			<p>	Please look into the DropShadow HTML documentation to get an idea 
* 			how to use filter classes in AnimationPackage.
* 			<p>
* 			Example 1: <a href="GradientBevel_01.html">(Example .swf)</a>
* 			<blockquote><pre>
* 			import flash.filters.GradientBevelFilter;
*			
*			var filter:GradientBevelFilter = new GradientBevelFilter();
*			filter.colors = [0xFFFFFF, 0xFF0000, 0x000000];
*			filter.alphas = [1, 1, 1];
*			filter.ratios = [0, 128, 255];
*			filter.quality = 3; 
*			filter.type = "inner"; 
*			filter.knockout = true;
*			filter.distance = 5;
*			filter.angle = 225; 
*			filter.blurX = 8;
*			filter.blurY = 8; 
*			filter.strength = 2;
*			
*			var myGradientBevelIn:GradientBevel = new GradientBevel(mc,filter);
*			myGradientBevelIn.setOptimizationMode(true);
*			myGradientBevelIn.animationStyle(3000,Circ.easeOut);
*			myGradientBevelIn.animate(0,100);
* 			</pre></blockquote>
* 			<p>
*
* @usage      
* 			<pre>var myInstance:GradientBevel = new GradientBevel(mc);</pre> 
* 			<pre>var myInstance:GradientBevel = new GradientBevel(mc, filter, duration, callback);</pre> 
* 			<pre>var myInstance:GradientBevel = new GradientBevel(mc, filter, duration, easing, callback);</pre>
* 			<pre>var myInstance:GradientBevel = new GradientBevel(mc, filterIndex, filter, duration, callback);</pre> 
* 			<pre>var myInstance:GradientBevel = new GradientBevel(mc, filterIndex, filter, duration, easing, callback);</pre>
*			<pre>var myInstance:GradientBevel = new GradientBevel(mc, values);</pre> 
* 			<pre>var myInstance:GradientBevel = new GradientBevel(mc, values, duration, callback);</pre> 
* 			<pre>var myInstance:GradientBevel = new GradientBevel(mc, values, duration, easing, callback);</pre> 
*			<pre>var myInstance:GradientBevel = new GradientBevel(mc, filterIndex, values);</pre> 
* 			<pre>var myInstance:GradientBevel = new GradientBevel(mc, filterIndex, values, duration, callback);</pre> 
* 			<pre>var myInstance:GradientBevel = new GradientBevel(mc, filterIndex, values, duration, easing, callback);</pre> 
* 			<pre>var myInstance:GradientBevel = new GradientBevel(mcs);</pre> 
* 			<pre>var myInstance:GradientBevel = new GradientBevel(mcs, filter, duration, callback);</pre> 
* 			<pre>var myInstance:GradientBevel = new GradientBevel(mcs, filter, duration, easing, callback);</pre>
* 			<pre>var myInstance:GradientBevel = new GradientBevel(mcs, filterIndex, filter, duration, callback);</pre> 
* 			<pre>var myInstance:GradientBevel = new GradientBevel(mcs, filterIndex, filter, duration, easing, callback);</pre>
*			<pre>var myInstance:GradientBevel = new GradientBevel(mcs, values);</pre> 
* 			<pre>var myInstance:GradientBevel = new GradientBevel(mcs, values, duration, callback);</pre> 
* 			<pre>var myInstance:GradientBevel = new GradientBevel(mcs, values, duration, easing, callback);</pre> 
*			<pre>var myInstance:GradientBevel = new GradientBevel(mcs, filterIndex, values);</pre> 
* 			<pre>var myInstance:GradientBevel = new GradientBevel(mcs, filterIndex, values, duration, callback);</pre> 
* 			<pre>var myInstance:GradientBevel = new GradientBevel(mcs, filterIndex, values, duration, easing, callback);</pre> 
* @param mc (MovieClip) Movieclip to animate.
* @param mcs (Array) array of movieclips to animate.
* @param filterIndex (Number) position of the element in the Movieclip's filter property that shall be manipulated.
* @param filter (GradientBevelFilter) Targeted GradientBevelFilter object to animate to.
* @param values (Array) optional start and end values.
* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
* @param callback (String) Function to invoke after animation. See AnimationCore class.
*/
class de.alex_uhlmann.animationpackage.animation.GradientBevel 
											extends Filter 
											implements IMultiAnimatable {
	
	/*animationStyle properties inherited from AnimationCore*/
	/**
	* @property filterIndex (Number)
	* @property filters (Array)
	* @property colors (Array) 
	* @property alphas (Array)
	* @property ratios (Array)
	* @property quality (Number)
	* @property type (String)
	* @property knockout (Boolean)
	* @property movieclip (MovieClip) Movieclip to animate.
	* @property movieclips (Array) Array of Movieclips to animate.
	* @property duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @property easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @property callback (String) Function to invoke after animation. See AnimationCore class. 
	*/
	public var filter:GradientBevelFilter;
	private var m_colors:Array = [0xFFFFFF, 0x000000, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF];
	private var m_alphas:Array = [0, 100, 0, 100, 0];
	private var m_ratios:Array = [0, 64, 128, 192, 255];
	private var m_quality:Number = 1;
	private var m_type:String = "inner";
	private var m_knockout:Boolean = false;

	public function GradientBevel() {
		if(typeof(arguments[0]) == "movieclip") {
			this.mc = arguments[0];
		} else {
			this.mcs = arguments[0];
		}
		arguments.shift();
		this.init.apply(this, arguments);
	}

	public function setStartValues(startValues:Array, optional:Boolean):Boolean {
		this.hasStartValues = optional ? false : true;
		
		if(startValues[0] == null) {
			startValues[0] = createEmptyFilter();
		}
		if(startValues[0] instanceof GradientBevelFilter) {			
			var filter:GradientBevelFilter = startValues[0];
			
			if(this.hasStartValues) {
				this.setNonAnimatedProperties(filter);
			}
			
			return super.setStartValues([filter.distance, filter.angle, 
										filter.blurX, filter.blurY, 
										filter.strength], optional);			
		} else {
			return super.setStartValues(startValues, optional);
		}
	}
	
	public function setEndValues(endValues:Array):Boolean {
		
		if(endValues[0] == null) {
			endValues[0] = createEmptyFilter();
		}
		if(endValues[0] instanceof GradientBevelFilter) {
			
			var filter:GradientBevelFilter = endValues[0];
			this.setNonAnimatedProperties(filter);
			
			return super.setEndValues([filter.distance, filter.angle, 
										filter.blurX, filter.blurY, 
										filter.strength]);		
		} else {
			return super.setEndValues(endValues);
		}

	}
	
	private function initAnimation(filterIndex:Number, filterEnd:GradientBevelFilter, 
							duration:Number, easing:Object, callback:String):Void {

		if(arguments.length > 2) {
			this.animationStyle(duration, easing, callback);
		} else {			
			this.animationStyle(this.duration, this.easing, this.callback);
		}	
		
		this.initializeFilter(filterIndex, filterEnd);
		
		this.setStartValues([this.filter], true);
		this.setEndValues([filterEnd]);
	}
	
	private function initializeFilter(filterIndex:Number, filterEnd:GradientBevelFilter):Void {		
		if(this.mc != null) {	
			
			if(filterIndex == null) {				
				
				this.filter = this.createEmptyFilter();
				this.addFilter(this.filter);
				
			} else {			
				
				//if no filter of correct type is found at filterIndex, 
				//a new filter will be created.
				this.modifyOrCreateFilter(filterIndex);
			}
			
		} else {
			
			this.filterIndex = filterIndex;
			this.filter = filterEnd;
			
		}
	}	
	
	private function modifyOrCreateFilter(filterIndex:Number):Void {		
		this.filter = GradientBevelFilter(this.findFilter(filterIndex));
		this.filters = this.mc.filters;
		this.filterIndex = filterIndex;
	}

	private function isFilterOfCorrectType(filter:BitmapFilter):Boolean {
		return (filter instanceof GradientBevelFilter == true);
	}
	
	private function createEmptyFilter(Void):GradientBevelFilter {
		var filter:GradientBevelFilter = new GradientBevelFilter();
		filter.distance = 0;
		filter.angle = 0;
		filter.blurX = 0;
		filter.blurY = 0;
		filter.strength = 0;
		return filter;
	}
	
	private function initSingleMC(Void):Void {
		this.myAnimator.start = this.startValues;
		
		if(this.getOptimizationMode() 
			&& this.myAnimator.hasEquivalents()) {
				
			this.myAnimator.setter = [[this,"setDistance"],
								[this,"setAngle"],
								[this,"setBlurX"],
								[this,"setBlurY"],
								[this,"setStrength"]];							
		} else {				
			this.myAnimator.setter = [[this,"setGradientBevel"]];	
		}
	}
	
	private function initMultiMC(Void):Void {
		var myInstances:Array = [];			
		var len:Number = this.mcs.length;
		var mcs:Array = this.mcs;
		var i:Number = len;
		while(--i>-1) {
			myInstances[i] = new GradientBevel(mcs[i],this.filterIndex,this.filter);			
			var filter:GradientBevelFilter = this.updateFilter(createEmptyFilter());
			myInstances[i].setNonAnimatedProperties(filter);
		}
		this.myInstances = myInstances;

		this.myAnimator.multiStart = ["getMultiDistanceValue","getMultiAngleValue",
									"getMultiBlurXValue","getMultiBlurYValue",
									"getMultiStrengthValue"];
									
		this.myAnimator.multiSetter = [[this.myInstances,"setDistance"],
									[this.myInstances,"setAngle"],
									[this.myInstances,"setBlurX"],
									[this.myInstances,"setBlurY"],
									[this.myInstances,"setStrength"]];	

	}
	
	private function updateFilter(filter:GradientBevelFilter):GradientBevelFilter {		
		filter.colors = this.m_colors;
		filter.alphas = this.m_alphas;
		filter.ratios = this.m_ratios;
		filter.quality = this.m_quality;
		filter.type = this.m_type;
		filter.knockout = this.m_knockout;	
		return filter;
	}
	
	private function updateProperties(filter:BitmapFilter):Void {
		this.filter = updateFilter(GradientBevelFilter(filter));
		this.setStartValues([this.filter], true);		
	}

	private function setNonAnimatedProperties(filter:GradientBevelFilter):Void {
		this.colors = filter.colors;
		this.alphas = filter.alphas;
		this.ratios = filter.ratios;
		this.quality = filter.quality;
		this.type = filter.type;
		this.knockout = filter.knockout;		
	}	
	
	public function getMultiDistanceValue(Void):Number {
		return this.filter.distance;
	}	
	
	public function getMultiAngleValue(Void):Number {
		return this.filter.angle;
	}
	
	public function getMultiBlurXValue(Void):Number {
		return this.filter.blurX;
	}
	
	public function getMultiBlurYValue(Void):Number {
		return this.filter.blurY;
	}
	
	public function getMultiStrengthValue(Void):Number {
		return this.filter.strength;
	}	
		
	public function setGradientBevel(distance:Number, angle:Number, 
							blurX:Number, blurY:Number, 
							strength:Number):Void {

		this.filter.distance = distance;
		this.filter.angle = angle;
		this.filter.blurX = blurX;
		this.filter.blurY = blurY;
		this.filter.strength = strength;
		this.filters[this.filterIndex] = this.filter;
		this.mc.filters = this.filters;
	}

	public function setDistance(distance:Number):Void {		
		this.filter.distance = distance;		
		this.filters[this.filterIndex] = this.filter;
		this.mc.filters = this.filters;
	}	

	public function setAngle(angle:Number):Void {		
		this.filter.angle = angle;
		this.filters[this.filterIndex] = this.filter;
		this.mc.filters = this.filters;
	}	

	public function setBlurX(blurX:Number):Void {		
		this.filter.blurX = blurX;
		this.filters[this.filterIndex] = this.filter;
		this.mc.filters = this.filters;
	}
	
	public function setBlurY(blurY:Number):Void {		
		this.filter.blurY = blurY;		
		this.filters[this.filterIndex] = this.filter;
		this.mc.filters = this.filters;
	}
	
	public function setStrength(strength:Number):Void {		
		this.filter.strength = strength;		
		this.filters[this.filterIndex] = this.filter;
		this.mc.filters = this.filters;
	}
	
	public function get colors():Array {
		return this.m_colors;
	}
	
	public function set colors(colors:Array):Void {
		this.filter.colors = colors;
		this.m_colors = colors;
	}
	
	public function get alphas():Array {
		return this.m_alphas;
	}
	
	public function set alphas(alphas:Array):Void {
		this.filter.alphas = alphas;
		this.m_alphas = alphas;
	}
	
	public function get ratios():Array {
		return this.m_ratios;
	}
	
	public function set ratios(ratios:Array):Void {
		this.filter.ratios = ratios;
		this.m_ratios = ratios;
	}	
	
	public function get quality():Number {
		return this.m_quality;
	}
	
	public function set quality(quality:Number):Void {
		this.filter.quality = quality;
		this.m_quality = quality;
	}
	
	public function get type():String {
		return this.m_type;
	}
	
	public function set type(type:String):Void {
		this.filter.type = type;
		this.m_type = type;
	}
	
	public function get knockout():Boolean {
		return this.m_knockout;
	}
	
	public function set knockout(knockout:Boolean):Void {
		this.filter.knockout = knockout;
		this.m_knockout = knockout;
	}
	
	/*inherited from AnimationCore*/
	
	/**
	* @method run
	* @description  		
	* @usage   
	* 
	* 		the same overloading applies to this method as described in the 
	* 		constructor. Just without the mc and mcs parameters.
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
	* @usage   <pre>myInstance.addEventListener(event, listener);</pre>
	* 		    <pre>myInstance.addEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myInstance.removeEventListener(event, listener);</pre>
	* 		    <pre>myInstance.removeEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myInstance.removeAllEventListeners();</pre>
	* 		    <pre>myInstance.removeAllEventListeners(event);</pre>
	* 	  
	*@param event (String) Event to remove all subscribed listeners from. If not specified, all listeners to any event will be removed.
	*/
	
	/*inherited from APCore*/
	/**
	* @method eventListenerExists
	* @description 	GDispatcher specific feature. Checks if a listener is already subscribed to a certain event.
	* 		
	* @usage   <pre>myInstance.eventListenerExists(event, listener);</pre>
	* 			<pre>myInstance.eventListenerExists(event, listener, handler);</pre>
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
		return "GradientBevel";
	}
}