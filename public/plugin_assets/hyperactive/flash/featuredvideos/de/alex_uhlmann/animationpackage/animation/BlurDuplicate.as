import de.alex_uhlmann.animationpackage.APCore;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.animation.Alpha;

/**
* @class Blur
* @author Alex Uhlmann
* @description Creates, removes and manipulates movieclip instances 
* 			inside a container movieclip to simulate a blur effect.<p>		
* 			There are two ways to use this class. One way is to specify 
* 			the duration, easing equation and callback properties outside 
* 			the current method, either with setting the properies directly 
* 			or with the animationStyle() method like it is used in 
* 			de.alex_uhlmann.animationpackage.drawing.
* 			<p>
* 			Example 1:
* 			<blockquote><pre>
*			var myBlur:BlurDuplicate = new BlurDuplicate(mc.inner_mc);
*			myBlur.animationStyle(3000,Sine.easeIn,"onCallback");
*			myBlur.alphaIn();
*			myBlur.put(10,1,2,2);
*			</pre></blockquote>  			
* 			Example 2: The alternative way is shorter.
* 			<blockquote><pre>	
* 			var myBlur:BlurDuplicate = new BlurDuplicate(mc.inner_mc);
*			myBlur.alphaIn(3000,Sine.easeIn,"onCallback");
*			myBlur.put(10,1,2,2);
* 			</pre></blockquote>
* 			Example 3: <a href="BlurDuplicate_03.html">(Example .swf)</a> Blur in, blur out loop. Use animationStyle() to define default animation properties. 
* 			Later, modify animation properties directly, to customize animation.
*   			<blockquote><pre>
* 			var myBlur:BlurDuplicate = new BlurDuplicate(mc.inner_mc);
*			myBlur.animationStyle(3000,Sine.easeIn,"onCallback");
*			myBlur.alphaIn();
*			myBlur.put(10,1,2,0);
*			myListener.onCallback = function()
*			{
*				myBlur.callback = "onCallback2";
*				myBlur.alphaOut();
*			}
*			myListener.onCallback2 = function()
*			{		
*				myBlur.callback = "onCallback";	
*				myBlur.alphaIn();	
*				myBlur.put(10,1,2,0);
*			}
*			</pre></blockquote> 
* @usage <tt>var myBlur:BlurDuplicate = new BlurDuplicate(inner_mc);</tt> 
* @param inner_mc (MovieClip) Movieclip to animate. Movieclip should have a parent clip.
*/
class de.alex_uhlmann.animationpackage.animation.BlurDuplicate extends AnimationCore {	
	
	/*animationStyle properties inherited from AnimationCore*/
	/** 
	* @property movieclip (MovieClip) Movieclip to animate. Movieclip should have a parent clip.
	* @property duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @property easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @property callback (String) Function to invoke after animation. See AnimationCore class. 
	*/		
	private var outer_mc:MovieClip;
	private var currParam:Array;
	private var fade:Boolean = false;
	private var alphaInst:Alpha;
	private var alphaMeth:Function;
	private var instancesArr:Array = new Array();
	private var blurMode:String;
	
	public function BlurDuplicate(inner_mc:MovieClip) {
		super();
		this.animationStyle();
		this.init(inner_mc);		
	}
		
	private function init():Void {
		var inner_mc:MovieClip = arguments[0];
		this.outer_mc = inner_mc._parent;		
		this.mc = inner_mc;
	}
	
	/**
	* @method alphaIn
	* @description 	Fade in blur. Works in combination with put method.		
	* 			<p>		
	* 			Example 1: Put a blur gradually with animation. Note: The alphaIn method 
	* 			has to be above the put method.
	* 			<blockquote><pre>			
	*			var myBlur:BlurDuplicate = new BlurDuplicate(mc.inner_mc);
	*			myBlur.alphaIn(3000,Sine.easeIn,"onCallback");
	*			myBlur.put(10,1,2,2);
	*			</pre></blockquote>
	* 			Example 2: Define animation properties outside of method.
	* 			<blockquote><pre>
	* 			var myBlur:BlurDuplicate = new BlurDuplicate(mc.inner_mc);
	*			myBlur.animationStyle(3000,Sine.easeIn,"onCallback");
	*			myBlur.alphaIn();
	*			myBlur.put(10,1,2,2);
	* 			</pre></blockquote>
	* 
	* @usage   <pre>myBlur.alphaIn();</pre>
	* 		<pre>myBlur.alphaIn(duration);</pre>
	* 		<pre>myBlur.alphaIn(duration, callback);</pre>
	* 		<pre>myBlur.alphaIn(duration, easing, callback);</pre>
	* 	  
	* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @param callback (String) Function to invoke after animation. See APCore class.
	* @return void
	*/
	public function alphaIn(duration:Number, easing:Object, callback:String):Void {
				
		var paramLen:Number = 0;
		if (arguments.length > paramLen) {			
			this.animationStyle.apply(this,[duration, easing, callback]);			
		}		
		this.dispatchEvent.apply(this, [ {type:"onStart"} ]);		
		this.fade = true;
		this.blurMode = "IN";
		this.currParam = [null, this.duration, this.easing];
	}	
	
