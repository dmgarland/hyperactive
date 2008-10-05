import de.alex_uhlmann.animationpackage.APCore;
import de.alex_uhlmann.animationpackage.animation.IAnimatable;
import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.IVisitor;
import de.alex_uhlmann.animationpackage.utility.IVisitorElement;
import de.alex_uhlmann.animationpackage.utility.IComposite;
import de.alex_uhlmann.animationpackage.utility.Pause;
import ascb.util.Proxy;

/**
* @class Animation
* @author Alex Uhlmann
* @description   The Animation class combines Sequence and Parallel to allow overlaps in child animations. 
* 			You can send start and end values in duration to the addChild method. 
* 			Animation allows you to animate the classes of 
* 			de.alex_uhlmann.animationpackage.animation in a sequence and/or parallel in a uniform manner.
* 			Animation uses the composite design pattern. [GoF]
* 			<p>
* 			Example 1: <a href="Animation_01.html">(Example .swf)</a> Animate different animations back and forth.
* 			Notice the we can send start and end values in duration to the addChild method. If we don't specify start 
* 			and end parameters, the child's duration will match the duration specified to Animation.
* 			<pre><blockquote> 
*			var myMoveOnQuadCurve:MoveOnQuadCurve = new MoveOnQuadCurve(mc,100,100,300,300,500,100);
*			var myScale:Scale = new Scale(mc,25,25);
*			var myRotation:Rotation = new Rotation(mc,360);
*			var myColorTransform:ColorTransform = new ColorTransform(mc,0xff0000,50);
*			
*			var myAnimation:Animation = new Animation();
*			myAnimation.addChild(myMoveOnQuadCurve);
*			myAnimation.addChild(myColorTransform);
*			myAnimation.addChild(myScale,0,1000);
*			myAnimation.addChild(myRotation,1000,1500);
*			myAnimation.animationStyle(2000,Circ.easeInOut,"onCallback");
*			myAnimation.animate(0,100);
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
* @usage <tt>var myAnimation:Animation = new Animation();</tt> 
*/
class de.alex_uhlmann.animationpackage.animation.Animation 
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
	private var childsTimesArr:Array;
	private var myPausesObj:Object;
	private var start:Number;
	private var end:Number;
	private var durationChild:Object;
	private var callbackFunc:Function;
	private var multipleValues:Boolean = false;	
	
	public function Animation() {
		super();
		this.childsArr = new Array();
		this.childsTimesArr = new Array();
		this.myPausesObj = new Object();
	}
	
	/**
	* @method animate
	* @description 	animates the contents of the composite.
	* @usage   <pre>myInstance.animate(start, end);</pre> 	  
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
	* @usage   <pre>instance.goto(percentage);</pre>
	* @param percentage (Number) Percentage value of the animation.
	* @return void
	*/
	
	private function invokeAnimation(start:Number, end:Number):Void {
		var goto:Boolean;
		var percentage:Number;
		if(end == null) {
			goto = true;
			end = start;
			start = 0;
			percentage = end;
		} else {
			goto = false;
			this.setStartValue(start);	
			this.setEndValue(end);			
		}		
		
		this.tweening = true;
		this.start = start;
		this.end = end;
		var myPause_loc:Pause;

		this.durationChild = this.getDurationChild();
		/*invoke all childs according to their start time in childsTimesArr.*/
		var i:Number, len:Number = this.childsArr.length;	
		for (i = 0; i < len; i++) {
			var child:Object = this.childsArr[i];
			var childStart:Number = childsTimesArr[i].start;
			var childEnd:Number = childsTimesArr[i].end;			
			var isChildEndNotDefined : Boolean = isNaN(childEnd);
			var isChildEndBiggerThanSpecifiedDuration : Boolean = (childEnd > this.duration && this.duration != null);
			if(isChildEndNotDefined || isChildEndBiggerThanSpecifiedDuration) {				
				childEnd = this.duration;
			}
			
			if(goto) {
				var childStartPerc:Number = childStart / this.duration * 100;
				var childEndPerc:Number = childEnd / this.duration * 100;
				var totalPerc:Number = childEndPerc - childStartPerc;
			
				if(childStartPerc < percentage && childEndPerc > percentage) {
					child.goto((percentage - childStartPerc) / totalPerc * 100);
				} else if(childStartPerc < percentage && childEndPerc <= percentage) {
					child.goto(100);
				} else if(childStartPerc >= percentage && childEndPerc >= percentage) {
					child.goto(0);
				}
				
			} else {
				
				if(childStart == 0) {
					this.invokeAnimationInstance(child, 
												childEnd - childStart);
				} else {				
					myPause_loc = new Pause();
					var ID:Number = myPause_loc.getID();
					if(this.getTweenMode() == AnimationCore.INTERVAL) {		
						myPause_loc.waitMS(childStart, 
											this, 
											"invokeAnimationInstance", 
											[child, childEnd - childStart, ID]);
					} else if(this.getTweenMode() == AnimationCore.FRAMES) {
						if(this.getDurationMode() == AnimationCore.MS) {
							myPause_loc.waitFrames(APCore.fps * childStart, 
													this, 
													"invokeAnimationInstance", 
													[child, childEnd - childStart, ID]);
						} else {
							myPause_loc.waitFrames(childStart, 
												this, 
												"invokeAnimationInstance", 
												[child, childEnd - childStart, ID]);
						}
					}
					this.myPausesObj[ID] = myPause_loc;
				}			
			}			
		}
		
		if(goto) {
			if(percentage <= 0) {
				this.dispatchEvent({type:"onStart", 
								value:this.getStartValue()});
			} else if(percentage >= 100) {
				this.dispatchEvent({type:"onEnd", 
								value:this.getEndValue()});
			} else {
				this.dispatchEvent({type:"onUpdate", 
								value:this.getCurrentValue()});		
			}		
		} else {
			this.dispatchEvent.apply(this, [ {type:"onStart", value:this.getStartValue()} ]);
		}		
	}

	private function getDurationChild(Void):Object {
		var longestDuration:Number = 0;
		var longestDurationChild:Number;
		var childNum:Number = null;
		var i:Number, len:Number = this.childsArr.length;	
		for (i = 0; i < len; i++) {
			var child:Object = this.childsArr[i];
			var childStart:Number = childsTimesArr[i].start;
			var childEnd:Number = childsTimesArr[i].end;
			if(isNaN(childEnd)) {
				childNum = i;
			} else {
				if(childEnd >= longestDuration) {
					longestDurationChild = i;
					longestDuration = childEnd;
				}
			}			
		}

		if(this.duration == null) {			
			this.duration = longestDuration;			
			this.callbackFunc = Proxy.create(this, this.invokeCallback);
			durationChild = this.childsArr[longestDurationChild];
			durationChild.addEventListener("onEnd", callbackFunc);
			return null;
		}

		var durationChild:Object;
		if(childNum == null) {			
			var myPause_loc:Pause;
			if(this.getTweenMode() == AnimationCore.INTERVAL) {
				myPause_loc = new Pause(AnimationCore.MS,this.duration, this, "invokeCallback");
			} else if(this.getTweenMode() == AnimationCore.FRAMES) {
				if(this.getDurationMode() == AnimationCore.MS) {
					myPause_loc = new Pause(AnimationCore.FRAMES,APCore.fps * this.duration, 
											this, "invokeCallback");
				} else {
					myPause_loc = new Pause(AnimationCore.FRAMES,this.duration, 
											this, "invokeCallback");
				}
			}
			durationChild = this.myPausesObj[myPause_loc.getID()] = myPause_loc;
			durationChild.animate(0,100);
		} else {			
			this.callbackFunc = Proxy.create(this, this.invokeCallback);
			durationChild = this.childsArr[childNum];
			durationChild.addEventListener("onEnd", callbackFunc);
		}
		durationChild.addEventListener("onUpdate", this);
		return durationChild;
	}
	
	private function invokeAnimationInstance(child:Object, duration:Number, ID:Number):Void {
		delete this.myPausesObj[ID];
		child.duration = duration;
		child.animate(this.start, this.end);
	}	

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
	* @usage   <pre>myInstance.animationStyle(duration);</pre>
	* 		<pre>myInstance.animationStyle(duration, callback);</pre>
	* 		<pre>myInstance.animationStyle(duration, easing, callback);</pre>
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
		super.animationStyle(duration, easing, callback);
	}
	
	public function onUpdate(eventObject:Object):Void {
		this.dispatchEvent({type:eventObject.type, value:this.getCurrentValue()});
	}	
	
	public function invokeCallback(Void):Void {
		if(this.tweening) {
			this.durationChild.removeEventListener("onEnd", this.callbackFunc);
			delete this.myPausesObj[this.durationChild.getID()];
			this.stop();
			this.tweening = false;
			APCore.broadcastMessage(this.callback, this);
			this.dispatchEvent.apply(this, [ {type:"onEnd", value:this.getEndValue()} ]);			
		}
	}
	
	/**
	* @method addChild
	* @description 	adds a primitive or composite to the composite instance of Animation. 
	* 				Accepts optional start and end values in duration. See class description.
	* @usage  <pre>myInstance.addChild(component);</pre>
	* @param component (IAnimatable) Must be compatible to IAnimatable.
	* @param start (Number) start value in duration. Either milliseconds or frames.
	* @param end (Number) end value in duration. Either milliseconds or frames.
	* @return IAnimatable class that was added.
	*/
	public function addChild(component:IAnimatable, start:Number, end:Number):IAnimatable {		
		if(component instanceof Object) {
			this.childsArr.push(component);
			if(start == null) {
				start = 0;
			}
			if(end == null) {
				end = NaN;
			}
			this.childsTimesArr.push({start:start, end:end});
		}
		return component;
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
				this.childsTimesArr.splice(i, 1);
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
			var child:String;
			for (child in this.myPausesObj) {				
				this.myPausesObj[child].stop();
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
			var child:String;
			for (child in this.myPausesObj) {	
				this.myPausesObj[child].pauseMe();
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
			var child:String;
			for (child in this.myPausesObj) {			
				this.myPausesObj[child].resume();
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
		return this.getCurrentPercentage();
	}	
	
	/**
	* @method getCurrentPercentage
	* @description 	returns the current state of the animation in percentage. 
	* 				Especially usefull in combination with goto().
	* @usage   <tt>myInstance.getCurrentPercentage();</tt>
	* @return Number
	*/
	public function getCurrentPercentage(Void):Number {
		if(this.durationChild != null) {
			return this.durationChild.getCurrentPercentage();
		} else {
			return 0;
		}
	}	

	/**
	* @method getDurationElapsed
	* @description 	returns the elapsed time or frames since the current tween started tweening.
	* @usage   <tt>myInstance.getDurationElapsed();</tt>
	* @return Number
	*/
	public function getDurationElapsed(Void):Number {		
		return this.durationChild.getDurationElapsed();
	}	
	
	/**
	* @method getDurationRemaining
	* @description 	returns the remaining time or frames since the current tween started tweening.
	* @usage   <tt>myInstance.getDurationRemaining();</tt>
	* @return Number
	*/
	public function getDurationRemaining(Void):Number {
		return this.durationChild.getDurationRemaining();
	}	
	
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
	* @usage   <pre>myInstance.addEventListener(event, listener);</pre>
	* 		    <pre>myInstance.addEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myInstance.removeEventListener(event, listener);</pre>
	* 		    <pre>myInstance.removeEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myInstance.removeAllEventListeners();</pre>
	* 		    <pre>myInstance.removeAllEventListeners(event);</pre>
	* 	  
	*@param event (String) Event to remove all subscribed listeners from. If not specified, all listeners to any event will be removed.
	*/
	
	/*inherited from APCore*/
	/**
	* @method eventListenerExists
	* @description 	GDispatcher specific feature. Checks if a listener is already subscribed to a certain event.
	* 		
	* @usage   <pre>myInstance.eventListenerExists(event, listener);</pre>
	* 			<pre>myInstance.eventListenerExists(event, listener, handler);</pre>
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
		return "Animation";
	}
}