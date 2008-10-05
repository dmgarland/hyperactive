import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.Animator;

/**
* @class MoveOnCurve
* @author Alex Uhlmann, Steve Schwarz
* @description   Moves a movieclip on along a bezier curve with n controlpoints. With MoveOnCurve 
* 			you can create bezier curves with an arbitrary length. The start and end points are the points 
* 			on the curve. In contrary to i.e. MoveOnQuadCurve the MoveOnCurve class by default 
* 			uses control points instead of points on the curve between the start and end points (anchor points).<p>		
* 			You can specify the duration, easing equation and callback properties 
* 			either with setting the properies directly or with the animationStyle() method 
* 			like it is used in de.alex_uhlmann.animationpackage.drawing.
* 			<p>
* 			Example 1: <a href="MoveOnCurve_01.html">(Example .swf)</a> Draw a bezier curve with 11 
* 			control points. Loop a movieclip on it and draw the curve for visualisation. Attach a trail with 
* 			infinite length and make it interruptible.
* 			<blockquote><pre>			
*			var x1:Number = 350;
*			var y1:Number = 50;
*			var x2:Number = 50;
*			var y2:Number = 50;
*			var x3:Number = 50;
*			var y3:Number = 200;
*			var x4:Number = 850;
*			var y4:Number = 200;
*			var x5:Number = 350;
*			var y5:Number = 350;
*			var x6:Number = 50;
*			var y6:Number = 350;
*			var x7:Number = -550;
*			var y7:Number = 500;
*			var x8:Number = 600;
*			var y8:Number = 600;
*			var x9:Number = 650;
*			var y9:Number = 500;
*			var x10:Number = 650;
*			var y10:Number = 50;
*			var x11:Number = 350;
*			var y11:Number = 50;
*			
*			var myStar:Star = new Star(275,200,20,10,6)
*			myStar.lineStyle();
*			myStar.fillStyle(0x9C3031);
*			myStar.draw();
*			
*			var points:Array = new Array();
*			points.push({x:x1, y:y1});
*			points.push({x:x2, y:y2});
*			points.push({x:x3, y:y3});
*			points.push({x:x4, y:y4});
*			points.push({x:x5, y:y5});
*			points.push({x:x6, y:y6});
*			points.push({x:x7, y:y7});
*			points.push({x:x8, y:y8});
*			points.push({x:x9, y:y9});
*			points.push({x:x10, y:y10});
*			points.push({x:x11, y:y11});
*			
*			var myMOC:MoveOnCurve = new MoveOnCurve(myStar.movieclip,points);
*			myMOC.animationStyle(4000);
*			myMOC.addEventListener("onEnd",this);
*			function onEnd() {
*				myMOC.animate(0,100);
*			}
*			myMOC.animate(0,100);
*			
*			var myCurve = new Curve(points);
*			myCurve.lineStyle(6,0x8CA6BD);
*			myCurve.animationStyle(4000);
*			myCurve.animate(0,100);
*			
*			var myTrail:Trail = new Trail(myStar.movieclip);
*			myTrail.attach(250,40,null);
*			
*			var myText:Text = new Text();
*			myText.setText("Press the mouse to pause/resume the animation.");
*			
*			function onMouseDown() {
*				if(myMOC.isTweening() == true) {
*					myMOC.pause();
*					myCurve.pause();
*					myTrail.pause();
*				} else {
*					myMOC.resume();
*					myCurve.resume();
*					myTrail.resume();
*				}
*			}
*			</pre></blockquote> 
* 			Example 2: <a href="MoveOnCurve_02.html">(Example .swf)</a> Do  
* 			the same like above just move and orientate 
* 			the AP logo along the curve.
* 			<blockquote><pre>
* 			...			
*			var myMOC:MoveOnCurve = new MoveOnCurve(mc,points);
*			myMOC.orientOnPath(true);
*			myMOC.animationStyle(8000);
*			myMOC.addEventListener("onEnd",this);
*			function onEnd() {
*				myMOC.animate(0,100);
*			}
*			myMOC.animate(0,100);
*			
*			var myTrail:Trail = new Trail(mc);
*			myTrail.attach(250,40,null);
* 			...
*			</pre></blockquote>  
* 			Example 3: Draw a quadratic bezier curve (3 control points).
* 			<blockquote><pre>			
*			var points:Array = new Array();
*			points.push({x:0, y:0});
*			points.push({x:275, y:200});
*			points.push({x:550, y:0});
*			
*			var myMOC:MoveOnCurve = new MoveOnCurve(mc);
*			myMOC.animationStyle(4000,Circ.easeInOut);
*			myMOC.run(points);
*			</pre></blockquote>
* 			Example 4: The alternative way is shorter. The same like above in one line.
* 			<blockquote><pre>	
* 			new MoveOnCurve(mc).run([{x:0,y:0},{x:275,y:200},{x:550,y:0}],4000,Circ.easeInOut);
* 			</pre></blockquote>		
*  			Example 5: You can also specify the properties via the constructor. 
* 			This might come in handy if you're using the Sequence or Parallel class.  
* 			Take a look at their class documentations for more information. 
* 			The animate() method and its start and end paremeters might also be useful. 
* 			<blockquote><pre>
*			var points:Array = new Array();
*			points.push({x:0, y:0});
*			points.push({x:275, y:200});
*			points.push({x:550, y:0});
* 
* 			var myMOC:MoveOnCurve = new MoveOnCurve(mc,points,4000,Circ.easeInOut);
* 			myMOC.animate(0,100);
* 			</pre></blockquote>
* @usage <pre>var myMOC:MoveOnCurve = new MoveOnCurve(mc);</pre> 
* 		<pre>var myMOC:MoveOnCurve = new MoveOnCurve(mc, points);</pre>
*		<pre>var myMOC:MoveOnCurve = new MoveOnCurve(mc, points, duration);</pre>
* 		<pre>var myMOC:MoveOnCurve = new MoveOnCurve(mc, xpoints, duration, callback);</pre>
* 		<pre>var myMOC:MoveOnCurve = new MoveOnCurve(mc, points, duration, easing, callback);</pre>
* @param mc (MovieClip) Movieclip to animate.
* @param points (Array) Array of objects with x and y properties that define the curve.
* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
* @param callback (String) Function to invoke after animation. See APCore class.
*/
class de.alex_uhlmann.animationpackage.animation.MoveOnCurve 
												extends AnimationCore 
												implements ISingleAnimatable {	
	
	/*animationStyle properties inherited from AnimationCore*/
	/** 
	* @property duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @property easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @property callback (String) Function to invoke after animation. See APCore class. 
	*/	
	private var mc:MovieClip;
	private var points:Array;
	private var n:Number;
	private var rotateTo:Boolean = false;
	private var rotateOn:Boolean = false;
	private var overriddenRounded:Boolean = false;
	
	/*
	* cache for last point calculated by getPointsOnCurve. 
	* Used to calculate slope/rotation
	*/
	private var lastPoint:Object;	
	
	public function MoveOnCurve() {				
		super();
		this.mc = arguments[0];
		if(arguments.length > 1) {			
			this.initAnimation.apply(this, arguments.slice(1));
		}
	}
	
	private function initAnimation(points:Array, duration:Number, easing:Object, callback:String):Void {		
		
		var paramLen:Number = 1;
		if (arguments.length > paramLen) {			
			this.animationStyle(duration, easing, callback);
		} else {
			this.animationStyle(this.duration, this.easing, this.callback);
		}		
		this.points = points;
		this.n = this.points.length-1;
		this.setStartValue(0);
		this.setEndValue(100);
	}
	
	private function invokeAnimation(start:Number, end:Number):Void {		
		this.startInitialized = false;
		
		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		this.myAnimator.start = [0];
		this.myAnimator.end = [100];
		if(this.rotateTo == true) {
			this.myAnimator.setter = [[this,"moveAndRotateTo"]];
		} else if(this.rotateOn == true) {
			this.myAnimator.setter = [[this,"moveAndRotateOn"]];
		} else {
			this.myAnimator.setter = [[this,"move"]];				
		}
		if(end != null) {
			this.myAnimator.animationStyle(this.duration, this.easing, this.callback);
			this.myAnimator.animate(start, end);
		} else {
			this.myAnimator.goto(start);
		}
	}
	
	private function move(targ:Number):Void {
		var p:Object = this.getPointsOnCurve(targ);		
		if(overriddenRounded) {
			this.mc._x = Math.round(p.x);
			this.mc._y = Math.round(p.y);			
		}
		else {
			this.mc._x = p.x;
			this.mc._y = p.y;			
		}
	}
	
	private function moveAndRotateTo(targ:Number):Void {
		var p:Object = this.getPointsOnCurve(targ);
		if(overriddenRounded) {
			this.mc._x = Math.round(p.x);
			this.mc._y = Math.round(p.y);
			this.mc._rotation = Math.round(this.computeRotation(targ, p) - 90);
		}
		else {
			this.mc._x = p.x;
			this.mc._y = p.y;
			this.mc._rotation = this.computeRotation(targ, p) - 90;
		}
	}
	
	private function moveAndRotateOn(targ:Number):Void {		
		var p:Object = this.getPointsOnCurve(targ);
		if(overriddenRounded) {
			this.mc._x = Math.round(p.x);
			this.mc._y = Math.round(p.y);
			this.mc._rotation = Math.round(this.computeRotation(targ, p));
		}
		else {
			this.mc._x = p.x;
			this.mc._y = p.y;
			this.mc._rotation = this.computeRotation(targ, p);
		}		
	}
	
	private function computeRotation(targ:Number, p:Object):Number {
		if (this.lastPoint.x == undefined) {
			//just calculated the first point. Store it.
			this.lastPoint = p;
			//go 1% forward to get next point
			p = this.getPointsOnCurve(targ + 1);
		}
		var degrees:Number = Math.atan2(this.lastPoint.y-p.y, this.lastPoint.x-p.x)/(Math.PI/180);
		//update cache
		this.lastPoint = p;	
		return degrees;
	}
	
	/*
	* de.alex_uhlmann.animationpackage.drawing.CubicCurve needs to access this method.
	* Adapted from Paul Bourke.
	*/
	public function getPointsOnCurve(targ:Number):Object {
		var v:Number = targ / 100;
		var k:Number, kn:Number, nn:Number, nkn:Number, blend:Number, muk:Number, munk:Number;
		var n:Number = this.n;
		var p:Array = this.points;
		var b:Object = {x:0, y:0};
		if(v != 1) {
			//calculate for all control points 
			//but the last point on the path
			muk = 1;		
			munk = Math.pow(1 - v, n);		
			for (k = 0; k <= n; k++) {			
				nn = n;
				kn = k;
				nkn = n - k;			
				blend = muk * munk;			
				muk *= v;
				munk /= (1 - v);			
				while (nn >= 1) {
					blend *= nn;				
					nn--;
					if (kn > 1) {
						blend /= kn;
						kn--;
					}
					if (nkn > 1) {
						blend /= nkn;
						nkn--;
					}
				}
				b.x += p[k].x * blend;
				b.y += p[k].y * blend;		
			}
			return b;
		} else {
		//Calculate the last point 
		//- it is NOT a control point
			var l:Number = p.length - 1;
			b.x = p[l].x;
			b.y = p[l].y;
			return b;
		}
	}

	/**
	* @method run
	* @description
	* @usage   
	* 		<pre>myInstance.run();</pre>
	* 		<pre>myInstance.run(points);</pre>
	* 		<pre>myInstance.run(points, duration);</pre>
	*		<pre>myInstance.run(points, duration, callback);</pre>
	* 		<pre>myInstance.run(points, duration, easing, callback);</pre>
	* 	  
	* @param points (Array) Array of objects with x and y properties that define the curve.
	* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @param callback (String) Function to invoke after animation. See APCore class.
	* @return void
	*/
	public function run():Void {							
		
		this.initAnimation.apply(this, arguments);
		this.invokeAnimation(0, 100);
	}
	
	/**
	* @method animate
	* @description 	similar to the run() method. Offers start and end parameters.
	* @usage   <pre>myMOC.animate(start, end);</pre> 	  
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
	* @method orientToPath
	* @description 	offers the opportunity to rotate the object towards the curve while animating.
	* 				Default is false. If true the object orientates towards the curve.
	*                  		If false the object's rotation will not be altered. See class documentation.
	* @usage   <pre>myInstance.orientToPath(rotateTo);</pre> 	  
	* @param rotateTo (Boolean) <code>true</code> or <code>false</code>.
	* @return void
	*/
	public function orientToPath(bool:Boolean):Void {
		if(bool) {
			this.rotateOn = false;
		}
		this.rotateTo = bool;
	}
	
	/**
	* @method orientOnPath
	* @description 	offers the opportunity to rotate the object on the curve while animating.
	* 				Default is false. If true the object orientates on the curve.
	*                  		If false the object's rotation will not be altered. See class documentation.
	* @usage   <pre>myInstance.orientToPath(rotateOn);</pre> 	  
	* @param rotateOn (Boolean) <code>true</code> or <code>false</code>.
	* @return void
	*/	
	public function orientOnPath(bool:Boolean):Void {
		if(bool) {
			this.rotateTo = false;
		}
		this.rotateOn = bool;
	}
	
	/**
	* @method roundResult
	* @description 	rounds animation results to integers. (might be usefull for animating pixelfonts). Default is false.		
	* @usage   <pre>myInstance.roundResult(event, listener);</pre>
	*@param rounded (Boolean) <code>true</code> rounds the result. Animates with integers. Less accuracy.
	*                  				<code>false</code> animates with floating point numbers.
	*/
	public function checkIfRounded(Void):Boolean {
		return this.overriddenRounded;
	}
	
	public function roundResult(overriddenRounded:Boolean):Void {
		this.overriddenRounded = overriddenRounded;
	}
	
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
	* @method getStartValue
	* @description 	returns the original, starting value of the current tween. Percentage.
	* @usage   <tt>myInstance.getStartValue();</tt>
	* @return Number
	*/
	
	/**
	* @method getEndValue
	* @description 	returns the targeted value of the current tween. Percentage.
	* @usage   <tt>myInstance.getEndValue();</tt>
	* @return Number
	*/

	/**
	* @method getCurrentValue
	* @description 	returns the current value of the current tween. Percentage.
	* @usage   <tt>myInstance.getCurrentValue();</tt>
	* @return Number
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
	*			<b>value</b> (Number) value to animate.<p>
	* 		
	* @usage   <pre>myMOC.addEventListener(event, listener);</pre>
	* 		    <pre>myMOC.addEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myMOC.removeEventListener(event, listener);</pre>
	* 		    <pre>myMOC.removeEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myMOC.removeAllEventListeners();</pre>
	* 		    <pre>myMOC.removeAllEventListeners(event);</pre>
	* 	  
	*@param event (String) Event to remove all subscribed listeners from. If not specified, all listeners to any event will be removed.
	*/
	
	/*inherited from APCore*/
	/**
	* @method eventListenerExists
	* @description 	GDispatcher specific feature. Checks if a listener is already subscribed to a certain event.
	* 		
	* @usage   <pre>myMOC.eventListenerExists(event, listener);</pre>
	* 			<pre>myMOC.eventListenerExists(event, listener, handler);</pre>
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
		return "MoveOnCurve";
	}
}