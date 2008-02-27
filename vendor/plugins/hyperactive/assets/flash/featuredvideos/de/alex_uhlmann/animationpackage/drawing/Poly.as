import de.alex_uhlmann.animationpackage.drawing.IDrawable;
import de.alex_uhlmann.animationpackage.drawing.Shape;

/**
* @class Poly
* @author Alex Uhlmann
* @description Poly is a class for creating regular polygons. Negative values 
* 			for sides will draw the polygon in the reverse direction, 
* 			which allows for creating knock-outs in masks.
* 			If you specify a movieclip as first parameter, the shape will be drawn inside this movieclip. 
* 			If you omit the mc parameter, the class will create a new movieclip in _root.apContainer_mc.
* 			<p>
* 			Example 1: draw a poly with default parameters.		
* 			<blockquote><pre>
*			var myPoly:Poly = new Poly();
*			myPoly.draw();
*			</pre></blockquote> 
* 			Example 2: <a href="Poly_02.html">(Example .swf)</a> draw a poly with custom parameters.		
* 			<blockquote><pre>
*			var myPoly:Poly = new Poly(275,200,100,6);
*			myPoly.lineStyle(2,0xff0000,100);
*			myPoly.fillStyle(0xff0000,100);
*			myPoly.draw();
*			</pre></blockquote>
* 			Example 3. A triangle.
*			<blockquote><pre>
* 			var myPoly:Poly = new Poly(275,200,100,3);
*			myPoly.lineStyle(2,0xff0000,100);
*			myPoly.fillStyle(0xff0000,100);
*			myPoly.draw();
*			</pre></blockquote>
* 			Example 4. A circle.
*			<blockquote><pre>
* 			var myPoly:Poly = new Poly(275,200,50,50);
*			myPoly.lineStyle(2,0xff0000,100);
*			myPoly.fillStyle(0xff0000,100);
*			myPoly.draw();
*			</pre></blockquote>
* @usage <pre>var myPoly:Poly = new Poly();</pre> 
* 		<pre>var myPoly:Poly = new Poly(x, y, radius, sides);</pre>
* 		<pre>var myPoly:Poly = new Poly(mc, x, y, radius, sides);</pre>
* @param mc (MovieClip) existing movieclip to draw in.
* @param x (Number) X position of the drawing. Center point.
* @param y (Number) Y position of the drawing. Center point.
* @param radius (Number) radius of poly.
* @param sides (Number) sides of poly.
*/
class de.alex_uhlmann.animationpackage.drawing.Poly 
									extends Shape 
									implements IDrawable {	
	
	/*static default properties*/
	/*lineStyle properties inherited from Shape*/
	/*fillStyle properties inherited from Shape*/	
	/** 
	* @property radius_def (Number)(static) default property. radius of poly.
	* @property sides_def (Number)(static) default property. sides of poly. Defaults to 4.
	* 
	* @property movieclip (MovieClip)(read only) Movieclip that contains the drawing.
	* @property lineThickness (Number) Outline thickness.
	* @property lineRGB (Number) Outline color of the drawing as hex number.
	* @property lineAlpha (Number) Outline transparency (alpha).
	* @property fillRGB (Number) Fill color of the drawing.
	* @property fillAlpha (Number) Fill transparency.	
	*/	
	public static var radius_def:Number = 50;
	public static var sides_def:Number = 6;
	private var x:Number = 0;
	private var y:Number = 0;
	private var radius:Number;
	private var sides:Number;
	private var angle:Number;
	
	public function Poly() {
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

	private function initCustom(mc:MovieClip, x:Number, y:Number, radius:Number, sides:Number):Void {		
		
		this.mc = this.createClip({mc:mc, x:x, y:y});		
		this.initShape.apply(this,arguments.slice(1));
	}

	private function initAuto(x:Number, y:Number, radius:Number, sides:Number):Void {		
		
		this.mc = this.createClip({name:"apDraw", x:x, y:y});		
		this.initShape.apply(this,arguments);
	}
		
	private function initShape(x:Number, y:Number, radius:Number, sides:Number):Void {
	
		this.radius = (radius == null) ? Poly.radius_def : radius;
		this.sides = (sides == null) ? Poly.sides_def : sides;
		this.angle = 0;
	}
	
	/*inherited from Shape*/
	/**
	* @method draw
	* @description 	Draws it.		
	* @usage <pre>myPoly.draw();</pre>
	*/
	
	/**
	* @method drawBy
	* @description 	Draws the shape without clearing the movieclip.
	* @usage <pre>myInstance.drawBy();</pre>
	*/	
	
	/**
	* @method getRadius
	* @description 	Returns the radius.
	* @usage  <pre>myPoly.getRadius();</pre>
	* @return Number that represents the radius in pixels. 
	*/	
	public function getRadius(Void):Number {		
		return this.radius;		
	}
		
	/**
	* @method setRadius
	* @description 	Sets the radius of the drawing.		
	* 		
	* @usage   <pre>myPoly.setRadius(radius);</pre>
	* 	  
	* @param radius (Number) radius in pixels.
	*/	
	public function setRadius(radius:Number):Void {	
		this.radius = radius;		
	}	
	
	/**
	* @method getSides
	* @description 	Return the sides of the drawing.
	* @usage  <pre>myPoly.getSides();</pre>
	* @return Number of sides. 
	*/	
	public function getSides(Void):Number {		
		return this.sides;		
	}
		
	/**
	* @method setSides
	* @description 	Sets the sides of the drawing.		
	* 		
	* @usage   <pre>myPoly.setSides(sides);</pre>
	* 	  
	* @param sides (Number) the number of sides.
	*/	
	public function setSides(sides:Number):Void {	
		this.sides = sides;		
	}	
	
	private function drawNew(Void):Void {		
		this.mc.moveTo(this.x, this.y);
		if (this.fillRGB != null && this.fillGradient == false) {
			this.mc.beginFill(this.fillRGB, this.fillAlpha);
		} else if (this.fillGradient == true){
			this.mc.beginGradientFill(this.gradientFillType, this.gradientColors, this.gradientAlphas, this.gradientRatios, this.gradientMatrix);
		}		
		this.drawPoly(this.x, this.y, this.sides, this.radius, this.angle);
		this.mc.endFill();
	}
	
	/*-------------------------------------------------------------
		drawPoly is a method for creating regular
		polygons. Negative values for sides will draw the
		polygon in the reverse direction, which allows for
		creating knock-outs in masks.
	-------------------------------------------------------------*/
	private function drawPoly(x:Number, y:Number, sides:Number, 
							  radius:Number, angle:Number):Void {
		// ==============
		// drawPoly() - by Ric Ewing (ric@formequalsfunction.com) - version 1.4 - 4.7.2002
		// 
		// x, y = center of polygon
		// sides = number of sides (Math.abs(sides) must be > 2)
		// radius = radius of the points of the polygon from the center
		// angle = [optional] starting angle in degrees. (defaults to 0)
		// ==============
		// convert sides to positive value
		var count:Number = Math.abs(sides);
		// check that count is sufficient to build polygon
		if (count>2) {
			// init vars
			var step:Number, start:Number, n:Number, dx:Number, dy:Number;
			// calculate span of sides
			step = (Math.PI*2)/sides;
			// calculate starting angle in radians
			start = (angle/180)*Math.PI;
			this.mc.moveTo(x+(Math.cos(start)*radius), y-(Math.sin(start)*radius));
			// draw the polygon
			for (n=1; n<=count; n++) {
				dx = x+Math.cos(start+(step*n))*radius;
				dy = y-Math.sin(start+(step*n))*radius;
				this.mc.lineTo(dx, dy);
			}
		}
	}
	
	/*inherited from Shape*/
	/**
	* @method lineStyle
	* @description 	define outline.		
	* 		
	* @usage   <pre>myPoly.lineStyle();</pre>
	* 		<pre>myPoly.lineStyle(lineThickness, lineRGB, lineAlpha);</pre>
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
	* @usage   <pre>myPoly.fillStyle();</pre>
	* 		<pre>myPoly.fillStyle(fillRGB, fillAlpha);</pre>
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
			this.x = this.radius + registrationObj.x;
			this.y = this.radius + registrationObj.y;
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
		return "Poly";
	}
}