	/*adapted from Ralf Bokelberg http://ww.qlod.com 02-2002*/
	/*It isn't possible to duplicate textfields and container mc's. ) : */	
	/**
	* @method put
	* @description 	Creates the blur. 			
	* 			<p> 
	* 			Example 1: Put a blur instantly.		
	* 			<blockquote><pre>
	*			var myBlur:BlurDuplicate = new BlurDuplicate(mc.inner_mc);				
	*			myBlur.put(10,1,2,2);
	* 			</pre></blockquote> 			
	* 			Example 2: Put a blur gradually with animation. Note: The alphaIn method 
	* 			has to be placed above the put method.
	* 			<blockquote><pre>			
	*			var myBlur:BlurDuplicate = new BlurDuplicate(mc.inner_mc);
	*			myBlur.alphaIn(3000,Sine.easeIn,"onCallback");
	*			myBlur.put(10,1,2,2);
	*			</pre></blockquote>
	* 		
	* @usage   <pre>myBlur.put(strength);</pre>
	* 		<pre>myBlur.put(strength, posFactor, scaleFactor, rotFactor);</pre>
	* 	  
	* @param strength (Number) Blur power.
	* @param posFactor (Number) Specifies how far the blur instances are positioned from inner_mc. Defaults to 0.
	* @param scaleFactor (Number) Specifies how much the blur instances are scaled from inner_mc. Defaults to 0.
	* @param rotFactor (Number) Specifies how much the blur instances are rotated from inner_mc. Defaults to 0.
	* @return void
	*/
	public function put(strength:Number, posFactor:Number, scaleFactor:Number, rotFactor:Number):Void {
		
		if(posFactor == null) {
			posFactor = 0;
		}
		if(scaleFactor == null) {
			scaleFactor = 0;
		}
		if(rotFactor == null) {
			rotFactor = 0;
		}
		this.tweening = true;
		var astep:Number = 100/strength;		
		var dp:Number;
		var i:Number = strength;
		for (i=1; i<strength; i++) {
			/*Flash Player 7 feature disabled*/
			//var dp:Number = this.mc._parent.getNextHighestDepth();			
			dp = this.getNextDepth(this.mc._parent);			
			var targ:MovieClip = this.mc.duplicateMovieClip("apBlur"+dp+"_mc", dp);	
			var a:Number = astep * i;
			if(this.fade) {
				targ._alpha = 0;
				this.currParam[0] = 100-a;
				this.alphaInst = new Alpha(targ);				
				this.alphaMeth = this.alphaInst["run"];
				this.instancesArr.push(this.alphaInst);
				this.invokeFunc(this.alphaInst, this.alphaMeth, false, i-1);				
			}			
			targ._x -= Math.random() * i * posFactor;
			targ._y -= Math.random() * i * posFactor;
			targ._width += scaleFactor * i;
			targ._height += scaleFactor * i;
			targ._alpha -= a;
			targ._rotation += i * rotFactor;
		}		
		this.myAnimator = this.alphaInst.myAnimator;
		this.alphaInst.addEventListener("onEnd", this);
		delete this.currParam;		
	}
	
