import de.alex_uhlmann.animationpackage.animation.IAnimatable;
import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.IVisitor;
import de.alex_uhlmann.animationpackage.utility.IVisitorElement;
import de.alex_uhlmann.animationpackage.utility.IComposite;
import de.alex_uhlmann.animationpackage.utility.Animator;
import org.dembicki.Path;

/**
* @class MoveOnPath
* @author Alex Uhlmann
* @description   Moves a movieclip on along a path using Ivan Dembicki's com.sharedfonts.Path. This allows to 
* 			animate an object very evenly along a path. 
* 			<p>
* 			Example 1: <a href="MoveOnPath_01.html">(Example .swf)</a>
* 			<blockquote><pre>
*			//draw the path for visualisation.
*			new QuadCurve(400,100,100,0,100,100,true).draw();
*			new QuadCurve(100,100,100,200,450,380,true).draw();
*			new QuadCurve(450,380,0,100,400,100,true).draw();
*		
*			var myMoveOnQuadCurve1:MoveOnQuadCurve = new MoveOnQuadCurve(mc,400,100,100,0,100,100);
*			var myMoveOnQuadCurve2:MoveOnQuadCurve = new MoveOnQuadCurve(mc,100,100,100,200,450,380);
*			var myMoveOnQuadCurve3:MoveOnQuadCurve = new MoveOnQuadCurve(mc,450,380,0,100,400,100);
*			
*			var myMOP:MoveOnPath = new MoveOnPath(mc);
*			myMOP.addChild(myMoveOnQuadCurve1);
*			myMOP.addChild(myMoveOnQuadCurve2);
*			myMOP.addChild(myMoveOnQuadCurve3);
*			myMOP.animationStyle(4000,Linear.easeNone);
*			myMOP.animate(0,100);
*			</pre></blockquote>
* 			<p>
* 			Example 2: <a href="MoveOnPath_02.html">(Example .swf)</a> Orient the object towards the path while 
* 			animating with Sine easing.
* 			<blockquote><pre>
* 			//draw the path for visualisation.
* 			new QuadCurve(400,100,100,0,100,100,true).draw();
* 			new QuadCurve(100,100,100,200,450,380,true).draw();
* 			new QuadCurve(450,380,0,100,400,100,true).draw();
* 		
* 			var myMoveOnQuadCurve1:MoveOnQuadCurve = new MoveOnQuadCurve(mc,400,100,100,0,100,100);
*			var myMoveOnQuadCurve2:MoveOnQuadCurve = new MoveOnQuadCurve(mc,100,100,100,200,450,380);
* 			var myMoveOnQuadCurve3:MoveOnQuadCurve = new MoveOnQuadCurve(mc,450,380,0,100,400,100);
* 			
* 			var myMOP:MoveOnPath = new MoveOnPath(mc);
* 			myMOP.addChild(myMoveOnQuadCurve1);
* 			myMOP.addChild(myMoveOnQuadCurve2);
* 			myMOP.addChild(myMoveOnQuadCurve3);
* 			myMOP.orientToPath(true);
* 			myMOP.animationStyle(8000,Sine.easeInOut);
* 			myMOP.animate(0,100);
*			</pre></blockquote>
* 			<p>
* 			Example 3: <a href="MoveOnPath_03.html">(Example .swf)</a> Same like above except 
* 			that the object will orientate itself on the path instead towards the path. 
* 			This is like the rotation on a path works in the Flash IDE.
* 			<blockquote><pre>
* 			//draw the path for visualisation.
* 			new QuadCurve(400,100,100,0,100,100,true).draw();
* 			new QuadCurve(100,100,100,200,450,380,true).draw();
* 			new QuadCurve(450,380,0,100,400,100,true).draw();
* 		
* 			var myMoveOnQuadCurve1:MoveOnQuadCurve = new MoveOnQuadCurve(mc,400,100,100,0,100,100);
*			var myMoveOnQuadCurve2:MoveOnQuadCurve = new MoveOnQuadCurve(mc,100,100,100,200,450,380);
* 			var myMoveOnQuadCurve3:MoveOnQuadCurve = new MoveOnQuadCurve(mc,450,380,0,100,400,100);
* 			
* 			var myMOP:MoveOnPath = new MoveOnPath(mc);
* 			myMOP.addChild(myMoveOnQuadCurve1);
* 			myMOP.addChild(myMoveOnQuadCurve2);
* 			myMOP.addChild(myMoveOnQuadCurve3);
* 			myMOP.orientOnPath(true);
* 			myMOP.animationStyle(8000,Sine.easeInOut);
* 			myMOP.animate(0,100);
*			</pre></blockquote>
* @usage <pre>var myMOP:MoveOnPath = new MoveOnPath(mc);</pre> 
*		<pre>var myMOP:MoveOnPath = new MoveOnPath(mc, duration);</pre>
* 		<pre>var myMOP:MoveOnPath = new MoveOnPath(mc, duration, callback);</pre>
* 		<pre>var myMOP:MoveOnPath = new MoveOnPath(mc, duration, easing, callback);</pre>
* @param mc (MovieClip) Movieclip to animate.
* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
* @param callback (String) Function to invoke after animation. See APCore class.
*/
class de.alex_uhlmann.animationpackage.animation.MoveOnPath 
										extends AnimationCore 
										implements ISingleAnimatable, 
												IVisitorElement, 
												IComposite {	
	
	private var start:Number;
	private var end:Number;
	private var childsArr:Array;
	private var myPath:Path;
	private var pathArr:Array;
	private var rotateTo:Boolean = false;
	private var rotateOn:Boolean = false;
	private var overriddenRounded:Boolean = false;
	
	public function MoveOnPath() {				
		super();
		this.mc = arguments[0];
		this.childsArr = new Array();
		if(arguments.length > 1) {			
			this.initAnimation.apply(this, arguments.slice(1));
		}
	}
	
	private function initAnimation(duration:Number, easing:Object, callback:String):Void {		
		
		var paramLen:Number = 0;
		if (arguments.length > paramLen) {			
			this.animationStyle(duration, easing, callback);
		} else {
			this.animationStyle(this.duration, this.easing, this.callback);
		}
	}

	private function invokeAnimation(start:Number, end:Number):Void {
		this.startInitialized = false;
		
		this.pathArr = new Array();
		
		var i:Number, len:Number = this.childsArr.length;
		var child:Object = this.childsArr[0];			
		child.useControlPoints(true);
		this.pathArr.push(child.x1);
		this.pathArr.push(child.y1);		
		for(i = 0; i < len; i++) {
			var child:Object = this.childsArr[i];			
			child.useControlPoints(true);		
			this.pathArr.push(child.x2);
			this.pathArr.push(child.y2);
			this.pathArr.push(child.x3);
			this.pathArr.push(child.y3);
		}
		this.myPath = new Path(this.pathArr);
		this.setStartValue(0);
		this.setEndValue(this.myPath.path_length-1);
		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		this.myAnimator.start = [0];
		this.myAnimator.end = [this.myPath.path_length-1];
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
		var p:Object = this.myPath.getPoint(targ, true);
		if(overriddenRounded) {
			this.mc._x = Math.round(p._x);
			this.mc._y = Math.round(p._y);			
		}
		else {
			this.mc._x = p._x;
			this.mc._y = p._y;			
		}
	}
	
	private function moveAndRotateTo(targ:Number):Void {
		var p:Object = this.myPath.getPoint(targ, false);		
		if(overriddenRounded) {
			this.mc._x = Math.round(p._x);
			this.mc._y = Math.round(p._y);
			this.mc._rotation = Math.round(p._rotation-90);
		}
		else {
			this.mc._x = p._x;
			this.mc._y = p._y;
			this.mc._rotation = p._rotation-90;
		}
	}
	
	private function moveAndRotateOn(targ:Number):Void {
		var p:Object = this.myPath.getPoint(targ, false);		
		if(overriddenRounded) {
			this.mc._x = Math.round(p._x);
			this.mc._y = Math.round(p._y);
			this.mc._rotation = Math.round(p._rotation);
		}
		else {
			this.mc._x = p._x;
			this.mc._y = p._y;
			this.mc._rotation = p._rotation;
		}
	}
	
	/**
	* @method animate
	* @description 	animates the contents of the composite.
	* @usage   <pre>myInstance.animate(start, end);</pre> 	  
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
	* @method addChild
	* @description 	adds a primitive or composite to the composite instance of Parallel 
	* See class description.
	* @usage  <pre>myInstance.addChild(component);</pre>
	* @param component (IAnimatable) Must be compatible to IAnimatable.
	* @return IAnimatable class that was added.
	*/
	public function addChild(component:IAnimatable):IAnimatable {		
		if(component instanceof Object) {
			this.childsArr.push(component);
			return component;
		}
	}	
	
	/**
	* @method removeChild
	* @description 	removes a primitive or composite from the composite instance of Parallel 
	* See class description.
	* @usage  <pre>myInstance.removeChild(component);</pre>
	* @param component (IAnimatable) Must be compatible to IAnimatable.	
	*/	
	public function removeChild(component:IAnimatable):Void {		
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			if(this.childsArr[i] == component) {
				this.childsArr.splice(i, 1);
			}
		}
	}
	
	/**
	* @method accept
	* @description 	Allow a visitor to visit its elements. See Visitor design pattern [GoF].
	* @usage  <pre>myInstance.accept(visitor);</pre>
	* @param visitor (IVisitor) Must be compatible to de.alex_uhlmann.animationpackage.utility.IVisitor.	
	*/
	public function accept(visitor:IVisitor):Void {
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			visitor.visit(this.childsArr[i]);			
		}
	}
	
	/**
	* @method getChildren
	* @description 	returns an Array of all children of the sequence. 
	* 				Could contain other Sequences.
	* @usage   <tt>myInstance.getChildren();</tt>
	* @return Array
	*/	
	public function getChildren(Void):Array {
		return this.childsArr;
	}	
	
	/**
	* @method roundResult
	* @description 	rounds animation results to integers. (might be usefull for animating pixelfonts). Default is false.		
	* @usage   <pre>myInstance.roundResult(rounded);</pre>
	* @param rounded (Boolean) <code>true</code> rounds the result. Animates with integers. Less accuracy. <code>false</code> animates with floating point numbers.
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
	* @param forceEndVal (Boolean) <code>true</code> or <code>false</code>.
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
		return "MoveOnPath";
	}
}