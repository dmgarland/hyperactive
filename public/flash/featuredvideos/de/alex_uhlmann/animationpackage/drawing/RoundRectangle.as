import de.alex_uhlmann.animationpackage.drawing.IDrawable;
import de.alex_uhlmann.animationpackage.drawing.Rectangle;

/**
* @class RoundRectangle
* @author Alex Uhlmann
* @description RoundRectangle is a class for creating rectangles and	rounded rectangles. 
* 			The rounding is very much like that of the rectangle tool in Flash where if the
*			rectangle is smaller in either dimension than the rounding would permit, 
*			the rounding scales down to fit.
* 			If you specify a movieclip as first parameter, the shape will be drawn inside this movieclip. 
* 			If you omit the mc parameter, the class will create a new movieclip in _root.apContainer_mc.
* 			<p>
* 			Example 1: draw a rectangle with default parameters.		
* 			<blockquote><pre>
*			var myRoundRectangle:RoundRectangle = new RoundRectangle();			
* 			myRoundRectangle.draw();
*			</pre></blockquote> 
* 			Example 2: draw a rectangle with custom parameters.		
* 			<blockquote><pre>
*			var myRoundRectangle:RoundRectangle = new RoundRectangle(275,200,200,100);
*			myRoundRectangle.setCornerRadius(60);
* 			myRoundRectangle.lineStyle(2,0xff0000,100);
*			myRoundRectangle.fillStyle(0x000000,100);
*			myRoundRectangle.draw();
*			</pre></blockquote> 
* 			Example 3: Draw another rounded rectangle with each corner different.
* 			<blockquote><pre>
*			var myRoundRectangle:RoundRectangle = new RoundRectangle(275,200,200,100);
*			myRoundRectangle.setCornerRadii({tl:5,tr:10,bl:20,br:40});
*			myRoundRectangle.lineStyle(5,0xff0000,100);
*			myRoundRectangle.fillStyle(0x000000,100);
*			myRoundRectangle.draw();
* 			</pre></blockquote>
* 			<p>
* 			Example 4: Take a look at example 3 of the Rectangle class documentation. Same applies to RoundRectangle.
* 
* @usage <pre>var myRoundRectangle:RoundRectangle = new RoundRectangle();</pre> 
* 		<pre>var myRoundRectangle:RoundRectangle = new RoundRectangle(x, y, width, height, cornerRadius);</pre>
* 		<pre>var myRoundRectangle:RoundRectangle = new RoundRectangle(x, y, width, height, cornerRadii);</pre>
* 		<pre>var myRoundRectangle:RoundRectangle = new RoundRectangle(mc, x, y, width, height, cornerRadius);</pre>
*  		<pre>var myRoundRectangle:RoundRectangle = new RoundRectangle(mc, x, y, width, height, cornerRadii);</pre>
* @param mc (MovieClip) existing movieclip to draw in.
* @param x (Number) X position of the drawing. Center point.
* @param y (Number) Y position of the drawing. Center point.
* @param width (Number) width of rectangle in pixels.
* @param height (Number) height of rectangle in pixels.
* @param cornerRadii or cornerRadius(Object or Number) see setCornerRadii and setCornerRadius.
*/
class de.alex_uhlmann.animationpackage.drawing.RoundRectangle 
											extends Rectangle 
											implements IDrawable {	
	
	/*static default properties*/
	/*lineStyle properties inherited from Shape*/
	/*fillStyle properties inherited from Shape*/	
	/** 
	* @property width_def (Number)(static) default property. width of rectangle. Defaults to 100.
	* @property height_def (Number)(static) default property. height of rectangle. Defaults to 100.
	* @property cornerRadii_def (Object)(static) default property. corner radii of rectangle. Defaults to 25 degrees each.
	* 
	* @property movieclip (MovieClip)(read only) Movieclip that contains the drawing.
	* @property lineThickness (Number) Outline thickness.
	* @property lineRGB (Number) Outline color of the drawing as hex number.
	* @property lineAlpha (Number) Outline transparency (alpha).
	* @property fillRGB (Number) Fill color of the drawing.
	* @property fillAlpha (Number) Fill transparency.	
	*/
	public static var cornerRadii_def:Object = {tl:25,tr:25,bl:25,br:25};
	private var cornerRadii:Object;
	private var cornerRadius:Number;
	
	public function RoundRectangle() {
		super(false);
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

	private function initCustom(mc:MovieClip, x:Number, y:Number, width:Number, height:Number):Void {		
		
		this.mc = this.createClip({mc:mc, x:x, y:y});		
		this.initShape.apply(this,arguments.slice(1));
	}

	private function initAuto(x:Number, y:Number, width:Number, height:Number):Void {		
		
		this.mc = this.createClip({name:"apDraw", x:x, y:y});		
		this.initShape.apply(this,arguments);
	}
		
	private function initShape(x:Number, y:Number, width:Number, height:Number):Void {	
		var cornerRadii:Object = arguments[4];
		var temp = cornerRadii;
		if(typeof(temp) == "number") {
			this.setCornerRadius(temp);
		} else {
			this.cornerRadii = (cornerRadii == null) ? RoundRectangle.cornerRadii_def : cornerRadii;		
			if(this.setCornerRadii(cornerRadii) == false) {
				this.cornerRadii = RoundRectangle.cornerRadii_def;
			}
		}
		super.initShape(x, y, width, height);
	}
	
	/*inherited from Rectangle*/
	/**
	* @method draw
	* @description 	Draws the rectangle.
	* @usage  <pre>myRoundRectangle.draw();</pre>
	*/
	
	/**
	* @method drawBy
	* @description 	Draws the shape without clearing the movieclip.
	* @usage <pre>myInstance.drawBy();</pre>
	*/
	
	/**
	* @method getCornerRadius
	* @description 	returns the corner radius of the rectangle in degrees.
	* @usage  <pre>myRoundRectangle.getCornerRadius();</pre>
	* @return Number 
	*/
	public function getCornerRadius(Void):Number {
		return this.cornerRadius;		
	}
	
	/**
	* @method setCornerRadius
	* @description 	sets the corner radius of the rectangle in degrees.
	* @usage  <pre>myRoundRectangle.getCornerRadius();</pre>
	* @param cornerRadius (Number) 
	*/
	public function setCornerRadius(cornerRadius:Number):Void {
		this.cornerRadius = cornerRadius;		
	}
	
	/**
	* @method getCornerRadii
	* @description 	returns the corner radii (plural of radius) of the rectangle in degrees.
	* @usage  <pre>myRoundRectangle.setCornerRadii();</pre>
	* @return Object 
	*/
	public function getCornerRadii(Void):Object {
		return this.cornerRadii;		
	}
	
	/**
	* @method setCornerRadii
	* @description 	sets the corner radii (plural of radius) of the rectangle in degrees.
	* 				Only accepts objects with tl (top left), tr (top right), bl (bottom left) and br (bottom right) properties.
	* @usage  <pre>myRoundRectangle.setCornerRadii();</pre>
	* @param cornerRadius (Object) 
	*/
	public function setCornerRadii(cornerRadii:Object):Boolean {		
		if(cornerRadii.tl != null && cornerRadii.tr != null && cornerRadii.bl != null && cornerRadii.br != null) {
			this.cornerRadii = cornerRadii;
			return true;
		} else {
			return false;
		}
	}	
	
	/*inherited from Rectangle*/	
	/**
	* @method getSize
	* @description 	Returns the dimensions of the rectangle.
	* @usage  <pre>myRectangle.getSize();</pre>
	* @return Object that contains w for with and h for height properties that define the dimension of the drawing in pixels. 
	*/	
	
	/*inherited from Rectangle*/	
	/**
	* @method setSize
	* @description 	Sets the dimensions of the rectangle.		
	* 		
	* @usage   <pre>myRectangle.setSize(width, height);</pre>
	* 	  
	* @param width (Number) width of rectangle in pixels.
	* @param height (Number) height of rectangle in pixels.
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
		var c:Number = this.cornerRadius;
		if(c != null) {
			this.cornerRadii = {tl:c,tr:c,bl:c,br:c};
		}
		this.drawRect(this.x, this.y, this.m_width, this.m_height, this.cornerRadii);
		this.mc.endFill();
	}
	
	/*-------------------------------------------------------------
		drawRect() is a method for drawing rectangles and
		rounded rectangles. Regular rectangles are
		sufficiently easy that I often just rebuilt the
		method in any file I needed it in, but the rounded
		rectangle was something I was needing more often,
		hence the method. The rounding is very much like
		that of the rectangle tool in Flash where if the
		rectangle is smaller in either dimension than the
		rounding would permit, the rounding scales down to
		fit.
	-------------------------------------------------------------*/
	private function drawRect(x:Number, y:Number, w:Number, h:Number):Void {
		var cornerRadii:Object = arguments[4];
		// ==============
		// drawRect() - by Ric Ewing (ric@formequalsfunction.com) - version 1.1 - 4.7.2002
		// 
		// x, y = top left corner of rect
		// w = width of rect
		// h = height of rect
		// cornerRadius = [optional] radius of rounding for corners (defaults to 0)
		// ==============
		// if the user has defined cornerRadius our task is a bit more complex. :)
		if(cornerRadii.tl >= 0 && cornerRadii.tr >= 0 && cornerRadii.bl >= 0 && cornerRadii.br >= 0) {
			// init vars
			var theta:Number, angle:Number, cx:Number, cy:Number, px:Number, py:Number;
			// make sure that w + h are larger than 2*cornerRadius
			var maxRadii:Number = Math.min(w, h)/2;
			if(cornerRadii.tl > maxRadii) {
				cornerRadii.tl = maxRadii;
			}
			if(cornerRadii.tr > maxRadii) {
				cornerRadii.tr = maxRadii;
			}
			if(cornerRadii.bl > maxRadii) {
				cornerRadii.bl = maxRadii;
			}
			if(cornerRadii.br > maxRadii) {
				cornerRadii.br = maxRadii;
			}			
			// theta = 45 degrees in radians
			theta = Math.PI/4;
			
			if(cornerRadii.tr > 0) {
				// draw top line
				this.mc.moveTo(x+cornerRadii.tl, y); 
				this.mc.lineTo(x+w-cornerRadii.tr, y);
				//angle is currently 90 degrees
				angle = -Math.PI/2;
				// draw tr corner in two parts
				cx = x+w-cornerRadii.tr+(Math.cos(angle+(theta/2))*cornerRadii.tr/Math.cos(theta/2));
				cy = y+cornerRadii.tr+(Math.sin(angle+(theta/2))*cornerRadii.tr/Math.cos(theta/2));
				px = x+w-cornerRadii.tr+(Math.cos(angle+theta)*cornerRadii.tr);
				py = y+cornerRadii.tr+(Math.sin(angle+theta)*cornerRadii.tr);
				this.mc.curveTo(cx, cy, px, py);
				angle += theta;
				cx = x+w-cornerRadii.tr+(Math.cos(angle+(theta/2))*cornerRadii.tr/Math.cos(theta/2));
				cy = y+cornerRadii.tr+(Math.sin(angle+(theta/2))*cornerRadii.tr/Math.cos(theta/2));
				px = x+w-cornerRadii.tr+(Math.cos(angle+theta)*cornerRadii.tr);
				py = y+cornerRadii.tr+(Math.sin(angle+theta)*cornerRadii.tr);
				this.mc.curveTo(cx, cy, px, py);
			} else {				
				this.mc.moveTo(x+cornerRadii.tl, y);
				this.mc.lineTo(x+w, y);
				//angle is currently 90 degrees
				angle = -Math.PI/2;
				angle += theta;
			}			
			if(cornerRadii.br > 0) {
				// draw right line
				this.mc.lineTo(x+w, y+h-cornerRadii.br);
				// draw br corner
				angle += theta;
				cx = x+w-cornerRadii.br+(Math.cos(angle+(theta/2))*cornerRadii.br/Math.cos(theta/2));
				cy = y+h-cornerRadii.br+(Math.sin(angle+(theta/2))*cornerRadii.br/Math.cos(theta/2));
				px = x+w-cornerRadii.br+(Math.cos(angle+theta)*cornerRadii.br);
				py = y+h-cornerRadii.br+(Math.sin(angle+theta)*cornerRadii.br);
				this.mc.curveTo(cx, cy, px, py);
				angle += theta;
				cx = x+w-cornerRadii.br+(Math.cos(angle+(theta/2))*cornerRadii.br/Math.cos(theta/2));
				cy = y+h-cornerRadii.br+(Math.sin(angle+(theta/2))*cornerRadii.br/Math.cos(theta/2));
				px = x+w-cornerRadii.br+(Math.cos(angle+theta)*cornerRadii.br);
				py = y+h-cornerRadii.br+(Math.sin(angle+theta)*cornerRadii.br);
				this.mc.curveTo(cx, cy, px, py);
			} else {
				this.mc.lineTo(x+w, y+h);
				angle += theta;
				angle += theta;				
			}
			if(cornerRadii.bl > 0) {
				// draw bottom line
				this.mc.lineTo(x+cornerRadii.bl, y+h);
				// draw bl corner
				angle += theta;
				cx = x+cornerRadii.bl+(Math.cos(angle+(theta/2))*cornerRadii.bl/Math.cos(theta/2));
				cy = y+h-cornerRadii.bl+(Math.sin(angle+(theta/2))*cornerRadii.bl/Math.cos(theta/2));
				px = x+cornerRadii.bl+(Math.cos(angle+theta)*cornerRadii.bl);
				py = y+h-cornerRadii.bl+(Math.sin(angle+theta)*cornerRadii.bl);
				this.mc.curveTo(cx, cy, px, py);
				angle += theta;
				cx = x+cornerRadii.bl+(Math.cos(angle+(theta/2))*cornerRadii.bl/Math.cos(theta/2));
				cy = y+h-cornerRadii.bl+(Math.sin(angle+(theta/2))*cornerRadii.bl/Math.cos(theta/2));
				px = x+cornerRadii.bl+(Math.cos(angle+theta)*cornerRadii.bl);
				py = y+h-cornerRadii.bl+(Math.sin(angle+theta)*cornerRadii.bl);
				this.mc.curveTo(cx, cy, px, py);
			} else {
				this.mc.lineTo(x, y+h);
				angle += theta;
				angle += theta;
			}
			if(cornerRadii.tl > 0) {
				// draw left line
				this.mc.lineTo(x, y+cornerRadii.tl);
				// draw tl corner
				angle += theta;
				cx = x+cornerRadii.tl+(Math.cos(angle+(theta/2))*cornerRadii.tl/Math.cos(theta/2));
				cy = y+cornerRadii.tl+(Math.sin(angle+(theta/2))*cornerRadii.tl/Math.cos(theta/2));
				px = x+cornerRadii.tl+(Math.cos(angle+theta)*cornerRadii.tl);
				py = y+cornerRadii.tl+(Math.sin(angle+theta)*cornerRadii.tl);
				this.mc.curveTo(cx, cy, px, py);
				angle += theta;
				cx = x+cornerRadii.tl+(Math.cos(angle+(theta/2))*cornerRadii.tl/Math.cos(theta/2));
				cy = y+cornerRadii.tl+(Math.sin(angle+(theta/2))*cornerRadii.tl/Math.cos(theta/2));
				px = x+cornerRadii.tl+(Math.cos(angle+theta)*cornerRadii.tl);
				py = y+cornerRadii.tl+(Math.sin(angle+theta)*cornerRadii.tl);
				this.mc.curveTo(cx, cy, px, py);
			} else {
				this.mc.lineTo(x, y);
				angle += theta;
				angle += theta;
			}		
		} else {
			// cornerRadius was not defined or = 0. This makes it easy.
			super.drawRect(x, y, w, h);
		}
	}
	
	/*inherited from Shape*/	
	/**
	* @method lineStyle
	* @description 	define outline.		
	* 		
	* @usage   <pre>myRoundRectangle.lineStyle();</pre>
	* 		<pre>myRoundRectangle.lineStyle(lineThickness, lineRGB, lineAlpha);</pre>
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
	* @usage   <pre>myRoundRectangle.fillStyle();</pre>
	* 		<pre>myRoundRectangle.fillStyle(fillRGB, fillAlpha);</pre>
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
		return "RoundRectangle";
	}
}