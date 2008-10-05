import de.alex_uhlmann.animationpackage.APCore;
import de.alex_uhlmann.animationpackage.animation.IAnimatable;
import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.IVisitor;
import de.alex_uhlmann.animationpackage.utility.IVisitorElement;
import de.alex_uhlmann.animationpackage.utility.IComposite;

/**
* @class Parallel
* @author Alex Uhlmann
* @description  Parallel allows you to animate the classes of 
* 			de.alex_uhlmann.animationpackage.animation synchronously in a uniform manner.
* 			Parallel uses the composite design pattern. [GoF]
* 			<p>
* 			Example 1: <a href="Parallel_01.html">(Example .swf)</a> Animate different animations at the same time back and forth.
* 			<pre><blockquote> 
* 			var myMoveOnQuadCurve:MoveOnQuadCurve = new MoveOnQuadCurve(mc,100,100,300,300,500,100);
*			var myScale:Scale = new Scale(mc,50,50);
*			var myRotation:Rotation = new Rotation(mc,360);
*			var myColorTransform:ColorTransform = new ColorTransform(mc,0xff0000,50);
* 
*			var myParallel:Parallel = new Parallel();
*			myParallel.addChild(myMoveOnQuadCurve);
*			myParallel.addChild(myScale);
*			myParallel.addChild(myRotation);
*			myParallel.addChild(myColorTransform);
*			myParallel.animationStyle(2000,Circ.easeInOut,"onCallback");
*			myParallel.animate(0,100);
*			myListener.onCallback = function(source) {	
*				source.callback = "onCallback2";
*				source.animate(100,0);
*			}
*			myListener.onCallback2 = function(source) {
*				source.callback = "onCallback";
*				source.animate(0,100);
*			}
* 			</pre></blockquote>
* 			<p>			
* @usage <tt>var myParallel:Parallel = new Parallel();</tt> 
*/
class de.alex_uhlmann.animationpackage.animation.Parallel 
											extends AnimationCore 
											implements ISingleAnimatable, 
													IVisitorElement, 
													IComposite {	
	
	/*animationStyle properties inherited from AnimationCore*/
	/** 
	* @property duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @property easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @property callback (String) Function to invoke after animation. See AnimationCore class. 
	*/

	private var childsArr:Array;
	private var oneChild:Object;
	
	public function Parallel() {		
		super();
		this.childsArr = new Array();
	}
	
	private function invokeAnimation(start:Number, end:Number) {
		var goto:Boolean;
		if(end == null) {
			goto = true;
			end = start;
			start = 0;
		} else {
			goto = false;
			this.setStartValue(start);	
			this.setEndValue(end);
		}
		var i:Number, len:Number = this.childsArr.length;
		var child:Object;
		for (i = 0; i < len; i++) {
			child = this.childsArr[i];
			if(goto == false) {
				child.animate(start, end);
			} else {
				child.goto(end);
			}
			if(child.duration == this.duration) {
				this.oneChild = child;
			}
		}
		this.oneChild.addEventListener("onUpdate",this);
		this.oneChild.addEventListener("onEnd", this);
		this.myAnimator = this.oneChild.myAnimator;
		this.tweening = true;	
		this.dispatchEvent.apply(this, [ {type:"onStart", value:this.getStartValue()} ]);
	}	
	
	/**
	* @method animate
	* @description 	animates the contents of the composite.
	* @usage   <pre>myParallel.animate(start, end);</pre> 	  
	* @param start (Number) start value. Percentage.
	* @param end (Number) end value. Percentage.
	* @return void
	*/	
	public function animate(start:Number, end:Number):Void {
		this.invokeAnimation(start, end);
	}
	
	/**
	* @method goto
	* @description 	jumps to a specific step of the animation and stays there.
	* @usage   <pre>myInstance.goto(percentage);</pre>
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
	* @usage   <pre>myParallel.animationStyle(duration);</pre>
	* 		<pre>myParallel.animationStyle(duration, callback);</pre>
	* 		<pre>myParallel.animationStyle(duration, easing, callback);</pre>
	* 	  
	* @param duration (Number) Duration of animation(s) in milliseconds or frames. Default is milliseconds.
	* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @param callback (String) Function to invoke after animation(s). See APCore class.
	*/
	public function animationStyle(duration:Number, easing:Object, callback:String):Void {
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {					
			this.childsArr[i].animationStyle(duration, easing);			
		}
		this.duration = duration;
		this.callback = callback;
	}	
	
	public function onStart(eventObject:Object):Void {		
		this.dispatchEvent({type:eventObject.type, value:this.getStartValue()});
	}
	
	public function onUpdate(eventObject:Object):Void {		
		this.dispatchEvent({type:eventObject.type, value:this.getCurrentValue()});
	}
	
	public function onEnd(eventObj:Object):Void {			
		
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {	
			var child:Object = this.childsArr[i];
			if(child.isTweening()) {
				child.addEventListener("onEnd",this);
				return;
			}	
		}
		this.tweening = false;
		eventObj.target.removeEventListener("onEnd", this);
		APCore.broadcastMessage(this.callback, this);		
		this.dispatchEvent.apply(this, [ {type:"onEnd", value:this.getEndValue()} ]);
	}
	
	/**
	* @method addChild
	* @description 	adds a primitive or composite to the composite instance of Parallel 
	* See class description.
	* @usage  <pre>myParallel.addChild(component);</pre>
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
	* @usage  <pre>myParallel.removeChild(component);</pre>
	* @param component (IAnimatable) Must be compatiblee to IAnimatable.	
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
	*@param rounded (Boolean) <code>true</code> rounds the result. Animates with integers. Less accuracy. <code>false</code> animates with floating point numbers.
	*/
	public function roundResult(rounded:Boolean):Void {
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			this.childsArr[i].roundResult(rounded);		
		}
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
	public function forceEnd(forceEndVal:Boolean):Void {
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			this.childsArr[i].forceEnd(forceEndVal);		
		}
	}
	
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
	public function setOptimizationMode(optimize:Boolean):Void {
		this.equivalentsRemoved = optimize;
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			this.childsArr[i].setOptimizationMode(optimize);		
		}
	}	
	
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
	* @usage   <tt>setTweenMode(tweenMode);</tt> 	
	* @param tweenMode (String) Either AnimationCore.INTERVAL for time-based tweening or AnimationCore.FRAMES for frame-based tweening.
	* @returns   <code>true</code> if setting tween mode was successful, 
	*                  <code>false</code> if not successful.
	*/
	public function setTweenMode(tweenMode:String):Boolean {
		this.tweenMode = tweenMode;
		var isSet:Boolean;
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			isSet = this.childsArr[i].setTweenMode(tweenMode);		
		}
		return isSet;
	}
	
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
	* @usage   <tt>setDurationMode(durationMode);</tt> 	
	* @param durationMode (String) Either AnimationCore.MS for milliseconds or AnimationCore.FRAMES.
	* @returns   <code>true</code> if setting duration mode was successful, 
	*                  <code>false</code> if not successful.
	*/	
	public function setDurationMode(durationMode:String):Boolean {
		this.durationMode = durationMode;
		var isSet:Boolean;
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			isSet = this.childsArr[i].setDurationMode(durationMode);		
		}
		return isSet;
	}

	/*inherited from AnimationCore*/
	/**
	* @method stop
	* @description 	stops the animation if not locked..
	* @usage   <tt>myInstance.stop();</tt> 
	* @returns <code>true</code> if instance was successfully stopped. 
	*                  <code>false</code> if instance could not be stopped, because it was locked.
	*/
	public function stop(Void):Boolean {
		if(super.stop() == true) {			
			var i:Number, len:Number = this.childsArr.length;
			for (i = 0; i < len; i++) {				
				this.childsArr[i].stop();
			}
			return true;
		} else {
			return false;
		}
	}	
	
	/**
	* @method pause
	* @description 	pauses the animation if not locked. Call resume() to continue animation.
	* @usage   <tt>myInstance.pause();</tt> 	  
	* @param duration (Number) optional property. Number of milliseconds or frames to pause before continuing animation.
	* @returns <code>true</code> if instance was successfully paused. 
	*                  <code>false</code> if instance could not be paused, because it was locked.
	*/
	public function pause(duration:Number):Boolean {		
		if(super.pause(duration) == true) {
			var i:Number, len:Number = this.childsArr.length;
			for (i = 0; i < len; i++) {				
				this.childsArr[i].pause();
			}
			return true;
		} else {
			return false;
		}
	}	
	
	/**
	* @method resume
	* @description 	continues the animation if not locked. 
	* @usage   <tt>myInstance.resume();</tt> 	
	* @returns <code>true</code> if instance was successfully resumed. 
	*                  <code>false</code> if instance could not be resumed, because it was locked.
	*/
	public function resume(Void):Boolean {		
		if(super.resume() == true) {
			var i:Number, len:Number = this.childsArr.length;
			for (i = 0; i < len; i++) {				
				this.childsArr[i].resume();
			}			
			return true;
		} else {
			return false;
		}
	}	
	
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
	public function getStartValue(Void):Number {		
		var startValue:Number = super.getStartValue();
		if(startValue == null) {
			startValue = 0;
		}
		return startValue;
	}	
	
	/**
	* @method getEndValue
	* @description 	returns the targeted value of the current tween. Percentage.
	* @usage   <tt>myInstance.getEndValue();</tt>
	* @return Number
	*/
	public function getEndValue(Void):Number {		
		var endValue:Number = super.getEndValue();
		if(endValue == null) {
			endValue = 100;
		}
		return endValue;
	}	

	/**
	* @method getCurrentValue
	* @description 	returns the current value of the current tween. Percentage.
	* @usage   <tt>myInstance.getCurrentValue();</tt>
	* @return Number
	*/
	public function getCurrentValue(Void):Number {
		return (this.currentValue = this.oneChild.getCurrentPercentage());
	}	
	
	/**
	* @method getCurrentPercentage
	* @description 	returns the current state of the animation in percentage. 
	* 				Especially usefull in combination with goto().
	* @usage   <tt>myInstance.getCurrentPercentage();</tt>
	* @return Number
	*/
	public function getCurrentPercentage(Void):Number {
		return this.oneChild.getCurrentPercentage();
	}	

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
	* @usage   <pre>myParallel.addEventListener(event, listener);</pre>
	* 		    <pre>myParallel.addEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myParallel.removeEventListener(event, listener);</pre>
	* 		    <pre>myParallel.removeEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myParallel.removeAllEventListeners();</pre>
	* 		    <pre>myParallel.removeAllEventListeners(event);</pre>
	* 	  
	*@param event (String) Event to remove all subscribed listeners from. If not specified, all listeners to any event will be removed.
	*/
	
	/*inherited from APCore*/
	/**
	* @method eventListenerExists
	* @description 	GDispatcher specific feature. Checks if a listener is already subscribed to a certain event.
	* 		
	* @usage   <pre>myParallel.eventListenerExists(event, listener);</pre>
	* 			<pre>myParallel.eventListenerExists(event, listener, handler);</pre>
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
		return "Parallel";
	}
}