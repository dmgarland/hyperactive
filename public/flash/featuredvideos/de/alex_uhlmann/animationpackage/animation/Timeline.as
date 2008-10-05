import de.alex_uhlmann.animationpackage.APCore;
import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.Animator;
import de.andre_michelle.events.ImpulsDispatcher;

/**
* @class Timeline
* @author Ralf Bokelberg, Alex Uhlmann
* @description  There are two different ways to use Timeline for. One way is to animate 
* 				existing movieclip timeline(s) with AnimationPackage's tween engine. This way you can 
* 				apply easing equations to a movieclip timeline. If choosing the default time-based tweening, 
* 				the animation is independend from the current frame rate of your movieclip timeline(s). 
* 				See example number 1 and 2 for more information.<p>
* 				The other way is to control existing movieclip timelines with the API of AnimationPackage. 
* 				See example number 3 for more information about this opportunity.<p>
* 			Example 1: 	<a href="Timeline_01.html">(Example .swf)</a>
* 						<a href="Timeline_01.fla">(Example .fla)</a>
* 			Animate a single movieclip timeline via AnimationPackage's tween engine. 
* 			Animation of a movieclip that contains 50 frames of a shape tween. It starts with a rectangle 
* 			and ends with a polygon drawn with the Flash MX 2004 IDE. It is a usual linear tween 
* 			with a stop() action in the first frame. With Timeline we apply a Bounce easing equation to the linear 
* 			shape tween animation inside movieclip mc.
* 			<blockquote><pre>
*			var myTimeline:Timeline = new Timeline(mc,0,50);
*			myTimeline.animationStyle(2000,Bounce.easeOut);
*			myTimeline.animate(0,100);
*			</pre></blockquote>
* 			You could have used <code>AnimationCore.setTweenModes(AnimationCore.FRAMES);</code> and 
* 			a duration property of 50 to emulate a movieclip timeline animation with the same speed. 
* 			<p>
* 			Example 2: 	<a href="Timeline_02.html">(Example .swf)</a>
* 						<a href="Timeline_02.fla">(Example .fla)</a>
* 			Animate multiple movieclip timelines via AnimationPackage's tween engine.
* 			All Movieclips have the same structure than in the example above with 50 frames and a stop() action 
* 			in the first frame. Just the shape tween animation itself is different in some movieclips.
* 			<blockquote><pre>
*			var mcs:Array = new Array(top1_mc,top2_mc,top3_mc,bottom1_mc,bottom2_mc,bottom3_mc);
*			
*			//Two movieclips start at frame 30. This shall demonstrate 
* 			//Timeline's consideration of different start values
*			top1_mc.gotoAndStop(30);
*			bottom1_mc.gotoAndStop(30);
*			
*			var myTimeline:Timeline = new Timeline(mcs,50);
*			myTimeline.animationStyle(2500,Bounce.easeOut);
*			myTimeline.addEventListener("onEnd",this);
*			myTimeline.animate(0,100);
*			function onEnd(e:Object) {
*				trace("source: "+e.target+" event: "+e.type+" frame: "+e.value);
*				new Text().setText("source: "+e.target+" event: "+e.type+" frame: "+e.value);
*			}
* 
*			//pause and resume the animation in turns with each mouse click.
*			function onMouseDown() {
*				if(myTimeline.isTweening()){
*					myTimeline.pause();
*				} else {
*					myTimeline.resume();
*				}
*			}
*			</pre></blockquote>
*			<p>
* 			Example 3: 	<a href="Timeline_03.html">(Example .swf)</a>
* 						<a href="Timeline_03.fla">(Example .fla)</a>
* 			Another use of Timeline is to control movieclip timelines.
* 			Same movieclips like in example 2. Notice that we don't use the animationStyle method here, 
* 			because we don't want to apply an easing equation to the movieclip timelines specified in the Array mcs.
* 			We play every movieclip timeline by its own and get all informations, including events, about them via 
* 			the known API of AnimationPackage. The .swf plays at 31 fps.
* 			<blockquote><pre>
* 			//some textfields for logging event informations.
*			var myStartText:Text = new Text();
*			myStartText.setText("",0,0);
*			var myUpdateText:Text = new Text();
*			myUpdateText.setText("",0,15);
*			var myEndText:Text = new Text();
*			myEndText.setText("",0,30);
*			
*			var mcs:Array = new Array(top1_mc,top2_mc,top3_mc,bottom1_mc,bottom2_mc,bottom3_mc);
*			
* 			var myTimeline:Timeline = new Timeline(mcs);
*			myTimeline.addEventListener("onStart",this);
*			myTimeline.addEventListener("onUpdate",this);
*			myTimeline.addEventListener("onEnd",this);
* 
*			//internally, this method invokes the play() method on each movieclip instance.
* 			//you could i.e. also use stop(), gotoAndStop(), gotoAndPlay(), nextFrame(), 
* 			//and prevFrame() via Timeline.
*			myTimeline.play();
*			
*			function onStart(e:Object) {
*				myStartText.updateText("source: "+e.target+" event: "+e.type+" frame: "+e.value+"\n");	
*			}
*			function onUpdate(e:Object) {
*				myUpdateText.updateText("source: "+e.target+" event: "+e.type+" frame: "+e.value+"\n");
*			}
*			function onEnd(e:Object) {
*				myEndText.updateText("source: "+e.target+" event: "+e.type+" frame: "+e.value+"\n");
*				myTimeline.stop();
*			}
*			
* 			//even if not animated via AnimationPackage's own tween engine, you're still able to stop and pause 
* 			//the movieclip timeline(s) as you would expect with every IAnimatable instance.
*			function onMouseDown() {
*				if(myTimeline.isTweening()){
*					myTimeline.pause();
*				} else {
*					myTimeline.resume();
*				}
*			}
*			</pre></blockquote>
* 			Notice, that if you use Timeline for controling movieclip timelines, omitting the second parameter 
* 			like we have done in the Timeline constructor of example 3, reads the _totalframe property 
* 			of the movieclip you want to control as end value of the animation. 
* 			Nevertheless you could also have set a second property (amount parameter, see usage) 
* 			as a end value or you could also have set a start and end value (value parameter, see usage) 
* 			If no start and end values are specified, the movieclip's _currentframe and _totalframe properties 
* 			are used as start and end values.
*			<p>
* 
* 			There are many ways to use this class. One way is to specify 
* 			the duration, easing equation and callback properties outside 
* 			the current method, either with setting the properies directly 
* 			or with the animationStyle() method like it is used in 
* 			de.alex_uhlmann.animationpackage.drawing.
* 			<p>
* 			Example 4: 
* 			<blockquote><pre>			
*			var myTimeline:Timeline = new Timeline(mc);
*			myTimeline.animationStyle(2000,Circ.easeIn,"onCallback");
*			myTimeline.run(50);
*			</pre></blockquote>  			
* 			Example 5: The alternative way is shorter. The same like above in one line.
* 			<blockquote><pre>	
* 			new Timeline(mc).run(50,2000,Circ.easeInOut,"onCallback");
* 			</pre></blockquote>
* 			Example 6: You can also specify the properties via the constructor. 
* 			This might come in handy if you're using the Sequence or Parallel class.  
* 			Take a look at their class documentations for more information. 
* 			The animate() method and its start and end percentage parameters might also be useful. 			
* 			<blockquote><pre>
* 			var myTimeline:Timeline = new Timeline(mc,0,2000,Circ.easeInOut);
* 			myTimeline.animate(50,100);
* 			</pre></blockquote>
* 			Example 7: By default, the start value of your animation is the current value of your sound instance 
* 			retrieved from getTimeline(). You can explicitly define the start values either via the setStartValue 
* 			or run method or via the constructor. Here is one example for the constructor solution. 
* 			This also might come in handy using composite classes, like Sequence.
* 			<blockquote><pre>
*			var myTimeline:Timeline = new Timeline(mc,[50,0],2000,Circ.easeIn);
*			myTimeline.run();
* 			</pre></blockquote>	
* @usage 
* 			<pre>var myTimeline:Timeline = new Timeline(mcs);</pre> 
* 			<pre>var myTimeline:Timeline = new Timeline(mcs, amount, duration, callback);</pre> 
* 			<pre>var myTimeline:Timeline = new Timeline(mcs, amount, duration, easing, callback);</pre>
*			<pre>var myTimeline:Timeline = new Timeline(mcs, values);</pre> 
* 			<pre>var myTimeline:Timeline = new Timeline(mcs, values, duration, callback);</pre> 
* 			<pre>var myTimeline:Timeline = new Timeline(mcs, values, duration, easing, callback);</pre>      
* 			<pre>var myTimeline:Timeline = new Timeline(mc);</pre> 
* 			<pre>var myTimeline:Timeline = new Timeline(mc, amount, duration, callback);</pre> 
* 			<pre>var myTimeline:Timeline = new Timeline(mc, amount, duration, easing, callback);</pre>
*			<pre>var myTimeline:Timeline = new Timeline(mc, values);</pre> 
* 			<pre>var myTimeline:Timeline = new Timeline(mc, values, duration, callback);</pre> 
* 			<pre>var myTimeline:Timeline = new Timeline(mc, values, duration, easing, callback);</pre> 
* @param mc (MovieClip) Movieclip to animate.
* @param mcs (Array) array of movieclips to animate.
* @param amount (Number) Targeted frames to animate to.
* @param values (Array) optional start and end values.
* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
* @param callback (String) Function to invoke after animation. See AnimationCore class.
*/
class de.alex_uhlmann.animationpackage.animation.Timeline 
											extends AnimationCore 
											implements ISingleAnimatable {	
	
	/*animationStyle properties inherited from AnimationCore*/
	/**
	* @property movieclip (MovieClip) Movieclip to animate.
	* @property movieclips (Array) Array of Movieclips to animate.
	* @property duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @property easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @property callback (String) Function to invoke after animation. See AnimationCore class. 
	*/
	private var myTLs:Array;
	
	public function Timeline() {
		super();
		if(typeof(arguments[0]) == "movieclip") {
			this.mc = arguments[0];
		} else {
			this.mcs = arguments[0];
			var myTLs:Array = [];
			var len:Number = this.mcs.length;
			var mcs:Array = this.mcs;
			var i:Number = len;
			while(--i>-1) {
				myTLs[i] = new Timeline(mcs[i]);
			}
			this.myTLs = myTLs;
		}
		if(arguments.length > 1) {
			arguments.shift();
			this.init.apply(this, arguments);
		} else {
			this.init(this.getTotalFrames());
		}
	}
	
	private function init():Void {
		if(arguments.length > 0) {
			super.init.apply(this, arguments);
			var len:Number = this.mcs.length;
			var i:Number = len;
			while(--i>-1) {
				if(this.startValue == null) {
					this.myTLs[i].setStartValue(this.startValue, true);
				} else {
					this.myTLs[i].setStartValue(this.startValue);
				}
				this.myTLs[i].setEndValue(this.endValue);
			}
		} else {
			super.init(this.getTotalFrames());
		}		
	}
	
	private function initAnimation(amount:Number, duration:Number, easing:Object, callback:String):Void {		
		if (arguments.length > 1) {		
			this.animationStyle(duration, easing, callback);
		} else {
			this.animationStyle(this.duration, this.easing, this.callback);
		}		
		if(this.mc != null) {
			this.setStartValue(this.mc._currentframe, true);
		}
		this.setEndValue(amount);
	}
	
	private function invokeAnimation(start:Number, end:Number):Void {		
		this.startInitialized = false;
		this.roundResult(true);
		
		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		this.myAnimator.end = [this.endValue];
		
		if(this.mc != null) {
			this.myAnimator.start = [this.startValue];
			this.myAnimator.setter = [[this,"gotoAndStopMCAnimator"]];
		} else {					
			this.myAnimator.multiStart = ["getCurrentFrame"];										
			this.myAnimator.multiSetter = [[this.myTLs,"gotoAndStopMCAnimator"]];
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
	* @description  Notice that this method only makes sense if Timeline is used for animating 
	* 				and not only for controling movieclip timelines. See class documentation.
	* @usage   
	* 		<pre>myInstance.run();</pre>
	* 		<pre>myInstance.run(amount);</pre>
	* 		<pre>myInstance.run(amount, duration);</pre>
	*		<pre>myInstance.run(amount, duration, callback);</pre>
	* 		<pre>myInstance.run(amount, duration, easing, callback);</pre>
	* 		<pre>myInstance.run(values, duration);</pre>
	* 		<pre>myInstance.run(values, duration, callback);</pre>
	*		<pre>myInstance.run(values, duration, easing, callback);</pre>
	* 	  
	* @param amount (Number) Targeted frames to animate to.
	* @param values (Array) optional start and end values.
	* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @param callback (String) Function to invoke after animation. See APCore class.
	* @return void
	*/
	
	/**
	* @method animate
	* @description 	similar to the run() method. Offers start and end parameters.
	* 				Notice that this method only makes sense if Timeline is used for animating 
	* 				and not only for controling movieclip timelines. See class documentation.
	* @usage   <pre>myInstance.animate(start, end);</pre> 	  
	* @param start (Number) start value. Percentage.
	* @param end (Number) end value. Percentage.
	* @return void
	*/
	
	/**
	* @method goto
	* @description 	jumps to a specific step of the animation and stays there.
	* 				Notice that this method only makes sense if Timeline is used for animating 
	* 				and not only for controling movieclip timelines. See class documentation.
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
	* 			Notice that this method only makes sense if Timeline is used for animating 
	* 			and not only for controling movieclip timelines. See class documentation.
	* 		
	* @usage   <pre>myInstance.animationStyle(duration);</pre>
	* 		<pre>myInstance.animationStyle(duration, callback);</pre>
	* 		<pre>myInstance.animationStyle(duration, easing, callback);</pre>
	* 	  
	* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @param callback (String) Function to invoke after animation. See APCore class.
	*/
	
	private function gotoAndStopMCAnimator(frame:Number):Void {	
		if(this.mc._currentframe != frame) {
			this.mc.gotoAndStop(frame);
		}
	}
	
	private function gotoAndStopMC(frame:Number):Void {	
		this.mc.gotoAndStop(frame);
		this.checkFrame();
	}	
	
	private function gotoAndPlayMC(frame:Number):Void {	
		this.mc.gotoAndPlay(frame);
		this.checkFrame();
		ImpulsDispatcher.addImpulsListener(this, "checkFrame");
	}
	
	private function playMC(Void):Void {	
		this.mc.play();
		this.checkFrame();
		ImpulsDispatcher.addImpulsListener(this, "checkFrame");
	}
	
	private function stopMC(Void):Void {	
		this.mc.stop();
		this.checkFrame();
	}
	
	private function nextFrameMC(Void):Void {	
		this.mc.nextFrame();
		this.checkFrame();
	}
	
	private function prevFrameMC(Void):Void {	
		this.mc.prevFrame();
		this.checkFrame();
	}	

	private function checkFrame(Void):Void {
		var c:Number = this.getCurrentFrame();
		if(c == this.currentValue) {
			if(c == this.getEndValue() || c == this.getStartValue()) {
				ImpulsDispatcher.removeImpulsListener(this);
				return;
			}
		}
		this.currentValue = c;
		var t:Number = this.getEndValue();
		if(c == this.getStartValue()) {
			this.tweening = true;			
			this.dispatchEvent({type:"onStart", value:c});
		} else if(c == t) {
			this.tweening = false;
			this.dispatchEvent({type:"onEnd", value:c});
		} else {
			this.dispatchEvent({type:"onUpdate", value:c});
		}
	}
	
	/**
	* @method gotoAndPlay
	* @description 	invokes gotoAndPlay on movieclip timeline(s).
	* @usage   <pre>myInstance.gotoAndPlay(frame);</pre> 	  
	* @param frame (Number)
	* @return void
	*/
	public function gotoAndPlay(frame:Number):Void {	
		if(this.mc != null) {
			this.gotoAndPlayMC(frame);
		} else {
			this.myTLs[0].addEventListener("onStart", this);
			this.myTLs[0].addEventListener("onUpdate", this);
			this.myTLs[0].addEventListener("onEnd", this);
			var len:Number = this.mcs.length;	
			var i:Number = len;
			while(--i>-1) {
				this.myTLs[i].gotoAndPlay(frame);
			}			
		}
	}
	
	/**
	* @method gotoAndStop
	* @description 	invokes gotoAndStop on movieclip timeline(s).
	* @usage   <pre>myInstance.gotoAndStop(frame);</pre> 	  
	* @param frame (Number)
	* @return void
	*/
	public function gotoAndStop(frame:Number):Void {		
		if(this.mc != null) {
			this.gotoAndStopMC(frame);
		} else {
			this.myTLs[0].addEventListener("onStart", this);
			this.myTLs[0].addEventListener("onUpdate", this);
			this.myTLs[0].addEventListener("onEnd", this);			
			var len:Number = this.mcs.length;	
			var i:Number = len;
			while(--i>-1) {
				this.myTLs[i].gotoAndStop(frame);
			}
		}
	}
	
	/**
	* @method play
	* @description 	invokes play on movieclip timeline(s).
	* @usage   <pre>myInstance.play();</pre>
	* @return void
	*/
	public function play(Void):Void {	
		if(this.mc != null) {
			this.playMC();			
		} else {
			this.myTLs[0].addEventListener("onStart", this);
			this.myTLs[0].addEventListener("onUpdate", this);
			this.myTLs[0].addEventListener("onEnd", this);
			var len:Number = this.mcs.length;	
			var i:Number = len;
			while(--i>-1) {
				this.myTLs[i].play();
			}			
		}
	}
	
	/**
	* @method nextFrame
	* @description 	invokes nextFrame on movieclip timeline(s).
	* @usage   <pre>myInstance.nextFrame();</pre>
	* @return void
	*/
	public function nextFrame(Void):Void {	
		if(this.mc != null) {
			this.nextFrameMC();
		} else {
			this.myTLs[0].addEventListener("onStart", this);
			this.myTLs[0].addEventListener("onUpdate", this);
			this.myTLs[0].addEventListener("onEnd", this);
			var len:Number = this.mcs.length;	
			var i:Number = len;
			while(--i>-1) {
				this.myTLs[i].nextFrame();
			}			
		}
	}
	
	/**
	* @method prevFrame
	* @description 	invokes prevFrame on movieclip timeline(s).
	* @usage   <pre>myInstance.prevFrame();</pre>
	* @return void
	*/
	public function prevFrame(Void):Void {	
		if(this.mc != null) {
			this.prevFrameMC();
		} else {
			this.myTLs[0].addEventListener("onStart", this);
			this.myTLs[0].addEventListener("onUpdate", this);
			this.myTLs[0].addEventListener("onEnd", this);
			var len:Number = this.mcs.length;	
			var i:Number = len;
			while(--i>-1) {
				this.myTLs[i].prevFrame();
			}			
		}
	}
	
	public function getStartFrame(Void):Number {
		return 1;
	}
	
	/**
	* @method getCurrentFrame
	* @description asked the timeline movieclip mc for its _currentframe property. In case 
	* 				an Array of movieclips was specified, only the first element will be asked.
	* @usage   <pre>myInstance.getCurrentFrame();</pre> 	  
	* @return Number, number of frames that mc contains.
	*/
	public function getCurrentFrame(Void):Number {
		if(this.mc != null) {
			return this.mc._currentframe;
		} else {					
			return this.mcs[0]._currentframe;	
		}		
	}
	
	/**
	* @method getTotalFrames
	* @description asked the timeline movieclip mc for its _totalframes property. 
	* 			 In case an Array of movieclips was specified, only the first element will be asked.
	* @usage   <pre>myInstance.getTotalFrames();</pre> 	  
	* @return Number, number of frames that mc contains.
	*/
	public function getTotalFrames(Void):Number {
		if(this.mc != null) {
			return this.mc._totalframes;
		} else {
			return this.mcs[0]._totalframes;	
		}
	}
	
	private function onStart(e:Object):Void {
		this.tweening = true;
		this.startValue = e.value;
		this.dispatchEvent({type:e.type, value:e.value});
	}
	
	private function onUpdate(e:Object):Void {
		this.currentValue = e.value;
		this.dispatchEvent({type:e.type, value:e.value});
	}
	
	private function onEnd(e:Object):Void {
		this.tweening = false;
		this.endValue = e.value;
		APCore.broadcastMessage(this.callback, this, e.value);
		this.dispatchEvent({type:e.type, value:e.value});			
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
	* @description 	stops the animation if not locked.
	* @usage   <tt>myInstance.stop();</tt> 
	* @returns <code>true</code> if instance was successfully stopped. 
	*                  <code>false</code> if instance could not be stopped, because it was locked.
	*/	
	public function stop(Void):Boolean {
		if(this.mc != null) {
			this.stopMC();
			return super.stop();
		} else {
			this.myTLs[0].addEventListener("onStart", this);
			this.myTLs[0].addEventListener("onUpdate", this);
			this.myTLs[0].addEventListener("onEnd", this);			
			var len:Number = this.mcs.length;	
			var i:Number = len;
			while(--i>-1) {
				this.myTLs[i].stop();
			}			
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
		if(this.myAnimator == null) {
			this.stop();
			return super.pause(duration);
		} else {
			return super.pause(duration);
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
		if(this.myAnimator == null) {
			this.play();
			return super.resume();
		} else {
			return super.resume();
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
	* @description 	returns the original, starting value of the current tween.
	* @usage   <tt>myInstance.getStartValue();</tt>
	* @return Number
	*/

	/**
	* @method setStartValue
	* @description 	sets the original, starting value of the current tween.
	* @usage   <tt>myInstance.setStartValue(startValue);</tt>
	* @param startValue (Number)	
	* @return Boolean, indicates if the assignment was performed.
	*/
	public function setStartValue(startValue:Number, optional:Boolean):Boolean {
		startValue = Math.round(startValue);
		if(optional != true) {
			this.mc.gotoAndStop(startValue);
		}
		return super.setStartValue(startValue, optional);		
	}
	
	/**
	* @method getEndValue
	* @description 	returns the targeted value of the current tween.
	* @usage   <tt>myInstance.getEndValue();</tt>
	* @return Number
	*/
	
	/**
	* @method setEndValue
	* @description 	sets the targeted value of the current tween.
	* @usage   <tt>myInstance.setEndValue(endValue);</tt>
	* @param endValue (Number)	
	* @return Boolean, indicates if the assignment was performed.
	*/
	public function setEndValue(endValue:Number):Boolean {
		endValue = Math.round(endValue);
		return super.setEndValue(endValue);				
	}

	/**
	* @method getCurrentValue
	* @description 	returns the current value of the current tween.
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
	public function getDurationElapsed(Void):Number {		
		if(this.myAnimator == null) {
			return this.currentValue;
		} else {
			return super.getDurationElapsed();
		}
	}	
	
	/**
	* @method getDurationRemaining
	* @description 	returns the remaining time or frames since the current tween started tweening.
	* @usage   <tt>myInstance.getDurationRemaining();</tt>
	* @return Number
	*/
	public function getDurationRemaining(Void):Number {		
		if(this.myAnimator == null) {
			return this.endValue - this.currentValue;
		} else {
			return super.getDurationRemaining();
		}
	}	
	
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
		return "Timeline";
	}
}