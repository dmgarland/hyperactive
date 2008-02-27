import de.alex_uhlmann.animationpackage.utility.ColorCore;

/**
* @class ColorFX
* @author Alex Uhlmann, Marcel Fahle
* @description  Offers some color effect methods. Used by ColorNegative, ColorBrightness and 
* 				ColorDodge classes.
* 			<p>
* 			Example 1: Sets the movieclip mc to a negative color value.	
* 			<blockquote><pre>
*			var myColorFX:ColorFX = new ColorFX(mc);
*			myColorFX.setNegative(255);	
*			</pre></blockquote>
* 			<p>
* 
* @usage <pre>var myColorFX:ColorFX = new ColorFX(mc);</pre> 
* @param mc (MovieClip) Movieclip to animate. 
*/
class de.alex_uhlmann.animationpackage.utility.ColorFX extends ColorCore {			
	
	public function ColorFX(mc:MovieClip) {		
		super(mc);	
	}
	
	/**
	* @method getColorDodge
	* @description
	* @usage   <tt>myInstance.getColorDodge();</tt>
	* @return Object
	*/
	public function getColorDodge(Void):Object {		
		return {r:this.getRedDodge(), 
				g:this.getGreenDodge(), 
				b:this.getBlueDodge()};		
	}
	
	/**
	* @method setColorDodge
	* @description
	* @usage   <tt>myInstance.setColorDodge(rgb);</tt>
	* @param rgb (Object)	
	*/	
	public function setColorDodge(rgb:Object):Void {		
		this.setRedDodge(rgb.r);
		this.setGreenDodge(rgb.g);
		this.setBlueDodge(rgb.b);
	}
	
	/**
	* @method getRedDodge
	* @description
	* @usage   <tt>myInstance.getRedDodge();</tt>
	* @return Number
	*/
	//Marcel Fahle's Color Dodge methods - www.marcelfahle.com	
	public function getRedDodge(Void):Number {
		var trans:Object = this.getTransform();
		return ((25600-(258*trans.ra))/trans.ra);		
	}
	
	/**
	* @method setRedDodge
	* @description
	* @usage   <tt>myInstance.setRedDodge(value);</tt>
	* @param value (Number)	
	*/	
	public function setRedDodge(value:Number):Void {
		var trans:Object = this.getTransform();
		trans.ra=100/((258-value)/256);
		this.setTransform(trans);
	}
	
	/**
	* @method getGreenDodge
	* @description
	* @usage   <tt>myInstance.getGreenDodge();</tt>
	* @return Number
	*/	
	public function getGreenDodge(Void):Number{
		var trans:Object = this.getTransform();
		return ((25600-(258*trans.ga))/trans.ga);		
	}
	
	/**
	* @method setGreenDodge
	* @description
	* @usage   <tt>myInstance.setGreenDodge(value);</tt>
	* @param value (Number)	
	*/	
	public function setGreenDodge(value:Number):Void {
		var trans:Object = this.getTransform();
		trans.ga=100/((258-value)/256);
		this.setTransform(trans);
	}
	
	/**
	* @method getBlueDodge
	* @description
	* @usage   <tt>myInstance.getBlueDodge();</tt>
	* @return Number
	*/	
	public function getBlueDodge(Void):Number{
		var trans:Object = this.getTransform();
		return ((25600-(258*trans.ba))/trans.ba);		
	}	
	
	/**
	* @method setBlueDodge
	* @description
	* @usage   <tt>myInstance.setBlueDodge(value);</tt>
	* @param value (Number)	
	*/	
	public function setBlueDodge(value:Number):Void {
		var trans:Object = this.getTransform();
		trans.ba=100/((258-value)/256);
		this.setTransform(trans);
	}
	
	/**
	* @method getBrightness
	* @description
	* @usage   <tt>myInstance.getBrightness();</tt>
	* @return Number
	*/	
	//adapted color_toolkit.as by Robert Penner
	public function getBrightness(Void):Number {
		var trans:Object = this.getTransform();
		return trans.rb ? 100 - trans.ra : trans.ra - 100;		
	}	
	
	/**
	* @method setBrightness
	* @description
	* @usage   <tt>myInstance.setBrightness(bright);</tt>
	* @param bright (Number)	
	*/	
	// brighten just like Property Inspector
	// bright between -100 and 100
	public function setBrightness(bright:Number):Void {			
		var trans:Object = this.getTransform();		
		trans.ra = trans.ga = trans.ba = 100 - Math.abs (bright); // color percent
		trans.rb = trans.gb = trans.bb = (bright > 0) ? bright * (256/100) : 0; // color offset
		this.setTransform (trans);		
	}
	
	/**
	* @method getNegative
	* @description
	* @usage   <tt>myInstance.getNegative();</tt>
	* @return Number
	*/	
	public function getNegative(Void):Number {		
		return this.getTransform().rb * (100/255);
	}
	
	/**
	* @method setNegative
	* @description
	* @usage   <tt>myInstance.setNegative(percent);</tt>
	* @param percent (Number)	
	*/	
	// produce a negative image of the normal appearance
	public function setNegative(percent:Number):Void {
		var t:Object = {};
		t.ra = t.ga = t.ba = 100 - 2 * percent;
		t.rb = t.gb = t.bb = percent * (255/100);
		this.setTransform (t);
	}
	
	/**
	* @method hexrgb2rgb
	* @description
	* @usage   <tt>myInstance.hexrgb2rgb(hexrgb);</tt>
	* @param hexrgb (Number)
	* @return Object
	*/	
	
	/**
	* @method rgb2hexrgb
	* @description
	* @usage   <tt>myInstance.rgb2hexrgb(r,g,b);</tt>
	* @param r (Number)
	* @param g (Number)
	* @param b (Number)
	* @return Number
	*/
	
	/**
	* @method reset
	* @description reset the color object to normal.
	* @usage   <tt>myInstance.reset();</tt>
	*/	
	
	/**
	* @method toString
	* @description 	returns the name of the class.
	* @usage   <tt>myInstance.toString();</tt>
	* @return String
	*/		
	public function toString(Void):String {
		return "ColorFX";
	}	
}