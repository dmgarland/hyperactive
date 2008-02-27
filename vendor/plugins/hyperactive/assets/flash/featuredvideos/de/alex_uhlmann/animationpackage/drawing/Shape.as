import de.alex_uhlmann.animationpackage.animation.AnimationCore;

/**
* @class Shape
* @author Alex Uhlmann
* @description  All drawing classes inside de.alex_uhlmann.animationpackage.drawing inherit their 
* 			lineStyle and fillStyle properties from Shape. If you don't specify 
* 			the lineStyle or fillStyle properties either with lineStyle() and fillStyle() methods 
* 			or directly via the properties, the default lineStyle and fillStyle properties are used.
* 			Shape gives you the opportunity	to set and retrieve default properties 
* 			for lineStyle and fillStyle properties. 
* 			Here is how those default properties are defined by default:		
* 			<pre><blockquote>
* 			Shape.lineThickness_def = null;
*			Shape.lineRGB_def = 0x000000;
*			Shape.lineAlpha_def = 100;	
*			Shape.fillRGB_def = 0x000000;
*			Shape.fillAlpha_def = 100;
* 			Shape.gradientFillType_def = null;
* 			Shape.gradientColors_def = null;
* 			Shape.gradientAlphas_def = null;
* 			Shape.gradientRatios_def = null;
* 			Shape.gradientMatrix_def = null;
* 			</pre></blockquote>
* 			Note that all default properties have the same name as their instance properties 
* 			but the suffix "_def".
* 			<p>
* 			Example 1: <a href="Shape_01.html">(Example .swf)</a> Declare 6 variables to store the three points that define the curve 
* 			for easy access. To visualize the points and the curve draw it with 
* 			the classes of the de.alex_uhlmann.animationpackage.drawing package. Then, 
*  			move the movieclip along the specified curve in 4 seconds using Bounce easing.	
* 			<pre><blockquote>
*			var x1:Number = 100;
*			var y1:Number = 100;
*			var x2:Number = 400;
*			var y2:Number = 200;
*			var x3:Number = 500;
*			var y3:Number = 400;
*			
*			var myQuadCurve:QuadCurve = new QuadCurve(x1,y1,x2,y2,x3,y3);
*			myQuadCurve.lineStyle(6);
*			myQuadCurve.draw();
*			
* 			//Since we want to draw three circles with the same style, which is not the default style, it makes sense to define default properties.
*			Shape.lineRGB_def = 0xff0000;
*			Shape.fillRGB_def = 0xff0000;
*			
*			new Ellipse(x1,y1,5,5).draw();						
*			new Ellipse(x2,y2,5,5).draw();
*			new Ellipse(x3,y3,5,5).draw();			
*			
*			var myMOC:MoveOnQuadCurve = new MoveOnQuadCurve(mc);
*			myMOC.animationStyle(4000,Bounce.easeOut);
*			myMOC.run(x1,y1,x2,y2,x3,y3);
* 			</pre></blockquote>
* 			<p> 
* 			Some classes have similarities to their equivalent in java.awt.geom.
* @usage <tt>private class constructor</tt> 
*/
class de.alex_uhlmann.animationpackage.drawing.Shape extends AnimationCore {
	
	/*static default properties*/
	/** 
	* @property lineThickness_def (Number)(static) default property. Outline thickness.
	* @property lineRGB_def (Number)(static) default property. Outline color of the drawing as hex number.
	* @property lineAlpha_def (Number)(static) default property. Outline transparency (alpha).
	* @property fillRGB_def (Number)(static) default property. Fill color of the drawing.
	* @property fillAlpha_def (Number)(static) default property. Fill transparency.
	* 
	* @property gradientFillType_def (String)(static) Gradient property. See MovieClip.beginGradientFill().
	* @property gradientColors_def (Array)(static) Gradient property. See MovieClip.beginGradientFill().
	* @property gradientAlphas_def (Array)(static) Gradient property. See MovieClip.beginGradientFill().
	* @property gradientRatios_def (Array)(static) Gradient property. See MovieClip.beginGradientFill().
	* @property gradientMatrix_def (Object)(static) Gradient property. See MovieClip.beginGradientFill().
	*/
	public static var lineRGB_def:Number = 0x000000;
	public static var lineAlpha_def:Number = 100;	
	public static var fillRGB_def:Number = 0x000000;
	public static var fillAlpha_def:Number = 100;
	private static var m_lineThickness_def:Number = null;
	private static var lineThickness_defModified:Boolean = false;	
	private static var gradientFillType_def:String;
	private static var gradientColors_def:Array;	
	private static var gradientAlphas_def:Array;
	private static var gradientRatios_def:Array;	
	private static var gradientMatrix_def:Object;
	private var penX:Number;
	private var penY:Number;
	private var initialized:Boolean = false;
	private var lineStyleModified:Boolean = false;
	