	/**
	* @method alphaOut
	* @description 	Fade out blur.	
	* 			<p>		
	* 			Example 1: Fade out a blur gradually with Default animation style properties.
	* 			Note: The alphaOut method has to be placed below the put method.
	* 			<blockquote><pre>			
	*			var myBlur:Blur = new Blur(mc.inner_mc);
	*			myBlur.put(10,1,0);
	*			myBlur.alphaOut();
	*			</pre></blockquote>
	* 			Example 2: Do the same just with customized animation style properties.
	* 			<blockquote><pre>
	* 			var myBlur:Blur = new Blur(mc.inner_mc);
	*			myBlur.put(10,1,0);
	*			myBlur.alphaOut(3000,Sine.easeIn,"onCallback");
	* 			</pre></blockquote>
	* 
	* @usage   <pre>myBlur.alphaOut();</pre>
	* 		<pre>myBlur.alphaOut(duration);</pre>
	* 		<pre>myBlur.alphaOut(duration, callback);</pre>
	* 		<pre>myBlur.alphaOut(duration, easing, callback);</pre>
	* 	  
	* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @param callback (String) Function to invoke after animation. See APCore class.
	* @return void
	*/
	public function alphaOut(duration:Number, easing:Object, callback:String):Void {
		var paramLen:Number = 0;
		if (arguments.length > paramLen) {			
			this.animationStyle.apply(this,[duration, easing, callback]);	
		}
		this.dispatchEvent.apply(this, [ {type:"onStart"} ]);		
		this.tweening = true;
		this.blurMode = "OUT";
		this.applyFunc(this.alphaInst, "run", [0, this.duration, this.easing]);
		this.myAnimator = this.alphaInst.myAnimator;
	}
	
	/**
	* @method remove
	* @description 	Removes blur instances. Note: alphaOut method removes blur instances automatically.	
	* 			<p>		
	* 			Example 1: <a href="Blur_remove_01.html">(Example .swf)</a> Remove a blur after fade in animation instantly.
	* 			<blockquote><pre>			
	*			var myBlur:Blur = new Blur(mc.inner_mc);
	*			myBlur.alphaIn(3000,Sine.easeIn,"onCallback");
	*			myBlur.put(10,1,2,2);
	*			myListener.onCallback = function()
	*			{	
	*				myBlur.remove();				
	*			}
	*			</pre></blockquote>
	* 			Example 2: To delete blur instances of a movieclip directly, 
	* 			specify the movieclip as a parameter. Do the same like above to illustrate this. 
	* 			<blockquote><pre>
	* 			var myBlur:Blur = new Blur(mc.inner_mc);
	*			var myOtherBlur:Blur = new Blur();
	*			myBlur.alphaIn(3000,Sine.easeIn,"onCallback");
	*			myBlur.put(10,1,2,2);
	*			delete myBlur;
	*			myListener.onCallback = function()
	*			{	
	*				myOtherBlur.remove(mc);
	*			}
	*			</pre></blockquote>
	* 
	* @usage   <pre>myBlur.remove();</pre>
	* 		<pre>myBlur.remove(mc);</pre>
	* 	  
	* @param mc (MovieClip) Container movieclip. Movieclip that contains the blur instances.	
	* @return MovieClip that contained the blur instances.
	*/
	public function remove(mc:MovieClip):MovieClip {			
		if(mc == null) {
			mc = this.outer_mc;
		}		
		var clips:String;
		for (clips in mc) {
			if (clips.substring(0,6) == "apBlur") {
				mc[clips].removeMovieClip();				
			}	
		}
		this.instancesArr.length = 0;
		return mc;
	}	
	
	/**
	* @method applyFunc
	* @description 	Invoke a specified method of a class with parameters that effects all blur instances. 
	* 			The class needs to have a movieclip property, which applyFunc will use to set the Blur movieclip instance. 
	* 			If the last paremeter is a String it is treated as a callback 
	* 			and therefore send only to one Blur movieclip. Therefore I recommend 
	* 			using the functions of AnimationPackage that are compatible to these limitations. 
	* 			Furthermore, you cannot use pause(), stop() and resume() methods on animations created by myBlur.applyFunc().
	* 			<p>
	* 			Example 1: <a href="Blur_applyFunc_01.html">(Example .swf)</a> colors blur movieclips slightly red after fading in.
	* 			<blockquote><pre>			
	*			var myBlur:Blur = new Blur(mc.inner_mc);
	*			myBlur.alphaIn(3000,Sine.easeIn,"onCallback");
	*			myBlur.put(10,1,2,0);
	*			myListener.onCallback = function()
	*			{	
	*				myBlur.applyFunc(new ColorTransform(), "run", [0xff0000, 100, 4000, Quad.easeOut]);
	*			}
	*			</pre></blockquote>
	* 
	* @usage   <pre>myBlur.applyFunc(scope, funcStr);</pre> 		
	* 		<pre>myBlur.applyFunc(scope, funcStr, param);</pre>
	* 	  
	* @param scope (Number) Object.
	* @param funcStr (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @param param (Array) An optional array of parameters passed to funcStr. Note the limitations described in description. 
	* @return void
	*/
	public function applyFunc(scope:Object, funcStr:String, param:Array):Void {		
		var i:Number = 0;
		var func:Function = scope[funcStr];		
		this.currParam = param;
		var hasCallback:Boolean = false;		
		var lastArg = arguments[arguments.length-1][arguments.length+1];
		if(typeof(lastArg) == "string") {			
			hasCallback = true;
		}
		var clips:String;
		for (clips in this.outer_mc) {			
			if (clips.substring(0,6) == "apBlur") {
				/*save all Alpha instances for pausing, resuming and stopping*/
				if(scope instanceof Alpha) {
					this.alphaInst = new Alpha(this.outer_mc[clips]);					
					this.instancesArr.push(this.alphaInst);
					func = this.alphaInst[funcStr];			
					this.invokeFunc(this.alphaInst, func, hasCallback, i);
				} else {
					scope.movieclip = this.outer_mc[clips];				
					this.invokeFunc(scope, func, hasCallback, i);
				}
				i++;				
			}
		}
		this.alphaInst.addEventListener("onEnd", this);
		delete this.currParam;
	}
	
