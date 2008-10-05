import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.Animator;
import de.alex_uhlmann.animationpackage.utility.BezierToolkit;

/**
* @class MoveOnCubicCurve
* @author Alex Uhlmann, Steve Schwarz
* @description  Moves a movieclip along a specified cubic bezier curve in a specified time and easing equation.
* 			The curve is specified with four points. Start point, two points on the curve or control points, end point.
* 			With the useControlPoints method you can specify control points instead of points on the curve, 
* 			which is the default. The MovieClip.curveTo method uses control points i.e.
* 			<p>
* 			Example 1: <a href="MoveOnCubicCurve_run_01.html">(Example .swf)</a> 
* 			Declare 8 variables to store the four points that define the curve 
* 			for easy access. To visualize the points and the curve draw it with 
* 			the classes of the de.alex_uhlmann.animationpackage.drawing package. Then, 
*  			move the movieclip along the specified curve in three seconds using Bounce easing.
* 			Draw circles on the current positions of the movieclip.
*  			<pre><blockquote>
*			var x1:Number = 100;
*			var y1:Number = 100;
*			var x2:Number = 300;
*			var y2:Number = 300;
*			var x3:Number = 500;
*			var y3:Number = 100;
*			var x4:Number = 500;
*			var y4:Number = 400;
*			
*			new Ellipse(x1,y1,10,10).draw();						
*			new Ellipse(x2,y2,10,10).draw();
*			new Ellipse(x3,y3,10,10).draw();
*			new Ellipse(x4,y4,10,10).draw();
*			
*			var myEllipse:Ellipse = new Ellipse(x1,y1,15,15)
*			myEllipse.lineStyle(1,0xff0000);
*			myEllipse.fillStyle(0xff0000);
*			myEllipse.draw();
*			
*			var myMOC:MoveOnCubicCurve = new MoveOnCubicCurve(myEllipse.movieclip);
*			myMOC.animationStyle(3000,Bounce.easeOut);
*			//draw a circle in every function update.
*			var myObject:Object = new Object();
*			myMOC.addEventListener("onUpdate",myObject);
*			myObject.onUpdate = function(eventObject:Object) {
*				var mc:MovieClip = eventObject.target.movieclip;
* 				new Ellipse(mc._x,mc._y,3,3).draw();
*			}
*			
*			myMOC.run(x1,y1,x2,y2,x3,y3,x4,y4);
*			</pre></blockquote>
* 			Example 2: Move a movieclip along the curve in 4 seconds using circular easing. 		
* 			<blockquote><pre>
*			new MoveOnQuadCurve(mc).run(100,100,300,300,500,100,500,400,4000,Circ.easeInOut);			
* 			</pre></blockquote>
* 			<p>		
* 			You can specify the duration, easing equation and callback properties 
* 			either with setting the properies directly or with the animationStyle() method 
* 			like it is used in de.alex_uhlmann.animationpackage.drawing.
* 			<p>
* 			Example 3:
* 			<blockquote><pre>			
*			var myMOC:MoveOnCubicCurve = new MoveOnCubicCurve(mc);
*			myMOC.animationStyle(4000,Circ.easeInOut);
*			myMOC.run(100,100,300,300,500,100,500,400);
*			</pre></blockquote>  			
* 			Example 4: The alternative way is shorter. The same like above in one line.
* 			<blockquote><pre>	
* 			new MoveOnCubicCurve(mc).run(100,100,300,300,500,100,500,400,4000,Circ.easeInOut);
* 			</pre></blockquote>		
*  			Example 5: You can also specify the properties via the constructor. 
* 			This might come in handy if you're using the Sequence or Parallel class.  
* 			Take a look at their class documentations for more information. 
* 			The animate() method and its start and end percentage parameters might also be useful. 
* 			<blockquote><pre>
* 			var myMoveOnCubicCurve:MoveOnCubicCurve = new MoveOnCubicCurve(mc,100,100,300,300,500,100,500,400,4000,Circ.easeInOut);
* 			myMoveOnCubicCurve.animate(0,100);
* 			</pre></blockquote>
* @usage <pre>var myMOC:MoveOnCubicCurve = new MoveOnCubicCurve(mc);</pre> 
* 		<pre>var myMOC:MoveOnCubicCurve = new MoveOnCubicCurve(mc, x1, y1, x2, y2, x3, y3, x4, y4);</pre>
*		<pre>var myMOC:MoveOnCubicCurve = new MoveOnCubicCurve(mc, x1, y1, x2, y2, x3, y3, x4, y4, duration);</pre>
* 		<pre>var myMOC:MoveOnCubicCurve = new MoveOnCubicCurve(mc, x1, y1, x2, y2, x3, y3, x4, y4, duration, callback);</pre>
* 		<pre>var myMOC:MoveOnCubicCurve = new MoveOnCubicCurve(mc, x1, y1, x2, y2, x3, y3, x4, y4, duration, easing, callback);</pre>
* 		<pre>var myMOC:MoveOnCubicCurve = new MoveOnCubicCurve(mc, x1, y1, x2, y2, x3, y3, x4, y4, withControlpoints);</pre>
*		<pre>var myMOC:MoveOnCubicCurve = new MoveOnCubicCurve(mc, x1, y1, x2, y2, x3, y3, x4, y4, withControlpoints, duration);</pre>
* 		<pre>var myMOC:MoveOnCubicCurve = new MoveOnCubicCurve(mc, x1, y1, x2, y2, x3, y3, x4, y4, withControlpoints, duration, callback);</pre>
* 		<pre>var myMOC:MoveOnCubicCurve = new MoveOnCubicCurve(mc, x1, y1, x2, y2, x3, y3, x4, y4, withControlpoints, duration, easing, callback);</pre>
* @param mc (MovieClip) Movieclip to animate.
* @param x1 (Number) start point to define curve. Coordinate point x
* @param y1 (Number) start point to define curve. Coordinate point y
* @param x2 (Number) point on the curve or control point to define curve. Coordinate point x
* @param y2 (Number) point on the curve or control point to define curve. Coordinate point y
* @param x3 (Number) point on the curve or control point to define curve. Coordinate point x
* @param y3 (Number) point on the curveor control point to define curve. Coordinate point y
* @param x4 (Number) end point to define curve. Coordinate point x
* @param y4 (Number) end point to define curve. Coordinate point y 
* @param withControlpoints (Boolean) specify control points between the start and end points of the curve instead of points on the curve. Default is false.
* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
* @param callback (String) Function to invoke after animation. See APCore class.
*/
class de.alex_uhlmann.animationpackage.animation.MoveOnCubicCurve 
											extends AnimationCore 
											implements ISingleAnimatable {	
	
	/*animationStyle properties inherited from AnimationCore*/
	/** 
	* @property duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @property easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @property callback (String) Function to invoke after animation. See APCore class. 
	*/	
	private var mc:MovieClip;
	private var x1:Number;
	private var y1:Number;
	private var x2:Number;
	private var y2:Number;
	private var x3:Number;
	private var y3:Number;
	private var x4:Number;
	private var y4:Number;
	private var myBezierToolkit:BezierToolkit;
	private var p1:Object;
	private var p2:Object;
	private var p3:Object;
	private var p4:Object;
	private var withControlpoints:Boolean = false;
	private var x2ControlPoint:Number;
	private var y2ControlPoint:Number;
	private var x3ControlPoint:Number;
	private var y3ControlPoint:Number;
	private var rotateTo:Boolean = false;
	private var rotateOn:Boolean = false;
	private var overriddenRounded:Boolean = false;
	
	/*
	* cache for last point calculated by getPointsOnCurve. 
	* Used to calculate slope/rotation
	*/
	private var lastPoint:Object;
	
	public function MoveOnCubicCurve() {				
		super();
		this.mc = arguments[0];
		if(arguments.length > 1) {			
			this.initAnimation.apply(this, arguments.slice(1));
		}
	}
	
	private function initAnimation(x1:Number, y1:Number, x2:Number, 
							y2:Number, x3:Number, y3:Number, x4:Number, y4:Number, withControlpoints:Object, 
							duration:Object, easing:Object, callback:String):Void {		
		
		var paramLen:Number = 8;
		
		var temp;
		if(typeof(withControlpoints) == "number") {
			temp = withControlpoints;
			var temp_ms:Number = temp;                  
			var temp_easing = duration;
			temp = easing;
			easing = temp_easing;
		        callback = temp;			
			this.animationStyle(temp_ms, easing, callback);
		} else if (arguments.length > paramLen) {
			temp = duration;
			this.animationStyle(temp, easing, callback);
		} else {
			this.animationStyle(this.duration, this.easing, this.callback);
		}
		this.myBezierToolkit = new BezierToolkit();
		if(typeof(withControlpoints) == "boolean") {
			temp = withControlpoints;
			this.withControlpoints = temp;
		}
		if(this.withControlpoints == false) {
			
			this.x2ControlPoint = x2;
			this.y2ControlPoint = y2;
			this.x3ControlPoint = x3;
			this.y3ControlPoint = y3;
			var controlPoint:Object = this.myBezierToolkit.getCubicControlPoints(x1, y1, x2, y2, x3, y3, x4, y4);
			x2 = controlPoint.x1;
			y2 = controlPoint.y1;
			x3 = controlPoint.x2;
			y3 = controlPoint.y2;
		}
		this.init(x1, y1, x2, y2, x3, y3, x4, y4);
		this.setStartValue(0);
		this.setEndValue(100);		
	}
	
	private function init():Void {
				
		this.x1 = arguments[0];
		this.y1 = arguments[1];
		this.x2 = arguments[2];
		this.y2 = arguments[3];
		this.x3 = arguments[4];
		this.y3 = arguments[5];
		this.x4 = arguments[6];
		this.y4 = arguments[7];
		this.p1 = {x:this.x1, y:this.y1};
		this.p2 = {x:this.x2, y:this.y2};
		this.p3 = {x:this.x3, y:this.y3};
		this.p4 = {x:this.x4, y:this.y4};		
	}
	
	private function invokeAnimation(start:Number, end:Number):Void {		
		this.startInitialized = false;
		
		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		this.myAnimator.start = [0];
		this.myAnimator.end = [100];
		if(this.rotateTo == true) {
			this.myAnimator.setter = [[this,"moveAndRotateTo"]];
		} else if(this.rotateOn == true) {
			this.myAnimator.setter = [[this,"moveAndRotateOn"]];
		} else {
			this.myAnimator.setter = [[this,"move"]];				
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
	* @usage  
	* 		<pre>myMOC.run(x1, y1, x2, y2, x3, y3, x4, y4);</pre>
	*		<pre>myMOC.run(x1, y1, x2, y2, x3, y3, x4, y4, duration);</pre>
	* 		<pre>myMOC.run(x1, y1, x2, y2, x3, y3, x4, y4, duration, callback);</pre>
	* 		<pre>myMOC.run(x1, y1, x2, y2, x3, y3, x4, y4, duration, easing, callback);</pre>
	* 		<pre>myMOC.run(x1, y1, x2, y2, x3, y3, x4, y4, withControlpoints);</pre>
	*		<pre>myMOC.run(x1, y1, x2, y2, x3, y3, x4, y4, withControlpoints, duration);</pre>
	* 		<pre>myMOC.run(x1, y1, x2, y2, x3, y3, x4, y4, withControlpoints, duration, callback);</pre>
	* 		<pre>myMOC.run(x1, y1, x2, y2, x3, y3, x4, y4, withControlpoints, duration, easing, callback);</pre>
	* 	  
	* @param x1 (Number) start point to define curve. Coordinate point x
	* @param y1 (Number) start point to define curve. Coordinate point y
	* @param x2 (Number) point on the curve or control point to define curve. Coordinate point x
	* @param y2 (Number) point on the curve or control point to define curve. Coordinate point y
	* @param x3 (Number) point on the curve or control point to define curve. Coordinate point x
	* @param y3 (Number) point on the curveor control point to define curve. Coordinate point y
	* @param x4 (Number) end point to define curve. Coordinate point x
	* @param y4 (Number) end point to define curve. Coordinate point y 
	* @param withControlpoints (Boolean) specify control points between the start and end points of the curve instead of points on the curve. Default is false.
	* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @param callback (String) Function to invoke after animation. See APCore class.
	* @return void
	*/	
	public function run():Void {							
		
		this.initAnimation.apply(this, arguments);
		this.invokeAnimation(0, 100);
	}
	
	/**
	* @method animate
	* @description 	similar to the run() method. Offers start and end parameters.
	* @usage   <pre>myMOC.animate(start, end);</pre> 	  
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
	
	private function move(targ:Number):Void {
		var p:Object = this.myBezierToolkit.getPointsOnCubicCurve(targ, this.p1, this.p2, this.p3, this.p4);
		if(overriddenRounded) {
			this.mc._x = Math.round(p.x);
			this.mc._y = Math.round(p.y);			
		}
		else {
			this.mc._x = p.x;
			this.mc._y = p.y;			
		}
	}
	
	private function moveAndRotateTo(targ:Number):Void {
		var p:Object = this.myBezierToolkit.getPointsOnCubicCurve(targ, 
												this.p1, 
												this.p2, 
												this.p3, 
												this.p4);
		if(overriddenRounded) {
			this.mc._x = Math.round(p.x);
			this.mc._y = Math.round(p.y);
			this.mc._rotation = Math.round(this.computeRotation(targ, p) - 90);
		}
		else {
			this.mc._x = p.x;
			this.mc._y = p.y;
			this.mc._rotation = this.computeRotation(targ, p) - 90;
		}		
	}
	
	private function moveAndRotateOn(targ:Number):Void {
		var p:Object = this.myBezierToolkit.getPointsOnCubicCurve(targ, 
												this.p1, 
												this.p2, 
												this.p3, 
												this.p4);
		if(overriddenRounded) {
			this.mc._x = Math.round(p.x);
			this.mc._y = Math.round(p.y);
			this.mc._rotation = Math.round(this.computeRotation(targ, p));
		}
		else {
			this.mc._x = p.x;
			this.mc._y = p.y;
			this.mc._rotation = this.computeRotation(targ, p);
		}
	}
	
	private function computeRotation(targ:Number, p:Object):Number {
		if (this.lastPoint.x == undefined) {
			//just calculated the first point. Store it.
			this.lastPoint = p;
			//go 1% forward to get next point
			p = this.myBezierToolkit.getPointsOnCubicCurve(
									targ + 1, 
									this.p1, 
									this.p2, 
									this.p3, 
									this.p4);
		}
		var degrees:Number = Math.atan2(this.lastPoint.y-p.y, this.lastPoint.x-p.x)/(Math.PI/180);
		//update cache
		this.lastPoint = p;
		return degrees;
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
	* @method orientToPath
	* @description 	offers the opportunity to rotate the object towards the curve while animating.
	* 				Default is false. If true the object orientates towards the curve.
	*                  		If false the object's rotation will not be altered. See class documentation.
	* @usage   <pre>myInstance.orientToPath(rotateTo);</pre> 	  
	* @param rotateTo (Boolean) <code>true</code> or <code>false</code>.
	* @return void
	*/	
	public function orientToPath(bool:Boolean):Void {
		if(bool) {
			this.rotateOn = false;
		}
		this.rotateTo = bool;
	}
	
	/**
	* @method orientOnPath
	* @description 	offers the opportunity to rotate the object on the curve while animating.
	* 				Default is false. If true the object orientates on the curve.
	*                  		If false the object's rotation will not be altered. See class documentation.
	* @usage   <pre>myInstance.orientToPath(rotateOn);</pre> 	  
	* @param rotateOn (Boolean) <code>true</code> or <code>false</code>.
	* @return void
	*/	
	public function orientOnPath(bool:Boolean):Void {
		if(bool) {
			this.rotateTo = false;
		}
		this.rotateOn = bool;
	}
	
	/**
	* @method useControlPoints
	* @description 	offers the opportunity to specify control points between the start and end points 
	* 				of the curve instead of points on the curve. Default is false.
	* 				If true points between start and end points are control points.
	*                  		If false points between start and end points are points on the curve.
	* @usage   <pre>myInstance.useControlPoints(withControlpoints);</pre> 	  
	* @param withControlpoints (Boolean) <code>true</code> or <code>false</code>.
	* @return void
	*/
	public function useControlPoints(withControlpoints:Boolean):Void {
		if(withControlpoints) {
			this.x2 = this.x2ControlPoint;
			this.y2 = this.y2ControlPoint;
			this.x3 = this.x3ControlPoint;
			this.y3 = this.y3ControlPoint;
			this.p2 = {x:this.x2, y:this.y2};
			this.p3 = {x:this.x3, y:this.y3};
		}
		this.withControlpoints = withControlpoints;		
	}
	
	/**
	* @method roundResult
	* @description 	rounds animation results to integers. (might be usefull for animating pixelfonts). Default is false.		
	* @usage   <pre>myInstance.roundResult(event, listener);</pre>
	*@param rounded (Boolean) <code>true</code> rounds the result. Animates with integers. Less accuracy.
	*                  				<code>false</code> animates with floating point numbers.
	*/
	public function checkIfRounded(Void):Boolean {
		return this.overriddenRounded;
	}
	
	public function roundResult(overriddenRounded:Boolean):Void {
		this.overriddenRounded = overriddenRounded;
	}
	
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
	* @usage   <pre>myMOC.addEventListener(event, listener);</pre>
	* 		    <pre>myMOC.addEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myMOC.removeEventListener(event, listener);</pre>
	* 		    <pre>myMOC.removeEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myMOC.removeAllEventListeners();</pre>
	* 		    <pre>myMOC.removeAllEventListeners(event);</pre>
	* 	  
	*@param event (String) Event to remove all subscribed listeners from. If not specified, all listeners to any event will be removed.
	*/
	
	/*inherited from APCore*/
	/**
	* @method eventListenerExists
	* @description 	GDispatcher specific feature. Checks if a listener is already subscribed to a certain event.
	* 		
	* @usage   <pre>myMOC.eventListenerExists(event, listener);</pre>
	* 			<pre>myMOC.eventListenerExists(event, listener, handler);</pre>
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
		return "MoveOnCubicCurve";
	}
}