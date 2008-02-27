import de.alex_uhlmann.animationpackage.APCore;
import de.alex_uhlmann.animationpackage.animation.IAnimatable;
import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.IVisitor;
import de.alex_uhlmann.animationpackage.utility.IVisitorElement;
import de.alex_uhlmann.animationpackage.utility.IComposite;

/**
* @class Sequence
* @author Alex Uhlmann
* @description  Sequence allows you to animate the classes of 
* 			de.alex_uhlmann.animationpackage.animation one after the other in a uniform manner.
* 			Sequence uses the composite design pattern. [GoF]
* 			<p>
* 			Example 1: <a href="Sequence_01.html">(Example .swf)</a> Animate a sequence of animations back and forth.	
* 			<pre><blockquote> 
*			var myMoveOnQuadCurve:MoveOnQuadCurve = new MoveOnQuadCurve(mc,100,100,300,300,500,100);
*			var myScale:Scale = new Scale(mc,50,50);
*			var myRotation:Rotation = new Rotation(mc,360);
*			var myColorTransform:ColorTransform = new ColorTransform(mc,0xff0000,50);
*			
*			var mySequence:Sequence = new Sequence();
*			mySequence.setAnimateMode("EACH");
* 			mySequence.addChild(myMoveOnQuadCurve);
*			mySequence.addChild(myScale);
*			mySequence.addChild(myRotation);
*			mySequence.addChild(myColorTransform);
*			mySequence.animationStyle(4000,Circ.easeInOut,"onCallback");
*			mySequence.animate(0,100);
*			myListener.onCallback = function(source) {
*				trace("end of "+source);	
*				source.callback = "onCallback2";
*				source.animate(100,0);
*			}
*			myListener.onCallback2 = function(source) {
*				trace("end of "+source);	
*				source.callback = "onCallback";
*				source.animate(0,100);
*			}
* 			</pre></blockquote>
* 			<p> 
* 			Example 2: <a href="Sequence_02.html">(Example .swf)</a> 
* 			Animate a sequence of Move animations like a path animation back and forth.
* 			Notice that every Move will be animated separately like in the example above. The problem is with 
* 			the backward animation.
* 			<pre><blockquote> 
* 			var myMove1:Move = new Move(mc,[400,300,400,50]);
*			var myMove2:Move = new Move(mc,[400,50,150,50]);
*			var myMove3:Move = new Move(mc,[150,50,150,300]);
* 		
*			var mySequence:Sequence = new Sequence();
* 			mySequence.setAnimateMode("EACH");
*			mySequence.addChild(myMove1);
*			mySequence.addChild(myMove2);
*			mySequence.addChild(myMove3);
*			mySequence.animationStyle(2000,Circ.easeInOut,"onCallback");
*			mySequence.animate(0,100);
*
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
*			The order of Move animations doesn't seem correct for our path.<p>
* 			Example 3: <a href="Sequence_03.html">(Example .swf)</a> 
* 			Let's fix the problem with setting the animate mode to JOIN instead of 
* 			Each. Since Sequence comes by default with animate mode set to JOIN 
* 			all we have to do is simply to delete the setAnimateMode line.
* 			<pre><blockquote> 
*			var myMove1:Move = new Move(mc,[400,300,400,50]);
*			var myMove2:Move = new Move(mc,[400,50,150,50]);
*			var myMove3:Move = new Move(mc,[150,50,150,300]);
*			
* 			var mySequence:Sequence = new Sequence();	
*			mySequence.addChild(myMove1);
*			mySequence.addChild(myMove2);
*			mySequence.addChild(myMove3);
*			mySequence.animationStyle(2000,Circ.easeInOut,"onCallback");
*			mySequence.animate(0,100);
*			
*			myListener.onCallback = function(source) {
*				source.callback = "onCallback2";
*				source.animate(100,0);
*			}
*			myListener.onCallback2 = function(source) {
*				source.callback = "onCallback";
*				source.animate(0,100);
*			}
* 			</pre></blockquote>
* 			Example 4: <a href="Sequence_04.html">(Example .swf)</a> 
* 			Notice that in the example above our easing equation is applied to every child each. 
* 			To let the Move animations behave more like a path animation we need to set the easing mode 
* 			to JOIN.
* 			<pre><blockquote> 
*			var myMove1:Move = new Move(mc,[400,300,400,50]);
*			var myMove2:Move = new Move(mc,[400,50,150,50]);
*			var myMove3:Move = new Move(mc,[150,50,150,300]);
*			
*			var mySequence:Sequence = new Sequence();
*			mySequence.addChild(myMove1);
*			mySequence.addChild(myMove2);
*			mySequence.addChild(myMove3);
* 			mySequence.setEasingMode("JOIN");	
*			mySequence.animationStyle(2000,Circ.easeInOut,"onCallback");
*			mySequence.animate(0,100);
*			
*			myListener.onCallback = function(source) {
*				source.callback = "onCallback2";
*				source.animate(100,0);
*			}
*			myListener.onCallback2 = function(source) {
*				source.callback = "onCallback";
*				source.animate(0,100);
*			}
* 			</pre></blockquote> 			
* 			Reader exercise: create a smoother path animation with MoveOnQuadCurve, MoveOnCubicCurve 
* 			and/or MoveOnCurve. And, take a look into MoveOnPath for another approach to 
* 			create path animations using Ivan Dembicki's com.sharedfonts.Path class.
* 			<p>
*			Example 5: <a href="Sequence_05.html">(Example .swf)</a> Animate a sequence back and 
* 			forth and attaches a Trail animation on a certain part of the sequence. The Text class helps to 
* 			log all the updates of the sequence. Notice the usage of Sequence.getCurrentValue and the 
* 			specific properties of the eventObject returned by EventDispatcher. There are getter methods 
* 			of the Sequence class that also offer the information returned by the eventObject.
* 			<pre><blockquote>
*			var myStar:Star = new Star(275,200,60,15,6);
*			myStar.lineStyle();
*			myStar.fillStyle(0x9C3031);
*			myStar.draw()
*			var mc:MovieClip = myStar.movieclip;
*			
*			var myMoveOnQuadCurve:MoveOnQuadCurve = new MoveOnQuadCurve(mc,300,100,400,300,580,100);
*			var myScale:Scale = new Scale(mc,50,50);
*			var myRotation:Rotation = new Rotation(mc,360);
*			var myColorTransform:ColorTransform = new ColorTransform(mc,0x8CA6BD,0);
*			
*			var myText:Text = new Text();
*			
*			function onStart(eventObject:Object) {
*				this.setText(eventObject);
*			}
*			
*			function onUpdate(eventObject:Object) {
*				this.setText(eventObject);
*				//if the next child of the Sequence is an instance of Rotation, attach the Trail 
*				//for the duration of the Rotation instance.
*				if(eventObject.nextChild instanceof Rotation) {
*					var myTrail:Trail = new Trail(mc);
*					myTrail.attach(250,40,eventObject.childDuration);
*				}
*			}
*			
*			function setText(eventObject:Object) {
*				var myTextfield:TextField = myText.getText();
*				if(myTextfield == null) {
*					myText.setText(eventObject.nextChild+" is at no. "
* 						+mySequence.getCurrentValue()+" in your "+mySequence);
*				} else {
*					if(myTextfield.textHeight < Stage.height-10) {
*						myText.addText("\n"+eventObject.nextChild+" is at no. "
*									+mySequence.getCurrentValue()+" in your "+mySequence);
*					} else {			
*						myText.movieclip.removeMovieClip();
*					}		
*				}
*			}
*			
*			//Note that myText and mySequence will be visible inside the onUpdate, onStart 
*			//and setText functions (closure).
*			var mySequence:Sequence = new Sequence();
*			mySequence.addEventListener("onStart",this);
*			mySequence.addEventListener("onUpdate",this);
*			mySequence.addChild(myMoveOnQuadCurve);
*			mySequence.addChild(myScale);
*			mySequence.addChild(myRotation);
*			mySequence.addChild(myColorTransform);
*			mySequence.animationStyle(6000,Circ.easeInOut,"onCallback");
*			mySequence.animate(0,100);
*			
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
* 			
* @usage <tt>var mySequence:Sequence = new Sequence();</tt>
*/
class de.alex_uhlmann.animationpackage.animation.Sequence 
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
	public static var JOIN:String = "JOIN";
	public static var EACH:String = "EACH";
	private var childsArr:Array;
	private var start:Number;
	private var end:Number;
	private var currentChild:Object;
	private var childDuration:Number;
	private var position:Number = 1;
	private var animateMode:String = "JOIN";
	private var easingMode:String = "EACH";
	private var easingClass:String;
	private var firstEasingMeth:String;
	private var lastEasingMeth:String;
	private var roundedPosStart:Number;
	private var roundedPosEnd:Number;
	private var percentages:Array;
	private var backwards:Boolean = false;
	private var elapsedDuration:Number = 0;
	private var sequenceArr:Array;
	
	public function Sequence() {		
		super();
		this.childsArr = new Array();
		this.sequenceArr = new Array();
	}
	
	/**
	* @method animate
	* @description 	animates the contents of the composite.
	* @usage   <pre>mySequence.animate(start, end);</pre> 	  
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
	
	private function invokeAnimation(start:Number, end:Number) {
		var goto:Boolean;
		var percentage:Number;
		if(end == null) {
			goto = true;
			percentage = end = start;
			start = 0;			
		} else {
			goto = false;
			this.start = start;
			this.end = end;
			this.tweening = true;
		}
		
		var i:Number, len:Number = this.childsArr.length;		
		var fChild:Object;
		
		var posStart:Number = start / 100 * len;
		var posEnd:Number = end / 100 * len;
			
		this.setStartValue(posStart);
		this.setEndValue(posEnd);
		
		
		if(this.animateMode == "JOIN") {			

			if(!goto) {
			
				var details:Object = this.getAnimateDetails(start, end, this.childsArr, this);
				this.backwards = details.backwards;
				this.position = details.position;			
				var roundedPosStart:Number = details.roundedPosStart;
				var roundedPosEnd:Number = details.roundedPosEnd;
				this.percentages = details.percentages;			
				
				if(this.easingMode == "JOIN") {				
					
					var dividedDuration:Number = this.childDuration = this.duration / len;
					if(this.childsArr[roundedPosStart] instanceof Sequence) {
						this.childsArr[roundedPosStart].animationStyle(dividedDuration, _global.com.robertpenner.easing[this.easingClass][this.firstEasingMeth]);
					} else {
						this.childsArr[roundedPosStart].easing = _global.com.robertpenner.easing[this.easingClass][this.firstEasingMeth];
					}
					if(this.childsArr[roundedPosEnd] instanceof Sequence) {
						this.childsArr[roundedPosEnd].animationStyle(dividedDuration, _global.com.robertpenner.easing[this.easingClass][this.lastEasingMeth]);
					} else {
						this.childsArr[roundedPosEnd].easing = _global.com.robertpenner.easing[this.easingClass][this.lastEasingMeth];
					}
				}
			
				fChild = this.currentChild = this.childsArr[roundedPosStart];
				fChild.animate(this.percentages[this.position-1].start, 
								this.percentages[this.position-1].end);	
									
			} else {
				
				if(percentage < 0) {
					this.invokeAnimation(0);
					return;
				} else if(percentage > 100) {
					this.invokeAnimation(100);
					return;
				}
				var posPerc:Number = percentage / 100 * (len);
				var roundedPosPerc:Number = Math.floor(posPerc);
				var perc_loc:Number = (posPerc - roundedPosPerc) * 100;
				this.position = roundedPosPerc + 1;
				this.currentChild = this.childsArr[roundedPosPerc];
				
				for (i = 0; i < len; i++) {
					var child:Object = this.childsArr[i];
					if(i < roundedPosPerc) {
						child.goto(100);
					} else {
						child.goto(0);
					}
				}
				
				this.childsArr[roundedPosPerc].goto(perc_loc);
				
				if(percentage == 0) {
					this.dispatchEvent({type:"onStart", 
									value:this.getStartValue(),
									childDuration:this.childDuration});
				} else if(percentage == 100) {
					this.dispatchEvent({type:"onEnd", 
									value:this.getEndValue(), 
									childDuration:this.childDuration});
				} else {
					this.dispatchEvent({type:"onUpdate", 
									value:this.getCurrentValue(), 
									childDuration:this.childDuration});		
				}
			}
			
		} else {			
			
			this.percentages = new Array();
			this.position = 1;
			for (i = 0; i < len; i++) {
				var child:Object = this.childsArr[i];
				this.sequenceArr.push(this.childsArr[i+1]);
				child.addEventListener("onUpdate", this);
				child.addEventListener("onEnd", this);
				this.percentages[i] = {start:start, end:end};
			}		
			fChild = this.currentChild = this.childsArr[0];			
			if(goto == false) {
				if(start > end) {
					this.backwards = true;				
				} else {
					this.backwards = false;
				}				
				fChild.animate(start, end);
			} else {			
				fChild.goto(percentage);
			}
		}
		if(!goto) {
			this.childDuration = fChild.duration;
			this.elapsedDuration = 0;
			this.dispatchEvent.apply(this, [ {type:"onStart",
											value:this.getStartValue(),
											nextChild:fChild, 
											lastChild:null, 
											childDuration:this.childDuration} ]);
		}
	}

	private function getAnimateDetails(start:Number, 
									end:Number, 
									childsArr:Array, 
									ref:Object):Object {
		
		var backwards:Boolean;
		if(start > end) {
			backwards = true;				
		} else {
			backwards = false;
		}
		/*			
		* To compute start and end values for all childs combined, 
		* I first compute the childs where the tween will start and end. (rule of three)
		* The integer part of the number posStart and posEnd represents that.
		* The fractional part of those numbers represent the percentage to be animated in integer child.
		*/
		var i:Number, len:Number = this.childsArr.length;
		var posStart:Number = start / 100 * (len);
		var posEnd:Number = end / 100 * (len);
		
		var roundedPosStart:Number = Math.floor(posStart);
		var roundedPosEnd:Number = Math.floor(posEnd);			
		var start_loc:Number;
		if(posStart > roundedPosStart) {				
			start_loc = (posStart - roundedPosStart) * 100;					
		} else {
			if(backwards) {
				roundedPosStart--;
				start_loc = 100;
			} else {					
				start_loc = 0;
			}
		}			
		var end_loc:Number;
		if(posEnd > roundedPosEnd) {				
			end_loc = (posEnd - roundedPosEnd) * 100;					
		} else {				
			if(backwards) {
				end_loc = 0;
			} else {
				roundedPosEnd--;
				end_loc = 100;
			}
		}
		
		this.position = roundedPosStart+1;
		

		//apply animate state to all children.			
		for (i = 0; i < len; i++) {
			var child:Object = this.childsArr[i];			
			child.omitEvent = true;
			if(backwards) {
				if(i > roundedPosStart) {
					child.goto(0);
				} else {
					child.goto(100);
				}
			}
			child.omitEvent = false;
		}		
		for (i = len-1; i > -1; i--) {
			var child:Object = this.childsArr[i];
			child.omitEvent = true;
			if(!backwards) {
				if(i < roundedPosStart) {
					child.goto(100);
				} else {
					child.goto(0);
				}
			}
			child.omitEvent = false;
			child.addEventListener("onUpdate", this);
		}

		
		//reset succossors.
		this.sequenceArr = new Array();
		
		var percentages:Array = new Array();
		var child:Object;
		//for forward tweening
		for (i = roundedPosStart; i < roundedPosEnd; i++) {
			child = childsArr[i];
			this.sequenceArr.push(this.childsArr[i+1]);
			child.addEventListener("onEnd", ref);
			if(i == roundedPosStart) {
				percentages[i] = {start:start_loc, end:100};
			} else {
				percentages[i] = {start:0, end:100};
			}
		}
		//for backward tweening
		for (i = roundedPosStart; i > roundedPosEnd; i--) {
			child = childsArr[i];
			this.sequenceArr.push(this.childsArr[i-1]);
			child.addEventListener("onEnd", ref);
			if(i == roundedPosStart) {
				percentages[i] = {start:start_loc, end:0};
			} else {
				percentages[i] = {start:100, end:0};
			}
		}
		child = childsArr[roundedPosEnd];
		child.addEventListener("onEnd", ref);
		if(backwards) {
			percentages[roundedPosEnd] = {start:100, end:end_loc};
		} else {
			percentages[roundedPosEnd] = {start:0, end:end_loc};
		}
		
		var details = new Object();
		details.backwards = backwards;
		details.position = roundedPosStart+1;
		details.roundedPosStart = roundedPosStart;
		details.roundedPosEnd = roundedPosEnd;		
		details.percentages = percentages;		
		return details;
	}
	
	public function onStart(eventObject:Object):Void {		
		this.dispatchEvent({type:"onStart", 
							value:this.getStartValue(),
							childDuration:this.childDuration});
	}	
	
	public function onUpdate(eventObject:Object):Void {	
		this.dispatchEvent({type:"onUpdate", 
							value:this.getCurrentValue(), 
							childDuration:this.childDuration});
	}
	
	public function onEnd(eventObj:Object):Void {
		
		eventObj.target.removeEventListener("onEnd", this);
		var successor:Object = this.sequenceArr.shift();
		this.childDuration = successor.duration;
		if(successor == null) {
			this.tweening = false;
			APCore.broadcastMessage(this.callback, this);			
			this.dispatchEvent.apply(this, [ {type:"onEnd",
											value:this.getEndValue(),
											nextChild:null, 
											lastChild:eventObj.target, 
											childDuration:null} ]);

		} else {
			/*backwards will only be true in Sequence mode JOIN*/
			if(this.animateMode == Sequence.JOIN && this.backwards) {
				this.position--;
			} else {
				this.position++;
			}
			this.elapsedDuration += eventObj.target.getDurationElapsed();
			this.currentChild = successor;			
			this.dispatchEvent.apply(this, [ {type:"onUpdatePosition",
											value:this.getCurrentValue(),
											nextChild:successor, 
											lastChild:eventObj.target, 
											childDuration:this.childDuration} ]);			

			successor["animate"].apply(successor, [this.percentages[this.position-1].start, 
												this.percentages[this.position-1].end]);
		}		
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
	* @description 	set the animation style properties for your animation. Overwrites animationStyle settings from childs.
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
	* @usage   <pre>mySequence.animationStyle(duration);</pre>
	* 		<pre>mySequence.animationStyle(duration, callback);</pre>
	* 		<pre>mySequence.animationStyle(duration, easing, callback);</pre>
	* 	  
	* @param duration (Number) Duration of animation(s) in milliseconds or frames. Default is milliseconds.
	* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @param callback (String) Function to invoke after animation(s). See APCore class.
	*/
	public function animationStyle(duration:Number, easing:Object, callback:String):Void {
		super.animationStyle(duration, easing, callback);
		var i, len:Number = this.childsArr.length;
		var dividedDuration:Number = this.childDuration = duration / len;
		if(this.animateMode == "JOIN") {
			var fChild:Object = this.childsArr[0];		
			fChild.animationStyle(dividedDuration, easing);		
			var firstEasing:String;
			var lastEasing:String;
			var oneClass:Function;
			var meth:String;
			var func:Function;
			var classes = eval("com.robertpenner.easing");
			var c:String;
			var myC:String, myMeth:String;
			for(c in classes) {				
				oneClass = _global.com.robertpenner.easing[c]; 
				for(meth in oneClass) {					
					func = oneClass[meth];
					if(func == fChild.easing) {						
						myC = c;
						myMeth = meth;					
						if(meth == "easeIn") {
							firstEasing = "easeIn";
							lastEasing = "easeNone"; 
						} else if(meth == "easeOut") {
							firstEasing = "easeNone";
							lastEasing = "easeOut"; 						
						} else if(meth == "easeInOut") {
							firstEasing = "easeIn";
							lastEasing = "easeOut"; 					
						} else if(meth == "easeNone") {
							firstEasing = "easeNone";
							lastEasing = "easeNone"; 						
						}
						break;
					}
				}
			}		
			if(this.easingMode == "JOIN") {
				for (i = 0; i < len; i++) {
					this.childsArr[i].animationStyle(dividedDuration, 
							_global.com.robertpenner.easing.Linear.easeNone);
				}
			} else {
				for (i = 0; i < len; i++) {
					this.childsArr[i].animationStyle(dividedDuration, easing);					
				}
			}
			this.firstEasingMeth = firstEasing;
			this.lastEasingMeth = lastEasing;
			this.easingClass = myC;		
			
		} else {
			for (i = 0; i < len; i++) {
				this.childsArr[i].animationStyle(dividedDuration, easing);
			}
		}
		this.callback = callback;
	}

	/**
	* @method setAnimateMode
	* @description 	sets the animate mode. If JOIN, the start and end percentage 
	* 				parameters influences the composite animation as a whole. Defaults to JOIN. 
	* 				See class documentation.
	* @usage   <tt>myInstance.setAnimateMode();</tt>
	* @param animateMode (String) Either EACH or JOIN.
	* @return Boolean, indicates if the assignment was performed.
	*/
	public function setAnimateMode(animateMode:String):Boolean {
		if(animateMode == "EACH" || animateMode == "JOIN") {	
			this.animateMode = animateMode;
		} else {
			return false;
		}
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			var child:Object = this.childsArr[i];
			if(child instanceof Sequence) {
				child.setAnimateMode(animateMode);
			}
		}
		return true;	
	}
	
	/**
	* @method getAnimateMode
	* @description 	returns the current animate mode.
	* @usage   <tt>myInstance.getAnimateMode();</tt>
	* @return String
	*/
	public function getAnimateMode(Void):String {
		return this.animateMode;
	}
	
	/**
	* @method setEasingMode
	* @description 	sets the easing mode. If EACH, each child will be animated separately.
	* 				If JOIN the childs seem to share one easing equation. Defaults to EACH.
	* @usage   <tt>myInstance.setEasingMode();</tt>
	* @param easingMode (String) Either EACH or JOIN.
	* @return Boolean, indicates if the assignment was performed.
	*/
	public function setEasingMode(easingMode:String):Boolean {
		if(easingMode == "EACH" || easingMode == "JOIN") {	
			this.easingMode = easingMode;
		} else {
			return false;
		}
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			var child:Object = this.childsArr[i];			
			if(child instanceof Sequence) {
				child.setEasingMode(easingMode);
			}
		}
		return true;
	}
	
	/**
	* @method getEasingMode
	* @description 	returns the current easing mode.
	* @usage   <tt>myInstance.getEasingMode();</tt>
	* @return String
	*/
	public function getEasingMode(Void):String {
		return this.easingMode;
	}
	
	/**
	* @method getChild
	* @description 	returns the current child of the sequence.
	* @usage   <tt>myInstance.getChild();</tt>
	* @return IAnimatable
	*/	
	public function getChild(Void):IAnimatable {		
		return IAnimatable(this.currentChild);
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
	* @method getNextChild
	* @description 	returns the next child of the sequence.
	* @usage   <tt>myInstance.getNextChild();</tt>
	* @return IAnimatable
	*/	
	public function getNextChild(Void):IAnimatable {
		if(this.animateMode == "JOIN" && this.backwards) {
			return IAnimatable(this.childsArr[this.position-2]);
		} else {
			return IAnimatable(this.childsArr[this.position]);
		}
	}
	
	/**
	* @method getPreviousChild
	* @description 	returns the previous child of the sequence.
	* @usage   <tt>myInstance.getPreviousChild();</tt>
	* @return IAnimatable
	*/	
	public function getPreviousChild(Void):IAnimatable {		
		if(this.animateMode == "JOIN" && this.backwards) {
			if(this.position-1 == this.childsArr.length) {
				return IAnimatable(this.childsArr[this.position-1]);
			} else {
				return IAnimatable(this.childsArr[this.position]);
			}			
		} else {
			return IAnimatable(this.childsArr[this.position-2]);
		}
	}
	
	/**
	* @method getChildDuration
	* @description 	returns the duration of the currently animated child in constrast to the duration property, 
	* 				which is the duration of the whole Sequence.  
	* @usage   <tt>myInstance.getChildDuration();</tt>
	* @return Number
	*/
	public function getChildDuration(Void):Object {		
		return this.childDuration;
	}

	/**
	* @method addChild
	* @description 	adds a primitive or composite to the composite instance of Sequence 
	* See class description.
	* @usage  <pre>mySequence.addChild(component);</pre>
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
	* @description 	removes a primitive or composite from the composite instance of Sequence 
	* See class description.
	* @usage  <pre>mySequence.removeChild(component);</pre>
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
	* @method roundResult
	* @description 	rounds animation results to integers. (might be usefull for animating pixelfonts). Default is false.		
	* @usage   <pre>myInstance.roundResult(rounded);</pre>
	* @param rounded (Boolean) <code>true</code> rounds the result. Animates with integers. Less accuracy. <code>false</code> animates with floating point numbers.
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
	
	/*inherited from AnimationCore*/
	/**
	* @method stop
	* @description 	stops the animation if not locked..
	* @usage   <tt>myInstance.stop();</tt> 
	* @returns <code>true</code> if instance was successfully stopped. 
	*                  <code>false</code> if instance could not be stopped, because it was locked.
	*/
	public function stop(Void):Boolean {		
		var success:Boolean = this.getChild().stop();
		if(success) {
			this.tweening = false;
			this.paused = false;
			this.dispatchEvent.apply(this, [ {type:"onEnd", 
										nextChild:null, 
										lastChild:this.getChild(), 
										childDuration:null} ]);
		}
		return success;
	}	
	
	/**
	* @method pause
	* @description 	pauses the animation if not locked. Call resume() to continue animation.
	* @usage   <tt>myInstance.pause(duration);</tt> 	  
	* @param duration (Number) optional property. Number of milliseconds or frames to pause before continuing animation.
	* @returns <code>true</code> if instance was successfully paused. 
	*                  <code>false</code> if instance could not be paused, because it was locked.
	*/
	public function pause(duration:Number):Boolean {		
		var success:Boolean = this.getChild().pause(duration);
		if(success) {
			this.tweening = false;
			this.paused = true;
		}
		return success;		
	}	
	
	/**
	* @method resume
	* @description 	continues the animation if not locked. 
	* @usage   <tt>myInstance.resume();</tt> 	
	* @returns <code>true</code> if instance was successfully resumed. 
	*                  <code>false</code> if instance could not be resumed, because it was locked.
	*/
	public function resume(Void):Boolean {	
		var success:Boolean = this.getChild().resume();
		if(success) {
			this.tweening = true;
			this.paused = false;
		}
		return success;
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
	* @description 	returns the original, starting value of the current tween. First position of sequence. Always zero.
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
	* @description 	returns the targeted value of the current tween. first position of sequence. 
	* 				Last position of sequence. Number of childs added to the sequence.
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
	* @description 	returns the current value of the current tween. Current position of sequence.
	* @usage   <tt>myInstance.getCurrentValue();</tt>
	* @return Number
	*/
	public function getCurrentValue(Void):Number {
		return this.position;
	}
	
	/**
	* @method getCurrentPercentage
	* @description 	returns the current state of the animation in percentage. 
	* 				Especially usefull in combination with goto().
	* @usage   <tt>myInstance.getCurrentPercentage();</tt>
	* @return Number
	*/
	public function getCurrentPercentage(Void):Number {
		var pos:Number = this.getCurrentValue()-1;
		var perc:Number = this.currentChild.getCurrentPercentage();
		if(typeof(perc) != "number" || isNaN(perc)) {
			perc = 0;			
		}
		if(this.animateMode == Sequence.EACH && this.backwards == true) {
			pos = this.getEndValue() - (pos - (this.getStartValue() - 1));
		}
		var currentValue:Number = pos + perc / 100;
		var currentPerc:Number = currentValue / (this.childsArr.length) * 100;		
		return currentPerc;			
	}
	
	/**
	* @method getDurationElapsed
	* @description 	returns the elapsed time or frames since the current tween started tweening.
	* @usage   <tt>myInstance.getDurationElapsed();</tt>
	* @return Number
	*/
	public function getDurationElapsed(Void):Number {
		return this.elapsedDuration + this.currentChild.getDurationElapsed();
	}
	
	/**
	* @method getDurationRemaining
	* @description 	returns the remaining time or frames since the current tween started tweening.
	* @usage   <tt>myInstance.getDurationRemaining();</tt>
	* @return Number
	*/
	public function getDurationRemaining(Void):Number {
		return this.duration - this.getDurationElapsed();
	}
	
	/*inherited from APCore*/
	/**
	* @method addEventListener
	* @description 	Subscribe to a predefined event. The following standard EventDispatcher events are broadcasted<p>
	* 			<b>onStart</b>, broadcasted when sequence starts.<br>
	* 			<b>onUpdate</b>, broadcasted when a Sequence's child updates.<br>
	*			<b>onUpdatePosition</b>, broadcasted when sequence animates a new child.<br>
	* 			<b>onEnd</b>, broadcasted when sequence ends.<p>
	* 			The even object returned, contains the following properties:<p>
	* 			<b>type</b> (String) event broadcasted.<br>
	*			<b>target</b> (Sequence) event source.<br>
	*			<b>value</b> (Sequence) current position of Sequence. First child is 1.<br> 
	* 			<b>nextChild</b> (IAnimatable) next child in sequence to be animated.<br>
	* 			<b>lastChild</b> (IAnimatable) last child in sequence that has been animated.<br>
	* 			<b>childDuration</b> (Number) duration of every single child.<br>
	* 		
	* @usage   <pre>mySequence.addEventListener(event, listener);</pre>
	* 		    <pre>mySequence.addEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>mySequence.removeEventListener(event, listener);</pre>
	* 		    <pre>mySequence.removeEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>mySequence.removeAllEventListeners();</pre>
	* 		    <pre>mySequence.removeAllEventListeners(event);</pre>
	* 	  
	*@param event (String) Event to remove all subscribed listeners from. If not specified, all listeners to any event will be removed.
	*/
	
	/*inherited from APCore*/
	/**
	* @method eventListenerExists
	* @description 	GDispatcher specific feature. Checks if a listener is already subscribed to a certain event.
	* 		
	* @usage   <pre>mySequence.eventListenerExists(event, listener);</pre>
	* 			<pre>mySequence.eventListenerExists(event, listener, handler);</pre>
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
		return "Sequence";
	}
}