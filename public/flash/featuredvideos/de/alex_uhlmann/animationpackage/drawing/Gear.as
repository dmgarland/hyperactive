import de.alex_uhlmann.animationpackage.drawing.IDrawable;
import de.alex_uhlmann.animationpackage.drawing.Shape;

/**
* @class Gear
* @author Alex Uhlmann
* @description Gear is a class for drawing gears... you know, cogs with teeth 
* 			and a hole in the middle where the axle goes? FYI: if you modify 
* 			this to draw the hole polygon in the opposite direction, it will remain
*			transparent if the gear is used for a mask.
* 			If you specify a movieclip as first parameter, the shape will be drawn inside this movieclip. 
* 			If you omit the mc parameter, the class will create a new movieclip in _root.apContainer_mc.
* 			<p>
* 			Example 1: draw a gear with default parameters.		
* 			<blockquote><pre>
*			var myGear:Gear = new Gear();
*			myGear.draw();
*			</pre></blockquote> 
* 			Example 2: <a href="Gear_02.html">(Example .swf)</a> draw a gear with custom parameters.		
* 			<blockquote><pre>
*			var myGear:Gear = new Gear(275,200,40,50,10,8,15);
*			myGear.lineStyle(2,0xff0000,100);
*			myGear.fillStyle(0xff0000,100);
*			myGear.draw();
*			</pre></blockquote> 			
* 			Example 3: 
* 			<blockquote><pre>
* 			var myGear:Gear = new Gear(275,200,40,25,10);
* 			myGear.lineStyle(2,0xff0000,100);
* 			myGear.fillStyle(0xff0000,100);
*			myGear.draw();
*			</pre></blockquote>
* 			Example 4: <a href="Gear_04.html">(Example .swf)</a> Kind of a sun.
* 			<blockquote><pre>
*			var myGear:Gear = new Gear(275,200,30,100,10);
*			myGear.lineStyle(2,0xff0000,100);
*			myGear.fillStyle(0xff0000,100);
*			myGear.draw();
*			</pre></blockquote> 		
* @usage <pre>var myGear:Gear = new Gear();</pre> 
* 		<pre>var myGear:Gear = new Gear(x, y, innerRadius, outerRadius, sides, holeSides, holeRadius);</pre>
* 		<pre>var myGear:Gear = new Gear(mc, x, y, innerRadius, outerRadius, sides, holeSides, holeRadius);</pre>
* @param mc (MovieClip) existing movieclip to draw in.
* @param x (Number) X position of the drawing. Center point.
* @param y (Number) Y position of the drawing. Center point.
* @param innerRadius (Number) Radius of the indent of the teeth.
* @param outerRadius (Number) Outer radius of the teeth.
* @param sides (Number) Number of teeth on gear. (must be > 2)	
* @param holeSides (Number) draw a polygonal hole with this many sides (must be > 2). Defaults to 8.
* @param holeRadius (Number) size of hole. Defaults to 3.
*/
class de.alex_uhlmann.animationpackage.drawing.Gear 
										extends Shape 
										implements IDrawable {	
	
	/*static default properties*/
	/*lineStyle properties inherited from Shape*/
	/*fillStyle properties inherited from Shape*/
	/** 
	* @property innerRadius_def (Number)(static) default property. Radius of the indent of the teeth.
	* @property outerRadius_def (Number)(static) default property. Outer radius of the teeth.
	* @property sides_def (Number)(static) default property. Number of teeth on gear. (must be > 2). Defaults to 10.
	* @property holeSides_def_def (Number)(static) default property. draw a polygonal hole with this many sides (must be > 2). Defaults to 8.
	* 
	* @property movieclip (MovieClip) Movieclip that contains the drawing.
	* @property lineThickness (Number) Outline thickness.
	* @property lineRGB (Number) Outline color of the drawing as hex number.
	* @property lineAlpha (Number) Outline transparency (alpha).
	* @property fillRGB (Number) Fill color of the drawing.
	* @property fillAlpha (Number) Fill transparency.
	*/
	public static var innerRadius_def:Number = 80;
	public static var outerRadius_def:Number = 100;	
	public static var sides_def:Number = 10;
	public static var holeSides_def:Number = 8;	
	public static var holeRadius_def:Number = 20;
	private var x:Number = 0;
	private var y:Number = 0;
	private var innerRadius:Number;
	private var outerRadius:Number;
	private var sides:Number;
	private var angle:Number;
	private var holeSides:Number;
	private var holeRadius:Number;
	
	public function Gear() {
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

	private function initCustom(mc:MovieClip, x:Number, y:Number, innerRadius:Number, outerRadius:Number, 
						holeSides:Number, holeRadius:Number, sides:Number):Void {		
		
		this.mc = this.createClip({mc:mc, x:x, y:y});		
		this.initShape.apply(this,arguments.slice(1));
	}

	private function initAuto(x:Number, y:Number, innerRadius:Number, outerRadius:Number, 
					holeSides:Number, holeRadius:Number, sides:Number):Void {		
		
		this.mc = this.createClip({name:"apDraw", x:x, y:y});		
		this.initShape.apply(this,arguments);
	}
		
	private function initShape(x:Number, y:Number, innerRadius:Number, outerRadius:Number, 
					holeSides:Number, holeRadius:Number, sides:Number):Void {
	
		this.innerRadius = (innerRadius == null) ? Gear.innerRadius_def : innerRadius;
		this.outerRadius = (outerRadius == null) ? Gear.outerRadius_def : outerRadius;		
		this.sides = (sides == null) ? Gear.sides_def : sides;
		this.angle = 0;	
		this.holeSides = (holeSides == null || holeSides < 2) ? Gear.holeSides_def : holeSides;
		this.holeRadius = (holeRadius == null) ? Gear.holeRadius_def : holeRadius;		
	}
	
	/*inherited from Shape*/
	/**
	* @method draw
	* @description 	Draws gears.
	* @usage <pre>myGear.draw();</pre>
	*/
	
	/**
	* @method drawBy
	* @description 	Draws the shape without clearing the movieclip.
	* @usage <pre>myInstance.drawBy();</pre>
	*/	
	
	/**
	* @method getInnerRadius
	* @description 	Return the radius of the indent of the teeth.
	* @usage  <pre>myGear.getInnerRadius();</pre>
	* @return Number of the radius of the indent of the teeth.
	*/	
	public function getInnerRadius(Void):Number {		
		return this.innerRadius;		
	}
		
	/**
	* @method setInnerRadius
	* @description 	Sets the radius of the indent of the teeth.		
	* 		
	* @usage   <pre>myGear.setInnerRadius(innerRadius);</pre>
	* 	  
	* @param innerRadius (Number) radius of the indent of the teeth.
	*/	
	public function setInnerRadius(innerRadius:Number):Void {	
		this.innerRadius = innerRadius;		
	}	
	
	/**
	* @method getOuterRadius
	* @description 	Return the outer radius of the teeth.
	* @usage  <pre>myGear.getOuterRadius();</pre>
	* @return Number of the outer radius of the teeth.
	*/	
	public function getOuterRadius(Void):Number {		
		return this.outerRadius;		
	}
		
	/**
	* @method setOuterRadius
	* @description 	Sets the outer radius of the teeth.	
	* 		
	* @usage   <pre>myGear.setOuterRadius(outerRadius);</pre>
	* 	  
	* @param outerRadius (Number) outer radius of the teeth.
	*/	
	public function setOuterRadius(outerRadius:Number):Void {	
		this.outerRadius = outerRadius;		
	}
	
	/**
	* @method getHoleSides
	* @description 	Return the number of sides of the inner polygonal hole.
	* @usage  <pre>myGear.getHoleSides();</pre>
	* @return Number of sides of the inner polygonal hole.
	*/	
	public function getHoleSides(Void):Number {		
		return this.holeSides;		
	}
		
	/**
	* @method setHoleSides
	* @description 	Sets the number of sides of the inner polygonal hole.		
	* 		
	* @usage   <pre>myGear.setHoleSides(holeSides);</pre>
	* 	  
	* @param holeSides (Number) sides of the inner polygonal hole.
	*/	
	public function setHoleSides(holeSides:Number):Void {	
		this.holeSides = holeSides;		
	}	
	
	/**
	* @method getHoleRadius
	* @description 	Return the size of hole.
	* @usage  <pre>myGear.getHoleRadius();</pre>
	* @return Number of the size of hole in pixels.
	*/	
	public function getHoleRadius(Void):Number {		
		return this.holeRadius;		
	}
		
	/**
	* @method setHoleRadius
	* @description 	Sets the size of hole.	
	* 		
	* @usage   <pre>myGear.setHoleRadius(holeRadius);</pre>
	* 	  
	* @param outerRadius (Number) size of hole in pixels.
	*/	
	public function setHoleRadius(holeRadius:Number):Void {	
		this.holeRadius = holeRadius;		
	}
	
	/**
	* @method getSides
	* @description 	Return the sides of the drawing.
	* @usage  <pre>myGear.getSides();</pre>
	* @return Number of sides. 
	*/	
	public function getSides(Void):Number {		
		return this.sides;		
	}
		
	/**
	* @method setSides
	* @description 	Sets the sides of the drawing.		
	* 		
	* @usage   <pre>myGear.setSides(sides);</pre>
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
		this.drawGear(this.x, this.y, this.sides, this.innerRadius, 
					  this.outerRadius, this.angle, this.holeSides, this.holeRadius);
		this.mc.endFill();
	}	
	
	/*-------------------------------------------------------------
		drawGear is a method that draws gears... you
		know, cogs with teeth and a hole in the middle where
		the axle goes? Okay, okay... so nobody *needs* a
		method to draw a gear. I know that this is probably
		one of my least useful methods. But it was an easy
		adaptation of the polygon method so I did it anyway.
		Enjoy. FYI: if you modify this to draw the hole
		polygon in the opposite direction, it will remain
		transparent if the gear is used for a mask.
	-------------------------------------------------------------*/
	private function drawGear(x:Number, y:Number, sides:Number, 
							  innerRadius:Number, outerRadius:Number, 
							  angle:Number, holeSides:Number, holeRadius:Number):Void {
		// ==============
		// drawGear() - by Ric Ewing (ric@formequalsfunction.com) - version 1.3 - 3.5.2002
		// 
		// x, y = center of gear.
		// sides = number of teeth on gear. (must be > 2)
		// innerRadius = radius of the indent of the teeth.
		// outerRadius = outer radius of the teeth.
		// angle = [optional] starting angle in degrees. Defaults to 0.
		// holeSides = [optional] draw a polygonal hole with this many sides (must be > 2).
		// holeRadius = [optional] size of hole. Default = innerRadius/3.
		// ==============
		if (sides>2) {
			// init vars
			var step:Number, qtrStep:Number, start:Number, n:Number, dx:Number, dy:Number;
			// calculate length of sides
			step = (Math.PI*2)/sides;
			qtrStep = step/4;
			// calculate starting angle in radians
			start = (angle/180)*Math.PI;
			this.mc.moveTo(x+(Math.cos(start)*outerRadius), y-(Math.sin(start)*outerRadius));
			// draw lines
			for (n=1; n<=sides; n++) {
				dx = x+Math.cos(start+(step*n)-(qtrStep*3))*innerRadius;
				dy = y-Math.sin(start+(step*n)-(qtrStep*3))*innerRadius;
				this.mc.lineTo(dx, dy);
				dx = x+Math.cos(start+(step*n)-(qtrStep*2))*innerRadius;
				dy = y-Math.sin(start+(step*n)-(qtrStep*2))*innerRadius;
				this.mc.lineTo(dx, dy);
				dx = x+Math.cos(start+(step*n)-qtrStep)*outerRadius;
				dy = y-Math.sin(start+(step*n)-qtrStep)*outerRadius;
				this.mc.lineTo(dx, dy);
				dx = x+Math.cos(start+(step*n))*outerRadius;
				dy = y-Math.sin(start+(step*n))*outerRadius;
				this.mc.lineTo(dx, dy);
			}
			// This is complete overkill... but I had it done already. :)
			if (holeSides>2) {
				if(holeRadius == undefined) {
					holeRadius = innerRadius/3;
				}
				step = (Math.PI*2)/holeSides;
				this.mc.moveTo(x+(Math.cos(start)*holeRadius), y-(Math.sin(start)*holeRadius));
				for (n=1; n<=holeSides; n++) {
					dx = x+Math.cos(start+(step*n))*holeRadius;
					dy = y-Math.sin(start+(step*n))*holeRadius;
					this.mc.lineTo(dx, dy);
				}
			}
		}
	}
	
	/*inherited from Shape*/
	/**
	* @method lineStyle
	* @description 	define outline.		
	* 		
	* @usage   <pre>myGear.lineStyle();</pre>
	* 		<pre>myGear.lineStyle(lineThickness, lineRGB, lineAlpha);</pre>
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
	* @usage   <pre>myGear.fillStyle();</pre>
	* 		<pre>myGear.fillStyle(fillRGB, fillAlpha);</pre>
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
		return "Gear";
	}
}