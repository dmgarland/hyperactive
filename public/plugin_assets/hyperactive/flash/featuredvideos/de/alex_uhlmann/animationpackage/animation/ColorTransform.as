import de.alex_uhlmann.animationpackage.animation.IMultiAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.Animator;
import de.alex_uhlmann.animationpackage.utility.ColorToolkit;

/**
* @class ColorTransform
* @author Alex Uhlmann
* @description Manipulates the colors of a movieclip or a number of movieclips 
* 			with help of the ColorToolkit class, 
* 			which extends the build-in Color class via the ColorCore class.
* 			ColorTransform accepts two kinds of color input values.<p>
* 			<b>Way no. 1 "easy way": One offset and one percentage value.</b><p>
* 			A number in the range 0 to 16777215 (0xFFFFFF), representing the new RGB offsets 
* 			of the movieclip. Can be a decimal integer or a hexadecimal integer. 
* 			Another number to specify the color transformation percentages of the movieclip. Does not allow 
* 			the manipulation of alpha components and of single color percentage values. Use "the complex way" 
* 			for that.<p>
* 			<b>Way no. 2 "complex way": A transform object like the one returned by Color.getTransform().</b><p>
* 			Takes one object with both, the offset and percentage values for a movieclip's 
* 			red, green, blue and alpha components. The properties can be: 
* 			ra, rb, ga, gb, ba, bb, aa, ab. Take a look into the Color 
* 			class of your Flash manual for more information about the properties
* 			of the Color transformObject or get <a href="http://www.moock.org">Colin Moock's</a> 
* 			ASDG for an in depth discussion. The transformationObject doesn't need to be complete. 
* 			If you haven't specified some of the eight properties, ColorTransform will retrieve the 
* 			missing color properties from the current color of your movieclip. Way no. 2 offers more 
* 			complex color manipulations than way no. 1, since you have access to all single 
* 			offset and percentage values of the movieclip including the alpha components.<p>
*  
* 			You can specify the duration, easing equation and callback properties 
* 			either with setting the properies directly or with the animationStyle() method 
* 			like it is used in de.alex_uhlmann.animationpackage.drawing.
* 			<p>
* 			Example 1a: Way no. 1
* 			<blockquote><pre>			
*			var myCT:ColorTransform = new ColorTransform(mc);
*			myCT.animationStyle(3000,Quad.easeOut,"onCallback");
*			myCT.run(0xff0000,50);
*			</pre></blockquote> 
* 			Example 1b: Way no. 2
* 			<blockquote><pre>			
*			var myCT:ColorTransform = new ColorTransform(mc);
*			myCT.animationStyle(3000,Quad.easeOut,"onCallback");
*			var brightRed:Object = {ra:50,rb:255,ga:50,gb:0,ba:50,bb:0,aa:100,ab:0};
*			myCT.run(brightRed);
*			</pre></blockquote>
* 			Note that 
* 			<pre><blockquote>
* 			var brightRed:Object = {ra:50,rb:255,ga:50,gb:0,ba:50,bb:0,aa:100,ab:0}; 			
* 			</pre></blockquote>
* 			is just another syntax for
* 			<pre><blockquote>
* 			var brightRed:Object = new Object();
* 			brightRed.ra = 50;
* 			brightRed.rb = 255;
* 			brightRed.ga = 50;
* 			brightRed.gb = 0;
* 			brightRed.ba = 50;
* 			brightRed.bb = 0;
* 			brightRed.aa = 100;
* 			brightRed.ab = 0; 			
* 			</pre></blockquote> 			
* 			Example 2: The alternative way is shorter. The same like above in one line.
* 			<blockquote><pre>	
* 			new ColorTransform(mc).run(0xff0000,50,3000,Quad.easeOut,"onCallback");
* 			</pre></blockquote>
*  			Example 3: You can also specify the properties via the constructor. 
* 			This might come in handy if you're using the Sequence or Parallel class.  
* 			Take a look at their class documentations for more information. 
* 			The animate() method and its start and end paremeters might also be useful. 
* 			<blockquote><pre>
* 			var myColorTransform:ColorTransform = new ColorTransform(mc,0xff0000,50,2000,Circ.easeInOut,"onCallback");
* 			myColorTransform.animate(0,100);
* 			</pre></blockquote>
* 			Example 4: By default, the start value of your animation is the current value. You can explicitly 
* 			define the start values either via the setStartValues or run method or via the constructor. Here is one 
* 			example for the constructor solution. This also might come in handy using composite classes, like 
* 			Sequence.
* 			<blockquote><pre>
*			var myCT:ColorTransform = new ColorTransform(mc,[0x0000ff,20,0xff0000,20],3000,Quad.easeOut);
*			myCT.run();
* 			</pre></blockquote>	
*  			<p> 
* 			Example 5: Transform the color of a movieclip to an opaque red tone
* 			using default animationStyle properties (1 second, using linear easing). 
* 			<blockquote><pre>
*			var myCT:ColorTransform = new ColorTransform(mc);
*			myCT.run(0xff0000,0);
*			</pre></blockquote>
* 			<p>
* 			Example 6: <a href="ColorTransform_run_02.html">(Example .swf)</a> Colorize a movieclip to red with 50 percentage and then to green
* 			with 50 percentage in 6 seconds using Quad easing. Note that I nullify 
* 			the callback property, which would call the onCallback method again. 
* 			<blockquote><pre>			
*			var myCT:ColorTransform = new ColorTransform(mc);
*			myCT.animationStyle(3000,Quad.easeOut,"onCallback");
*			myCT.run(0xff0000,50);
*			myListener.onCallback = function() {	
*				myCT.callback = null;
*				myCT.run(0x00ff00,50);	
*			}
*			</pre></blockquote>
* 			<p>
* 			Example 7: Use the transformationObject to fade a movieclip from 
* 			opaque red to opaque green in 3 seconds.
* 			<blockquote><pre>
*			var myCT:ColorTransform = new ColorTransform(mc);
*			myCT.animationStyle(3000);
*			//Note that you don't have to specify all of the possible properties in the tansformationObject.
* 			//ColorTransform will retrieve the missing properties from your current movieclip.
*			var red:Object = {ra:0,rb:255,ga:0,gb:0,ba:0,bb:0};
*			var green:Object = {ra:0,rb:0,ga:0,gb:255,ba:0,bb:0};
*			
*			myCT.setStartValues([red]);
*			myCT.setEndValues([green]);			
*			myCT.run();
*			</pre></blockquote>
* 			<p>
* 			Example 8: Do the same like in example 7 just use way no. 1. Notice that I listen to all 
* 			events from ColorTransform (onStart, onUpdate and onEnd). Inside the handler methods you 
* 			can access the color values of the current state of the animation. There are two ways to 
* 			accomblish this. One way is to ask the "value" property of the eventObject 
* 			send by EventDispatcher. 
* 			See addEventListener documentation. Another way is to ask the getStartValues, getCurrentValues 
* 			and getEndValues methods of ColorTransform. This way you can access the color values depending 
* 			on how you initialized ColorTransform. See getStartValues documentation for more information. 
* 			Notice that in this example I modify the result of getCurrentValues method 
* 			inside the onUpdate handler in order to trace hexadecimal numbers instead of decimal numbers. 
* 			
* 			<blockquote><pre>
*			var myCT:ColorTransform = new ColorTransform(mc);
*			myCT.animationStyle(3000);
*			myCT.setStartValues([0xff0000,0]);
*			myCT.setEndValues([0x00ff00,0]);
*			myCT.addEventListener("onStart",this);
*			myCT.addEventListener("onUpdate",this);
*			myCT.addEventListener("onEnd",this);
*			myCT.run();
*			
*			function onStart(eventObject:Object){	
*				trace("onStart "+eventObject.value);
*				trace("getStartValues "+myCT.getStartValues());
*			}
*			function onUpdate(eventObject:Object){	
*				trace("onUpdate "+eventObject.value);
*				var currentValues:Array = myCT.getCurrentValues();
*				var rgbNumber:Number = currentValues[0];
*				var hexrgb:String = rgbNumber.toString(16);
*				trace("getCurrentValues "+hexrgb);
*			}
*			function onEnd(eventObject:Object){
*				trace("onEnd "+eventObject.value);
*				trace("getEndValues "+myCT.getEndValues());	
*			}
*			</pre></blockquote>
* 			Example 9: To animate many movieclips the same way, this class also accepts 
* 			an Array of movieclips instead of one movieclip. This way yields to a better performance than 
* 			creating a new class instance for each movieclip you want to animate. Different 
* 			start values of your movieclip properties are considered when animating multiple movieclips 
* 			within one animation instance.
* 			<blockquote><pre>
* 			var mcs:Array = new Array(mc1,mc2,mc3);
*			var myCT:ColorTransform = new ColorTransform(mcs);
*			myCT.setOptimizationMode(true);
*			myCT.animationStyle(3000);
*			var red:Object = {ra:0,rb:255,ga:0,gb:0,ba:0,bb:0};
*			var green:Object = {ra:0,rb:0,ga:0,gb:255,ba:0,bb:0};
*			myCT.setStartValues([red]);
*			myCT.setEndValues([green]);
*			myCT.run();
* 			</pre></blockquote>
* 
* 			<p>
*  
* @usage 
* 		<pre>var myCT:ColorTransform = new ColorTransform(mc);</pre> 
*		<pre>var myCT:ColorTransform = new ColorTransform(mc, rgb, percentage);</pre>
* 		<pre>var myCT:ColorTransform = new ColorTransform(mc, rgb, percentage, duration);</pre>
*		<pre>var myCT:ColorTransform = new ColorTransform(mc, rgb, percentage, duration, callback);</pre>
* 		<pre>var myCT:ColorTransform = new ColorTransform(mc, rgb, percentage, duration, easing, callback);</pre>
*		<pre>var myCT:ColorTransform = new ColorTransform(mc, transformationObject);</pre>
* 		<pre>var myCT:ColorTransform = new ColorTransform(mc, transformationObject, duration);</pre>
*		<pre>var myCT:ColorTransform = new ColorTransform(mc, transformationObject, duration, callback);</pre>
* 		<pre>var myCT:ColorTransform = new ColorTransform(mc, transformationObject, duration, easing, callback);</pre>
*		<pre>var myCT:ColorTransform = new ColorTransform(mc, values);</pre> 
* 		<pre>var myCT:ColorTransform = new ColorTransform(mc, values, duration, callback);</pre> 
* 		<pre>var myCT:ColorTransform = new ColorTransform(mc, values, duration, easing, callback);</pre> 
* 		<pre>var myCT:ColorTransform = new ColorTransform(mcs);</pre> 
*		<pre>var myCT:ColorTransform = new ColorTransform(mcs, rgb, percentage);</pre>
* 		<pre>var myCT:ColorTransform = new ColorTransform(mcs, rgb, percentage, duration);</pre>
*		<pre>var myCT:ColorTransform = new ColorTransform(mcs, rgb, percentage, duration, callback);</pre>
* 		<pre>var myCT:ColorTransform = new ColorTransform(mcs, rgb, percentage, duration, easing, callback);</pre>
*		<pre>var myCT:ColorTransform = new ColorTransform(mcs, transformationObject);</pre>
* 		<pre>var myCT:ColorTransform = new ColorTransform(mcs, transformationObject, duration);</pre>
*		<pre>var myCT:ColorTransform = new ColorTransform(mcs, transformationObject, duration, callback);</pre>
* 		<pre>var myCT:ColorTransform = new ColorTransform(mcs, transformationObject, duration, easing, callback);</pre>
*		<pre>var myCT:ColorTransform = new ColorTransform(mcs, values);</pre> 
* 		<pre>var myCT:ColorTransform = new ColorTransform(mcs, values, duration, callback);</pre> 
* 		<pre>var myCT:ColorTransform = new ColorTransform(mcs, values, duration, easing, callback);</pre> 
* @param mc (MovieClip) Movieclip to animate.
* @param mcs (Array) array of movieclips to animate.
* @param rgb (Number) Targeted color value (as a hex number) to animated to. 
* @param percentage (Number) Targeted percentage value to animated to. 0 is opaque. (-255 - 255).
* @param transformationObject (Object) Targeted amounts to animate to. Same transformationObject like returned from the build-in Color.getTransfrom().
* @param values (Array) optional start and end values.
* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
* @param callback (String) Function to invoke after animation
*/
class de.alex_uhlmann.animationpackage.animation.ColorTransform 
											extends AnimationCore 
											implements IMultiAnimatable {
	
	/*animationStyle properties inherited from AnimationCore*/
	/** 
	* @property movieclip (MovieClip) Movieclip to animate.
	* @property movieclips (Array) Array of Movieclips to animate.
	* @property duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @property easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @property callback (String) Function to invoke after animation. See AnimationCore class. 
	*/
	private var myCTK:ColorToolkit;
	private var colorTransformMode:Boolean = false;
	private var startRGB:Number;
	private var startPercentage:Object;
	private var endRGB:Number;
	private var endPercentage:Number;
	private var transformObject:Object;
	private var hasStartValues:Boolean;
	private var overwriteProperty:String = "movieclip";
	
	public function ColorTransform() {
		super();
		if(typeof(arguments[0]) == "movieclip") {
			this.mc = arguments[0];
			this.myCTK = new ColorToolkit(this.mc);
		} else {
			this.mcs = arguments[0];
			this.myCTK = new ColorToolkit(this.mcs[0]);
		}
		if(arguments.length > 1) {
			arguments.shift();
			this.init.apply(this, arguments);
		}		
	}
	
	private function init():Void {
		if(arguments[0] instanceof Array) {				
			var values:Array = arguments[0];
			if(values.length == 4) {
				var endValues:Array = values.slice(-2);
				arguments.shift();
				arguments.splice(0, 0, endValues[0], endValues[1]);
				this.initAnimation.apply(this, arguments);
				this.setStartValues([values[0], {r:values[1], 
													g:values[1], 
													b:values[1], 
													a:values[1]}]);
			} else {
				var endValues:Array = values.slice(-1);
				arguments.shift();
				arguments.splice(0, 0, endValues[0]);
				this.initAnimation.apply(this, arguments);				
				this.setStartValues([values[0]]);					
			}
		} else if(arguments.length > 0) {			
			this.initAnimation.apply(this, arguments);
		}		
	}
	
	public function setStartValues(startValues:Array, optional:Boolean):Boolean {
		if(startValues[0] instanceof Object) {
			
			this.colorTransformMode = true;
			var colorObj:Object = this.transformObject = this.myCTK.getTransform();
			var obj:Object = startValues[0];			
			var p:String;
			for(p in obj) {				
				colorObj[p] = obj[p];				
			}
			if(optional) {
				this.hasStartValues = false;
			} else {
				this.hasStartValues = true;
			}
			return super.setStartValues([colorObj.ra, colorObj.rb, 
										colorObj.ga, colorObj.gb, 
										colorObj.ba, colorObj.bb, 
										colorObj.aa, colorObj.ab], optional);						
		} else if(startValues.length == 2) {
					
			this.colorTransformMode = false;
			this.startRGB = startValues[0];
			if(typeof(startValues[1]) == "number") {
				this.startPercentage = {r:startValues[1], g:startValues[1], b:startValues[1]};
			} else {
				this.startPercentage = startValues[1];
			}			
			var startRGB:Object = this.myCTK.hexrgb2rgb(this.startRGB);
			var startPercentage:Object = this.startPercentage;
			return super.setStartValues([startPercentage.r, startRGB.r, 
										startPercentage.g, startRGB.g, 
										startPercentage.b, startRGB.b, 
										100, 0], optional);									
		} else {
			return super.setStartValues.apply(this,arguments);
		}					
	}
	
	public function setEndValues(endValues:Array):Boolean {
		if(endValues[0] instanceof Object) {			
			
			this.colorTransformMode = true;
			var colorObj:Object = this.myCTK.getTransform();
			var obj:Object = endValues[0];
			var p:String;
			for(p in obj) {				
				colorObj[p] = obj[p];				
			}			
			return super.setEndValues([colorObj.ra, colorObj.rb, 
										colorObj.ga, colorObj.gb, 
										colorObj.ba, colorObj.bb, 
										colorObj.aa, colorObj.ab]);						
		} else if(endValues.length == 2) {
			
			this.colorTransformMode = false;
			this.endRGB = endValues[0];
			this.endPercentage = endValues[1];
			var endRGB:Object = this.myCTK.hexrgb2rgb(this.endRGB);;
			var endPercentage:Number = this.endPercentage;
			return super.setEndValues([endPercentage, endRGB.r, 
										endPercentage, endRGB.g, 
										endPercentage, endRGB.b, 
										100, 0]);		
		} else {
			return super.setEndValues.apply(this,arguments);
		}				
	}
	
	/*
	* If the user specified one offset and one percentage 
	* value, only the percentage value of red will be returned. As soon as the ColorTransform 
	* modifies the movieclip all percentage values will have the same value anyway in this 
	* mode.
	*/
	public function getStartValues(Void):Array {		
		if(this.colorTransformMode == false && this.mc != null) {
			return [this.startRGB, this.startPercentage.r];			
		}
		return this.startValues;			
	}
	
	public function getCurrentValues(Void):Array {		
		if(this.colorTransformMode == false && this.mc != null) {
			var colors:Array = this.currentValues;			
			var currentRGB:Number = this.myCTK.rgb2hexrgb(colors[1], colors[3], colors[5]);
			var currentPercentage:Number = colors[0];
			return [currentRGB, currentPercentage];			
		}
		return this.currentValues;		
	}
	
	public function getEndValues(Void):Array {		
		if(this.colorTransformMode == false && this.mc != null) {
			return [this.endRGB, this.endPercentage];			
		}
		return this.endValues;			
	}
	
	private function initAnimation():Void {		
		if(arguments[0] instanceof Object) {
			
			if(arguments.length > 1) {			
				this.animationStyle(arguments[1], arguments[2], arguments[3]);
			} else {
				this.animationStyle(this.duration, this.easing, this.callback);
			}
			
			this.setStartValues([this.myCTK.getTransform()], true);
			this.setEndValues([arguments[0]]);			
		
		} else {			
			
			if(arguments.length > 2) {			
				this.animationStyle(arguments[2], arguments[3], arguments[4]);
			} else {
				this.animationStyle(this.duration, this.easing, this.callback);
			}
			
			this.setStartValues([this.myCTK.getColorOffsetHex(), this.myCTK.getColorPercent()], true);
			this.setEndValues([arguments[0], arguments[1]]);	
		}	
	}
	
	private function invokeAnimation(start:Number, end:Number):Void {		
		
		this.startInitialized = false;
		
		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		this.myAnimator.end = this.endValues;
		
		if(this.mc != null) {
			//colorize movieclip right away when a fixed start value has been set.
			if(this.colorTransformMode) {
				this.myCTK.setTransform(this.transformObject);		
			}			
			this.myAnimator.start = this.startValues;				
			this.myAnimator.setter = [[this.myCTK, "setRedPercent"], 
								[this.myCTK, "setRedOffset"], 
								[this.myCTK, "setGreenPercent"], 
								[this.myCTK, "setGreenOffset"], 
								[this.myCTK, "setBluePercent"], 
								[this.myCTK, "setBlueOffset"],
								[this.myCTK, "setAlphaPercent"], 
								[this.myCTK, "setAlphaOffset"]];		
		} else {
			
			var myCTKs:Array = [];
			var len:Number = this.mcs.length;	
			var i:Number = len;
			if(this.colorTransformMode == true && this.hasStartValues == true) {
				while(--i>-1) {
					myCTKs[i] = new ColorToolkit(this.mcs[i]);
					myCTKs[i].setTransform(this.transformObject);
				}				
			} else {
				while(--i>-1) {
					myCTKs[i] = new ColorToolkit(this.mcs[i]);
				}				
			}
			
			this.myAnimator.multiStart = ["getRedPercent", 
									"getRedOffset", 
									"getGreenPercent",
									"getGreenOffset", 
									"getBluePercent", 
									"getBlueOffset",
									"getAlphaPercent", 
									"getAlphaOffset"];			
			
			this.myAnimator.multiSetter = [[myCTKs, "setRedPercent"], 
									[myCTKs, "setRedOffset"], 
									[myCTKs, "setGreenPercent"],
									[myCTKs, "setGreenOffset"], 
									[myCTKs, "setBluePercent"], 
									[myCTKs, "setBlueOffset"],
									[myCTKs, "setAlphaPercent"],
									[myCTKs, "setAlphaOffset"]];
		}
		
		if(end != null) {
			this.myAnimator.animationStyle(this.duration, this.easing, this.callback);
			this.myAnimator.animate(start, end);
		} else {
			this.myAnimator.goto(start);
		}	
		
	}
	
	/**
	* @method run
	* @description 	manipulates the color of a movieclip in a specified time and easing equation. 
	* 				See class documentation.
	* @usage   
	* 
	* 		<pre>myCT.run();</pre>
	* 		<pre>myCT.run(rgb, percentage);</pre>
	* 		<pre>myCT.run(rgb, percentage, duration);</pre>
	*		<pre>myCT.run(rgb, percentage, duration, callback);</pre>
	* 		<pre>myCT.run(rgb, percentage, duration, easing, callback);</pre>
	* 		<pre>myCT.run(transformationObject);</pre>
	* 		<pre>myCT.run(transformationObject, duration);</pre>
	*		<pre>myCT.run(transformationObject, duration, callback);</pre>
	* 		<pre>myCT.run(transformationObject, duration, easing, callback);</pre> 
	* 		<pre>myCT.run(values, duration);</pre>
	* 		<pre>myCT.run(values, duration, callback);</pre>
	*		<pre>myCT.run(values, duration, easing, callback);</pre>
	* 	  
	* @param rgb (Number) Targeted color value (as a hex number) to animated to. 
	* @param percentage (Number) Targeted percentage value to animated to. 0 is opaque. (-255 - 255).
	* @param transformationObject (Object) Targeted amounts to animate to. Same transformationObject like returned from the build-in Color.getTransfrom().	
	* @param values (Array) optional start and end values.	
	* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @param callback (String) Function to invoke after animation
	* @return void
	*/	
	
	/**
	* @method animate
	* @description 	similar to the run() method. Offers start and end parameters.
	* @usage   <pre>myCT.animate(start, end);</pre> 	  
	* @param start (Number) start value. Percentage.
	* @param end (Number) end value. Percentage.
	* @return void
	*/
	
	/**
	* @method goto
	* @description 	jumps to a specific step of the animation and stays there.
	* @usage   <pre>instance.goto(percentage);</pre>
	* @param percentage (Number) Percentage value of the animation.
	* @return void
	*/	
	
	/*inherited from AnimationCore*/
	/**
	* @method animationStyle
	* @description 	set the animation style properties for your animation.
	* 			Notice that if your easing equation supports additional parameters you 
	* 			can send those parameters with the easing parameter in animationStyle.
	* 			You have to send an Array as easing parameter. The first 
	* 			element has to be the easing equation in Robert Penner style. The 
	* 			following parameters can be your additional parameters. i.e.:
	* 			<blockquote><pre>
	*			var myRotation:Rotation = new Rotation(mc);
	*			myRotation.animationStyle(2000,[Back.easeOut,4]);
	*			myRotation.run(360);
	*			</pre></blockquote>
	* 			See also "Customizable easing equations" in readme for more information.		
	* 		
	* @usage   <pre>myInstance.animationStyle(duration);</pre>
	* 		<pre>myInstance.animationStyle(duration, callback);</pre>
	* 		<pre>myInstance.animationStyle(duration, easing, callback);</pre>
	* 	  
	* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @param callback (String) Function to invoke after animation. See APCore class.
	*/
	
	/**
	* @method roundResult
	* @description 	rounds animation results to integers. (might be usefull for animating pixelfonts). Default is false.		
	* @usage   <pre>myInstance.roundResult(rounded);</pre>
	*@param rounded (Boolean) <code>true</code> rounds the result. Animates with integers. Less accuracy. <code>false</code> animates with floating point numbers.
	*/
	
	/**
	* @method forceEnd
	* @description 	Flash does not guaranteed that time-based tweening will reach 
	* 			the end value(s) of your animation. By default AnimationPackage 
	* 			guarantees that the end value(s) will be reached. The forceEnd 
	* 			method allows you to disable this guarantee and only accept 
	* 			the values from your easing equation. In certain situations this can 
	* 			lead to a smoother ending of the animation. Notice that in frame-based 
	* 			tweening the end value(s) will always be reached.	
	* @usage   <pre>myInstance.forceEnd(forceEndVal);</pre>
	*@param forceEndVal (Boolean) <code>true</code> or <code>false</code>.
	*/	
	
	/**
	* @method getOptimizationMode
	* @description 	returns the optimization mode. See setOptimizationMode for more information. 
	* @usage   <tt>getOptimizationMode();</tt>
	* @return Boolean
	*/	
	
	/**
	* @method setOptimizationMode
	* @description 	Allows to explicitly remove parts of the animation that don't change during 
	* 				the animation. 
	* 				This can add additional performance to your animation. Note that 
	* 				setting this method to true has side effects. If all start and end values match, 
	* 				the animation won't start and will immediatly invoke an onEnd event. 
	* 				The order of values returned by getStartValue(s), getCurrentValue(s), 
	* 				getEndValue(s) and the value property of the eventObject returned 
	* 				by EventDispatcher might change if you set this method to true. You can 
	* 				still retrieve the parts of the animation that are actually animated 
	* 				if you access the Animator instance of your animation class via 
	* 				myAnimator. Ask <code>myInstance.myAnimator.setter</code> to retrieve 
	* 				all currently animated parts of the animation. See Animator 
	* 				documentation. Of cource, if you know your input values you would 
	* 				probably look at them.<p>
	* 				Note that the AnimationCore class offers a static setOptimizationModes method 
	* 				(note the last "s" at the end) that allows you to remove parts of 
	* 				'all' your animations that don't change during the animation.
	* @usage   <pre>myInstance.setOptimizationMode(optimize);</pre>
	* @param optimize (Boolean)
	*/
	
	/**
	* @method getTweenMode
	* @description 	returns the current tween mode used by the instance. 
	* 				Please check with AnimationCore.setTweenModes for more information.
	* @usage   <tt>getTweenMode();</tt>
	* @return String that specifies the tween mode. Either AnimationCore.INTERVAL or AnimationCore.FRAMES.
	*/
	
	/**
	* @method setTweenMode
	* @description 	sets the current tween mode used by the instance. 
	* 				Please check with AnimationCore.setTweenModes for more information.
	* @usage   <tt>setTweenMode();</tt> 	
	* @param t (String) Either AnimationCore.INTERVAL for time-based tweening or AnimationCore.FRAMES for frame-based tweening.
	* @returns   <code>true</code> if setting tween mode was successful, 
	*                  <code>false</code> if not successful.
	*/
	
	/**
	* @method getDurationMode
	* @description 	returns the current duration mode used by the instance.
	* 				Please check with AnimationCore.setTweenModes for more information.
	* @usage   <tt>getDurationMode();</tt>
	* @return String that specifies the duration mode. Either AnimationCore.MS or AnimationCore.FRAMES.
	*/
	
	/**
	* @method setDurationMode
	* @description 	sets the current duration mode used by the instance. 
	* 				Please check with AnimationCore.setTweenModes for more information.
	* @usage   <tt>setDurationMode();</tt> 	
	* @param d (String) Either AnimationCore.MS for milliseconds or AnimationCore.FRAMES.
	* @returns   <code>true</code> if setting duration mode was successful, 
	*                  <code>false</code> if not successful.
	*/
	
	/**
	* @method stop
	* @description 	stops the animation if not locked..
	* @usage   <tt>myInstance.stop();</tt> 
	* @returns <code>true</code> if instance was successfully stopped. 
	*                  <code>false</code> if instance could not be stopped, because it was locked.
	*/	
	
	/**
	* @method pause
	* @description 	pauses the animation if not locked. Call resume() to continue animation.
	* @usage   <tt>myInstance.pause();</tt> 	  
	* @param duration (Number) optional property. Number of milliseconds or frames to pause before continuing animation.
	* @returns <code>true</code> if instance was successfully paused. 
	*                  <code>false</code> if instance could not be paused, because it was locked.
	*/	
	
	/**
	* @method resume
	* @description 	continues the animation if not locked. 
	* @usage   <tt>myInstance.resume();</tt> 	
	* @returns <code>true</code> if instance was successfully resumed. 
	*                  <code>false</code> if instance could not be resumed, because it was locked.
	*/
	
	/**
	* @method lock
	* @description 	locks the animation to prevent pausing, resuming and stopping. Default is unlocked.
	* @usage   <tt>myInstance.lock();</tt> 	  
	*/	
	
	/**
	* @method unlock
	* @description 	unlocks the animation to allow pausing, resuming and stopping. Default is unlocked.
	* @usage   <tt>myInstance.unlock();</tt> 	  
	*/
	
	/**
	* @method isTweening
	* @description 	checks if the instance is currently animated.
	* @usage   <tt>myInstance.isTweening();</tt> 	
	* @returns   <code>true</code> if instance is tweening, 
	*                  <code>false</code> if instance is not tweening.
	*/	
	
	/**
	* @method getStartValues
	* @description 	returns the original, starting values of the current tween. 
	* 				The values returned depend on how you used/started the ColorTransform class.
	* 				If you used one offset value (i.e. in form of a hexadecimal number) 
	* 				and one percentage number to initialize ColorTransform, 
	* 				the offset and percentage numbers will be returned by this method. 				
	* 				If you've used a transformObject to initialize ColorTransform, 
	*				the values returned are all properties of the transformObject 
	* 				of the Color class. They are returned in an array of the following order: 
	* 				From 0 - 7:  ra, rb, ga, gb, ba, bb, aa, ab. Take a look into the Color 
	* 				class of your Flash manual for more information about the properties
	* 				of the Color transformObject or get <a href="http://www.moock.org">Colin Moock's</a> 
	* 				ASDG for an in depth discussion.
	* @usage   <tt>myInstance.getStartValues();</tt>
	* @return (Array)
	*/
	
	/**
	* @method setStartValues
	* @description 	sets the original, starting values of the current tween. See class documentation.				
	* @usage   <tt>myInstance.setStartValues(startValues);</tt>
	* @param startValues (Array)
	* @return Boolean, indicates if the assignment was performed.
	*/	
	
	/**
	* @method getEndValues
	* @description 	returns the targeted values of the current tween.
	* 				The values returned depend on how you used/started the ColorTransform class.
	* 				See getStartValues for more information.
	* @usage   <tt>myInstance.getEndValues();</tt>
	* @return (Array)
	*/
	
	/**
	* @method setEndValues
	* @description 	sets the targeted value of the current tween. See class documentation.
	* @usage   <tt>myInstance.setEndValues(endValues);</tt>
	* @param endValues (Array)
	* @return Boolean, indicates if the assignment was performed.
	*/

	/**
	* @method getCurrentValues
	* @description 	returns the current values of the current tween.
	* 				The values returned depend on how you used/started the ColorTransform class.
	* 				See getStartValues for more information.
	* @usage   <tt>myInstance.getCurrentValues();</tt>
	* @return (Array)
	*/
	
	/**
	* @method getCurrentPercentage
	* @description 	returns the current state of the animation in percentage. 
	* 				Especially usefull in combination with goto().
	* @usage   <tt>myInstance.getCurrentPercentage();</tt>
	* @return Number
	*/	

	/**
	* @method getDurationElapsed
	* @description 	returns the elapsed time or frames since the current tween started tweening.
	* @usage   <tt>myInstance.getDurationElapsed();</tt>
	* @return Number
	*/
	
	/**
	* @method getDurationRemaining
	* @description 	returns the remaining time or frames since the current tween started tweening.
	* @usage   <tt>myInstance.getDurationRemaining();</tt>
	* @return Number
	*/
	
	/*inherited from APCore*/
	/**
	* @method addEventListener
	* @description 	Subscribe to a predefined event. The following standard EventDispatcher events are broadcasted<p>
	* 			<b>onStart</b>, broadcasted when animation starts.<br>
	*			<b>onUpdate</b>, broadcasted when animation updates.<br>
	*			<b>onEnd</b>, broadcasted when animation ends.<p>
	* 			The even object returned, contains the following properties:<p>
	* 			<b>type</b> (String) event broadcasted.<br>
	*			<b>target</b> (Object) event source.<br>
	*			<b>value</b> (Array) values to animate. See getStartValues and class documentation.<p>
	* 		
	* @usage   <pre>myCT.addEventListener(event, listener);</pre>
	* 		    <pre>myCT.addEventListener(event, listener, handler);</pre>
	* 	  
	*@param event (String) Event to subscribe listener to. GDispatcher specific feature allows to subscribe to all events from an event source if the string "ALL" is passed. 
	*@param listener (Object) The listener object to subscribe to the specified event.
	*@param handler (String) Optional. GDispatcher specific feature. The name of a function to call. This function will be called within the scope of the object specified in the second parameter.
	*/
	
	/*inherited from APCore*/
	/**
	* @method removeEventListener
	* @description 	Removes a listener from a subscribed event.	
	* 		
	* @usage   <pre>myCT.removeEventListener(event, listener);</pre>
	* 		    <pre>myCT.removeEventListener(event, listener, handler);</pre>
	* 	  
	*@param event (String) Event to remove subscribed listener from. GDispatcher specific feature allows to remove subscribtion to all events if the string "ALL" is passed. Works only if listener has been subscribed via the "ALL" string in addEventListener.
	*@param listener (Object) The listener object to unsubscribe from the specified event.
	*@param handler (String) Optional. GDispatcher specific feature. Only needed if the listener has been subscribed with a handler function.
	*/
	
	/*inherited from APCore*/
	/**
	* @method removeAllEventListeners
	* @description 	GDispatcher specific feature. Removes all listeners for a specific event, or for all events.
	* 		
	* @usage   <pre>myCT.removeAllEventListeners();</pre>
	* 		    <pre>myCT.removeAllEventListeners(event);</pre>
	* 	  
	*@param event (String) Event to remove all subscribed listeners from. If not specified, all listeners to any event will be removed.
	*/
	
	/*inherited from APCore*/
	/**
	* @method eventListenerExists
	* @description 	GDispatcher specific feature. Checks if a listener is already subscribed to a certain event.
	* 		
	* @usage   <pre>myCT.eventListenerExists(event, listener);</pre>
	* 			<pre>myCT.eventListenerExists(event, listener, handler);</pre>
	* 	  
	*@param event (String) Event to check subscription.
	*@param listener (Object) The listener object to check subscription.
	*@param handler (String) The handler function to check subscription.	
	*@returns <code>true</code> if event exists on listener. 
	*                  <code>false</code> if event doesn't exist on listener. 
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
		return "ColorTransform";
	}
}