	private var m_lineThickness:Number;
	private var m_lineRGB:Number;
	private var m_lineAlpha:Number;	
	public var fillRGB:Number;
	public var fillAlpha:Number;
	
	public var fillGradient:Boolean = false;	
	public var gradientFillType:String;
	public var gradientColors:Array;	
	public var gradientAlphas:Array;
	public var gradientRatios:Array;	
	public var gradientMatrix:Object;	
	
	private function Shape(noEvents:Boolean) {		
		super(noEvents);
		if(Shape.lineThickness_defModified) {
			this.prepareLineStyle(Shape.m_lineThickness_def, null, null);			
		}
	}
	
	public function getPenPosition(Void):Object {
		return {x:this.penX, y:this.penY};
	}
	
	public function setPenPosition(p:Object):Void {
		this.penX = p.x;
		this.penY = p.y;
	}
	
	public function lineStyle(lineThickness:Number, lineRGB:Number, lineAlpha:Number):Void {		
		this.lineStyleModified = true;
		this.m_lineThickness = (lineThickness === null) ? Shape.lineThickness_def : lineThickness;	
		this.m_lineRGB = (lineRGB == null) ? Shape.lineRGB_def : lineRGB;
		this.m_lineAlpha = (lineAlpha == null) ? Shape.lineAlpha_def : lineAlpha;		
	}
	
	private function prepareLineStyle(lineThickness:Number, lineRGB:Number, lineAlpha:Number):Void {		
		if(lineThickness == null) {
			lineThickness = this.lineThickness;
		}
		if(lineRGB == null) {
			lineRGB = this.lineRGB;
		}
		if(lineAlpha == null) {
			lineAlpha = this.lineAlpha;
		}
		this.lineStyle(lineThickness, lineRGB, lineAlpha);
	}	
	
	public function fillStyle(fillRGB:Number, fillAlpha:Number):Void {
		this.fillGradient = false;
		this.fillRGB = (fillRGB === null) ? Shape.fillRGB_def : fillRGB;
		this.fillAlpha = (fillAlpha == null) ? Shape.fillAlpha_def : fillAlpha;
	}

	public function gradientStyle(fillType:String, colors:Array, alphas:Array, ratios:Array, matrix:Object):Void {
		this.fillGradient = true;
		this.gradientFillType = fillType;
		this.gradientColors = colors;
		this.gradientAlphas = alphas;
		this.gradientRatios = ratios;
		this.gradientMatrix = matrix;
	}
	
	private function clearDrawing(Void):Void {
		this.mc.clear();
		if(this.lineStyleModified) {
			this.mc.lineStyle(this.lineThickness, this.lineRGB, this.lineAlpha);
		}
	}
	
	public function clear(Void):Void {
		this.mc.clear();
	}	
	
	public function draw(Void):Void {
		this.clearDrawing();
		this.drawNew();
	}
	
	public function drawBy(Void):Void {
		if(this.lineStyleModified) {
			this.mc.lineStyle(this.lineThickness, this.lineRGB, this.lineAlpha);
		}
		this.drawNew();
	}
	
	//fails silently.
	private function drawNew(Void):Void {}
	
	public function setInitialized(initialized:Boolean):Void {
		this.initialized = initialized;
	}
	
	public function getInitialized(Void):Boolean {
		return this.initialized;
	}	
	
	public static function get lineThickness_def():Number {
		return Shape.m_lineThickness_def;
	}
	
	public static function set lineThickness_def(lineThickness_def:Number):Void {
		if(lineThickness_def == null) {
			Shape.lineThickness_defModified = false;
		} else {
			Shape.lineThickness_defModified = true;
		}
		Shape.m_lineThickness_def = lineThickness_def;
	}
	
	public function get lineRGB():Number {		
		return this.m_lineRGB;
	}
	
	public function set lineRGB(lineRGB:Number):Void {
		this.prepareLineStyle(null, lineRGB, null);		
	}
	
	public function get lineAlpha():Number {
		return this.m_lineAlpha;
	}
	
	public function set lineAlpha(lineAlpha:Number):Void {
		this.prepareLineStyle(null, null, lineAlpha);		
	}
	
	public function get lineThickness():Number {
		return this.m_lineThickness;
	}
	
	public function set lineThickness(lineThickness:Number):Void {
		this.prepareLineStyle(lineThickness, null, null);		
	}

	public function toString(Void):String {
		return "Shape";
	}
}