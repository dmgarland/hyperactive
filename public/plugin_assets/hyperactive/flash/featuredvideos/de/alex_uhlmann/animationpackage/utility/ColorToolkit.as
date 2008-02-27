import de.alex_uhlmann.animationpackage.utility.ColorCore;

/**
* @class ColorToolkit
* @author Alex Uhlmann
* @description  Offers easy access to properties of the Color transform object. 
* 				Used by ColorTransform and ColorDodge classes.
* 			<p>
* 			Example 1: Sets the movieclip mc to a solid write color.	
* 			<blockquote><pre>
*			var myColorToolkit:ColorToolkit = new ColorToolkit(mc);
*			myColorToolkit.setColorOffsetHex(0xffffff);
*			</pre></blockquote>
* 			<p>
* 
* @usage <pre>var myColorToolkit:ColorToolkit = new ColorToolkit(mc);</pre> 
* @param mc (MovieClip) Movieclip to animate. 
*/
//adapted color_toolkit.as by Robert Penner
class de.alex_uhlmann.animationpackage.utility.ColorToolkit extends ColorCore {			
		
	public function ColorToolkit(mc:MovieClip) {
		super(mc);		
	}
	
	/**
	* @method getColorOffsetHex
	* @description
	* @usage   <tt>myInstance.getColorOffsetHex();</tt>
	* @return Number
	*/	
	public function getColorOffsetHex(Void):Number {		
		return this.rgb2hexrgb(this.getRedOffset(), 
								this.getGreenOffset(), 
								this.getBlueOffset());		
	}
	
	/**
	* @method setColorOffsetHex
	* @description
	* @usage   <tt>myInstance.setColorOffsetHex(rgb);</tt>
	* @param rgb (Number)	
	*/
	public function setColorOffsetHex(rgb:Number):Void {		
		var rgbObj:Object = this.hexrgb2rgb(rgb);		
		this.setRedOffset(rgbObj.r);
		this.setGreenOffset(rgbObj.g);
		this.setBlueOffset(rgbObj.b);		
	}
	
	/**
	* @method getColorOffset
	* @description
	* @usage   <tt>myInstance.getColorOffset();</tt>
	* @return Object
	*/	
	public function getColorOffset(Void):Object {		
		return {r:this.getRedOffset(), 
				g:this.getGreenOffset(), 
				b:this.getBlueOffset(), 
				a:this.getAlphaOffset()};		
	}
	
	/**
	* @method setColorOffset
	* @description
	* @usage   <tt>myInstance.setColorOffset(rgb);</tt>
	* @param rgb (Object)	
	*/	
	public function setColorOffset(rgb:Object):Void {		
		this.setRedOffset(rgb.r);
		this.setGreenOffset(rgb.g);
		this.setBlueOffset(rgb.b);
		this.setAlphaOffset(rgb.a);
	}
	
	/**
	* @method getColorPercent
	* @description
	* @usage   <tt>myInstance.getColorPercent();</tt>
	* @return Object
	*/	
	public function getColorPercent(Void):Object {		
		return {r:this.getRedPercent(), 
				g:this.getGreenPercent(), 
				b:this.getBluePercent(), 
				a:this.getAlphaPercent()};
	}
	
	/**
	* @method setColorPercent
	* @description
	* @usage   <tt>myInstance.setColorPercent(percent);</tt>
	* @param percent (Number)	
	*/	
	public function setColorPercent(percent:Number):Void {			
		this.setRedPercent(percent);
		this.setGreenPercent(percent);
		this.setBluePercent(percent);
		this.setAlphaPercent(percent);
	}	
	
	/**
	* @method getRedOffset
	* @description
	* @usage   <tt>myInstance.getRedOffset();</tt>
	* @return Number
	*/	
	//color offset
	public function getRedOffset(Void):Number {		
		return this.getTransform().rb;
	}	
	
	/**
	* @method setRedOffset
	* @description
	* @usage   <tt>myInstance.setRedOffset(offset);</tt>
	* @param offset (Number)	
	*/	
	public function setRedOffset(offset:Number):Void {
		var trans:Object = this.getTransform();
		trans.rb = offset;
		this.setTransform (trans);
	}
	
