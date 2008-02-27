import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.drawing.IDrawable;
import de.alex_uhlmann.animationpackage.drawing.IOutline;
import de.alex_uhlmann.animationpackage.drawing.Shape;
import de.alex_uhlmann.animationpackage.utility.Animator;
import de.alex_uhlmann.animationpackage.utility.BezierToolkit;

/**
* @class CubicCurve
* @author Alex Uhlmann
* @description CubicCurve is a class for drawing curves.
* 			If you specify a movieclip as first parameter, the shape will be drawn inside this movieclip. 
* 			If you omit the mc parameter, the class will create a new movieclip in _root.apContainer_mc.
* 			<p>
* 			Example 1: draw a curve with default parameters.		
* 			<blockquote><pre>
*			var myCubicCurve:CubicCurve = new CubicCurve();
*			myCubicCurve.draw();
*			</pre></blockquote> 
* 			Example 2: do the same, just animate it.		
* 			<blockquote><pre>
* 			var myCubicCurve:CubicCurve = new CubicCurve();
*			myCubicCurve.animate(0,100);
*			</pre></blockquote> 			
* 			Example 3: draw a curve with custom parameters. 
* 			<blockquote><pre>
*			var myCubicCurve:CubicCurve = new CubicCurve(100,100,300,300,500,100,500,400);
*			myCubicCurve.lineStyle(2,0xff0000,50);
*			myCubicCurve.draw();
*			</pre></blockquote>
* 			Example 4: the same like above using the getter/setter methods. 
* 			<blockquote><pre>
*			var myCubicCurve:CubicCurve = new CubicCurve();
*			myCubicCurve.lineStyle(2,0xff0000,50);
*			myCubicCurve.setX1(100);
*			myCubicCurve.setY1(100);
*			myCubicCurve.setX2(300);
*			myCubicCurve.setY2(300);
*			myCubicCurve.setX3(500);
*			myCubicCurve.setY3(100);
*			myCubicCurve.setX4(500);
*			myCubicCurve.setY4(400);
*			myCubicCurve.draw();
*			</pre></blockquote> 
* 			Example 5: <a href="CubicCurve_04.html">(Example .swf)</a> draw an animated curve with custom parameters, that 
* 			continues to animated to full size and back.
* 			<blockquote><pre>
*			var myCubicCurve:CubicCurve = new CubicCurve(50,100,200,300,400,100,550,400);
*			myCubicCurve.lineStyle(10,0xff0000,50);
*			myCubicCurve.animationStyle(2000,Circ.easeInOut,"onCallback");
*			myCubicCurve.animate(0, 100);
*			myListener.onCallback = function(source, value)
*			{	
*				if(value == 100) {
*					source.animate(100, 0);
*				} else {
*					source.animate(0, 100);
*				}	
*			}
*			</pre></blockquote> 	
* 			The curve is specified with four points. 
* 			Start point, two points on the curve and the end point.
*			Instead of the two points on the curve you can use 
* 			control points. For instance, the MovieClip.curveTo method uses control points.<p>
* @usage <pre>var myCubicCurve:CubicCurve = new CubicCurve();</pre> 
* 		<pre>var myCubicCurve:CubicCurve = new CubicCurve(x1, y1, x2, y2, x3, y3, x4, y4);</pre>
* 		<pre>var myCubicCurve:CubicCurve = new CubicCurve(x1, y1, x2, y2, x3, y3, x4, y4, withControlpoints);</pre> 
* 		<pre>var myCubicCurve:CubicCurve = new CubicCurve(mc, x1, y1, x2, y2, x3, y3, x4, y4);</pre>
* 		<pre>var myCubicCurve:CubicCurve = new CubicCurve(mc, x1, y1, x2, y2, x3, y3, x4, y4, withControlpoints);</pre>
* @param mc (MovieClip) existing movieclip to draw in.
* @param x1 (Number) start point to define curve. Coordinate point x
* @param y1 (Number) start point to define curve. Coordinate point y
* @param x2 (Number) point on the curve or control point to define curve. Coordinate point x
* @param y2 (Number) point on the curve or control point to define curve. Coordinate point y
* @param x3 (Number) point on the curve or control point to define curve. Coordinate point x
* @param y3 (Number) point on the curveor control point to define curve. Coordinate point y
* @param x4 (Number) end point to define curve. Coordinate point x
* @param y4 (Number) end point to define curve. Coordinate point y 
* @param withControlpoints (Boolean) specify control points between the start and end points of the curve instead of points on the curve. Default is false.
*/
class de.alex_uhlmann.animationpackage.drawing.CubicCurve 
									extends Shape 
									implements IDrawable, 
											IOutline, 
											ISingleAnimatable {	
	
	/*static default properties*/
	/*lineStyle properties inherited from Shape*/	
	/*animationStyle properties inherited from APCore*/	
	/** 
	* @property x1_def (Number)(static) default property. start point to define curve. Coordinate point x.
	* @property y1_def (Number)(static) default property. start point to define curve. Coordinate point y.
	* @property x2_def (Number)(static) default property. point on the curve or control point to define curve. Coordinate point x.
	* @property y2_def (Number)(static) default property. point on the curve or control point to define curve. Coordinate point y.
	* @property x3_def (Number)(static) default property. point on the curve or control point to define curve. Coordinate point x.
	* @property y3_def (Number)(static) default property. point on the curveor control point to define curve. Coordinate point y.
	* @property x4_def (Number)(static) default property. end point to define curve. Coordinate point x.
	* @property y4_def (Number)(static) default property. end point to define curve. Coordinate point y.
	* 
	* @property movieclip (MovieClip)(read only) Movieclip that contains the drawing.
	* @property lineThickness (Number) Outline thickness.
	* @property lineRGB (Number) Outline color of the drawing as hex number.
	* @property lineAlpha (Number) Outline transparency (alpha).	
	* @property duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @property easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @property callback (String) Function to invoke after animation. See APCore class. 
	*/
	public static var x1_def:Number = 0;
	public static var y1_def:Number = 0;	
	public static var x2_def:Number = 180;
	public static var y2_def:Number = 400;	
	public static var x3_def:Number = 400;
	public static var y3_def:Number = 0;
	public static var x4_def:Number = 550;
	public static var y4_def:Number = 400;		
	private var myBezierToolkit:BezierToolkit;
	/*start, control and end points of curve*/
	private var x1:Number;
	private var y1:Number;
	private var x2:Number;
	private var y2:Number;
	private var x3:Number;
	private var y3:Number;
	private var x4:Number;
	private var y4:Number;
	private var p1:Object;
	private var p2:Object;
	private var p3:Object;
	private var p4:Object;
	private var x1Orig:Number;
	private var y1Orig:Number;
	private var x2Orig:Number;
	private var y2Orig:Number;
	private var x3Orig:Number;
	private var y3Orig:Number;
	private var x4Orig:Number;
	private var y4Orig:Number;	
	private var withControlpoints:Boolean = false;
	private var x2ControlPoint:Number;
	private var y2ControlPoint:Number;
	private var x3ControlPoint:Number;
	private var y3ControlPoint:Number;
	public var mode:String = "REDRAW";
	private var lastStep:Number = 0;
	private var overriddenRounded:Boolean = true;
	private var overriddedOptimize:Boolean = true;
	
	public function CubicCurve() {
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

	private function initCustom(mc:MovieClip, x1:Number, y1:Number, x2:Number, y2:Number, 
						x3:Number, y3:Number, x4:Number, y4:Number, withControlpoints:Boolean):Void {		
		
		this.mc = this.createClip({mc:mc, x:0, y:0});		
		this.initShape.apply(this,arguments.slice(1));
	}

	private function initAuto(x1:Number, y1:Number, x2:Number, y2:Number, 
						x3:Number, y3:Number, x4:Number, y4:Number, withControlpoints:Boolean):Void {		
		
		this.mc = this.createClip({name:"apDraw", x:0, y:0});		
		this.initShape.apply(this,arguments);
	}
		
	private function initShape(x1:Number, y1:Number, x2:Number, y2:Number, 
						x3:Number, y3:Number, x4:Number, y4:Number, withControlpoints:Boolean):Void {
		
		this.x1 = (x1 == null) ? CubicCurve.x1_def : x1;
		this.y1 = (y1 == null) ? CubicCurve.y1_def : y1;
		this.x2 = (x2 == null) ? CubicCurve.x2_def : x2;
		this.y2 = (y2 == null) ? CubicCurve.y2_def : y2;
		this.x3 = (x3 == null) ? CubicCurve.x3_def : x3;
		this.y3 = (y3 == null) ? CubicCurve.y3_def : y3;
		this.x4 = (x4 == null) ? CubicCurve.x4_def : x4;
		this.y4 = (y4 == null) ? CubicCurve.y4_def : y4;
		if(withControlpoints != null) {
			this.withControlpoints = withControlpoints;
		}
		this.x1Orig = this.x1;
		this.y1Orig = this.y1;
		this.x2Orig = this.x2;
		this.y2Orig = this.y2;
		this.x3Orig = this.x3;
		this.y3Orig = this.y3;
		this.x4Orig = this.x4;
		this.y4Orig = this.y4;
		this.myBezierToolkit = new BezierToolkit();
	}

	/*inherited from Shape*/
	/**
	* @method draw
	* @description 	Draws the curve.
	* @usage <pre>myCubicCurve.draw();</pre>
	*/	
	public function draw(Void):Void {
		this.setInitialized(false);
		this.setDefaultRegistrationPoint({position:"CENTER"});
		this.clearDrawing();
		this.mc.moveTo(this.x1, this.y1);		
		this.drawNew();
	}
	
	/**
	* @method drawBy
	* @description 	Draws the line without clearing the movieclip.
	* @usage <pre>myCubicCurve.drawBy();</pre>
	*/
	public function drawBy(Void):Void {
		this.initControlPoints();
		
		if(this.lineStyleModified) {
			this.mc.lineStyle(this.lineThickness, this.lineRGB, this.lineAlpha);
		}
		if(this.penX != this.x1 || this.penY != this.y1) {			
			this.mc.moveTo(this.x1, this.y1);
		}
		
		this.drawNew();
	}
	
	public function drawTo(Void):Void {
		this.drawNew();
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
			this.setInitialized(false);
			this.setDefaultRegistrationPoint({position:"CENTER"});	
			if(overriddedOptimize) {
				setter = "drawLineCurve";
			} else {
				setter = "drawLineCurveSecure";
			}
		} else if(this.mode == "DRAW"){
			this.initControlPoints();			
			if(this.penX != this.x1 || this.penY != this.y1) {			
				if(this.lineStyleModified) {
					this.mc.lineStyle(this.lineThickness, this.lineRGB, this.lineAlpha);
				}
				this.mc.moveTo(this.x1, this.y1);
			}
			if(overriddedOptimize) {
				setter = "drawLineCurveBy";
			} else {
				setter = "drawLineCurveBySecure";
			}			
		} else {
			setter = "drawLineCurveBy";
		}
		this.startValue = 0;
		this.endValue = 100;		
		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		this.myAnimator.start = [0];
		this.myAnimator.end = [100];
		this.myAnimator.setter = [[this, setter]];
		if(goto == false) {
			this.myAnimator.animationStyle(this.duration, this.easing, this.callback);
			this.myAnimator.animate(start, end);
		} else {
			if(this.mode == "DRAWTO")return;
			this.myAnimator.goto(end);
		}		
	}
	
	/**
	* @method animate
	* @description 	Draws an animated curve.		
	* @usage  	<pre>myCubicCurve.animate(orig, targ);</pre>  
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
	* @usage  	<pre>myCubicCurve.animateBy(start, end);</pre>  
	* @param start (Number) A percent value that specifies where the animation shall beginn. (0 - 100).
	* @param end (Number) A percent value that specifies where the animation shall end. (0 - 100).
	*/	
	public function animateBy(start:Number, end:Number):Void {		
		this.mode = "DRAW";
		this.invokeAnimation(start, end);
	}
	
	public function animateTo(start:Number, end:Number):Void {		
		this.mode = "DRAWTO";
		this.invokeAnimation(start, end);
	}	
	
	/**
	* @method goto
	* @description 	jumps to a specific step of the animation and stays there.
	* @usage   <pre>instance.goto(percentage);</pre>
	* @param percentage (Number) Percentage value of the animation.
	* @return void
	*/	
	
	private function drawNew(Void):Void {
		var myCC:com.robertpenner.bezier.CubicCurve = new com.robertpenner.bezier.CubicCurve(this.mc);
		myCC.drawBezier(this.x1, this.y1, this.x2, this.y2, this.x3, this.y3, this.x4, this.y4, 1);
		this.penX = this.x4;
		this.penY = this.y4;
	}
	
	private function drawLineCurve(v:Number):Void {		
		if(this.lastStep == 0) {
			if(this.lineStyleModified) {
				this.mc.lineStyle(this.lineThickness, this.lineRGB, this.lineAlpha);
			}
			this.mc.moveTo(this.x1, this.y1);
		}
		var len:Number;
		
		if(overriddenRounded) {
			len = Math.round(v);	
		} else {
			len = v;
		}

		var s:Number;
		if(len < this.lastStep) {
			this.clearDrawing();
			this.mc.moveTo(this.x1, this.y1);
			s = this.startValue;
		} else {
			s = this.lastStep;
		}
		if(len == this.lastStep) {
			return;
		}
		this.lastStep = len;
		var p:Object;
		var i:Number;
		for(i = s; i <= len; i++) {
			p = this.myBezierToolkit.getPointsOnCubicCurve(i, this.p1, this.p2, this.p3, this.p4);
			this.mc.lineTo(p.x, p.y);			
		}
	}
	
	private function drawLineCurveBy(v:Number):Void {		
		var p:Object;
		var s:Number = (this.lastStep == null) ? this.startValue : this.lastStep;		
		var len:Number;
		if(overriddenRounded) {
			len = Math.round(v);	
		} else {
			len = v;
		}
		if(len == this.lastStep) {
			return;
		}		
		this.lastStep = len;
		var i:Number;		
		for(i = s; i <= len; i++) {
			p = this.myBezierToolkit.getPointsOnCubicCurve(i, this.p1, this.p2, this.p3, this.p4);
			this.mc.lineTo(p.x, p.y);				
		}
	}	
	
	//clunky and slow. I don't like it. But it does the job.
	private function drawLineCurveSecure(v:Number):Void {		
		this.clearDrawing();
		this.mc.moveTo(this.x1, this.y1);		
		var p:Object;
		var s:Number = this.startValue;		
		var len:Number = Math.round(v);		
		var i:Number;
		for(i = s; i <= len; i++) {
			p = this.myBezierToolkit.getPointsOnCubicCurve(i, this.p1, this.p2, this.p3, this.p4);
			this.mc.lineTo(p.x, p.y);	
		}
	}
	
	private function drawLineCurveBySecure(v:Number):Void {		
		this.mc.moveTo(this.x1, this.y1);		
		var p:Object;
		var s:Number = this.startValue;		
		var len:Number = Math.round(v);
		var i:Number;
		for(i = s; i <= len; i++) {
			p = this.myBezierToolkit.getPointsOnCubicCurve(i, this.p1, this.p2, this.p3, this.p4);
			this.mc.lineTo(p.x, p.y);
		}
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
		if(withControlpoints && this.initialized == true) {
			this.x2 = this.x2ControlPoint;
			this.y2 = this.y2ControlPoint;
			this.x3 = this.x3ControlPoint;
			this.y3 = this.y3ControlPoint;
			this.p2 = {x:this.x2, y:this.y2};
			this.p3 = {x:this.x3, y:this.y3};
		}
		this.withControlpoints = withControlpoints;		
	}
	
	public function initControlPoints(Void):Void {
		if(!this.initialized) {
			if(this.withControlpoints == false) {
				this.x2ControlPoint = x2;
				this.y2ControlPoint = y2;
				this.x3ControlPoint = x3;
				this.y3ControlPoint = y3;
				var controlPoint:Object = this.myBezierToolkit.getCubicControlPoints(this.x1, this.y1, 
								this.x2, this.y2, this.x3, this.y3, this.x4, this.y4);
				this.x2 = controlPoint.x1;
				this.y2 = controlPoint.y1;
				this.x3 = controlPoint.x2;
				this.y3 = controlPoint.y2;				
			}
			this.p1 = {x:this.x1, y:this.y1};
			this.p2 = {x:this.x2, y:this.y2};
			this.p3 = {x:this.x3, y:this.y3};
			this.p4 = {x:this.x4, y:this.y4};
			this.initialized = true;
		}
	}
	
	/*inherited from Shape*/
	/**
	* @method lineStyle
	* @description 	define outline.		
	* 		
	* @usage   <pre>myCubicCurve.lineStyle();</pre>
	* 		<pre>myCubicCurve.lineStyle(lineThickness, lineRGB, lineAlpha);</pre>
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
	* @usage   <pre>myCubicCurve.animationStyle(duration);</pre>
	* 		<pre>myCubicCurve.animationStyle(duration, callback);</pre>
	* 		<pre>myCubicCurve.animationStyle(duration, easing, callback);</pre>
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
		this.initialized = false;
		
		var centerX:Number;
		var centerY:Number;
		
		var minX:Number = Math.min(Math.min(Math.min(this.x1Orig, this.x2Orig), this.x3Orig), this.x4Orig);
		var maxX:Number = Math.max(Math.max(Math.max(this.x1Orig, this.x2Orig), this.x3Orig), this.x4Orig);
		var minY:Number = Math.min(Math.min(Math.min(this.y1Orig, this.y2Orig), this.y3Orig), this.y4Orig);
		var maxY:Number = Math.max(Math.max(Math.max(this.y1Orig, this.y2Orig), this.y3Orig), this.y4Orig);		
		
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
		this.x1 = this.x1Orig - centerX;
		this.y1 = this.y1Orig - centerY;
		this.x2 = this.x2Orig - centerX;
		this.y2 = this.y2Orig - centerY;
		this.x3 = this.x3Orig - centerX;
		this.y3 = this.y3Orig - centerY;
		this.x4 = this.x4Orig - centerX;
		this.y4 = this.y4Orig - centerY;
		this.initControlPoints();
	}	
	
	private function setDefaultRegistrationPoint(registrationObj:Object):Void {		
		if(!this.initialized) {
			this.setRegistrationPoint(registrationObj);
		}
	}
	
	public function reset() {
		this.x1 = this.x1Orig;
		this.y1 = this.y1Orig;
		this.x2 = this.x2Orig;
		this.y2 = this.y2Orig;
		this.x3 = this.x3Orig;
		this.y3 = this.y3Orig;
		this.x4 = this.x4Orig;
		this.y4 = this.y4Orig;
		this.initialized = false;
		this.initControlPoints();		
	}

	/**
	* @method getX1
	* @description returns a specific point of the outline.
	* @usage   <tt>myInstance.getX1();</tt>
	* @return Number
	*/	
	public function getX1(Void):Number {
		return this.x1;
	}
	
	/**
	* @method setX1
	* @description 	sets a specific point of the outline.
	* @usage   <tt>myInstance.setX1();</tt>
	* @param point (Number)
	*/
	public function setX1(x1:Number):Void {
		this.x1Orig = x1;
		this.x1 = x1;
	}
	
	/**
	* @method getY1
	* @description returns a specific point of the outline.
	* @usage   <tt>myInstance.getY1();</tt>
	* @return Number
	*/
	public function getY1(Void):Number {
		return this.y1;
	}
	
	/**
	* @method setY1
	* @description 	sets a specific point of the outline.
	* @usage   <tt>myInstance.setY1();</tt>
	* @param point (Number)
	*/	
	public function setY1(y1:Number):Void {
		this.y1Orig = y1;
		this.y1 = y1;
	}	
	
	/**
	* @method getX2
	* @description returns a specific point of the outline.
	* @usage   <tt>myInstance.getX2();</tt>
	* @return Number
	*/	
	public function getX2(Void):Number {
		return this.x2;
	}
	
	/**
	* @method setX2
	* @description 	sets a specific point of the outline.
	* @usage   <tt>myInstance.setX2();</tt>
	* @param point (Number)
	*/	
	public function setX2(x2:Number):Void {
		this.x2Orig = x2;
		this.x2 = x2;
	}
	
	/**
	* @method getY2
	* @description returns a specific point of the outline.
	* @usage   <tt>myInstance.getY2();</tt>
	* @return Number
	*/
	public function getY2(Void):Number {
		return this.y2;
	}
	
	/**
	* @method setY2
	* @description 	sets a specific point of the outline.
	* @usage   <tt>myInstance.setY2();</tt>
	* @param point (Number)
	*/		
	public function setY2(y2:Number):Void {
		this.y2Orig = y2;
		this.y2 = y2;
	}
	
	/**
	* @method getX3
	* @description returns a specific point of the outline.
	* @usage   <tt>myInstance.getX3();</tt>
	* @return Number
	*/	
	public function getX3(Void):Number {
		return this.x3;
	}
	
	/**
	* @method setX3
	* @description 	sets a specific point of the outline.
	* @usage   <tt>myInstance.setX3();</tt>
	* @param point (Number)
	*/	
	public function setX3(x3:Number):Void {
		this.x3Orig = x3;
		this.x3 = x3;
	}
	
	/**
	* @method getY3
	* @description returns a specific point of the outline.
	* @usage   <tt>myInstance.getY3();</tt>
	* @return Number
	*/	
	public function getY3(Void):Number {
		return this.y3;
	}
	
	/**
	* @method setY3
	* @description 	sets a specific point of the outline.
	* @usage   <tt>myInstance.setY3();</tt>
	* @param point (Number)
	*/	
	public function setY3(y3:Number):Void {
		this.y3Orig = y3;
		this.y3 = y3;
	}
	
	/**
	* @method getX4
	* @description returns a specific point of the outline.
	* @usage   <tt>myInstance.getX4();</tt>
	* @return Number
	*/	
	public function getX4(Void):Number {
		return this.x4;
	}
	
	/**
	* @method setX4
	* @description 	sets a specific point of the outline.
	* @usage   <tt>myInstance.setX4();</tt>
	* @param point (Number)
	*/	
	public function setX4(x4:Number):Void {
		this.x4Orig = x4;
		this.x4 = x4;
	}
	
	/**
	* @method getY4
	* @description returns a specific point of the outline.
	* @usage   <tt>myInstance.getY4();</tt>
	* @return Number
	*/	
	public function getY4(Void):Number {
		return this.y4;
	}
	
	/**
	* @method setY4
	* @description 	sets a specific point of the outline.
	* @usage   <tt>myInstance.setY4();</tt>
	* @param point (Number)
	*/	
	public function setY4(y4:Number):Void {
		this.y4Orig = y4;
		this.y4 = y4;
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
	public function getOptimizationMode(Void):Boolean {		
		return this.overriddedOptimize;
	}
	
	public function setOptimizationMode(overriddedOptimize:Boolean):Void {		
		this.overriddedOptimize = overriddedOptimize;
	}
	
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
	* @usage   <pre>myCubicCurve.addEventListener(event, listener);</pre>
	* 		    <pre>myCubicCurve.addEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myCubicCurve.removeEventListener(event, listener);</pre>
	* 		    <pre>myCubicCurve.removeEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myCubicCurve.removeAllEventListeners();</pre>
	* 		    <pre>myCubicCurve.removeAllEventListeners(event);</pre>
	* 	  
	*@param event (String) Event to remove all subscribed listeners from. If not specified, all listeners to any event will be removed.
	*/
	
	/*inherited from APCore*/
	/**
	* @method eventListenerExists
	* @description 	GDispatcher specific feature. Checks if a listener is already subscribed to a certain event.
	* 		
	* @usage   <pre>myCubicCurve.eventListenerExists(event, listener);</pre>
	* 			<pre>myCubicCurve.eventListenerExists(event, listener, handler);</pre>
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
		return "CubicCurve";
	}
}