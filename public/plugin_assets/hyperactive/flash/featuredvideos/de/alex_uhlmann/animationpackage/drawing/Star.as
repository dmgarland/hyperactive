import de.alex_uhlmann.animationpackage.drawing.IDrawable;
import de.alex_uhlmann.animationpackage.drawing.Shape;

/**
* @class Star
* @author Alex Uhlmann
* @description Star is a class for drawing star shaped polygons. Note that the stars by default 
* 			'point' to	the right. This is because the method starts drawing
*			at 0 degrees by default, putting the first point to the right of center. 
*			Negative values for sides	draws the star in reverse direction, allowing for
*			knock-outs when used as part of a mask.
* 			If you specify a movieclip as first parameter, the shape will be drawn inside this movieclip. 
* 			If you omit the mc parameter, the class will create a new movieclip in _root.apContainer_mc.
* 			<p>
* 			Example 1: draw a star with default parameters.		
* 			<blockquote><pre>
*			var myStar:Star = new Star();
*			myStar.draw();
*			</pre></blockquote> 
* 			Example 2: draw a star with custom parameters.		
* 			<blockquote><pre>
*			var myStar:Star = new Star(275,200,100,25,6);
*			myStar.lineStyle(2,0xff0000,100);
*			myStar.fillStyle(0xff0000,100);
*			myStar.draw();
*			</pre></blockquote>
* 			Example 3. <a href="Star_03.html">(Example .swf)</a> A star that only consists of straight lines.
*			<blockquote><pre>
* 			var myStar:Star = new Star(275,200,100,0,6);
*			myStar.lineStyle(2,0xff0000,100);
*			myStar.fillStyle(0xff0000,100);
*			myStar.draw();
* 			</pre></blockquote>			
* @usage <pre>var myStar:Star = new Star();</pre>
* 		<pre>var myStar:Star = new Star(x, y, innerRadius, outerRadius, sides);</pre>
* 		<pre>var myStar:Star = new Star(mc, x, y, innerRadius, outerRadius, sides);</pre>
* @param mc (MovieClip) existing movieclip to draw in.
* @param x (Number) X position of the drawing. Center point.
* @param y (Number) Y position of the drawing. Center point.
* @param innerRadius (Number) Radius of the indent of the sides.
* @param outerRadius (Number) Radius of the tips of the sides.
* @param sides (Number) Number of sides (must be > 2)	 
*/
class de.alex_uhlmann.animationpackage.drawing.Star 
									extends Shape 
									implements IDrawable {	
	
	/*static default properties*/
	/*lineStyle properties inherited from Shape*/
	/*fillStyle properties inherited from Shape*/
	/** 
	* @property innerRadius_def (Number)(static) default property. Radius of the indent of the sides.
	* @property outerRadius_def (Number)(static) default property. Radius of the tips of the sides.
	* @property sides_def (Number)(static) default property. Number of sides (must be > 2). Defaults to 4.
	* 
	* @property movieclip (MovieClip)(read only) Movieclip that contains the drawing.
	* @property lineThickness (Number) Outline thickness.
	* @property lineRGB (Number) Outline color of the drawing as hex number.
	* @property lineAlpha (Number) Outline transparency (alpha).
	* @property fillRGB (Number) Fill color of the drawing.
	* @property fillAlpha (Number) Fill transparency.	
	*/	
	public static var innerRadius_def:Number = 25;
	public static var outerRadius_def:Number = 100;
	public static var sides_def:Number = 4;
	private var x:Number = 0;
	private var y:Number = 0;
	private var innerRadius:Number;
	private var outerRadius:Number;
	private var sides:Number;
	private var angle:Number;
	
	public function Star() {
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

	private function initCustom(mc:MovieClip, x:Number, y:Number, innerRadius:Number, outerRadius:Number, sides:Number):Void {		
		
		this.mc = this.createClip({mc:mc, x:x, y:y});		
		this.initShape.apply(this,arguments.slice(1));
	}

	private function initAuto(x:Number, y:Number, innerRadius:Number, outerRadius:Number, sides:Number):Void {		
		
		this.mc = this.createClip({name:"apDraw", x:x, y:y});		
		this.initShape.apply(this,arguments);
	}
		
	private function initShape(x:Number, y:Number, innerRadius:Number, outerRadius:Number, sides:Number):Void {
	
		this.innerRadius = (innerRadius == null) ? Star.innerRadius_def : innerRadius;
		this.outerRadius = (outerRadius == null) ? Star.outerRadius_def : outerRadius;
		this.sides = (sides == null) ? Star.sides_def : sides;
		this.angle = 0;
	}
	
	/*inherited from Shape*/
	/**
	* @method draw
	* @description 	Draws stars.		
	* @usage <pre>myStar.draw();</pre>
	*/
	
	/**
	* @method drawBy
	* @description 	Draws the shape without clearing the movieclip.
	* @usage <pre>myInstance.drawBy();</pre>
	*/
	
	/**
	* @method getInnerRadius
	* @description 	Return the radius of the indent of the sides.
	* @usage  <pre>myStar.getInnerRadius();</pre>
	* @return Number of the radius of the indent of the sides.
	*/	
	public function getInnerRadius(Void):Number {		
		return this.innerRadius;		
	}
		
	/**
	* @method setInnerRadius
	* @description 	Sets the radius of the indent of the sides.	
	* 		
	* @usage   <pre>myStar.setInnerRadius(innerRadius);</pre>
	* 	  
	* @param innerRadius (Number) radius of the indent of the sides.
	*/	
	public function setInnerRadius(innerRadius:Number):Void {	
		this.innerRadius = innerRadius;		
	}	
	
	/**
	* @method getOuterRadius
	* @description 	Return the radius of the tips of the sides.
	* @usage  <pre>myStar.getOuterRadius();</pre>
	* @return Number of the radius of the tips of the sides.
	*/	
	public function getOuterRadius(Void):Number {		
		return this.outerRadius;		
	}
		
	/**
	* @method setOuterRadius
	* @description 	Sets the radius of the tips of the sides.	
	* 		
	* @usage   <pre>myStar.setOuterRadius(outerRadius);</pre>
	* 	  
	* @param outerRadius (Number) radius of the tips of the sides.
	*/	
	public function setOuterRadius(outerRadius:Number):Void {	
		this.outerRadius = outerRadius;		
	}
	
	/**
	* @method getSides
	* @description 	Return the sides of the drawing.
	* @usage  <pre>myStar.getSides();</pre>
	* @return Number of sides. 
	*/	
	public function getSides(Void):Number {		
		return this.sides;		
	}
	
	/**
	* @method setSides
	* @description 	Sets the sides of the drawing.		
	* 		
	* @usage   <pre>myStar.setSides(sides);</pre>
	* 	  
	* @param sides (Number) the number of sides.
	*/	
	public function setSides(sides:Number):Void {	
		this.sides = sides;		
	}	
	
	/*inherited from Shape*/
	/**
	* @method lineStyle
	* @description 	define outline.		
	* 		
	* @usage   <pre>myStar.lineStyle();</pre>
	* 		<pre>myStar.lineStyle(lineThickness, lineRGB, lineAlpha);</pre>
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
	* @usage   <pre>myStar.fillStyle();</pre>
	* 		<pre>myStar.fillStyle(fillRGB, fillAlpha);</pre>
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
	
	private function drawNew(Void):Void {
		this.mc.moveTo(this.x, this.y);
		if (this.fillRGB != null && this.fillGradient == false) {
			this.mc.beginFill(this.fillRGB, this.fillAlpha);
		} else if (this.fillGradient == true){
			this.mc.beginGradientFill(this.gradientFillType, 
										this.gradientColors, 
										this.gradientAlphas, 
										this.gradientRatios, 
										this.gradientMatrix);
		}		
		this.drawStar(this.x, 
						this.y, 
						this.sides, 
						this.innerRadius, 
						this.outerRadius, 
						this.angle);
		this.mc.endFill();
	}	
	
	/*-------------------------------------------------------------
		drawStar is a method for drawing star shaped
		polygons. Note that the stars by default 'point' to
		the right. This is because the method starts drawing
		at 0 degrees by default, putting the first point to
		the right of center. Negative values for points
		draws the star in reverse direction, allowing for
		knock-outs when used as part of a mask.
	-------------------------------------------------------------*/
	private function drawStar(x:Number, y:Number, points:Number, 
							  innerRadius:Number, outerRadius:Number, angle:Number):Void {
		
		// ==============
		// drawStar() - by Ric Ewing (ric@formequalsfunction.com) - version 1.4 - 4.7.2002
		// 
		// x, y = center of star
		// points = number of points (Math.abs(points) must be > 2)
		// innerRadius = radius of the indent of the points
		// outerRadius = radius of the tips of the points
		// angle = [optional] starting angle in degrees. (defaults to 0)
		// ==============
		var count:Number = Math.abs(points);
		if (count>2) {
			// init vars
			var step:Number, halfStep:Number, start:Number, n:Number, dx:Number, dy:Number;
			// calculate distance between points
			step = (Math.PI*2)/points;
			halfStep = step/2;
			// calculate starting angle in radians
			start = (angle/180)*Math.PI;
			this.mc.moveTo(x+(Math.cos(start)*outerRadius), y-(Math.sin(start)*outerRadius));
			// draw lines
			for (n=1; n<=count; n++) {
				dx = x+Math.cos(start+(step*n)-halfStep)*innerRadius;
				dy = y-Math.sin(start+(step*n)-halfStep)*innerRadius;
				this.mc.lineTo(dx, dy);
				dx = x+Math.cos(start+(step*n))*outerRadius;
				dy = y-Math.sin(start+(step*n))*outerRadius;
				this.mc.lineTo(dx, dy);
			}
		}
	}
	
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
			if(this.innerRadius > this.outerRadius) {
				this.x = this.innerRadius + registrationObj.x;
				this.y = this.innerRadius + registrationObj.y;
			} else {
				this.x = this.outerRadius + registrationObj.x;
				this.y = this.outerRadius + registrationObj.y;
			}
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
		return "Star";
	}
}