	/**
	* @method getGreenOffset
	* @description
	* @usage   <tt>myInstance.getGreenOffset();</tt>
	* @return Number
	*/	
	public function getGreenOffset(Void):Number {		
		return this.getTransform().gb;
	}	
	
	/**
	* @method setGreenOffset
	* @description
	* @usage   <tt>myInstance.setGreenOffset(offset);</tt>
	* @param offset (Number)	
	*/	
	public function setGreenOffset(offset:Number):Void {
		var trans:Object = this.getTransform();
		trans.gb = offset;
		this.setTransform(trans);
	}

	/**
	* @method getBlueOffset
	* @description
	* @usage   <tt>myInstance.getBlueOffset();</tt>
	* @return Number
	*/
	public function getBlueOffset(Void):Number {		
		return this.getTransform().bb;
	}	
	
	/**
	* @method setBlueOffset
	* @description
	* @usage   <tt>myInstance.setBlueOffset(offset);</tt>
	* @param offset (Number)	
	*/	
	public function setBlueOffset(offset:Number):Void {
		var trans:Object = this.getTransform();
		trans.bb = offset;
		this.setTransform (trans);
	}
	
	/**
	* @method getAlphaOffset
	* @description
	* @usage   <tt>myInstance.getAlphaOffset();</tt>
	* @return Number
	*/	
	public function getAlphaOffset(Void):Number {		
		return this.getTransform().ab;
	}	
	
	/**
	* @method setAlphaOffset
	* @description
	* @usage   <tt>myInstance.setAlphaOffset(offset);</tt>
	* @param offset (Number)	
	*/	
	public function setAlphaOffset(offset:Number):Void {
		var trans:Object = this.getTransform();
		trans.ab = offset;		
		this.setTransform(trans);
	}	
	
	/**
	* @method getRedPercent
	* @description
	* @usage   <tt>myInstance.getRedPercent();</tt>
	* @return Number
	*/	
	//color percent
	public function getRedPercent(Void):Number {		
		return this.getTransform().ra;
	}	
	
	/**
	* @method setRedPercent
	* @description
	* @usage   <tt>myInstance.setRedPercent(percent);</tt>
	* @param percent (Number)	
	*/	
	public function setRedPercent(percent:Number):Void {
		var trans:Object = this.getTransform();
		trans.ra = percent;
		this.setTransform(trans);
	}
	
	/**
	* @method getGreenPercent
	* @description
	* @usage   <tt>myInstance.getGreenPercent();</tt>
	* @return Number
	*/	
	public function getGreenPercent(Void):Number {		
		return this.getTransform().ga;
	}	
	
	/**
	* @method setGreenPercent
	* @description
	* @usage   <tt>myInstance.setGreenPercent(percent);</tt>
	* @param percent (Number)	
	*/	
	public function setGreenPercent(percent:Number):Void {
		var trans:Object = this.getTransform();
		trans.ga = percent;
		this.setTransform(trans);
	}
	
	/**
	* @method getBluePercent
	* @description
	* @usage   <tt>myInstance.getBluePercent();</tt>
	* @return Number
	*/	
	public function getBluePercent(Void):Number {		
		return this.getTransform().ba;
	}	
	
	/**
	* @method setBluePercent
	* @description
	* @usage   <tt>myInstance.setBluePercent(percent);</tt>
	* @param percent (Number)	
	*/	
	public function setBluePercent(percent:Number):Void {
		var trans:Object = this.getTransform();
		trans.ba = percent;
		this.setTransform(trans);
	}
	
	/**
	* @method getAlphaPercent
	* @description
	* @usage   <tt>myInstance.getAlphaPercent();</tt>
	* @return Number
	*/	
	public function getAlphaPercent(Void):Number {		
		return this.getTransform().aa;
	}	
	
	/**
	* @method setAlphaPercent
	* @description
	* @usage   <tt>myInstance.setAlphaPercent(percent);</tt>
	* @param percent (Number)	
	*/	
	public function setAlphaPercent(percent:Number):Void {
		var trans:Object = this.getTransform();
		trans.aa = percent;
		this.setTransform(trans);
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
		return "ColorToolkit";
	}	
}