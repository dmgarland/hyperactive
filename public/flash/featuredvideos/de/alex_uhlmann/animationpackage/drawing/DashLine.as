import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.drawing.IDrawable;
import de.alex_uhlmann.animationpackage.drawing.IOutline;
import de.alex_uhlmann.animationpackage.drawing.Line;

/**
* @class DashLine
* @author Alex Uhlmann
* @description DashLine is a class for drawing dashed (and dotted) lines. 
*  			If you specify a movieclip as first parameter, the shape will be drawn inside this movieclip. 
* 			If you omit the mc parameter, the class will create a new movieclip in _root.apContainer_mc.
* 			<p>
* 			Example 1: draw a line with default parameters.		
* 			<blockquote><pre>
*			var myLine:DashLine = new DashLine();
*			myLine.draw();			
*			</pre></blockquote> 
* 			Example 2: do the same, just animate it.		
* 			<blockquote><pre>
* 			var myLine:DashLine = new DashLine();
*			myLine.animate(0,100);
*			</pre></blockquote> 			
* 			Example 3: draw a line with custom parameters. A dotted line. 
* 			<blockquote><pre>
*			var myLine:DashLine = new DashLine(0,0,275,200,1,8);
*			myLine.lineStyle(1,0xff0000,100);
*			myLine.draw();
*			</pre></blockquote>
* 			Example 4: <a href="DashLine_04.html">(Example .swf)</a> draw an animated line with custom parameters, that 
* 			continues to animated to full size and back.
* 			<blockquote><pre>
*			var myLine:DashLine = new DashLine(0,0,275,200,4,20);
*			myLine.lineStyle(10,0xff0000,50);
*			myLine.animationStyle(2000,Sine.easeOut,"onCallback");
*			myLine.animate(0,100);
*			myListener.onCallback = function(source, value)
*			{	
*				if(value == 100) {
*					source.animate(100, 0);
*				} else {
*					source.animate(0, 100);
*				}	
*			}
*			</pre></blockquote>
* 			The dashed line is defined with two points. Start point and end point.
* 			To make a dotted line, specify a dash length between .5 and 1. 		
* @usage <pre>var myLine:DashLine = new DashLine();</pre> 
* 		<pre>var myLine:DashLine = new DashLine(x1, y1, x2, y2, len, gap);</pre>
* 		<pre>var myLine:DashLine = new DashLine(mc, x1, y1, x2, y2, len, gap);</pre>
* @param mc (MovieClip) existing movieclip to draw in.
* @param x1 (Number) start point to define line. Coordinate point x.
* @param y1 (Number) start point to define line. Coordinate point y.
* @param x2 (Number) end point to define line. Coordinate point x.
* @param y2 (Number) end point to define line. Coordinate point y.
* @param len (Number) length of dash. Defaults to 8.
* @param gap (Number) length of gap between dashes. Defaults to 8.
*/
class de.alex_uhlmann.animationpackage.drawing.DashLine 
											extends Line 
											implements IDrawable, 
													IOutline, 
													ISingleAnimatable {	
	
	/*static default properties*/
	/*lineStyle properties inherited from Shape*/	
	/*animationStyle properties inherited from AnimationCore*/	
	/** 
	* @property len_def (Number)(static) default property. length of dash. Defaults to 8.
	* @property gap_def (Number)(static) default property. length of gap between dashes. Defaults to 8.
	* 
	* @property movieclip (MovieClip)(read only) Movieclip that contains the drawing.
	* @property lineThickness (Number) Outline thickness.
	* @property lineRGB (Number) Outline color of the drawing as hex number.
	* @property lineAlpha (Number) Outline transparency (alpha).	
	* @property duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @property easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @property callback (String) Function to invoke after animation. See APCore class. 
	*/	
	public static var len_def:Number = 8;
	public static var gap_def:Number = 8;	
	private var len:Number;
	private var gap:Number;	
	
	public function DashLine() {
		super(false);
		this.init.apply(this, arguments);
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

	private function initCustom(mc:MovieClip, x1:Number, y1:Number, x2:Number, y2:Number):Void {		
		
		this.mc = this.createClip({mc:mc, x:0, y:0});		
		this.initShape.apply(this,arguments.slice(1));
	}

	private function initAuto(x1:Number, y1:Number, x2:Number, y2:Number):Void {		
		
		this.mc = this.createClip({name:"apDraw", x:0, y:0});		
		this.initShape.apply(this,arguments);
	}
		
	private function initShape(x1:Number, y1:Number, x2:Number, y2:Number):Void {
	
		var len:Number = arguments[4];
		var gap:Number = arguments[5];
		this.len = (len == null) ? DashLine.len_def : len;
		this.gap = (gap == null) ? DashLine.gap_def : gap;
		super.initShape(x1, y1, x2, y2);		
	}

	/*inherited from Line*/		
	/**
	* @method draw
	* @description 	Draws the dashed line.
	* @usage <pre>myLine.draw();</pre>
	*/

	/**
	* @method drawBy
	* @description 	Draws the line without clearing the movieclip.
	* @usage <pre>myLine.drawBy();</pre>
	*/

	/**
	* @method animate
	* @description 	Draws an animated dashed line.		
	* @usage  	<pre>myLine.animate(start, end);</pre>  
	* @param start (Number) A percent value that specifies where the animation shall beginn. (0 - 100).
	* @param end (Number) A percent value that specifies where the animation shall end. (0 - 100).
	* @return MovieClip that contains the drawing. 
	*/
	
	/**
	* @method animateBy
	* @description 	Draws an animated line without clearing the movieclip.		
	* @usage  	<pre>myLine.animateBy(start, end);</pre>  
	* @param start (Number) A percent value that specifies where the animation shall beginn. (0 - 100).
	* @param end (Number) A percent value that specifies where the animation shall end. (0 - 100).
	*/
	
	/**
	* @method goto
	* @description 	jumps to a specific step of the animation and stays there.
	* @usage   <pre>instance.goto(percentage);</pre>
	* @param percentage (Number) Percentage value of the animation.
	* @return void
	*/	
	
	private function drawLine(v:Number):Void {
		var p:Object = this.getPointsOnLine(v);		
		this.clearDrawing();			
		this.drawNewPoint(p.x, p.y);
	}	
	
	private function drawNewPoint(x2:Number, y2:Number):Void {	
		this.dashTo(this.x1, this.y1, x2, y2);
		this.penX = x2;
		this.penY = y2;		
	}
	
	/*-------------------------------------------------------------
	mc.dashTo is a metod for drawing dashed (and dotted) 
	lines. I made this to extend the lineTo function because it
	doesnÕt have the cutom line types that the in program
	line tool has. To make a dotted line, specify a dash length
	between .5 and 1.
	-------------------------------------------------------------*/
	private function dashTo(startx:Number, starty:Number, 
							endx:Number, endy:Number):Void {
		// ==============
		// mc.dashTo() - by Ric Ewing (ric@formequalsfunction.com) - version 1.2 - 5.3.2002
		// 
		// startx, starty = beginning of dashed line
		// endx, endy = end of dashed line
		// len = length of dash
		// gap = length of gap between dashes
		// ==============
		// init vars
		var seglength:Number, deltax:Number, deltay:Number;
		var segs:Number, cx:Number, cy:Number;
		// calculate the legnth of a segment
		seglength = this.len + this.gap;
		// calculate the length of the dashed line
		deltax = endx - startx;
		deltay = endy - starty;
		var delta:Number = Math.sqrt((deltax * deltax) + (deltay * deltay));
		// calculate the number of segments needed
		segs = Math.floor(Math.abs(delta / seglength));
		// get the angle of the line in radians
		var radians:Number = Math.atan2(deltay,deltax);
		// start the line here
		cx = startx;
		cy = starty;
		// add these to cx, cy to get next seg start
		deltax = Math.cos(radians)*seglength;
		deltay = Math.sin(radians)*seglength;
		// loop through each seg
		var n:Number;
		for (n = 0; n < segs; n++) {
			this.mc.moveTo(cx,cy);
			this.mc.lineTo(cx+Math.cos(radians)*this.len,cy+Math.sin(radians)*this.len);
			cx += deltax;
			cy += deltay;
		}
		// handle last segment as it is likely to be partial
		this.mc.moveTo(cx,cy);
		delta = Math.sqrt((endx-cx)*(endx-cx)+(endy-cy)*(endy-cy));
		if(delta>this.len){
			// segment ends in the gap, so draw a full dash
			this.mc.lineTo(cx+Math.cos(radians)*this.len,cy+Math.sin(radians)*this.len);
		} else if(delta>0) {
			// segment is shorter than dash so only draw what is needed
			this.mc.lineTo(cx+Math.cos(radians)*delta,cy+Math.sin(radians)*delta);
		}
		// move the pen to the end position
		this.mc.moveTo(endx,endy);
	}
	
	/*inherited from Shape*/
	/**
	* @method lineStyle
	* @description 	define outline.		
	* 		
	* @usage   <pre>myLine.lineStyle();</pre>
	* 		<pre>myLine.lineStyle(lineThickness, lineRGB, lineAlpha);</pre>
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
	* @usage   <pre>myLine.animationStyle(duration);</pre>
	* 		<pre>myLine.animationStyle(duration, callback);</pre>
	* 		<pre>myLine.animationStyle(duration, easing, callback);</pre>
	* 	  
	* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @param callback (String) Function to invoke after animation. See APCore class.
	*/
	
	/*inherited from Line*/
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
	
	/**
	* @method getX1
	* @description returns a specific point of the outline.
	* @usage   <tt>myInstance.getX1();</tt>
	* @return Number
	*/	
	
	/**
	* @method setX1
	* @description 	sets a specific point of the outline.
	* @usage   <tt>myInstance.setX1();</tt>
	* @param point (Number)
	*/
	
	/**
	* @method getY1
	* @description returns a specific point of the outline.
	* @usage   <tt>myInstance.getY1();</tt>
	* @return Number
	*/
	
	/**
	* @method setY1
	* @description 	sets a specific point of the outline.
	* @usage   <tt>myInstance.setY1();</tt>
	* @param point (Number)
	*/	
	
	/**
	* @method getX2
	* @description returns a specific point of the outline.
	* @usage   <tt>myInstance.getX2();</tt>
	* @return Number
	*/	

	/**
	* @method setX2
	* @description 	sets a specific point of the outline.
	* @usage   <tt>myInstance.setX2();</tt>
	* @param point (Number)
	*/	
	
	/**
	* @method getY2
	* @description returns a specific point of the outline.
	* @usage   <tt>myInstance.getY2();</tt>
	* @return Number
	*/	

	/**
	* @method setY2
	* @description 	sets a specific point of the outline.
	* @usage   <tt>myInstance.setY2();</tt>
	* @param point (Number)
	*/		
	
	/**
	* @method clear
	* @description 	removes all drawings. Identical to myInstance.movieclip.clear();
	* @usage <pre>myInstance.clear();</pre>
	*/	
	
	/*inherited from AnimationCore*/
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
	* @param milliseconds (Number) optional property. Number of milliseconds or frames to pause before continuing animation.
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
	* @usage   <pre>myLine.addEventListener(event, listener);</pre>
	* 		    <pre>myLine.addEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myLine.removeEventListener(event, listener);</pre>
	* 		    <pre>myLine.removeEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myLine.removeAllEventListeners();</pre>
	* 		    <pre>myLine.removeAllEventListeners(event);</pre>
	* 	  
	*@param event (String) Event to remove all subscribed listeners from. If not specified, all listeners to any event will be removed.
	*/
	
	/*inherited from APCore*/
	/**
	* @method eventListenerExists
	* @description 	GDispatcher specific feature. Checks if a listener is already subscribed to a certain event.
	* 		
	* @usage   <pre>myLine.eventListenerExists(event, listener);</pre>
	* 			<pre>myLine.eventListenerExists(event, listener, handler);</pre>
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
		return "DashLine";
	}
}