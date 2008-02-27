/*
* @class ColorCore
* @author Alex Uhlmann
* @description  Base class of color related classes in AnimationPackage. 
* 			(ColorFX and ColorToolkit) It offers common used methods 
* 			and subclasses from build-in Color. Handles movieclip registration.
*/
class de.alex_uhlmann.animationpackage.utility.ColorCore extends Color {			
	
	public var movieclip:MovieClip;
	
	public function ColorCore(mc:MovieClip) {
		super(mc);	
		movieclip = mc;
	}
	
	//Adapted from Colin Moock, ASDG2
	public function hexrgb2rgb(hexrgb:Number):Object {
		var red:Number = (hexrgb >> 16) & 0xff;
		var green:Number = (hexrgb >> 8) & 0xff;
		var blue:Number = hexrgb & 0xff;
		return {r:red, g:green, b:blue};
	}
	
	//Adapted from Colin Moock, ASDG2
	public function rgb2hexrgb(r:Number, g:Number, b:Number):Number {
		/*combine the color values into a single number.*/
		return ((r<<16) | (g<<8) | b);		
	}
	
	// reset the color object to normal
	public function reset(Void):Void {
		this.setTransform ({ra:100, ga:100, ba:100, rb:0, gb:0, bb:0});
	}
	
	public function toString(Void):String {
		return "ColorCore";
	}	
}