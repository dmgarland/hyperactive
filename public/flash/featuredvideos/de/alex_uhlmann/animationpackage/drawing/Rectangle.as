import de.alex_uhlmann.animationpackage.drawing.IDrawable;
import de.alex_uhlmann.animationpackage.drawing.Shape;

/**
* @class Rectangle
* @author Alex Uhlmann
* @description Rectangle is a class for creating rectangles.
* 			If you specify a movieclip as first parameter, the shape will be drawn inside this movieclip. 
* 			If you omit the mc parameter, the class will create a new movieclip in _root.apContainer_mc.
* 			<p>
* 			Example 1: draw a rectangle with default parameters.		
* 			<blockquote><pre>
*			var myRectangle:Rectangle = new Rectangle();
*			myRectangle.draw();
*			</pre></blockquote> 
* 			Example 2: draw a rectangle with custom parameters.		
* 			<blockquote><pre>
*			var myRectangle:Rectangle = new Rectangle(275,200,100,100);
*			myRectangle.lineStyle(2,0x000000,100);
*			myRectangle.fillStyle(0xff0000,100);
*			myRectangle.draw();
*			</pre></blockquote>
* 			Example 3: If we scale our rectangle from example 2 with the MovieClip._xscale, 
* 			MovieClip._yscale properties, the outline will scale too. If you want the outline 
* 			to stay fixed and just scale the fill, you need to redraw the rectangle in each step. 
* 			This allows the setSize method. Let's do a test to illustrate this: After the code 
* 			from example 2, write:
* 			<blockquote><pre>
* 			new Scale(myRectangle.movieclip).run(400,400);
* 			</pre></blockquote>
* 			<a href="Rectangle_03a.html">(Example .swf)</a> 
*  			You'll notice the that the outline also scaled. Instead using the Scale class, 
* 			use setScale() in combination with the Animator class from the ultility package. 
* 			<blockquote><pre>
*			var myAnimator:Animator = new Animator();				
*			myAnimator.caller = myAnimator;	
*			myAnimator.start = [myRectangle.getSize().w,myRectangle.getSize().h];
*			myAnimator.end = [400,400];
*			myAnimator.setter = [[_root,"scale"]];
*			myAnimator.run();
*			//Proxy class.			
*			function scale(w:Number,h:Number) {	
*				myRectangle.setSize(w,h);
*				myRectangle.draw();		
*			}
* 			</pre></blockquote>
* 			<a href="Rectangle_03b.html">(Example .swf)</a> 
* 			See Animator class.
* 
* @usage <pre>var myRectangle:Rectangle = new Rectangle();</pre> 
* 		<pre>var myRectangle:Rectangle = new Rectangle(x, y, width, height);</pre>
*		<pre>var myRectangle:Rectangle = new Rectangle(mc, x, y, width, height);</pre>
* @param mc (MovieClip) existing movieclip to draw in.
* @param x (Number) X position of the drawing. Center point.
* @param y (Number) Y position of the drawing. Center point.
* @param width (Number) width of rectangle in pixels.
* @param height (Number) height of rectangle in pixels.
*/
class de.alex_uhlmann.animationpackage.drawing.Rectangle 
											extends Shape 
											implements IDrawable {	
	
	/*static default properties*/
	/*lineStyle properties inherited from Shape*/
	/*fillStyle properties inherited from Shape*/	
	/** 
	* @property width_def (Number)(static) default property. width of rectangle. Defaults to 100.
	* @property height_def (Number)(static) default property. height of rectangle. Defaults to 100.
	* 
	* @property movieclip (MovieClip)(read only) Movieclip that contains the drawing.
	* @property lineThickness (Number) Outline thickness.
	* @property lineRGB (Number) Outline color of the drawing as hex number.
	* @property lineAlpha (Number) Outline transparency (alpha).
	* @property fillRGB (Number) Fill color of the drawing.
	* @property fillAlpha (Number) Fill transparency.	
	*/	
	public static var x_def:Number = 0;
	public static var y_def:Number = 0;
	public static var width_def:Number = 100;
	public static var height_def:Number = 100;	
	private var x:Number = 0;
	private var y:Number = 0;
	private var m_width:Number;
	private var m_height:Number;
	
	public function Rectangle() {
		super(true);
		if(arguments[0] === false) {
			return;
		}
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
	
		this.x = (x == null) ? Rectangle.x_def : x;
		this.y = (y == null) ? Rectangle.y_def : width;
		this.m_width = (width == null) ? Rectangle.width_def : width;
		this.m_height = (height == null) ? Rectangle.height_def : height;		
		this.setRegistrationPoint({position:"CENTER"});
	}	
	
	/*inherited from Shape*/
	/**
	* @method draw
	* @description 	Draws the rectangle.
	* @usage  <pre>myRectangle.draw();</pre>
	*/
	
	/**
	* @method drawBy
	* @description 	Draws the shape without clearing the movieclip.
	* @usage <pre>myInstance.drawBy();</pre>
	*/
	
	/**
	* @method getSize
	* @description 	Returns the dimensions of the rectangle.
	* @usage  <pre>myRectangle.getSize();</pre>
	* @return Object that contains w for with and h for height properties that define the dimension of the drawing in pixels. 
	*/	
	public function getSize(Void):Object {		
		return {w:this.m_width, h:this.m_height};	
	}
	
	/**
	* @method setSize
	* @description 	Sets the dimensions of the rectangle.		
	* 		
	* @usage   <pre>myRectangle.setSize(width, height);</pre>
	* 	  
	* @param width (Number) width of rectangle in pixels.
	* @param height (Number) height of rectangle in pixels.
	*/	
	public function setSize(width:Number, height:Number):Void {
		this.x -= (width - this.m_width) / 2;
		this.y -= (height - this.m_height) / 2;
		this.m_width = width;
		this.m_height = height;		
	}
	
	/*inherited from Shape*/
	/**
	* @method lineStyle
	* @description 	define outline.		
	* 		
	* @usage   <pre>myRectangle.lineStyle();</pre>
	* 		<pre>myRectangle.lineStyle(lineThickness, lineRGB, lineAlpha);</pre>
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
	* @usage   <pre>myRectangle.fillStyle();</pre>
	* 		<pre>myRectangle.fillStyle(fillRGB, fillAlpha);</pre>
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
		this.mc.moveTo(x, y);
		if (this.fillRGB != null && this.fillGradient == false) {
			this.mc.beginFill(this.fillRGB, this.fillAlpha);
		} else if (this.fillGradient == true){
			this.mc.beginGradientFill(this.gradientFillType, this.gradientColors, this.gradientAlphas, this.gradientRatios, this.gradientMatrix);
		}			
		this.drawRect(this.x, this.y, this.m_width, this.m_height);		
		this.mc.endFill();
	}
	
	private function drawRect(x:Number, y:Number, w:Number, h:Number):Void {	
		this.mc.lineTo(x+w, y);
		this.mc.lineTo(x+w, y+h);
		this.mc.lineTo(x, y+h);
		this.mc.lineTo(x, y);
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
			this.x = -(this.m_width / 2);
			this.y = -(this.m_height / 2);			
		} else { 
			if(registrationObj.x != null ) {
				this.x = registrationObj.x;
			}
			if(registrationObj.y != null ) {
				this.y = registrationObj.y;
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
		return "Rectangle";
	}
}