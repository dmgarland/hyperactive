import de.alex_uhlmann.animationpackage.APCore;
import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.drawing.IOutline;
import de.alex_uhlmann.animationpackage.drawing.Shape;
import de.alex_uhlmann.animationpackage.drawing.Line;
import de.alex_uhlmann.animationpackage.drawing.DashLine;
import de.alex_uhlmann.animationpackage.utility.IVisitor;
import de.alex_uhlmann.animationpackage.utility.IVisitorElement;
import de.alex_uhlmann.animationpackage.utility.IComposite;

/**
* @class Drawer
* @author Alex Uhlmann
* @description
* 			 Drawer allows to draw and animate arbitrary shapes/lines and can also
* 			treat the outline and fill separately.
* 			Drawer uses the composite design pattern. [GoF]
* 			There are two different approaches using Drawer:
* 			</p>
* 			For most use cases the drawBy/animateBy approach will 
* 			probably work for you. It is also the most optimized approach. Behind the 
* 			scences Drawer shares a single movieclip for all children that 
* 			each represent one outline and another 
* 			movieclip for the fill. Since all children share a single movieclip 
* 			the Flash Player connects the different outlines.
* 			</p>
* 			Example 1: <a href="Drawer_03.html">(Example .swf)</a> Draw a consistent, filled shape.
* 			<blockquote><pre>
*			var part1:Line = new Line(100,100,200,100);
*			var part2:CubicCurve = new CubicCurve(200,100,250,50,300,150,350,100);
*			var part3:QuadCurve = new QuadCurve(350,100,400,250,300,400);
*			var part4:Line = new Line(300,400,90,350,1,8);
*			var part5:Line = new Line(90,350,100,100);
*			
*			var myDraw_mc:MovieClip = this.createEmptyMovieClip("draw_mc",999);
*			var myDrawer:Drawer = new Drawer(myDraw_mc);
*			
*			myDrawer.addChild(part1);
*			myDrawer.addChild(part2);
*			myDrawer.addChild(part3);
*			myDrawer.addChild(part4);
*			myDrawer.addChild(part5);
*			
*			myDrawer.lineStyle(5,0x000000,50);
*			myDrawer.drawBy();
*			myDrawer.fillStyle(0xff0000,50);
*			myDrawer.fill();
*			</pre></blockquote>
* 			</p>
* 			For a much better example, check out  
* 			<a href="http://www.flash-creations.com/notes/sample_svgtoflash.php">Helen Triolo's usage of Drawer</a>
* 			 to animate an SVG file at runtime.
* 			</p>
* 			For some use cases, however you might want to treat outline styles separately. 
* 			Here, for each child representing an outline, 
* 			a new movieclip is created and individual lineStyle 
* 			properties are applied. To use the draw/animate approach:
* 			</p>
* 			Example 2: <a href="Drawer_01.html">(Example .swf)</a> Drawing a filled shape.
* 			<blockquote><pre>
*			var part1:DashLine = new DashLine(100,100,200,100);
*			part1.lineStyle(2,0x000000,50);
*			var part2:CubicCurve = new CubicCurve(200,100,250,50,300,150,350,100);
*			part2.lineStyle(1,0xff0000,100);
*			var part3:QuadCurve = new QuadCurve(350,100,400,250,300,400);
*			part3.lineThickness = 4;
*			var part4:DashLine = new DashLine(300,400,90,350,1,8);
*			part4.lineStyle(6,0x0000ff,100);
*			var part5:Line = new Line(90,350,100,100);
*			part5.lineStyle(6,0x00ff00);
*			
*			var myDraw_mc:MovieClip = this.createEmptyMovieClip("draw_mc",999);
*			var myDrawer:Drawer = new Drawer(myDraw_mc);
*			myDrawer.addChild(part1);
*			myDrawer.addChild(part2);
*			myDrawer.addChild(part3);
*			myDrawer.addChild(part4);
*			myDrawer.addChild(part5);
*			
*			myDrawer.draw();
*			myDrawer.fillStyle(0xff0000,50);
*			myDrawer.fill();
*			</pre></blockquote>
* 			</p>
* 			Note, that you could also have used the DashLine class 
* 			in the drawBy/animateBy approach. If you do, Drawer will create 
* 			a new movieclip for DashLine and the Flash Player will not be able 
* 			to connect this outline with other surrounding outlines. 
* 			</p>
* 			Example 3: <a href="Drawer_02.html">(Example .swf)</a> Animating a filled shape.
* 			<blockquote><pre>
*			AnimationCore.duration_def = 500;
*			AnimationCore.easing_def = Circ.easeInOut;
*			
*			var part1:DashLine = new DashLine(100,100,200,100);
*			part1.lineStyle(2,0x000000,50);
*			part1.animationStyle(1000,Sine.easeIn);
*			var part2:CubicCurve = new CubicCurve(200,100,250,50,300,150,350,100);
*			part2.lineStyle(1,0xff0000,100);
*			var part3:QuadCurve = new QuadCurve(350,100,400,250,300,400);
*			part3.lineThickness = 4;
*			var part4:DashLine = new DashLine(300,400,90,350,1,8);
*			part4.lineStyle(6,0x0000ff,100);
*			var part5:Line = new Line(90,350,100,100);
*			part5.lineStyle(6,0x00ff00);
*			part5.animationStyle(1000,Bounce.easeOut);
*			
*			var myDraw_mc:MovieClip = this.createEmptyMovieClip("draw_mc",999);
*			var myDrawer:Drawer = new Drawer(myDraw_mc);
*			myDrawer.addChild(part1);
*			myDrawer.addChild(part2);
*			myDrawer.addChild(part3);
*			myDrawer.addChild(part4);
*			myDrawer.addChild(part5);
*			
*			myDrawer.addEventListener("onEnd",this,"fillShape");
*			myDrawer.animate(0,100);
*			
*			function fillShape(eventObject:Object) {
*				myDrawer.fillStyle(0xff0000,50);
*				myDrawer.fill();
*				myDrawer.fillMovieclip._alpha = 0;
*				new Alpha(myDrawer.fillMovieclip).run(100,1000);
*				new ColorTransform(myDrawer.lineMovieclip).run(0xffff00,0,3000,Quad.easeOut);
*			}
*			</pre></blockquote> 
* 			<p>For another example take a look at example no. 2 from the Animator class. 
* 
* @usage    <pre>var myDrawer:Drawer = new Drawer();</pre> 
* 		<pre>var myDrawer:Drawer = new Drawer(mc);</pre>
* 
* @param mc (MovieClip) Movieclip container that will be used for drawing.
*/
class de.alex_uhlmann.animationpackage.drawing.Drawer 
											extends Shape 
											implements ISingleAnimatable, 
													IOutline, 
													IVisitorElement, 
													IComposite {	

	/*static default properties*/
	/*lineStyle properties inherited from Shape*/
	/*fillStyle properties inherited from Shape*/
	/** 
	* @property movieclip (MovieClip) Movieclip that contains the drawing.
	* @property lineMovieclip (MovieClip) Movieclip that contains all outlines.
	* @property fillMovieclip (MovieClip) Movieclip that contains the fill.
	* @property lineThickness (Number) Outline thickness.
	* @property lineRGB (Number) Outline color of the drawing as hex number.
	* @property lineAlpha (Number) Outline transparency (alpha).
	* @property fillRGB (Number) Fill color of the drawing.
	* @property fillAlpha (Number) Fill transparency.
	*/	
	private var childsArr:Array;
	private var start:Number;
	private var end:Number;	
	private var firstChild:Object;
	private var currentChild:Object;
	private var childDuration:Number;
	private var position:Number = 0;
	private var animateMode:String = "JOIN";
	private var percentages:Array;
	private var backwards:Boolean = false;
	private var sequenceArr:Array;
	private var redraw:Boolean = true;	
	private var areMovieclipsInjected:Boolean = false;
	private var m_lineMovieclip:MovieClip;
	private var m_fillMovieclip:MovieClip;	
	
	public function Drawer() {			
		super();		
		if(typeof(arguments[0]) == "movieclip") {					
			this.mc = arguments[0];
		} else {	
			this.mc = this.createClip({name:"apDraw", x:0, y:0});
		}
		this.childsArr = new Array();
		this.sequenceArr = new Array();
		super.lineStyle(null);
		this.fillStyle(null);	
	}

	/**
	* @method draw
	* @description 	Draws the contents of the composite.
	* @usage <pre>myInstance.draw();</pre>
	*/
	public function draw(Void):Void {
		this.redraw = true;
		
		this.initLineMovieclip();
		this.injectNewMovieclipsToChilds();
		
		this.firstChild = this.childsArr[0];
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			var child:Object = this.childsArr[i];
			if(child instanceof Drawer) {				
				child.draw();
			} else {
				this.lineMovieclip.clear();
				this.fillMovieclip.clear();					
				child.draw();
			}			
		}
	}
	
	
	/**
	* @method drawBy
	* @description 	Draws the contents of the composite. 
	* @usage <pre>myInstance.drawBy();</pre>
	*/	
	public function drawBy(Void):Void {	
		this.redraw = false;
		
		this.initLineMovieclip();		 	
		this.injectSingleMovieclipToChilds();
	
		this.lineMovieclip.lineStyle(this.lineThickness, 
									this.lineRGB, 
									this.lineAlpha);

		
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			var child:Object = this.childsArr[i];
			if(child instanceof Drawer) {				
				child.drawBy();
			} else {
				if(this.firstChild == null) {
					this.firstChild = child;
					this.lineMovieclip.moveTo(child.getX1(), child.getY1());
				}
				child.reset();
				child.drawTo();
			}	
		}
		this.firstChild = null;
	}
	
	public function invokeAnimation(start:Number, end:Number):Void {		
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

		if(this.initialized == false) {
			this.initLineMovieclip();
			if(this.redraw) {				
				this.injectNewMovieclipsToChilds();
			} else {			 	
				this.injectSingleMovieclipToChilds();
				this.lineMovieclip.lineStyle(this.lineThickness, 
											this.lineRGB, 
											this.lineAlpha);
			}
			this.initialized = true;
		} else {
			if(this.redraw) {				
				this.fillMovieclip.clear();
			} else {
				this.lineMovieclip.clear();
				this.fillMovieclip.clear();			
				this.lineMovieclip.lineStyle(this.lineThickness, 
											this.lineRGB, 
											this.lineAlpha);				
			}
		}
		
		if(this.animateMode == "JOIN") {		
		
			if(!goto) {
				var details:Object = this.getAnimateDetails(start, end, this.childsArr, this);
				this.backwards = details.backwards;
				this.position = details.position;			
				var roundedPosStart:Number = details.roundedPosStart;
				var roundedPosEnd:Number = details.roundedPosEnd;
				this.percentages = details.percentages;				
				
				fChild = this.currentChild = this.childsArr[roundedPosStart];
				this.firstChild = fChild;
				if(this.redraw) {
					fChild.movieclip.clear();
					fChild.initControlPoints();
					fChild.setInitialized(true);
					fChild.animate(this.percentages[this.position-1].start, this.percentages[this.position-1].end);
				} else {
					this.lineMovieclip.moveTo(fChild.getX1(), fChild.getY1());
					fChild.initControlPoints();
					fChild.setInitialized(true);					
					fChild.animateTo(this.percentages[this.position-1].start, this.percentages[this.position-1].end);
				}

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
				child.addEventListener("onEnd", this);				
				this.percentages[i] = {start:start, end:end};
			}		
			fChild = this.currentChild = this.childsArr[0];
			this.firstChild = fChild;
			if(this.redraw) {
				fChild.setInitialized(true);
				fChild.initControlPoints();		
				fChild.movieclip.clear();							
				fChild.animate(start, end);
			} else {
				this.lineMovieclip.moveTo(fChild.getX1(), fChild.getY1());
				fChild.setInitialized(true);
				fChild.initControlPoints();				
				fChild.animateTo(start, end);
			}
		}
		if(!goto) {
			this.myAnimator = fChild.myAnimator;
			this.childDuration = fChild.duration;
			this.dispatchEvent.apply(this, [ {type:"onStart", 
												value:this.getStartValue(),
												nextChild:fChild, 
												lastChild:null, 
												childDuration:this.childDuration} ]);			
		}		
	}
	
	private function initLineMovieclip(Void):Void {	
		if(this.m_lineMovieclip == null) {
			this.m_lineMovieclip = this.createClip({parentMC:this.mc, name:"apDraw"});
		}
	}
	
	private function injectNewMovieclipsToChilds(Void):Void {	
		if(!this.areMovieclipsInjected) {
			var i:Number, len:Number = this.childsArr.length;
			for (i = 0; i < len; i++) {				
				var child:Object = this.childsArr[i];
				child.movieclip.removeMovieClip();
				child.movieclip = this.createClip({parentMC:this.m_lineMovieclip, name:"apDraw"});
			}
			this.areMovieclipsInjected = true;
		}		
	}
	
	private function injectSingleMovieclipToChilds(Void):Void {	
		if(!this.areMovieclipsInjected) {
			var i:Number, len:Number = this.childsArr.length;
			for (i = 0; i < len; i++) {
				var child:Object = this.childsArr[i];			
				child.movieclip.removeMovieClip();
				child.movieclip = this.m_lineMovieclip;
				child.reset();
			}		
			this.areMovieclipsInjected = true;
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
	public function animate(start:Number, end:Number):Void {	
		this.redraw = true;
		super.animate(start, end);
	}
	
	/**
	* @method animateBy
	* @description 	animateBy the contents of the composite.
	* @usage   <pre>myInstance.animateBy(start, end);</pre> 	  
	* @param start (Number) start value. Percentage.
	* @param end (Number) end value. Percentage.
	* @return void
	*/		
	public function animateBy(start:Number, end:Number):Void {	
		this.redraw = false;		
		super.animate(start, end);
	}	
	
	/**
	* @method fill
	* @description 	Fills the contents of the composite.
	* @usage <pre>myInstance.fill();</pre>
	*/	
	public function fill(Void):Void {
		
		this.m_fillMovieclip = this.createClip({parentMC:this.mc, name:"apDraw"});
		/*
		* TRICKY: Drawer creates two movieclips. One for the outline and one for the fill. 
		* This workaround is needed because MovieClip.beginFill 
		* and MovieClip.endFill only work in one frame. If the user uses animate and wants to fill 
		* the shape afterwards this workaround comes into play. Furthermore, the user can manipulate the 
		* fill and outline by itself.
		*/
		this.m_fillMovieclip.lineStyle();
		var penPos:Object = this.firstChild.getPenPosition();
		penPos.x = this.firstChild.getX1();
		penPos.y = this.firstChild.getY1();
		/*
		* TRICKY: prevent the MovieClip.moveTo() to be invoked one every child.
		* Tell each child that the pen position is already in place.
		* In MovieClip.beginFill() - endFill() blocks the moveTo() method 
		* shall only be invoked once before beginFill().
		*/
		this.m_fillMovieclip.moveTo(penPos.x, penPos.y);
		this.firstChild.setPenPosition(penPos);		
		
		if (this.fillRGB != null && this.fillGradient == false) {			
			this.m_fillMovieclip.beginFill(this.fillRGB, this.fillAlpha);
		} else if (this.fillGradient == true){
			this.m_fillMovieclip.beginGradientFill(this.gradientFillType, 
													this.gradientColors, 
													this.gradientAlphas, 
													this.gradientRatios, 
													this.gradientMatrix);
		}
		//Hijack children to draw the outline of the fill movieclip.
		this.drawFillOutline();
		//The fill should stay behind the outline.
		this.m_fillMovieclip.swapDepths(this.m_lineMovieclip);
		this.m_fillMovieclip.endFill();
	}	
	
	private function drawFillOutline():Void {
		var lastChild:Object = this.firstChild;
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			var child:Object = this.childsArr[i];
			if(child instanceof DashLine) {
				child.reset();
				child = new Line(child.getX1(),child.getY1(),
								child.getX2(),child.getY2());
			}
			//the fill doesn't need an outline. But save properties before overwriting.
			var lineThickness:Number = child.lineThickness;
			var lineRGB:Number = child.lineRGB;
			var lineAlpha:Number = child.lineAlpha;
			child.lineStyle();
			child.setPenPosition(lastChild.getPenPosition());
			var origMC:MovieClip = child.movieclip;
			child.movieclip = this.m_fillMovieclip;
			if(child instanceof Drawer) {
				child.draw();
			} else {
				child.reset();
				child.drawBy();				
			}
			child.initControlPoints();
			if(this.redraw) {
				child.setInitialized(false);
			}
			child.movieclip = origMC;
			child.lineStyle(lineThickness, lineRGB, lineAlpha);
			lastChild = child;
		}		
	}
		
	private function getAnimateDetails(start:Number, end:Number, 
										childsArr:Array, ref:Object):Object {
		
		
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
			if(!this.redraw) {
				child.mode = "DRAWTO";
			}
			if(backwards) {
				if(i > roundedPosStart) {
					child.goto(0);
				} else {
					child.goto(100);
				}
			}
		}
		
		for (i = len-1; i > -1; i--) {
			var child:Object = this.childsArr[i];
			if(!this.redraw) {
				child.mode = "DRAWTO";
			}		
			if(!backwards) {
				if(i < roundedPosStart) {
					child.goto(100);
				} else {
					child.goto(0);
				}
			}
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
			this.duration = 0;			
			APCore.broadcastMessage(this.callback, this);			
			this.dispatchEvent.apply(this, [ {type:"onEnd", 
												value:this.getEndValue(),
												nextChild:null, 
												lastChild:eventObj.target, 
												childDuration:null} ]);			
		} else {
			
			/*backwards will only be true in Sequence mode JOIN*/
			if(this.backwards) {
				this.position--;
			} else {
				this.position++;
			}			
			this.currentChild = successor;
			if(this.redraw) {
				successor.movieclip.clear();
				successor.movieclip.lineStyle(successor.lineThickness, 
											successor.lineRGB, 
											successor.lineAlpha);
			}
			
			this.dispatchEvent.apply(this, [ {type:"onUpdatePosition",
											value:this.getCurrentValue(),
											nextChild:successor, 
											lastChild:eventObj.target, 
											childDuration:this.childDuration} ]);			
			
			var animateMeth:String;
			if(this.redraw) {				
				animateMeth = "animate";
			} else {
				animateMeth = "animateTo";
			}
			successor.initControlPoints();
			successor.setInitialized(true);
			successor[animateMeth].apply(successor, [this.percentages[this.position-1].start, 
												this.percentages[this.position-1].end]);
			this.myAnimator = successor.myAnimator;
		}		
	}
	
	/**
	* @method lineStyle
	* @description 	define outline. Overwrites lineStyle settings from childs.
	* 		
	* @usage   <pre>myInstance.lineStyle();</pre>
	* 		<pre>myInstance.lineStyle(lineThickness, lineRGB, lineAlpha);</pre>
	* 	  
	* @param lineThickness (Number) Outline thickness.
	* @param lineRGB (Number) Outline color as hex number.	
	* @param lineAlpha (Number) Outline transparency (alpha).
	*/	
	public function lineStyle(lineThickness:Number, lineRGB:Number, lineAlpha:Number):Void {		
		super.lineStyle(lineThickness, lineRGB, lineAlpha);
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {			
			this.childsArr[i].lineStyle(lineThickness, lineRGB, lineAlpha);			
		}
	}
	
	/**
	* @method fillStyle
	* @description 	 define fill.		
	* 		
	* @usage   <pre>myInstance.fillStyle();</pre>
	* 		<pre>myInstance.fillStyle(fillRGB, fillAlpha);</pre>
	* 	  
	* @param fillRGB (Number) Fill color.
	* @param fillAlpha (Number) Fill transparency.
	*/
	
	/**
	* @method gradientStyle
	* @description	 Same interface as MovieClip.beginGradientFill(). See manual.
	* 		
	* @usage   <pre>myInstance.gradientStyle(fillType, colors, alphas, ratios, matrix);</pre>
	* 	  
	* @param fillType (String)  Gradient property. See MovieClip.beginGradientFill().
	* @param colors (Array)  Gradient property. See MovieClip.beginGradientFill().
	* @param alphas (Array)  Gradient property. See MovieClip.beginGradientFill().
	* @param ratios (Array)  Gradient property. See MovieClip.beginGradientFill().
	* @param matrix (Object)  Gradient property. See MovieClip.beginGradientFill().
	*/

	/**
	* @method animationStyle
	* @description 	set animation settings. Overwrites animationStyle settings from childs.
	* 		
	* @usage   <pre>myInstance.animationStyle(duration);</pre>
	* 		<pre>myInstance.animationStyle(duration, callback);</pre>
	* 		<pre>myInstance.animationStyle(duration, easing, callback);</pre>
	* 	  
	* @param duration (Number) Duration of animation(s) in milliseconds or frames. Default is milliseconds.
	* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @param callback (String) Function to invoke after animation(s). See APCore class.
	*/	
	public function animationStyle(duration:Number, easing:Object, callback:String):Void {
		super.animationStyle(duration, easing, callback);
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {					
			this.childsArr[i].animationStyle(duration, easing);
		}
		this.duration = duration;
		this.callback = callback;
	}
	
	/**
	* @method setAnimateMode
	* @description 	sets the animate mode. If JOIN, the start and end percentage 
	* 				parameters influences the composite animation as a whole. Defaults to JOIN. 
	* 				See class documentation of Sequence for details.
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
			if(child instanceof Drawer) {
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
	* @method getChild
	* @description 	returns the current child of the sequence.
	* @usage   <tt>myInstance.getChild();</tt>
	* @return IOutline
	*/	
	public function getChild(Void):IOutline {		
		return IOutline(this.currentChild);
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
	* @return IOutline
	*/	
	public function getNextChild(Void):IOutline {
		if(this.animateMode == "JOIN" && this.backwards) {
			return IOutline(this.childsArr[this.position-2]);
		} else {
			return IOutline(this.childsArr[this.position]);
		}
	}
	
	/**
	* @method getPreviousChild
	* @description 	returns the previous child of the sequence.
	* @usage   <tt>myInstance.getPreviousChild();</tt>
	* @return IAnimatable
	*/	
	public function getPreviousChild(Void):IOutline {		
		if(this.animateMode == "JOIN" && this.backwards) {
			if(this.position-1 == this.childsArr.length) {
				return IOutline(this.childsArr[this.position-1]);
			} else {
				return IOutline(this.childsArr[this.position]);
			}			
		} else {
			return IOutline(this.childsArr[this.position-2]);
		}
	}	
	
	/**
	* @method getChildDuration
	* @description 	returns the duration of every single child in constrast to the duration property, 
	* 				which is the duration of the whole Sequence.  
	* @usage   <tt>myInstance.getChildDuration();</tt>
	* @return Number
	*/	
	public function getChildDuration(Void):Object {		
		return this.childDuration;
	}
	
	/**
	* @method addChild
	* @description 	adds a primitive or composite to the composite instance of Drawer 
	* See class description.
	* @usage  <pre>myInstance.addChild(component);</pre>
	* @param component (IOutline) Must be compatible to IOutline.
	* @return IOutline class that was added.
	*/	
	public function addChild(component:IOutline):IOutline {		
		if(component instanceof Object) {
			this.childsArr.push(component);
			return component;
		}
	}

	/**
	* @method removeChild
	* @description 	removes a primitive or composite from the composite instance of Drawer 
	* See class description.
	* @usage  <pre>myInstance.removeChild(component);</pre>
	* @param component (IOutline) Must be compatible to IOutline.	
	*/
	public function removeChild(component:IOutline):Void {		
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			if(this.childsArr[i] == component) {
				this.childsArr.splice(i, 1);
			}
		}
	}
	
	/**
	* @method clear
	* @description 	removes all drawings.
	* @usage <pre>myInstance.clear();</pre>
	*/
	public function clear(Void):Void {
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			var child:Object = this.childsArr[i];			
			child.mc.clear();			
		}
		this.fillMovieclip.clear();
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
	
	public function get lineMovieclip():MovieClip {
		return this.m_lineMovieclip;
	}
	
	public function set lineMovieclip(m_lineMovieclip:MovieClip):Void {
		this.m_lineMovieclip= m_lineMovieclip;
	}	
	
	public function get fillMovieclip():MovieClip {
		return this.m_fillMovieclip;
	}
	
	public function set fillMovieclip(m_fillMovieclip:MovieClip):Void {
		this.m_fillMovieclip= m_fillMovieclip;
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
			isSet =this.childsArr[i].setTweenMode(tweenMode);		
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
		var currentValue:Number = pos + perc / 100;		
		return currentValue / (this.childsArr.length) * 100;		
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
	* 			<b>onStart</b>, broadcasted when sequence starts.<br>
	* 			<b>onUpdate</b>, broadcasted when sequence animates a new object.<br>
	*			<b>onEnd</b>, broadcasted when animation ends.<p>
	* 			The even object returned, contains the following properties:<p>
	* 			<b>type</b> (String) event broadcasted.<br>
	*			<b>target</b> (Sequence) event source.<br>
	* 			<b>nextChild</b> (IAnimatable) next child in sequence to be animated.<br>
	* 			<b>lastChild</b> (IAnimatable) last child in sequence that has been animated.<br>
	* 			<b>childDuration</b> (Number) duration of every single child.<br>
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
		return "Drawer";
	}
}