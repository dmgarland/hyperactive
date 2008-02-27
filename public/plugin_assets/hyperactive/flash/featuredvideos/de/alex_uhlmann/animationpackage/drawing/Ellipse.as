import de.alex_uhlmann.animationpackage.drawing.IDrawable;
import de.alex_uhlmann.animationpackage.drawing.Shape;

/**
* @class Ellipse
* @author Alex Uhlmann
* @description Ellipse is a class for creating circles and ellipses.
* 			If you specify a movieclip as first parameter, the shape will be drawn inside this movieclip. 
* 			If you omit the mc parameter, the class will create a new movieclip in _root.apContainer_mc.
* 			<p>
* 			Example 1: draw an ellipse with default parameters. Results in a circle with a radius of 50.	
* 			<blockquote><pre>
*			var myEllipse:Ellipse = new Ellipse();
*			myEllipse.draw();
*			</pre></blockquote> 
* 			Example 2: <a href="Ellipse_02.html">(Example .swf)</a> draw an ellipse with custom parameters.		
* 			<blockquote><pre>
*			var myEllipse:Ellipse = new Ellipse(275,200,50,100);
*			myEllipse.lineStyle(3,0xff0000,100);
*			myEllipse.fillStyle(0x000000,100);
*			myEllipse.draw();
*			</pre></blockquote>
* 			Example 3. <a href="Ellipse_03.html">(Example .swf)</a> A circle.
*			<blockquote><pre>
* 			var myEllipse:Ellipse = new Ellipse(275,200,100,100);
*			myEllipse.lineStyle(2,0xff0000,100);
*			myEllipse.fillStyle(0x000000,100);
*			myEllipse.draw();
* 			</pre></blockquote>			
* @usage <pre>var myEllipse:Ellipse = new Ellipse();</pre> 
* 		<pre>var myEllipse:Ellipse = new Ellipse(x, y, xradius, yradius);</pre>
*		<pre>var myEllipse:Ellipse = new Ellipse(mc, x, y, xradius, yradius);</pre>
* @param mc (MovieClip) existing movieclip to draw in.
* @param x (Number) X position of the drawing. Center point.
* @param y (Number) Y position of the drawing. Center point.
* @param xradius (Number) X radius of ellipse.
* @param yradius (Number) Y radius of ellipse.
*/
class de.alex_uhlmann.animationpackage.drawing.Ellipse 
										extends Shape 
										implements IDrawable {	
	
	/*static default properties*/
	/*lineStyle properties inherited from Shape*/
	/*fillStyle properties inherited from Shape*/		
	/** 
	* @property xradius_def (Number)(static) default property. X radius of ellipse. Defaults to 50.
	* @property yradius_def (Number)(static) default property. Y radius of ellipse. Defaults to 50.
	* 
	* @property movieclip (MovieClip)(read only) Movieclip that contains the drawing.
	* @property lineThickness (Number) Outline thickness.
	* @property lineRGB (Number) Outline color of the drawing as hex number.
	* @property lineAlpha (Number) Outline transparency (alpha).
	* @property fillRGB (Number) Fill color of the drawing.
	* @property fillAlpha (Number) Fill transparency.	
	*/
	public static var yradius_def:Number = 50;
	public static var xradius_def:Number = 50;
	private var x:Number = 0;
	private var y:Number = 0;
	private var xradius:Number;
	private var yradius:Number;	
	
	public function Ellipse() {
		super(true);
		this.init.apply(this,arguments);
		this.fillStyle(null);		
	}
	
	private function init():Void {		
		if(typeof(arguments[0]) == "movieclip") {					
			this.initCustom.apply(this,arguments);
		} else {			
			this.initAuto.apply(this,arguments);
		}			
	}

	private function initCustom(mc:MovieClip, x:Number, y:Number, xradius:Number, yradius:Number):Void {		
		
		this.mc = this.createClip({mc:mc, x:x, y:y});		
		this.initShape.apply(this,arguments.slice(1));
	}

	private function initAuto(x:Number, y:Number, xradius:Number, yradius:Number):Void {		
		
		this.mc = this.createClip({name:"apDraw", x:x, y:y});		
		this.initShape.apply(this,arguments);
	}
	
	private function initShape(x:Number, y:Number, xradius:Number, yradius:Number):Void {
	
		this.xradius = (xradius == null) ? Ellipse.xradius_def : xradius;
		this.yradius = (yradius == null) ? Ellipse.yradius_def : yradius;
	}
	
	/*inherited from Shape*/
	/**
	* @method draw
	* @description 	Draws ellipses.
	* @usage <pre>myEllipse.draw();</pre>
	*/
	
	/**
	* @method drawBy
	* @description 	Draws the shape without clearing the movieclip.
	* @usage <pre>myInstance.drawBy();</pre>
	*/	
	
	/**
	* @method getSize
	* @description 	Returns the dimensions of the ellipse.
	* @usage  <pre>myEllipse.getSize();</pre>
	* @return Object that contains w for with and h for height properties that define the dimension of the drawing in pixels. 
	*/	
	public function getSize(Void):Object {		
		return { w:this.xradius * 2, h:this.yradius * 2 };	
	}
		
	/**
	* @method setSize
	* @description 	Sets the dimensions of the ellipse.		
	* 		
	* @usage   <pre>myEllipse.setSize(width, height);</pre>
	* 	  
	* @param width (Number) width of ellipse in pixels.
	* @param height (Number) height of ellipse in pixels.
	*/	
	public function setSize(width:Number, height:Number):Void {	
		this.xradius = width / 2;
		this.yradius = height / 2;		
	}
	
	private function drawNew(Void):Void {		
		this.mc.moveTo(this.x, this.y);
		if (this.fillRGB != null && this.fillGradient == false) {
			this.mc.beginFill(this.fillRGB, this.fillAlpha);
		} else if (this.fillGradient == true){
			this.mc.beginGradientFill(this.gradientFillType, this.gradientColors, this.gradientAlphas, this.gradientRatios, this.gradientMatrix);
		}		
		this.drawEllipse(this.x, this.y, this.xradius, this.yradius);
		this.mc.endFill();
	}	
	
	/*-------------------------------------------------------------
	drawEllipse() is a method for creating circles and
	ellipses. Hopefully this one is pretty straight
	forward. This method, like most of the others, is
	not as optimized as it could be. This was a
	conscious decision to keep the code as accessible as
	possible for those either new to AS or to the math
	involved in plotting points on a curve.
	-------------------------------------------------------------*/
	private function drawEllipse(x:Number, y:Number, radius:Number, yRadius:Number):Void {
		// ==============
		// drawEllipse() - by Ric Ewing (ric@formequalsfunction.com) - version 1.1 - 4.7.2002
		// 
		// x, y = center of ellipse
		// radius = radius of ellipse. If [optional] yRadius is defined, r is the x radius.
		// yRadius = [optional] y radius of ellipse.
		// ==============

		// init variables
		var theta:Number, xrCtrl:Number, yrCtrl:Number, angle:Number;
		var angleMid:Number, px:Number, py:Number, cx:Number, cy:Number;
		// if only yRadius is undefined, yRadius = radius
		if (yRadius == undefined) {
			yRadius = radius;
		}
		// covert 45 degrees to radians for our calculations
		theta = Math.PI/4;
		// calculate the distance for the control point
		xrCtrl = radius/Math.cos(theta/2);
		yrCtrl = yRadius/Math.cos(theta/2);
		// start on the right side of the circle
		angle = 0;
		this.mc.moveTo(x+radius, y);
		// this loop draws the circle in 8 segments
		var i:Number;
		for (i = 0; i<8; i++) {
			// increment our angles
			angle += theta;
			angleMid = angle-(theta/2);
			// calculate our control point
			cx = x+Math.cos(angleMid)*xrCtrl;
			cy = y+Math.sin(angleMid)*yrCtrl;
			// calculate our end point
			px = x+Math.cos(angle)*radius;
			py = y+Math.sin(angle)*yRadius;
			// draw the circle segment
			this.mc.curveTo(cx, cy, px, py);
		}
	}	
	
	/*inherited from Shape*/
	/**
	* @method lineStyle
	* @description 	define outline.		
	* 		
	* @usage   <pre>myEllipse.lineStyle();</pre>
	* 		<pre>myEllipse.lineStyle(lineThickness, lineRGB, lineAlpha);</pre>
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
	* @usage   <pre>myEllipse.fillStyle();</pre>
	* 		<pre>myEllipse.fillStyle(fillRGB, fillAlpha);</pre>
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
			this.x = this.xradius + registrationObj.x;
			this.y = this.yradius + registrationObj.y;			
		}
	}
	
	/**
	* @method clear
	* @description 	removes all drawings. Identical to myInstance.movieclip.clear();
	* @usage <pre>myInstance.clear();</pre>
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
		return "Ellipse";
	}
}