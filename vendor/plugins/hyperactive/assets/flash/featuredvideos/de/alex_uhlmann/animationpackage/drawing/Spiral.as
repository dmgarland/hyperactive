import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.drawing.IDrawable;
import de.alex_uhlmann.animationpackage.drawing.Shape;
import de.alex_uhlmann.animationpackage.utility.Animator;

/**
* @class Spiral
* @author Alex Uhlmann
* @description Spiral is a class for drawing regular and elliptical spirals (non-logarithmic).	
* 			If you specify a movieclip as first parameter, the shape will be drawn inside this movieclip. 
* 			If you omit the mc parameter, the class will create a new movieclip in _root.apContainer_mc.			
* 			<p>
* 			Example 1: draw a spiral with 3 cycles and standars parameters.		
* 			<blockquote><pre>
*			var mySpiral:Spiral = new Spiral();
*			mySpiral.setEndValue(3);
* 			mySpiral.draw();
*			</pre></blockquote> 
* 			Example 2: do the same, just animate it.		
* 			<blockquote><pre>
*			var mySpiral:Spiral = new Spiral();
*			mySpiral.setEndValue(3);
*			mySpiral.animate(0,100);
*			</pre></blockquote> 
* 			Example 3: <a href="Spiral_03.html">(Example .swf)</a> draw an animated spiral with custom parameters, that 
* 			continues to animated to full size and back.
* 			<blockquote><pre>
*			var mySpiral:Spiral = new Spiral(275,200,0,0,10,10);
*			mySpiral.setStartValue(0);
*			mySpiral.setEndValue(10);
*			mySpiral.lineStyle(1,0xff0000,100);
*			mySpiral.animationStyle(1000,Cubic.easeInOut,"onCallback");
*			mySpiral.animate(0,100);
*			myListener.onCallback = function(source, value)
*			{				
*				if(value == 10) {
*					source.animate(100,0);
*				} else {
*					source.animate(0,100);
*				}	
*			}
*			</pre></blockquote> 
* @usage <pre>var mySpiral:Spiral = new Spiral();</pre> 
*		<pre>var mySpiral:Spiral = new Spiral(x, y, xRadius, yRadius, xGrowth, yGrowth, startAngle);</pre>
* 		<pre>var mySpiral:Spiral = new Spiral(mc, x, y, xRadius, yRadius, xGrowth, yGrowth, startAngle);</pre>
* @param mc (MovieClip) existing movieclip to draw in.
* @param x (Number) X position of the drawing. Center point.
* @param y (Number) Y position of the drawing. Center point.
* @param xRadius (Number) Radius for x-axis in pixels.
* @param yRadius (Number) Radius for y-axis in pixels.
* @param xGrowth (Number) Number of pixels added to xRadius with each complete revolution.
* @param yGrowth (Number) Number of pixels added to yRadius with each complete revolution.
* @param startAngle (Number) Starting angle in degrees. A value of 0 starts rendering at (x,y).
* @param revolutions (Number) Number of complete cycles in final spiral.
*/
class de.alex_uhlmann.animationpackage.drawing.Spiral 
											extends Shape 
											implements IDrawable, 
												ISingleAnimatable {	
	
	/*static default properties*/
	/*lineStyle properties inherited from Shape*/	
	/*animationStyle properties inherited from APCore*/
	/**	
	* @property xRadius_def (Number)(static) default property. Radius for x-axis in pixels.
	* @property yRadius_def (Number)(static) default property. Radius for y-axis in pixels.
	* @property xGrowth_def (Number)(static) default property. Number of pixels added to xRadius with each complete revolution.
	* @property yGrowth_def (Number)(static) default property. Number of pixels added to yRadius with each complete revolution.
	* @property startAngle_def (Number)(static) default property. Starting angle in degrees. A value of 0 starts rendering at (x,y).
	* @property revolutions_def (Number)(static) default property. Number of complete cycles in final spiral. Defaults to 9.
	*
	* @property movieclip (MovieClip)(read only) Movieclip that contains the drawing.
	* @property lineThickness (Number) Outline thickness.
	* @property lineRGB (Number) Outline color of the drawing as hex number.
	* @property lineAlpha (Number) Outline transparency (alpha).	
	* @property duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @property easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @property callback (String) Function to invoke after animation. See APCore class. 
	*/	
	public static var xRadius_def:Number = 0;
	public static var yRadius_def:Number = 0;
	public static var xGrowth_def:Number = 9;
	public static var yGrowth_def:Number = 9;
	public static var startAngle_def:Number = 0;
	public static var revolutions_def:Number = 9;
	private var x:Number = 0;
	private var y:Number = 0;	
	private var xRadius:Number;
	private var xGrowth:Number;
	private var yRadius:Number;
	private var yGrowth:Number;
	private var startAngle:Number;
	private var revolutions:Number;	
	
	/*startAngle doesn't seem to have any effect on the spiral*/
	public function Spiral() {
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

	private function initCustom(mc:MovieClip, x:Number, y:Number, xRadius:Number, yRadius:Number, 
					xGrowth:Number, yGrowth:Number, startAngle:Number, revolutions:Number):Void {		
		
		this.mc = this.createClip({mc:mc, x:x, y:y});		
		this.initShape.apply(this,arguments.slice(1));
	}

	private function initAuto(x:Number, y:Number, xRadius:Number, yRadius:Number, 
					xGrowth:Number, yGrowth:Number, startAngle:Number, revolutions:Number):Void {		
		
		this.mc = this.createClip({name:"apDraw", x:x, y:y});		
		this.initShape.apply(this,arguments);
	}
		
	private function initShape(x:Number, y:Number, xRadius:Number, yRadius:Number, 
					xGrowth:Number, yGrowth:Number, startAngle:Number, revolutions:Number):Void {
	
		this.xRadius = (xRadius == null) ? Spiral.xRadius_def : xRadius;
		this.yRadius = (yRadius == null) ? Spiral.yRadius_def : yRadius;
		this.xGrowth = (xGrowth == null) ? Spiral.xGrowth_def : xGrowth;
		this.yGrowth = (yGrowth == null) ? Spiral.yGrowth_def : yGrowth;
		this.startAngle = (startAngle == null) ? Spiral.startAngle_def : startAngle;
		this.revolutions = (revolutions == null) ? Spiral.revolutions_def : revolutions;
		this.setStartValue(this.startAngle);
		this.setEndValue(this.revolutions);	
	}
	
	/**
	* @method draw
	* @description 	Draws regular and elliptical spirals (non-logarithmic). 		
	* @usage <pre>mySpiral.draw();</pre>
	*/	
	
	/**
	* @method drawBy
	* @description 	Draws the shape without clearing the movieclip.
	* @usage <pre>myInstance.drawBy();</pre>
	*/	
	
	private function invokeAnimation(start:Number, end:Number):Void {
		var goto:Boolean;
		if(end == null) {
			goto = true;
			end = start;
			start = 0;			
		} else {
			goto = false;
		}
		
		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		this.myAnimator.start = [this.startValue];
		this.myAnimator.end = [this.endValue];
		this.myAnimator.setter = [[this, "drawShape"]];
		if(goto == false) {
			this.myAnimator.animationStyle(this.duration, this.easing, this.callback);
			this.myAnimator.animate(start, end);
		} else {
			this.myAnimator.goto(end);
		}
	}
	
	public function setStartValue(startValue:Number, optional:Boolean):Boolean {
		this.startAngle = startValue;
		return super.setStartValue(startValue);
	}
	
	public function setEndValue(endValue:Number):Boolean {
		this.revolutions = endValue;
		return super.setEndValue(endValue);
	}	
	
	/**
	* @method animate
	* @description 	Animates regular and elliptical spirals (non-logarithmic). 		
	* @usage <pre>mySpiral.animate(start, end);</pre>
	* @param start (Number) starting position of spiral.
	* @param end (Number) Number of complete cycles in final spiral.
	*/
	
	/**
	* @method goto
	* @description 	jumps to a specific step of the animation and stays there.
	* @usage   <pre>instance.goto(percentage);</pre>
	* @param percentage (Number) Percentage value of the animation.
	* @return void
	*/
	
	/**
	* @method getRadius
	* @description 	Returns the radii for the axes in pixels.
	* @usage  <pre>mySpiral.getRadius();</pre>
	* @return Object that contains x (xRadius) and y (yRadius) properties. 
	*/	
	public function getRadius(Void):Object {		
		return { x:this.xRadius, y:this.yRadius };		
	}
		
	/**
	* @method setRadius
	* @description 	Sets the radii for the axes in pixels.
	* 		
	* @usage   <pre>mySpiral.setRadius(xRadius, yRadius);</pre>
	* 	  
	* @param xRadius (Number) Radius for x-axis in pixels.
	* @param yRadius (Number) Radius for y-axis in pixels.
	*/	
	public function setRadius(xRadius:Number, yRadius:Number):Void {	
		this.xRadius = xRadius;
		this.yRadius = yRadius;		
	}
	
	/**
	* @method getGrowth
	* @description 	Returns the numbers of pixels added to the radii with each complete revolution.
	* @usage  <pre>mySpiral.getGrowth();</pre>
	* @return Object that contains x (xGrowth) and y (yGrowth) properties. 
	*/	
	public function getGrowth(Void):Object {		
		return { x:this.xGrowth, y:this.yGrowth };	
	}
		
	/**
	* @method setGrowth
	* @description 	Sets the numbers of pixels added to the radii with each complete revolution.	
	* 		
	* @usage   <pre>mySpiral.setGrowth(xGrowth, yGrowth);</pre>
	* 	  
	* @param xGrowth (Number) Number of pixels added to xRadius with each complete revolution.
	* @param yGrowth (Number) Number of pixels added to yRadius with each complete revolution.
	*/	
	public function setGrowth(xGrowth:Number, yGrowth:Number):Void {	
		this.xGrowth = xGrowth;
		this.yGrowth = yGrowth;		
	}
	
	/**
	* @method getStartAngle
	* @description deprecated. Use getStartValue instead.
	* @usage  <pre>mySpiral.getStartAngle();</pre>
	* @return Number
	*/
	public function getStartAngle(Void):Number {
		return this.startAngle;		
	}
	
	/**
	* @method setStartAngle
	* @description deprecated. Use setStartValue instead.
	* @usage  <pre>mySpiral.setStartAngle(startAngle);</pre>
	* @param startAngle Number
	*/
	public function setStartAngle(startAngle:Number):Void {
		this.startAngle = startAngle;
		this.setStartValue(startAngle);
	}	
	
	/**
	* @method getRevolutions
	* @description 	deprecated. Use getEndValue instead. Returns the number of complete cycles in final spiral.
	* @usage  <pre>mySpiral.getRevolutions();</pre>
	* @return Number
	*/
	public function getRevolutions(Void):Number {
		return this.revolutions;		
	}
	
	/**
	* @method setRevolutions
	* @description 	deprecated. Use setEndValue instead. Sets the number of complete cycles in final spiral.
	* @usage  <pre>mySpiral.setRevolutions(angExt);</pre>
	* @param angExt Number
	*/
	public function setRevolutions(revolutions:Number):Void {
		this.revolutions = revolutions;
		this.setEndValue(revolutions);
	}
	
	public function drawShape(v:Number):Void {
		this.clearDrawing();
		this.revolutions = v;
		this.drawNew();
	}
	
	private function drawNew(Void):Void {	
		this.mc.moveTo(this.x, this.y);
		this.drawSpiral(this.x, this.y, this.startAngle, this.revolutions, 
						this.xRadius, this.xGrowth, this.yRadius, this.yGrowth);
	}
	
	/* *** MovieClip.drawSpiral *********************************************************************************
	 ************************************************************************************************************
	 **  PURPOSE:	a method for drawing regular and elliptical spirals (non-logarithmic). This method was 
	 **				inspired by an afternoon (ok, a whole freakin' day)	spent with a number of advanced 
	 **				drawing API methods written by Ric Ewing (ric@ricewing.com). Ric's code is available here:
	 **
	 **						http://www.macromedia.com/devnet/mx/flash/articles/adv_draw_methods.html
	 **
	 **				I have changed my code somewhat so that it will blend in reasonably well with Ric's methods.
	 **				Thanks to Ric for the inspiration.
	 **
	 **  NOTE:		I REALLY wanted to do this with fewer segments per revolution (e.g. the usual 8) using curveTo
	 **				instead of lineTo, but I was unable to figure out how to determine the control points 
	 **				correctly. If anyone can clue me in on the required math, I will update this method and give 
	 **				you due credit and boundless gratitude. Enjoy.  ---jim
	 **	
	 **	 REQUIRED PARAMETERS:
	 **
	 **		x, y	    -- center point for the spiral
	 **		startAngle  -- starting angle in degrees. a value of 0 starts rendering at (x,y)
	 **		revolutions -- number of complete cycles in final spiral
	 **		xRadius		-- radius for x-axis in pixels
	 **		xGrowth	    -- number of pixels added to xRadius with each complete revolution
	 **
	 **	 OPTIONAL PARAMETERS: ( will be set identical to x-values if not included )
	 **
	 **		yRadius     -- radius for y-axis in pixels
	 **		yGrowth	    -- number of pixels added to xRadius with each complete revolution
	 **
	 **
	 **	 BY::::::::::::::::::::james w. bennett iii ( snowballs.chance@hell.com ) -- version 1.0 -- march2003
	 **
	 ******/
	private function drawSpiral(x:Number, y:Number, startAngle:Number, revolutions:Number, 
								xRadius:Number, xGrowth:Number, yRadius:Number, yGrowth:Number):Void {
		
		// drawing resolution. STEP_SIZE = 6 yields 60 linesegments per revolution
		var STEP_SIZE:Number = 6; 	// in degrees
		
		// if y-axis information not included, set identical to x-axis
		if ( yRadius == undefined )
		{
			yRadius = xRadius;
			yGrowth = xGrowth;
		}
		else if ( yGrowth == undefined )
		{
			yGrowth = xGrowth;
		}
	
	
		// reverse the signs in order to reverse directions
		if ( revolutions < 0 )
		{
			STEP_SIZE  = -STEP_SIZE;
			startAngle = -startAngle;
		}
	
		// initialize variables
		var startRadians:Number, currentRadians:Number, endRadians:Number;
		var xRadiusDelta:Number, yRadiusDelta:Number;
		var stepsPerRevolution:Number;
		var ax:Number, ay:Number;
		var bx:Number, by:Number;		
		// convert angles from degrees to radians
		startRadians = -(startAngle / 180) * Math.PI;
		endRadians   = -((revolutions * 360) / 180) * Math.PI;
		var theta:Number        = -(STEP_SIZE   / 180) * Math.PI;
		
		// calculate step size
		stepsPerRevolution = Math.abs((2 * Math.PI) / theta);
		
		// calculate pixel-growth per step
		xRadiusDelta = xGrowth / stepsPerRevolution;
		yRadiusDelta = yGrowth / stepsPerRevolution;
		
		// get the starting point and ... 
		ax = x + xRadius * Math.cos( startRadians );
		ay = y + yRadius * Math.sin( startRadians );
		
		// ... move there
		this.mc.moveTo( ax, ay );
		
		// advance angle by one step (theta)
		currentRadians = startRadians + theta;
		
		// draw it
		while( Math.abs(currentRadians) < Math.abs(endRadians) )
		{
			// calculate the next point
			bx = x + xRadius * Math.cos( currentRadians );
			by = y + yRadius * Math.sin( currentRadians );
			
			// draw the line to it
			this.mc.lineTo( bx, by );
			
			// advance the angle
			currentRadians += theta;
			
			// increase the radius
			xRadius += xRadiusDelta;
			yRadius += yRadiusDelta;
		}
	}
	
	/*inherited from Shape*/
	/**
	* @method lineStyle
	* @description 	define outline.		
	* 		
	* @usage   <pre>mySpiral.lineStyle();</pre>
	* 		<pre>mySpiral.lineStyle(lineThickness, lineRGB, lineAlpha);</pre>
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
	* @usage   <pre>mySpiral.animationStyle(duration);</pre>
	* 		<pre>mySpiral.animationStyle(duration, callback);</pre>
	* 		<pre>mySpiral.animationStyle(duration, easing, callback);</pre>
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
		if(registrationObj.position == "CENTER") {		
			this.x = 0;
			this.y = 0;
		} else {	
			this.x = (this.revolutions * this.xGrowth) + registrationObj.x;
			this.y = (this.revolutions * this.yGrowth) + registrationObj.y;			
		}
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
	* @description 	returns the original, starting value of the current tween. In revolutions.
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
	* @description 	returns the targeted value of the current tween. In revolutions.
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
	* @description 	returns the current value of the current tween. In revolutions. 
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
	* @usage   <pre>mySpiral.addEventListener(event, listener);</pre>
	* 		    <pre>mySpiral.addEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>mySpiral.removeEventListener(event, listener);</pre>
	* 		    <pre>mySpiral.removeEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>mySpiral.removeAllEventListeners();</pre>
	* 		    <pre>mySpiral.removeAllEventListeners(event);</pre>
	* 	  
	*@param event (String) Event to remove all subscribed listeners from. If not specified, all listeners to any event will be removed.
	*/
	
	/*inherited from APCore*/
	/**
	* @method eventListenerExists
	* @description 	GDispatcher specific feature. Checks if a listener is already subscribed to a certain event.
	* 		
	* @usage   <pre>mySpiral.eventListenerExists(event, listener);</pre>
	* 			<pre>mySpiral.eventListenerExists(event, listener, handler);</pre>
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
		return "Spiral";
	}
}