	private function invokeFunc(scope:Object, func:Object, 
								hasCallback:Boolean, i:Number):Void {
		
		//invoke only one callback. The callback of first inst.
		//CLUNKY: Be carefull if your func's last argument is a String but not a callback.					
		if(hasCallback == true && i == 0) {			
			func.apply(scope, this.currParam);
			this.currParam.pop();				
		}else {
			func.apply(scope, this.currParam);
		}		
	}	

	private function onEnd(eventObj:Object):Void {			
		eventObj.target.removeEventListener("onEnd", this);
		if(this.blurMode == "OUT") {
			this.remove();
		}
		this.tweening = false;
		this.instancesArr.length = 0;
		APCore.broadcastMessage(this.callback, this);
		this.dispatchEvent.apply(this, [ {type:"onEnd", target:this} ]);
	}
	
	public function getStartValue(Void):Number {
		return 0;
	}
	
	public function getEndValue(Void):Number {	
		return 100;
	}
	
	public function getCurrentValue(Void):Number {		
		var start:Number = this.alphaInst.getStartValue();
		var end:Number = this.alphaInst.getEndValue();
		if(start < end) {	
			return this.alphaInst.getCurrentValue() / end * 100;
		} else {
			return 100 - this.alphaInst.getCurrentValue() / start * 100;
		}
	}
	
	public function stop(Void):Boolean {
		if(this.locked == true || this.tweening == false) {
			return false;
		} else {
			this.tweening = false;
			var len:Number = this.instancesArr.length;
			var i:Number;
			for (i=0; i<len; i++) {				
				this.instancesArr[i].stop();
			}
			return true;
		}
	}
	
	public function pause(duration:Number):Boolean {
		if(this.locked == true || this.tweening == false) {
			return false;
		} else {
			this.tweening = false;
			var len:Number = this.instancesArr.length;		
			var i:Number;
			for (i=0; i<len; i++) {
				this.instancesArr[i].pause(duration);				
			}
			return true;
		}
	}
	
	public function resume(Void):Boolean {		
		if(!this.locked) {
			this.tweening = true;
			var len:Number = this.instancesArr.length;		
			var i:Number;
			for (i=0; i<len; i++) {
				this.instancesArr[i].resume();	
			}
			return true;
		} else {
			return false;
		}
	}
		
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
	*			<b>onEnd</b>, broadcasted when animation ends.<p>
	* 			The even object returned, contains the following properties:<p>
	* 			<b>type</b> (String) event broadcasted.<br>
	*			<b>target</b> (Object) event source.<br>			
	* 		
	* @usage   <pre>myBlur.addEventListener(event, listener);</pre>
	* 		    <pre>myBlur.addEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myBlur.removeEventListener(event, listener);</pre>
	* 		    <pre>myBlur.removeEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myBlur.removeAllEventListeners();</pre>
	* 		    <pre>myBlur.removeAllEventListeners(event);</pre>
	* 	  
	*@param event (String) Event to remove all subscribed listeners from. If not specified, all listeners to any event will be removed.
	*/
	
	/*inherited from APCore*/
	/**
	* @method eventListenerExists
	* @description 	GDispatcher specific feature. Checks if a listener is already subscribed to a certain event.
	* 		
	* @usage   <pre>myBlur.eventListenerExists(event, listener);</pre>
	* 			<pre>myBlur.eventListenerExists(event, listener, handler);</pre>
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
		return "BlurDuplicate";
	}		
}