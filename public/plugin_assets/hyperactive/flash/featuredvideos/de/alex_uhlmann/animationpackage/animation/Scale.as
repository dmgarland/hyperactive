import de.alex_uhlmann.animationpackage.animation.IMultiAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.Animator;

/**
* @class Scale
* @author Alex Uhlmann, Ben Jackson
* @description  Manipulates either the _xscale and _yscale or _width and _height properties 
* 			of a movieclip or a number of movieclips.<p>	
* 			You can specify the duration, easing equation and callback properties 
* 			either with setting the properies directly or with the animationStyle() method 
* 			like it is used in de.alex_uhlmann.animationpackage.drawing.
* 			<p>
* 			Example 1:
* 			<blockquote><pre>			
*			var myScale:Scale = new Scale(mc);
*			myScale.animationStyle(2000,Sine.easeOut,"onCallback");
*			myScale.run(1500,1500);
*			</pre></blockquote>  			
* 			Example 2: The alternative way is shorter. The same like above in one line.
* 			<blockquote><pre>	
* 			new Scale(mc).run(1500,1500,2000,Sine.easeOut,"onCallback");
* 			</pre></blockquote>		
*  			Example 3: You can also specify the properties via the constructor. 
* 			This might come in handy if you're using the Sequence or Parallel class.  
* 			Take a look at their class documentations for more information. 
* 			The animate() method and its start and end percentage parameters might also be useful. 
* 			<blockquote><pre>
* 			var myScale:Scale = new Scale(mc,500,500,2000,Circ.easeOut,"onCallback");
* 			myScale.animate(0,100);
* 			</pre></blockquote>
* 			Example 4: By default, the start value of your animation is the current value. You can explicitly 
* 			define the start values either via the setStartValues or run method or via the constructor. Here is one 
* 			example for the constructor solution. This also might come in handy using composite classes, like 
* 			Sequence.
* 			<blockquote><pre>
* 			var myScale:Scale = new Scale(mc,[10,300],3000,Quad.easeOut);
* 			myScales.run();
* 			</pre></blockquote>
* 			<p>
* 			Example 5: Scretch a movieclip to _xscale 400 in 2 second using elastic easing. 		
* 			<blockquote><pre>
*			new Scale(mc).run(400,100,2000,Elastic.easeOut);
*			</pre></blockquote>
* 			<p>
* 			Example 6: <a href="Scale_run_02.html">(Example.swf)</a> Scale a movieclip 1500% proportionally in two seconds  
* 			using circular easing. After animation scale it back to 100%.
* 			<blockquote><pre>			
*			new Scale(mc).run(1500,1500,2000,Sine.easeOut,"onCallback");
*			myListener.onCallback = function() {
*				new Scale(mc).run(100,100,2000,Sine.easeIn);
*			}
*			</pre></blockquote>
* 			Example 7: <a href="Scale_run_03.html">(Example.swf)</a> <a href="Scale_run_04.html">(Example.swf)</a>
* 			To animate many movieclips the same way, this class also accepts 
* 			an Array of movieclips instead of one movieclip. This way yields to a better performance than 
* 			creating a new class instance for each movieclip you want to animate. Different 
* 			start values of your movieclip properties are considered when animating multiple movieclips 
* 			within one animation instance.
* 			<p>
* 			The following example is meant to shows that different start values are considered. 
* 			50 rectangles will be drawn with the drawing package and scaled with Scale using multiple 
* 			animations within one animation instance. See .swf example above.			
* 			<blockquote><pre>
*			var target:Line = new Line(500,0,500,98.5);
*			target.draw();
*			
*			var squares:Array = new Array();
*			for (var i:Number = 0; i<50; i++) {
*				var x:Number = Math.random() * 300;
*				var w:Number = Math.random() * 300;
*				
*				var myRectangle:Rectangle = new Rectangle(0, i*2, 100, 1);	
*				myRectangle.setRegistrationPoint({x:0, y:0});
*				myRectangle.lineStyle();
*				myRectangle.draw();	
*				myRectangle.movieclip._xscale = w;
*				squares[i] = myRectangle.movieclip;
*			}
*			
*			var myScale:Scale = new Scale(squares);
*			myScale.setOptimizationMode(true);
*			myScale.animationStyle(6000,Bounce.easeOut);
*			myScale.run(500,squares[0]._yscale);
* 			</pre></blockquote>
* 			<p>
* 			The example below moves, scales and rotates a number of movieclips with different start values.
* 			See .swf example above.
* 			<blockquote><pre>
*			var mcs:Array = new Array();
*			for (var i = 0; i<20; i++) {
*				var x:Number = Math.random() * 640;
*				var y:Number = Math.random() * 400;	
*				var r:Number = Math.random() * 360;
*				mcs[i] = this.attachMovie("mc", "mc"+i, i, {_x:x, _y:y, _xscale:0, _yscale:0, _rotation:r});
*			}
*			
*			var myMove:Move = new Move(mcs);
*			myMove.animationStyle(8000,Sine.easeInOut);
*			myMove.run(320,200);
*			
*			var myScale:Scale = new Scale(mcs);
*			myScale.animationStyle(8000,Sine.easeInOut);
*			myScale.run(100,100);
*			
*			var myRotation:Rotation = new Rotation(mcs);
*			myRotation.animationStyle(8000,Sine.easeInOut);
*			myRotation.run(360);
* 			</pre></blockquote>
* 			<p>
* 			Example 8: <a href="Scale_single.html">(Example.swf)</a> A similar experiment 
* 			like the above shows the speed difference compared to the way 
* 			that animates each movieclip in a single instance. This is the slow way:
* 			<blockquote><pre>
*			var squares:Array = new Array();
*			for (var i:Number = 0; i<200; i++) {
*				squares[i] = _root.attachMovie("square_mc", "s"+i, i, {_y:i*2});
*				var myScale:Scale = new Scale(squares[i]);
*				myScale.scaleWithPixels(true);
*				myScale.setOptimizationMode(true);
*				myScale.animationStyle(10000,Bounce.easeOut);
*				myScale.run(550,squares[0]._height);
*			}
* 			</pre></blockquote>
* 			<p>
* 			Example 9: <a href="Scale_multi.html">(Example.swf)</a> 
* 			...and this is the fast way:
* 			<blockquote><pre>
*			var squares:Array = new Array();
*			for (var i:Number = 0; i<200; i++) {
*				squares[i] = _root.attachMovie("square_mc", "s"+i, i, {_x:0, _y:i*2});
*			}
*			var myScale:Scale = new Scale(squares);
*			myScale.scaleWithPixels(true);
*			myScale.setOptimizationMode(true);
*			myScale.animationStyle(10000,Bounce.easeOut);
*			myScale.run(550,squares[0]._height);
* 			</pre></blockquote>
* 			<p>
* 
* @usage 
* 		<pre>var myScale:Scale = new Scale(mc);</pre> 
*		<pre>var myScale:Scale = new Scale(mc, amountx, amounty);</pre>
* 		<pre>var myScale:Scale = new Scale(mc, amountx, amounty, duration);</pre>
*		<pre>var myScale:Scale = new Scale(mc, amountx, amounty, duration, callback);</pre>
* 		<pre>var myScale:Scale = new Scale(mc, amountx, amounty, duration, easing, callback);</pre>
*		<pre>var myScale:Scale = new Scale(mc, values);</pre> 
* 		<pre>var myScale:Scale = new Scale(mc, values, duration, callback);</pre> 
* 		<pre>var myScale:Scale = new Scale(mc, values, duration, easing, callback);</pre>
* 		<pre>var myScale:Scale = new Scale(mcs);</pre> 
*		<pre>var myScale:Scale = new Scale(mcs, amountx, amounty);</pre>
* 		<pre>var myScale:Scale = new Scale(mcs, amountx, amounty, duration);</pre>
*		<pre>var myScale:Scale = new Scale(mcs, amountx, amounty, duration, callback);</pre>
* 		<pre>var myScale:Scale = new Scale(mcs, amountx, amounty, duration, easing, callback);</pre>
*		<pre>var myScale:Scale = new Scale(mcs, values);</pre> 
* 		<pre>var myScale:Scale = new Scale(mcs, values, duration, callback);</pre> 
* 		<pre>var myScale:Scale = new Scale(mcs, values, duration, easing, callback);</pre>  
* @param mc (MovieClip) Movieclip to animate.
* @param mcs (Array) array of movieclips to animate.
* @param amountx (Number) Targeted _xscale or _width to animate to.
* @param amounty (Number) Targeted _yscale or _height to animate to.
* @param values (Array) optional start and end values.
* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
* @param callback (String) Function to invoke after animation.
*/
class de.alex_uhlmann.animationpackage.animation.Scale 
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
	public var scaleXProperty:String = "_xscale";
	public var scaleYProperty:String = "_yscale";
	public var xProperty:String = "_x";
	public var yProperty:String = "_y";	
	private var pixelscale:Boolean = false;
	private var pixelscaleConstructValue:Boolean;
	private var areStartValuesSet:Boolean = false;	
	private var modifiedRegistrationPoint:Boolean = false;
	public var x:Number = 0;
	public var y:Number = 0;
	private var myInstances:Array;

	public function Scale() {
		super();
		if(typeof(arguments[0]) == "movieclip") {
			this.mc = arguments[0];
		} else {
			this.mcs = arguments[0];
		}
		if(arguments.length > 1) {
			arguments.shift();
			this.init.apply(this, arguments);
		}
	}
	
	private function init():Void {
		if(arguments[0] instanceof Array) {				
			var values:Array = arguments[0];
			var endValues:Array = values.slice(-2);
			arguments.shift();
			arguments.splice(0, 0, endValues[0], endValues[1]);
			this.initAnimation.apply(this, arguments);
			this.setStartValues([values[0], values[1]]);
		} else if(arguments.length > 0) {			
			this.initAnimation.apply(this, arguments);
		}
	}
	
	private function initAnimation(amountx:Number, amounty:Number, 
						duration:Number, easing:Object, callback:String):Void {		
		
		if (arguments.length > 2) {	
			this.animationStyle(duration, easing, callback);
		} else {
			this.animationStyle(this.duration, this.easing, this.callback);
		}
		
		if(this.mc != null) {
			this.pixelscaleConstructValue = this.pixelscale;
			this.setStartValues([this.mc[this.scaleXProperty], this.mc[this.scaleYProperty]], true);
		}
		this.setEndValues([amountx, amounty]);
	}
	
	private function invokeAnimation(start:Number, end:Number):Void {
		this.startInitialized = false;		
		
		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		this.myAnimator.end = this.endValues;

		if(this.mc != null) {

			//in case the pixelscale has been changed to true after the start values have been set via 
			//constructor, we need to calculate the start values again, but only if start values 
			//havn't been set and have to be calculated from current values.
			var hasPixelScaleChanged:Boolean = (this.pixelscaleConstructValue != this.pixelscale && this.pixelscale == true)
			if(hasPixelScaleChanged && !this.areStartValuesSet) {
				this.setStartValues([this.mc[this.scaleXProperty], this.mc[this.scaleYProperty]]);
			}
			
			this.myAnimator.start = this.startValues;
			
			if(!this.modifiedRegistrationPoint) {
				this.myAnimator.setter = [[this.mc, this.scaleXProperty], 
										[this.mc, this.scaleYProperty]];					
			} else {
				this.myAnimator.setter = [[this,"setX"], [this,"setY"]];
			}

		} else {
			
			if(!this.modifiedRegistrationPoint) {
				this.myAnimator.multiStart = [this.scaleXProperty, this.scaleYProperty];	
				this.myAnimator.multiSetter = [[this.mcs, this.scaleXProperty], 
									[this.mcs, this.scaleYProperty]];				
			} else {
				var myInstances:Array = [];			
				var len:Number = this.mcs.length;
				var mcs:Array = this.mcs;
				var i:Number = len;
				while(--i>-1) {
					myInstances[i] = new Scale(mcs[i]);
					myInstances[i].setStartValues(this.getStartValues());
					myInstances[i].scaleXProperty = this.scaleXProperty;
					myInstances[i].scaleYProperty = this.scaleYProperty;
					myInstances[i].x = this.x;
					myInstances[i].y = this.y;
				}
				this.myInstances = myInstances;
				this.myAnimator.multiStart = ["getMultiStartXValue","getMultiStartYValue"];	
				this.myAnimator.multiSetter = [[this.myInstances,"setX"], 
									[this.myInstances,"setY"]];
			}
		}
		
		if(end != null) {
			this.myAnimator.animationStyle(this.duration, this.easing, this.callback);
			this.myAnimator.animate(start, end);
		} else {
			this.myAnimator.goto(start);
		}
	}

	private function getMultiStartXValue(Void):Number {
		var startValue:Number = this.getStartValues()[0];
		if(startValue == null) {
			return this.mc[this.scaleXProperty];
		} else {
			return startValue;
		}
	}
	
	private function getMultiStartYValue(Void):Number {
		var startValue:Number = this.getStartValues()[1];
		if(startValue == null) {
			return this.mc[this.scaleYProperty];
		} else {
			return startValue;
		}
	}
	
	/*Adapted from solutions of Robert Penner, Darron Schall and Ben Jackson*/
	public function setX(value:Number):Void {
		
		var bounds:Object = this.mc.getBounds(this.mc);
		var xorigin:Number = bounds.xMin + this.x;

		var a:Object = {x:xorigin, y:0};
		this.mc.localToGlobal(a);
		this.mc._parent.globalToLocal(a);
		
		this.mc[this.scaleXProperty] = value;

		var b:Object = {x:xorigin, y:0};
		this.mc.localToGlobal(b);
		this.mc._parent.globalToLocal(b);
		this.mc[this.xProperty] -= b.x - a.x;
	}

	/*Adapted from solutions of Robert Penner, Darron Schall and Ben Jackson*/
	public function setY(value:Number):Void {
		
		var bounds:Object = this.mc.getBounds(this.mc);
		var yorigin:Number = bounds.yMin + this.y;
		
		var a:Object = {x:0, y:yorigin};
		this.mc.localToGlobal(a);
		this.mc._parent.globalToLocal(a);
		
		this.mc[this.scaleYProperty] = value;

		var b:Object = {x:0, y:yorigin};
		this.mc.localToGlobal(b);
		this.mc._parent.globalToLocal(b);
		this.mc[this.yProperty] -= b.y - a.y;
	}
	
	/**
	* @method run
	* @description 	Scales a movieclip from its the current _xscale and _yscale or _width and _height
	* 			property values to specified amounts in a specified time and easing equation.
	* 		
	* @usage   
	* 		<pre>myScale.run();</pre>		
	* 		<pre>myScale.run(amountx, amounty);</pre>
	* 		<pre>myScale.run(amountx, amounty, duration);</pre>
	*		<pre>myScale.run(amountx, amounty, duration, callback);</pre>
	* 		<pre>myScale.run(amountx, amounty, duration, easing, callback);</pre>
	* 		<pre>myScale.run(values, duration);</pre>
	* 		<pre>myScale.run(values, duration, callback);</pre>
	*		<pre>myScale.run(values, duration, easing, callback);</pre>
	* 	  
	* @param amountx (Number) Targeted _xscale or _width to animate to.
	* @param amounty (Number) Targeted _yscale or _height to animate to.
	* @param values (Array) optional start and end values.
	* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @param callback (String) Function to invoke after animation
	* @return void
	*/
	
	/**
	* @method animate
	* @description 	similar to the run() method. Offers start and end parameters.
	* @usage   <pre>myScale.animate(start, end);</pre> 	  
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
	* @method scaleWithPixels
	* @description 	changes the scaling mode. Default is false.
	* 				If true it scales the movieclip with _width and _height properties.
	*                  		If false it scales the movieclip with _xscale and _yscale properties.
	* @usage   <pre>myScale.scaleWithPixels(pixelscale);</pre> 	  
	* @param pixelscale (Boolean) <code>true</code> or <code>false</code>.
	* @return void
	*/
	public function scaleWithPixels(pixelscale:Boolean) {
		if(pixelscale) {
			this.scaleXProperty = "_width";
			this.scaleYProperty = "_height";
		} else {
			this.scaleXProperty = "_xscale";
			this.scaleYProperty = "_yscale";			
		}
		this.pixelscale = pixelscale;		
	}
	
	/**
	* @method setRegistrationPoint
	* @description 	Movieclips scale according to their registration point. If the registration 
	* 				point is in the center of the shape, the movieclip will scale evenly on all 
	* 				sides. setRegistrationPoint in Scale emulates modifying the 
	* 				registration point of the animation. Top left is 0,0. 
	* 				The parameter object accepts either x and y properties with coordinates as values 
	* 				of the registration point or a position property with 
	* 				String flags. Currently there are the following options 
	* 				for the position property available:<p>
	* 				CENTER = central registration point of movieclip.
	* 			<p>
	* 			Example 1: Set the registration point of an mc to the upper left corner (0,0). 
	* 			So even if mc's registration point is in the center, it will scale like as if 
	* 			the registration point would be on the upper left corner.
	* 			<blockquote><pre>
	*			var myScale:Scale = new Scale(mc);
	*			myScale.setRegistrationPoint( {x:0,y:0} );
	*			myScale.run(200, 200);
	*			</pre></blockquote>
	* 			<p>
	* @usage   <pre>myInstance.setRegistrationPoint(registrationObj);</pre>
	* 	  
	* @param registrationObj (Object)
	*/	
	public function setRegistrationPoint(registrationObj:Object):Void {
		this.modifiedRegistrationPoint = true;		
		if(registrationObj.position == "CENTER") {
			this.x = this.mc._width / 2;
			this.y = this.mc._height / 2;
		} else {
			if(registrationObj.x != null ) {
				this.x = registrationObj.x;
			}
			if(registrationObj.y != null ) {
				this.y = registrationObj.y;
			}
		}
	}
	
	/*inherited from AnimationCore*/
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
	* @description 	returns the original, starting values of the current tween. _xscale and _yscale or _width and _height properties.
	* @usage   <tt>myInstance.getStartValues();</tt>
	* @return (Array) First value is _xscale or _width, second is _yscale or _height.
	*/
	
	/**
	* @method setStartValues
	* @description 	sets the original, starting values of the current tween. _xscale and _yscale or _width and _height properties.
	* @usage   <tt>myInstance.setStartValues(startValues);</tt>
	* @param startValues (Array) First value is _xscale or _width, second is _yscale or _height.
	* @return Boolean, indicates if the assignment was performed.
	*/	
	public function setStartValues(startValues:Array, optional:Boolean):Boolean {
		if(optional == null) {	
			this.areStartValuesSet = true;
		}
		return super.setStartValues(startValues, optional);
	}
	
	/**
	* @method getEndValues
	* @description 	returns the targeted values of the current tween. _xscale and _yscale or _width and _height properties.
	* @usage   <tt>myInstance.getEndValues();</tt>
	* @return (Array) First value is _xscale or _width, second is _yscale or _height.
	*/
	
	/**
	* @method setEndValues
	* @description 	sets the targeted value of the current tween. _xscale and _yscale or _width and _height properties.
	* @usage   <tt>myInstance.setEndValues(endValues);</tt>
	* @param endValues (Array) First value is _xscale or _width, second is _yscale or _height.
	* @return Boolean, indicates if the assignment was performed.
	*/		

	/**
	* @method getCurrentValues
	* @description 	returns the current values of the current tween. _xscale and _yscale or _width and _height properties.
	* @usage   <tt>myInstance.getCurrentValues();</tt>
	* @return (Array) First value is _xscale or _width, second is _yscale or _height.
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
	*			<b>value</b> (Array) values to animate.<p>
	* 		
	* @usage   <pre>myScale.addEventListener(event, listener);</pre>
	* 		    <pre>myScale.addEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myScale.removeEventListener(event, listener);</pre>
	* 		    <pre>myScale.removeEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myScale.removeAllEventListeners();</pre>
	* 		    <pre>myScale.removeAllEventListeners(event);</pre>
	* 	  
	*@param event (String) Event to remove all subscribed listeners from. If not specified, all listeners to any event will be removed.
	*/
	
	/*inherited from APCore*/
	/**
	* @method eventListenerExists
	* @description 	GDispatcher specific feature. Checks if a listener is already subscribed to a certain event.
	* 		
	* @usage   <pre>myScale.eventListenerExists(event, listener);</pre>
	* 			<pre>myScale.eventListenerExists(event, listener, handler);</pre>
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
		return "Scale";
	}
}