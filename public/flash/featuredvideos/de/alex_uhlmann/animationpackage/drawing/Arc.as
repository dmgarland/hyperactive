import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.drawing.IDrawable;
import de.alex_uhlmann.animationpackage.drawing.Shape;
import de.alex_uhlmann.animationpackage.utility.Animator;

/**
* @class Arc
* @author Alex Uhlmann
* @description Arc is a class for drawing regular and elliptical arc segments 
* 			and pie shaped wedges. Very useful for creating charts. Similar to 
* 			java.awt.geom.Arc2D you can specify the closure type of the arc. 
* 			Available closure types are: 
* 			<blockquote><pre>
* 			OPEN = The closure type for an open arc with no path segments connecting the two ends of the arc segment.  
* 			CHORD = The closure type for an arc closed by drawing a straight line segment from the start of the arc segment to the end of the arc segment. 
* 			PIE = The closure type for an arc closed by drawing straight line segments from the start of the arc segment to the center of the full ellipse and from that point to the end of the arc segment. 
* 			Default closure type is CHORD.
* 			</pre></blockquote>
* 			If you specify a movieclip as first parameter, the shape will be drawn inside this movieclip. 
* 			If you omit the mc parameter, the class will create a new movieclip in _root.apContainer_mc.
* 			<p>
* 			Example 1: <a href="Arc_01.html">(Example .swf)</a> draw a 3/4 arc with default parameters.		
* 			<blockquote><pre>
*			var myArc:Arc = new Arc(275,200);
*			myArc.setEndValue(270);
* 			myArc.draw();
*			</pre></blockquote> 
* 			Example 2: <a href="Arc_02.html">(Example .swf)</a> draw an open arc, and animate it.		
* 			<blockquote><pre>
*			var myArc:Arc = new Arc(275,200);
*			myArc.lineStyle(0x000000);
*			myArc.fillStyle(0xff0000);
*			myArc.setArcType("OPEN");
*			myArc.setStartValue(0);
*			myArc.setEndValue(270);
*			myArc.animate(0,100);
*			</pre></blockquote> 			
* 			Example 3: <a href="Arc_03.html">(Example .swf)</a> draw an arc with custom parameters. 
* 			<blockquote><pre>
*			var myArc:Arc = new Arc(275,200,200,0,270,"PIE");			
*			myArc.lineStyle(15,0xff0000,50);
*			myArc.fillStyle(0xff0000,50);
*			myArc.draw();
*			</pre></blockquote>
* 			Example 4: <a href="Arc_04.html">(Example .swf)</a> draw an animated wedge with custom parameters, that 
* 			continues to animated to full size and back.
* 			<blockquote><pre>
*			var myArc:Arc = new Arc(275,200,150,0,270);	
*			myArc.setArcType("PIE");
*			myArc.lineStyle(2,0xff0000,50);
*			myArc.fillStyle(0xffff00,100);
*			myArc.animationStyle(2000,Sine.easeInOut,"onCallback");			
*			myArc.animate(0,100);
*			myListener.onCallback = function(source, value)
*			{			
*				if(value == 270) {
*					myArc.animate(100,0);
*				} else {
*					myArc.animate(0,100);
*				}	
*			}
*			</pre></blockquote> 
* @usage   <pre>var myArc:Arc = new Arc();</pre> 
* 		<pre>var myArc:Arc = new Arc(x, y, radius, start, end, type);</pre>
* 		<pre>var myArc:Arc = new Arc(mc, x, y, radius, start, end, type);</pre>
* @param mc (MovieClip) existing movieclip to draw in.
* @param x (Number) X position of the drawing. Center point.
* @param y (Number) Y position of the drawing. Center point.
* @param radius (Number) Radius of the drawing.
* @param start (Number) The starting angle of the arc in degrees.
* @param end (Number) The angular extent of the arc in degrees.
* @param type (String) The String constant that represents the closure type of this arc: OPEN, CHORD, or PIE. 
*/
class de.alex_uhlmann.animationpackage.drawing.Arc 
										extends Shape 
										implements IDrawable, 
												ISingleAnimatable {	

	/*static default properties*/	
	/*lineStyle properties inherited from Shape*/
	/*fillStyle properties inherited from Shape*/
	/*animationStyle properties inherited from APCore*/	
	/**	
	* @property radius_def (Number)(static) default property. Radius of the drawing. Defaults to 100.
	* @property start_def (Number)(static) default property. Specifies the size of the drawing to begin with (in degrees). Negative values draw clockwise. Defaults to 0.
	* @property end_def (Number)(static) default property. Specifies the size of the drawing to draw to (in degrees). Negative values draw clockwise. Defaults to 360.
	* @property type_def (Number)(static) default property. Default closure type of arc is CHORD.
	* 
	* @property movieclip (MovieClip)(read only) Movieclip that contains the drawing.
	* @property lineThickness (Number) Outline thickness.
	* @property lineRGB (Number) Outline color of the drawing as hex number.
	* @property lineAlpha (Number) Outline transparency (alpha).
	* @property fillRGB (Number) Fill color of the drawing.
	* @property fillAlpha (Number) Fill transparency.
	* 
	* @property duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @property easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @property callback (String) Function to invoke after animation. See APCore class. 
	*/	
	public static var radius_def:Number = 100;
	public static var start_def:Number = 0;
	public static var end_def:Number = 360;
	public static var type_def:String = "CHORD";	
	private var x:Number = 0;
	private var y:Number = 0;
	private var radius:Number;
	private var start:Number;
	private var end:Number;
	private var type:String;
	
	public function Arc() {
		super();
		this.init.apply(this,arguments);
		this.fillStyle(null);
		this.animationStyle();
	}	
	
	private function init():Void {		
		if(typeof(arguments[0]) == "movieclip") {					
			this.initCustom.apply(this,arguments);
		} else {			
			this.initAuto.apply(this,arguments);
		}
	}

	private function initCustom(mc:MovieClip, x:Number, y:Number, radius:Number, 
					start:Number, end:Number, type:String):Void {		
		
		this.mc = this.createClip({mc:mc, x:x, y:y});
		this.initShape.apply(this,arguments.slice(1));
	}

	private function initAuto(x:Number, y:Number, radius:Number, 
					start:Number, end:Number, type:String):Void {		
		
		this.mc = this.createClip({name:"apDraw", x:x, y:y});
		this.initShape.apply(this,arguments);
	}
		
	private function initShape(x:Number, y:Number, radius:Number, 
					start:Number, end:Number, type:String):Void {
	
		this.radius = (radius == null) ? Arc.radius_def : radius;
		this.start = (start == null) ? Arc.start_def : start;
		this.end = (end == null) ? Arc.end_def : end;
		this.type = (type == null) ? Arc.type_def : type;
		if(this.type == "PIE") {
			this.x = 0;
		} else {
			this.x = this.radius;		
		}
		this.setStartValue(this.start);
		this.setEndValue(this.end);
	}
	
	/**
	* @method draw
	* @description 	Draws regular and elliptical arc segments.		
	* @usage <pre>myArc.draw();</pre>
	*/

	/**
	* @method drawBy
	* @description 	Draws the shape without clearing the movieclip.
	* @usage <pre>myInstance.drawBy();</pre>
	*/

	private function invokeAnimation(start:Number, end:Number):Void {
		this.startInitialized = false;
		
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
		this.start = startValue;
		return super.setStartValue(startValue);
	}
	
	public function setEndValue(endValue:Number):Boolean {
		this.end = endValue;
		return super.setEndValue(endValue);
	}
	
	/**
	* @method animate
	* @description 	Draws the animated segments.		
	* @usage  	<pre>myArc.animate(start, end);</pre>  
	* @param start (Number) Specifies the size of the drawing to begin with (in degrees). Negative values draw clockwise.
	* @param end (Number) Specifies the size of the drawing to draw to (in degrees). Negative values draw clockwise.
	*/
	
	/**
	* @method goto
	* @description 	jumps to a specific step of the animation and stays there.
	* @usage   <pre>myInstance.goto(percentage);</pre>
	* @param percentage (Number) Percentage value of the animation.
	* @return void
	*/
	
	public function drawShape(v:Number):Void {
		this.clearDrawing();
		this.end = v;
		this.drawNew();
	}

	/**
	* @method getRadius
	* @description 	Returns the radius.
	* @usage  <pre>myArc.getRadius();</pre>
	* @return Number that represents the radius in pixels. 
	*/	
	public function getRadius(Void):Number {		
		return this.radius;		
	}
		
	/**
	* @method setRadius
	* @description 	Sets the radius of the drawing.		
	* 		
	* @usage   <pre>myArc.setRadius(radius);</pre>
	* 	  
	* @param radius (Number) radius in pixels.
	*/	
	public function setRadius(radius:Number):Void {	
		this.radius = radius;		
	}
	
	/**
	* @method getAngleStart
	* @description deprecated. Use getStartValue instead.
	* @usage  <pre>myArc.getAngleStart();</pre>
	* @return Number
	*/
	public function getAngleStart(Void):Number {
		return this.start;		
	}
	
	/**
	* @method setAngleStart
	* @description deprecated. Use setStartValue instead.
	* @usage  <pre>myArc.setAngleStart(startAngle);</pre>
	* @param startAngle Number
	*/
	public function setAngleStart(startAngle:Number):Void {
		this.start = startAngle;
		this.setStartValue(startAngle);
	}	
	
	/**
	* @method getAngleExtent
	* @description 	deprecated. Use getEndValue instead. Returns the angular extent of the arc.
	* @usage  <pre>myArc.getAngleExtent();</pre>
	* @return Number that represents the angular extent of the arc in degrees.
	*/
	public function getAngleExtent(Void):Number {
		return this.end;		
	}	
	
	/**
	* @method setAngleExtent
	* @description 	deprecated. Use setEndValue instead. Sets the angular extent of this arc to the specified value.
	* @usage  <pre>myArc.setAngleExtent(angExt);</pre>
	* @param angExt Number The angular extent of the arc in degrees.
	*/
	public function setAngleExtent(angExt:Number):Void {
		this.end = angExt;	
		this.setEndValue(angExt);
	}
	
	/**
	* @method getArcType
	* @description 	Returns the arc closure type of the arc: OPEN, CHORD, or PIE. See class description.
	* @usage  <pre>myArc.getArcType();</pre>
	* @return String of the constant closure type defined in this class.
	*/
	public function getArcType(Void):String {
		return this.type;		
	}
	
	/**
	* @method setArcType
	* @description 	Sets the closure type of this arc to the specified value: OPEN, CHORD, or PIE. See class description.
	* @usage  <pre>myArc.setArcType(type);</pre>
	* @param type (String) The String constant that represents the closure type of this arc: OPEN, CHORD, or PIE. 
	*/	
	public function setArcType(type:String):Void {		
		if(type == "PIE") {			
			if(this.x > this.radius) {
				this.x = this.radius;
			} else {
				this.x = 0;
			}
		} else {
			if(this.x > this.radius) {
				this.x = 2*this.radius;
			} else {
				this.x = this.radius;
			}
		}
		this.type = type;
	}
	
	/*inherited from Shape*/
	/**
	* @method lineStyle
	* @description 	define outline.		
	* 		
	* @usage   <pre>myArc.lineStyle();</pre>
	* 		<pre>myArc.lineStyle(lineThickness, lineRGB, lineAlpha);</pre>
	* 	  
	* @param lineThickness (Number) Outline thickness.
	* @param lineRGB (Number) Outline color of the drawing as hex number.	
	* @param lineAlpha (Number) Outline transparency (alpha).
	*/	
	
	/*inherited from Shape*/
	/**
	* @method fillStyle
	* @description 	define fill.		
	* 		
	* @usage   <pre>myArc.fillStyle();</pre>
	* 		<pre>myArc.fillStyle(fillRGB, fillAlpha);</pre>
	* 	  
	* @param fillRGB (Number) Fill color of the drawing.
	* @param fillAlpha (Number) Fill transparency.
	*/
	
	/**
	* @method gradientStyle
	* @description	 Same interface as MovieClip.beginGradientFill(). See manual.
	* 		
	* @usage   <pre>myShapeComposite.gradientStyle(fillType, colors, alphas, ratios, matrix);</pre>
	* 	  
	* @param fillType (String)  Gradient property. See MovieClip.beginGradientFill().
	* @param colors (Array)  Gradient property. See MovieClip.beginGradientFill().
	* @param alphas (Array)  Gradient property. See MovieClip.beginGradientFill().
	* @param ratios (Array)  Gradient property. See MovieClip.beginGradientFill().
	* @param matrix (Object)  Gradient property. See MovieClip.beginGradientFill().
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
	* @usage   <pre>myArc.animationStyle(duration);</pre>
	* 		<pre>myArc.animationStyle(duration, callback);</pre>
	* 		<pre>myArc.animationStyle(duration, easing, callback);</pre>
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
			if(this.type == "PIE") {
				this.x = 0;
			} else {
				this.x = this.radius;
			}			
			this.y = 0;
		} else if (registrationObj.x != null || registrationObj.y != null) {
			if(this.type == "PIE") {
				this.x = this.radius + registrationObj.x;
			} else {
				this.x = 2* (this.radius + registrationObj.x);
			}
			this.y = this.radius + registrationObj.y;
		}
	}
	
	/**
	* @method clear
	* @description 	removes all drawings. Identical to myInstance.movieclip.clear();
	* @usage <pre>myInstance.clear();</pre>
	*/
	
	private function drawNew(Void):Void {	
		this.mc.moveTo(this.x, this.y);
		if (this.fillRGB != null && this.fillGradient == false) {			
			this.mc.beginFill(this.fillRGB, this.fillAlpha);
		} else if (this.fillGradient == true){
			this.mc.beginGradientFill(this.gradientFillType, this.gradientColors, this.gradientAlphas, this.gradientRatios, this.gradientMatrix);
		}
		this.drawArc(this.x, this.y, this.start, this.end, this.radius);
		this.mc.endFill();
	}
	
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

	/*-------------------------------------------------------------
		drawArc is a method for drawing regular and elliptical 
		arc segments and pie shaped wedges. Thanks to: 
		Robert Penner, Eric Mueller and Michael Hurwicz for their contributions.
	-------------------------------------------------------------*/
	private function drawArc(x:Number, y:Number, startAngle:Number,
							   arc:Number, radius:Number, yRadius):Void {
				
		// ==============
		// drawArc() - by Ric Ewing (ric@formequalsfunction.com) - version 1.5 - 4.7.2002
		// 
		// x, y = This must be the current pen position... other values will look bad
		// radius = radius of Arc. If [optional] yRadius is defined, then r is the x radius
		// arc = sweep of the arc. Negative values draw clockwise.
		// startAngle = starting angle in degrees.
		// yRadius = [optional] y radius of arc. Thanks to Robert Penner for the idea.
		// ==============
		// Thanks to: Robert Penner, Eric Mueller and Michael Hurwicz for their contributions.
		// ==============

		// if yRadius is undefined, yRadius = radius
		if (yRadius == undefined) {
			yRadius = radius;
		}
		// Init vars
		var segAngle:Number, theta:Number, angle:Number, angleMid:Number, segs:Number;
		var ax:Number, ay:Number, bx:Number, by:Number, cx:Number, cy:Number;
		// no sense in drawing more than is needed :)
		if (Math.abs(arc)>360) {
			arc = 360;
		}
		// Flash uses 8 segments per circle, to match that, we draw in a maximum
		// of 45 degree segments. First we calculate how many segments are needed
		// for our arc.
		segs = Math.ceil(Math.abs(arc)/45);
		// Now calculate the sweep of each segment
		segAngle = arc/segs;		
		// The math requires radians rather than degrees. To convert from degrees
		// use the formula (degrees/180)*Math.PI to get radians. 
		theta = -(segAngle/180)*Math.PI;
		// convert angle startAngle to radians
		angle = -(startAngle/180)*Math.PI;
		if(this.type == "CHORD" || this.type == "OPEN") {			
			// find our starting points (ax,ay) relative to the secified x,y
			ax = x-Math.cos(angle)*radius;
			ay = y-Math.sin(angle)*yRadius;
		}
		// if our arc is larger than 45 degrees, draw as 45 degree segments
		// so that we match Flash's native circle routines.
		if (segs>0) {			
			if(this.type == "PIE") {
				// draw a line from the center to the start of the curve
				ax = x+Math.cos(startAngle/180*Math.PI)*radius;
				ay = y+Math.sin(-startAngle/180*Math.PI)*yRadius;
				this.mc.lineTo(ax, ay);			
				ax = x;
				ay = y;
			} 
			// Loop for drawing arc segments
			var i:Number;
			for(i = 0; i<segs; i++) {
				// increment our angle
				angle += theta;
				// find the angle halfway between the last angle and the new
				angleMid = angle-(theta/2);

				// calculate our end point
				bx = ax+Math.cos(angle)*radius;
				by = ay+Math.sin(angle)*yRadius;
				// calculate our control point
				cx = ax+Math.cos(angleMid)*(radius/Math.cos(theta/2));
				cy = ay+Math.sin(angleMid)*(yRadius/Math.cos(theta/2));				
	
				// draw the arc segment
				this.mc.curveTo(cx, cy, bx, by);
			}
			// close the wedge by drawing a line to the center. 
			// Draw transparent for open arc.
			if(this.type == "OPEN") {				
				this.mc.lineStyle();
				this.mc.lineTo(x, y);
				this.mc.lineStyle(this.lineThickness, this.lineRGB, this.lineAlpha);
			} else {
				this.mc.lineTo(x, y);
			}			
		}
		// In the native draw methods the user must specify the end point
		// which means that they always know where they are ending at, but
		// here the endpoint is unknown unless the user calculates it on their 
		// own. Lets be nice and let save them the hassle by passing it back. 
		//return {x:bx, y:by};
	}
	
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
	* @description 	sets the original, starting value of the current tween.
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
	* @description 	sets the targeted value of the current tween.
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
	* @usage   <pre>myArc.addEventListener(event, listener);</pre>
	* 		    <pre>myArc.addEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myArc.removeEventListener(event, listener);</pre>
	* 		    <pre>myArc.removeEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myArc.removeAllEventListeners();</pre>
	* 		    <pre>myArc.removeAllEventListeners(event);</pre>
	* 	  
	*@param event (String) Event to remove all subscribed listeners from. If not specified, all listeners to any event will be removed.
	*/
	
	/*inherited from APCore*/
	/**
	* @method eventListenerExists
	* @description 	GDispatcher specific feature. Checks if a listener is already subscribed to a certain event.
	* 		
	* @usage   <pre>myArc.eventListenerExists(event, listener);</pre>
	* 			<pre>myArc.eventListenerExists(event, listener, handler);</pre>
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
		return "Arc";
	}
}