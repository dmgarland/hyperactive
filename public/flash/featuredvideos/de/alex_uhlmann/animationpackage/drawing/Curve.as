import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.MoveOnCurve;
import de.alex_uhlmann.animationpackage.drawing.IDrawable;
import de.alex_uhlmann.animationpackage.drawing.Shape;
import de.alex_uhlmann.animationpackage.utility.Animator;

/**
* @class Curve
* @author Alex Uhlmann, Steve Schwarz
* @description Curve is a class for drawing bezier curves with n controlpoints. With Curve 
* 			you can create bezier curves with an arbitrary length. The start and end points are the points 
* 			on the curve. In contrary to i.e. QuadCurve the Curve class by default 
* 			uses control points instead of points on the curve between the start and end points (anchor points).<p>
* 			If you specify a movieclip as first parameter, the shape will be drawn inside this movieclip. 
* 			If you omit the mc parameter, the class will create a new movieclip in _root.apContainer_mc by default.
* 			<p>
* 			Take a look into MoveOnCurve for a more comprehensive example.
* 			Example 1: draw a quadratic bezier curve.
* 			<blockquote><pre>
*			var points:Array = new Array();
*			points.push({x:0, y:0});
*			points.push({x:275, y:200});
*			points.push({x:550, y:0});
*			
*			var myCurve:Curve = new Curve(points);
*			myCurve.draw();
*			</pre></blockquote>
* 			Example 2: draw an animated quadratic bezier curve with custom parameters, that 
* 			continues to animated to full size and back.
* 			<blockquote><pre>
*			var points:Array = new Array();
*			points.push({x:0, y:0});
*			points.push({x:275, y:200});
*			points.push({x:550, y:0});
* 			
* 			var myCurve:Curve = new Curve(points);
*			myCurve.lineStyle(10,0xff0000,50);
*			myCurve.animationStyle(2000,Circ.easeInOut,"onCallback");
*			myCurve.animate(0, 100);
*			myListener.onCallback = function(source, value)
*			{	
*				if(value == 100) {
*					source.animate(100, 0);
*				} else {
*					source.animate(0, 100);
*				}	
*			}
*			</pre></blockquote>	
* @usage <pre>var myCurve:Curve = new Curve();</pre> 
* 		<pre>var myCurve:Curve = new Curve(points);</pre> 
* 		<pre>var myCurve:Curve = new Curve(mc, points);</pre>
* @param mc (MovieClip) existing movieclip to draw in.
* @param points (Array) Array of objects with x and y properties that define the curve.
*/
class de.alex_uhlmann.animationpackage.drawing.Curve 
											extends Shape 
											implements IDrawable, 
													ISingleAnimatable {	
	
	/*static default properties*/
	/*lineStyle properties inherited from Shape*/	
	/*animationStyle properties inherited from APCore*/	
	/**
	* @property movieclip (MovieClip)(read only) Movieclip that contains the drawing.
	* @property lineThickness (Number) Outline thickness.
	* @property lineRGB (Number) Outline color of the drawing as hex number.
	* @property lineAlpha (Number) Outline transparency (alpha).	
	* @property duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @property easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @property callback (String) Function to invoke after animation. See APCore class. 
	*/	
	private var mc:MovieClip;
	private var points:Array;
	private var myPoints:Array;
	/*points already calculated by getPointsOnCurve*/
	private var calculatedPoints:Array;
	private var myMoveOnCurve:MoveOnCurve;
	private var x1:Number;
	private var y1:Number;
	private var mode:String = "REDRAW";

	public function Curve() {
		super();
		this.init.apply(this,arguments);
		this.lineStyle(null);
		this.animationStyle();
	}

	private function init():Void {		
		if(typeof(arguments[0]) == "movieclip") {					
			this.initCustom.apply(this,arguments);
		} else {			
			this.initAuto.apply(this,arguments);
		}			
	}

	private function initCustom(mc:MovieClip, points:Array):Void {		
		
		this.mc = this.createClip({mc:mc, x:0, y:0});		
		this.initShape.apply(this,arguments.slice(1));
	}

	private function initAuto(points:Array):Void {		
		
		this.mc = this.createClip({name:"apDraw", x:0, y:0});		
		this.initShape.apply(this,arguments);
	}
		
	private function initShape(points:Array):Void {
		
		this.points = points;
		var i:Number = this.points.length;		
		this.myPoints = new Array();
		while(--i>-1) {
			//Copy array by value.			
			this.myPoints[i] = {x: this.points[i].x, y: this.points[i].y};
		}
	}
	
	/*inherited from Shape*/
	/**
	* @method draw
	* @description 	Draws the curve.
	* @usage <pre>myInstance.draw();</pre>
	*/
	public function draw(Void):Void {
		this.setDefaultRegistrationPoint({position:"CENTER"});
		this.clearDrawing();
		this.mode = "REDRAW";
		this.goto(100);
	}
	
	/**
	* @method drawBy
	* @description 	Draws the shape without clearing the movieclip.
	* @usage <pre>myInstance.drawBy();</pre>
	*/
	//TODO: include a *real* drawBy method. ( ;
	public function drawBy(Void):Void {
		this.mode = "DRAW";
		this.goto(100);
	}
	
	private function invokeAnimation(start:Number, end:Number):Void {
		
		var goto:Boolean;
		if(end == null) {
			goto = true;
			end = start;
			start = 0;			
		} else {
			goto = false;
		}
		var setter:String;	
		if(this.mode == "REDRAW") {
			this.setDefaultRegistrationPoint({position:"CENTER"});
			setter = "drawLineCurve";
		} else {
			if(this.lineStyleModified) {
				this.mc.lineStyle(this.lineThickness, this.lineRGB, this.lineAlpha);
			}
			setter = "drawLineCurveBy";
		}
		this.startValue = 0;
		this.endValue = 100;		
		/*how to continuesly draw a curve. Ask MoveOnCurve.*/
		this.myMoveOnCurve = new MoveOnCurve(null, this.myPoints);		
		this.x1 = this.myPoints[0].x;
		this.y1 = this.myPoints[0].y;			
		
		this.calculatedPoints = new Array();

		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		this.myAnimator.start = [0];
		this.myAnimator.end = [100];
		this.myAnimator.setter = [[this, setter]];
		if(goto == false) {
			this.myAnimator.animationStyle(this.duration, this.easing, this.callback);
			this.myAnimator.animate(start, end);
		} else {
			this.myAnimator.goto(end);
		}		
	}
	
	/**
	* @method animate
	* @description 	Draws an animated curve.		
	* @usage  	<pre>myInstance.animate(orig, targ);</pre>  
	* @param start (Number) A percent value that specifies where the animation shall beginn. (0 - 100).
	* @param end (Number) A percent value that specifies where the animation shall end. (0 - 100).
	*/
	public function animate(start:Number, end:Number):Void {
		this.mode = "REDRAW";
		this.invokeAnimation(start, end);
	}
		
	/**
	* @method animateBy
	* @description 	Draws an animated curve without clearing the movieclip.		
	* @usage  	<pre>myInstance.animateBy(orig, targ);</pre>  
	* @param start (Number) A percent value that specifies where the animation shall beginn. (0 - 100).
	* @param end (Number) A percent value that specifies where the animation shall end. (0 - 100).
	*/
	public function animateBy(start:Number, end:Number):Void {	
		this.mode = "DRAW";
		this.invokeAnimation(start, end);
	}
	
	/**
	* @method goto
	* @description 	jumps to a specific step of the animation and stays there.
	* @usage   <pre>instance.goto(percentage);</pre>
	* @param percentage (Number) Percentage value of the animation.
	* @return void
	*/	
	
	//clunky and slow. I don't like it. But it does the job.
	private function drawLineCurve(v:Number):Void {		
		this.clearDrawing();
		this.mc.moveTo(this.x1, this.y1);
		var p:Object;
		var calc:Array = this.calculatedPoints;
		var s:Number = this.startValue;		
		var len:Number = Math.round(v);
		var i:Number;
		for(i = s; i <= len; i++) {
			if(calc[i] == null) {
				p = calc[i] = this.myMoveOnCurve.getPointsOnCurve(i);
			} else {
				p = calc[i];
			}
			this.mc.lineTo(p.x, p.y);
		}
	}
	
	private function drawLineCurveBy(v:Number):Void {		
		this.mc.moveTo(this.x1, this.y1);		
		var p:Object;
		var calc:Array = this.calculatedPoints;
		var calcL:Number = this.calculatedPoints.length;		
		var s:Number = this.startValue;		
		var len:Number = Math.round(v);
		var i:Number;
		for(i = s; i <= len; i++) {
			if(calc[i] == null) {
				p = calc[i] = this.myMoveOnCurve.getPointsOnCurve(i);
			} else {
				p = calc[i];
			}
			this.mc.lineTo(p.x, p.y);				
		}
	}
	
	/*inherited from Shape*/
	/**
	* @method lineStyle
	* @description 	define outline.		
	* 		
	* @usage   <pre>myInstance.lineStyle();</pre>
	* 		<pre>myInstance.lineStyle(lineThickness, lineRGB, lineAlpha);</pre>
	* 	  
	* @param lineThickness (Number) Outline thickness.
	* @param lineRGB (Number) Outline color of the drawing as hex number.	
	* @param lineAlpha (Number) Outline transparency (alpha).
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
	* @method setRegistrationPoint
	* @description 	Sets the registration point of the shape. Defaults to center. Top left is 0,0. 
	* 					The parameter object accepts either a position property with the value of "CENTER" 
	* 					or x and y properties of with coordinates as values of the registration point.
	* 			<p>
	* 			Example 1: Set the registration point of an ellipse to the upper left corner (0,0) instead of center.
	* 			<blockquote><pre>
	*			var myEllipse:Ellipse = new Ellipse(275,200,100,50);
	*			myEllipse.setRegistrationPoint( {x:0,y:0} );
	*			myEllipse.draw();
	*			</pre></blockquote>
	* 			<p>
	* 			internally AnimationPackage centers all shapes with
	* 			<blockquote><pre>
	*			myInstance.setRegistrationPoint( {position:"CENTER"} );
	*			</pre></blockquote>	
	* @usage   <pre>myInstance.setRegistrationPoint(registrationObj);</pre>
	* 	  
	* @param registrationObj (Object)
	*/	
	public function setRegistrationPoint(registrationObj:Object):Void {	
		this.reset();
		/*retrieve boundaries of the curve in order to compute the center for positioning.*/
		var minX:Number = this.getBoundary("x", "min");
		var minY:Number = this.getBoundary("y", "min");
		var maxX:Number = this.getBoundary("x", "max");
		var maxY:Number = this.getBoundary("y", "max");
		
		var centerX:Number;
		var centerY:Number;		
		if(registrationObj.position == "CENTER") {	
			centerX = (maxX - minX) / 2 + minX;
			centerY = (maxY - minY) / 2 + minY;		
		} else if (registrationObj.x != null || registrationObj.y != null) {
			centerX = minX + registrationObj.x;
			centerY = minY + registrationObj.y;		
		} else {
			centerX = 0;
			centerY = 0;
		}
	
		this.mc._x = centerX;
		this.mc._y = centerY;
		
		/*apply center values*/
		var i:Number = this.points.length;		
		this.myPoints = new Array();
		while(--i>-1) {
			//Copy array by value and modify that value.			
			this.myPoints[i] = {x: this.points[i].x, y: this.points[i].y};
			this.myPoints[i].x -= centerX;
			this.myPoints[i].y -= centerY;			
		}
		this.initialized = true;
	}

	private function getBoundary(prop:String, meth:String):Number {
		var i:Number = this.points.length;
		var result:Number = this.points[--i][prop];
		while(--i>-1) {
			var element:Number = this.points[i][prop];
			result = Math[meth](element, result);
		}
		return result;
	}

	private function setDefaultRegistrationPoint(registrationObj:Object):Void {		
		
		if(!this.initialized) {			
			this.setRegistrationPoint(registrationObj);			
		}
	}
	
	public function reset(Void):Void {
		this.initialized = false;
	}
	
	/**
	* @method clear
	* @description 	removes all drawings. Identical to myInstance.movieclip.clear();
	* @usage <pre>myInstance.clear();</pre>
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
	* @description 	returns the original, starting value of the current tween. Percentage.
	* @usage   <tt>myInstance.getStartValue();</tt>
	* @return Number
	*/
	
	/**
	* @method getEndValue
	* @description 	returns the targeted value of the current tween. Percentage.
	* @usage   <tt>myInstance.getEndValue();</tt>
	* @return Number
	*/

	/**
	* @method getCurrentValue
	* @description 	returns the current value of the current tween. Percentage.
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
		return "Curve";
	}
}