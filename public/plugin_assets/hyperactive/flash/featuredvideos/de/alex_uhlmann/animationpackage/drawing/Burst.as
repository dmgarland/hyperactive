import de.alex_uhlmann.animationpackage.drawing.IDrawable;
import de.alex_uhlmann.animationpackage.drawing.Shape;

/**
* @class Burst
* @author Alex Uhlmann
* @description Burst is a class for drawing bursts (rounded star shaped ovals often seen in advertising). 
* 			This method also makes some fun flower shapes if you play with the input numbers. 
* 			If you specify a movieclip as first parameter, the shape will be drawn inside this movieclip. 
* 			If you omit the mc parameter, the class will create a new movieclip in _root.apContainer_mc.
* 			<p>
* 			Example 1: draw a Burst with default parameters.		
* 			<blockquote><pre>
*			var myBurst:Burst = new Burst();
*			myBurst.draw();
*			</pre></blockquote> 
* 			Example 2: <a href="Burst_02.html">(Example .swf)</a> draw a Burst with custom parameters.		
* 			<blockquote><pre>
*			var myBurst:Burst = new Burst(275,200,40,50,10);
*			myBurst.lineStyle(2,0xff0000,100);
*			myBurst.fillStyle(0xff0000,100);
*			myBurst.draw();
*			</pre></blockquote> 			
* 			Example 3: <a href="Burst_03.html">(Example .swf)</a> 
* 			<blockquote><pre>
*			var myBurst:Burst = new Burst(275,200,40,25,10);
*			myBurst.lineStyle(2,0xff0000,100);
*			myBurst.fillStyle(0xff0000,100);
*			myBurst.draw();
*			</pre></blockquote>
* 			Example 4:
* 			<blockquote><pre>
*			var myBurst:Burst = new Burst(275,200,30,100,10);
*			myBurst.lineStyle(2,0xff0000,100);
*			myBurst.fillStyle(0xff0000,100);
*			myBurst.draw();
*			</pre></blockquote> 		
* @usage <pre>var myBurst:Burst = new Burst();</pre> 
* 		<pre>var myBurst:Burst = new Burst(x, y, innerRadius, outerRadius, sides);</pre> 		
* 		 <pre>var myBurst:Burst = new Burst(mc, x, y, innerRadius, outerRadius, sides);</pre> 
* 
* @param mc (MovieClip) existing movieclip to draw in.
* @param x (Number) X position of the drawing. Center point.
* @param y (Number) Y position of the drawing. Center point.
* @param innerRadius (Number) Radius of the indent of the curves.
* @param outerRadius (Number) Radius of the outermost points.
* @param sides (Number) Number of sides or points.	
*/
class de.alex_uhlmann.animationpackage.drawing.Burst 
										extends Shape 
										implements IDrawable {	
	
	/*static default properties*/
	/*lineStyle properties inherited from Shape*/
	/*fillStyle properties inherited from Shape*/	
	/** 
	* @property innerRadius_def (Number)(static) default property. Radius of the indent of the curves.
	* @property outerRadius_def (Number)(static) default property. Radius of the outermost points.
	* @property sides_def (Number)(static) default property. Number of sides or points.
	* 
	* @property movieclip (MovieClip)(read only) Movieclip that contains the drawing.
	* @property lineThickness (Number) Outline thickness.
	* @property lineRGB (Number) Outline color of the drawing as hex number.
	* @property lineAlpha (Number) Outline transparency (alpha).
	* @property fillRGB (Number) Fill color of the drawing.
	* @property fillAlpha (Number) Fill transparency.
	*/
	public static var innerRadius_def:Number = 80;
	public static var outerRadius_def:Number = 100;	
	public static var sides_def:Number = 10;	
	private var x:Number = 0;
	private var y:Number = 0;
	private var innerRadius:Number;
	private var outerRadius:Number;
	private var sides:Number;
	private var angle:Number;

	public function Burst() {		
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
		this.innerRadius = (innerRadius == null) ? Burst.innerRadius_def : innerRadius;
		this.outerRadius = (outerRadius == null) ? Burst.outerRadius_def : outerRadius;
		this.sides = (sides == null) ? Burst.sides_def : sides;
		this.angle = 0;		
	}
	
	/*inherited from Shape*/
	/**
	* @method draw
	* @description 	Draws bursts.
	* @usage <pre>myBurst.draw();</pre>
	*/
	
	/**
	* @method drawBy
	* @description 	Draws the shape without clearing the movieclip.
	* @usage <pre>myInstance.drawBy();</pre>
	*/	
	
	/**
	* @method getInnerRadius
	* @description 	Return the radius of the indent of the curves.
	* @usage  <pre>myBurst.getInnerRadius();</pre>
	* @return Number of the radius of the indent of the curves.
	*/	
	public function getInnerRadius(Void):Number {		
		return this.innerRadius;		
	}
		
	/**
	* @method setInnerRadius
	* @description 	Sets the radius of the indent of the curves.		
	* 		
	* @usage   <pre>myBurst.setInnerRadius(innerRadius);</pre>
	* 	  
	* @param innerRadius (Number) radius of the indent of the curves.
	*/	
	public function setInnerRadius(innerRadius:Number):Void {	
		this.innerRadius = innerRadius;		
	}	
	
	/**
	* @method getOuterRadius
	* @description 	Return the radius of the outermost points.
	* @usage  <pre>myBurst.getOuterRadius();</pre>
	* @return Number of the radius of the outermost points.
	*/	
	public function getOuterRadius(Void):Number {		
		return this.outerRadius;		
	}
		
	/**
	* @method setOuterRadius
	* @description 	Sets the radius of the outermost points.		
	* 		
	* @usage   <pre>myBurst.setOuterRadius(outerRadius);</pre>
	* 	  
	* @param outerRadius (Number) radius of the outermost points.
	*/	
	public function setOuterRadius(outerRadius:Number):Void {	
		this.outerRadius = outerRadius;		
	}
	
	/**
	* @method getSides
	* @description 	Return the sides of the drawing.
	* @usage  <pre>myBurst.getSides();</pre>
	* @return Number of sides. 
	*/	
	public function getSides(Void):Number {		
		return this.sides;		
	}
		
	/**
	* @method setSides
	* @description 	Sets the sides of the drawing.		
	* 		
	* @usage   <pre>myBurst.setSides(sides);</pre>
	* 	  
	* @param sides (Number) the number of sides.
	*/	
	public function setSides(sides:Number):Void {	
		this.sides = sides;		
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
	
	private function drawNew(Void):Void {		
		this.mc.moveTo(this.x, this.y);
		if (this.fillRGB != null && this.fillGradient == false) {
			this.mc.beginFill(this.fillRGB, this.fillAlpha);
		} else if (this.fillGradient == true){
			this.mc.beginGradientFill(this.gradientFillType, this.gradientColors, this.gradientAlphas, this.gradientRatios, this.gradientMatrix);
		}		
		this.drawBurst(this.x, this.y, this.sides, this.innerRadius, 
					   this.outerRadius, this.angle);
		this.mc.endFill();
	}	
	
	/*-------------------------------------------------------------
		drawBurst is a method for drawing bursts (rounded
		star shaped ovals often seen in advertising). This
		seemingly whimsical method actually had a serious
		purpose. It was done to accommodate a client that
		wanted to have custom bursts for 'NEW!' and
		'IMPROVED!' type elements on their site...
		personally I think those look tacky, but it's hard
		to argue with a paying client. :) This method also
		makes some fun flower shapes if you play with the
		input numbers. 
	-------------------------------------------------------------*/
	private function drawBurst(x:Number, y:Number, sides:Number, 
							   innerRadius:Number, outerRadius:Number, angle:Number):Void {
		// ==============
		// drawBurst() - by Ric Ewing (ric@formequalsfunction.com) - version 1.4 - 4.7.2002
		// 
		// x, y = center of burst
		// sides = number of sides or points
		// innerRadius = radius of the indent of the curves
		// outerRadius = radius of the outermost points
		// angle = [optional] starting angle in degrees. (defaults to 0)
		// ==============
		if (sides>2) {
			// init vars
			var step:Number, halfStep:Number, qtrStep:Number, start:Number;
			var n:Number, dx:Number, dy:Number, cx:Number, cy:Number;
			// calculate length of sides
			step = (Math.PI*2)/sides;
			halfStep = step/2;
			qtrStep = step/4;
			// calculate starting angle in radians
			start = (angle/180)*Math.PI;
			this.mc.moveTo(x+(Math.cos(start)*outerRadius), y-(Math.sin(start)*outerRadius));
			// draw curves
			for (n=1; n<=sides; n++) {
				cx = x+Math.cos(start+(step*n)-(qtrStep*3))*(innerRadius/Math.cos(qtrStep));
				cy = y-Math.sin(start+(step*n)-(qtrStep*3))*(innerRadius/Math.cos(qtrStep));
				dx = x+Math.cos(start+(step*n)-halfStep)*innerRadius;
				dy = y-Math.sin(start+(step*n)-halfStep)*innerRadius;
				this.mc.curveTo(cx, cy, dx, dy);
				cx = x+Math.cos(start+(step*n)-qtrStep)*(innerRadius/Math.cos(qtrStep));
				cy = y-Math.sin(start+(step*n)-qtrStep)*(innerRadius/Math.cos(qtrStep));
				dx = x+Math.cos(start+(step*n))*outerRadius;
				dy = y-Math.sin(start+(step*n))*outerRadius;
				this.mc.curveTo(cx, cy, dx, dy);
			}
		}
	}
	
	/*inherited from Shape*/
	/**
	* @method lineStyle
	* @description 	define outline.		
	* 		
	* @usage   <pre>myBurst.lineStyle();</pre>
	* 		<pre>myBurst.lineStyle(lineThickness, lineRGB, lineAlpha);</pre>
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
	* @usage   <pre>myBurst.fillStyle();</pre>
	* 		<pre>myBurst.fillStyle(fillRGB, fillAlpha);</pre>
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
		return "Burst";
	}
}