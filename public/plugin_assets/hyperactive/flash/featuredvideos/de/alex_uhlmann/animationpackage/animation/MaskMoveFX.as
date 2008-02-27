import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.MaskCore;
import de.alex_uhlmann.animationpackage.animation.Move;

/*inspired from Jon Williams, shovemedia.com, ActionScript Timeline Class v2.0 beta*/
/**
* @class MaskMoveFX
* @author Alex Uhlmann, Ben Jackson
* @description	Animates a mask using move effects. 
* 			You can specify the duration, easing equation and callback properties 
* 			either with setting the properies directly or with the animationStyle() method 
* 			like it is used in de.alex_uhlmann.animationpackage.drawing. 
* 			You can also send the animationStyle properties via the run() method or via the constructor. See the following examples.
*			The move effect needs to 
* 			be specified as a string abbreviation. Available mask move effects are:
* 			<blockquote><pre>
* 			"L" = left, moves the mask to the left.
* 			"R" = right, moves the mask to the right.
* 			"T" = top, moves the mask to the top.
* 			"B" = bottom, moves the mask to the bottom.
* 			"TL" = top left, moves the mask to the top left corner. 
* 			"TR" = top right, moves the mask to the top right corner.
* 			"BL" = bottom left, moves the mask to the bottom left corner.
* 			"BR" = bottom right, moves the mask to the bottom right corner.
* 			"CUSTOM" = moves the mask according to the adjustmentObj parameter.
* 			</pre></blockquote>
* 			<p> 
* 			Example 1: <a href="MaskMoveFX_01.html">(Example .swf)</a> Draw a rectangle and use it as a mask over movieclip mc.
* 			<blockquote><pre>
*			var myRect:Rectangle = new Rectangle(50,50,100,50);
*			myRect.draw();
*			var myMaskMoveFX:MaskMoveFX = new MaskMoveFX(mc,myRect.movieclip);
*			myMaskMoveFX.animationStyle(2000,Circ.easeInOut);
*			myMaskMoveFX.run("L",0,100);
* 			</pre></blockquote>
* 			If you don't specify a mask movieclip, 
* 			a Rectangle will be created in the parent timeline of mc.
* 			<p>
* 			You can alter a predefined move effect or you can define a custom move effect 
* 			via the adjustmentObj. The adjustmentObj of MaskMoveFX is an Object that contains five optional properties.
* 			<blockquote><pre>
* 			scaleOffset = Specifies the scaling of the mask. Defaults to 120 or 160, depening on the specified move effect. If null is specified, the mask movieclip won't be scaled at all.
* 			startX = Start point to move the mask from. Coordinate point x.
* 			startY = Start point to move the mask from. Coordinate point y.
*			endX = End point to move the mask to. Coordinate point x.
*			endY = End point to move the mask to. Coordinate point y.
* 			</pre></blockquote>
* 			<p>
* 			Example 2: <a href="MaskMoveFX_02.html">(Example .swf)</a> Mask only a specific part in the masked movieclip. Move according to the adjustmentObj. 
* 			Note that you can prevent automatic scaling of your mask movieclip if you set scaleOffset to null.
* 			<blockquote><pre>			
*			var myRect:Rectangle = new Rectangle(50,50,158,25);
*			myRect.draw();
*			var mcBounds:Object = mc.getBounds(_root);
*			var myMaskMoveFX1:MaskMoveFX = new MaskMoveFX(mc,myRect.movieclip);
*			AnimationCore.duration_def = 2000;
*			AnimationCore.easing_def = Circ.easeInOut;
*			myMaskMoveFX1.run("CUSTOM",0,100,{
*							scaleOffset:null, 
*							startX:mcBounds.xMin,
*							startY:mcBounds.yMax-22, 
*							endX:mcBounds.xMax-92, 
*							endY:mcBounds.yMax-22
*							});
*			</pre></blockquote>
* 			<p>
* 			Note that the start and end values (0 and 100) in example 2 have no effect when using the CUSTOM move effect.
* 			Furthermore, note that you can also alter predefined move effects via the properties of the adjustmentObj. 
* 			You don't have to specify the CUSTOM move effect, when you want to customize a move effect.
* 			<p>
* 			Note that all examples above created a mask movieclip above the masked mc. 
* 			If you want to manipulate physical movieclip properties of the masked movieclip, and at the same time 
* 			animate the movieclip with a mask effect, the mask effect would be disturbed. Here is a solution:
* 			<p>
* 			Example 3: <a href="MaskMoveFX_03.html">(Example .swf)</a> Using the Parallel class we use a mask effect and manipulate many physical properties of movieclip "mc" at the same time.
* 			<pre><blockquote>
* 			var myMoveOnQuadCurve:MoveOnQuadCurve = new MoveOnQuadCurve(mc,100,100,300,300,500,100);
*			var myScale:Scale = new Scale(mc,50,50);
*			var myColorTransform:ColorTransform = new ColorTransform(mc,0xff0000,50);
* 			//create the mask movieclip inside the movieclip mc to reflect all manipulations to mc.
*			var mask_mc:MovieClip = mc.createEmptyMovieClip("mask_mc",1);
*			var myRect:Rectangle = new Rectangle(mask_mc,50,50,100,50);
*			myRect.draw();
* 			//since the mask is inside mc you have to mask a movieclip inside mc.
* 			var myMaskMoveFX:MaskMoveFX = new MaskMoveFX(mc.inner_mc,myRect.movieclip,"TL");
*			
*			var myParallel:Parallel = new Parallel();
*			myParallel.addChild(myMoveOnQuadCurve);
*			myParallel.addChild(myScale);
*			myParallel.addChild(myColorTransform);
*			myParallel.addChild(myMaskMoveFX);
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
* 			</blockquote></pre>
* 			<p>
* 
* @usage 
* 		<pre>var myMaskMoveFX:MaskMoveFX = new MaskMoveFX(mc);</pre> 
* 		<pre>var myMaskMoveFX:MaskMoveFX = new MaskMoveFX(mc, mask_mc);</pre> 
* 		<pre>var myMaskMoveFX:MaskMoveFX = new MaskMoveFX(mc, mask_mc, effect);</pre>
* 		<pre>var myMaskMoveFX:MaskMoveFX = new MaskMoveFX(mc, mask_mc, effect, duration);</pre>
* 		<pre>var myMaskMoveFX:MaskMoveFX = new MaskMoveFX(mc, mask_mc, effect, duration, callback);</pre>
*		<pre>var myMaskMoveFX:MaskMoveFX = new MaskMoveFX(mc, mask_mc, effect, duration, easing, callback);</pre>
* 		<pre>var myMaskMoveFX:MaskMoveFX = new MaskMoveFX(mc, mask_mc, effect, adjustmentObj);</pre>
* 		<pre>var myMaskMoveFX:MaskMoveFX = new MaskMoveFX(mc, mask_mc, effect, adjustmentObj, duration);</pre>
* 		<pre>var myMaskMoveFX:MaskMoveFX = new MaskMoveFX(mc, mask_mc, effect, adjustmentObj, duration, callback);</pre>
*		<pre>var myMaskMoveFX:MaskMoveFX = new MaskMoveFX(mc, mask_mc, effect, adjustmentObj, duration, easing, callback);</pre>
* 
* @param mc (MovieClip) movieclip to be masked.
* @param mask_mc (MovieClip) movieclip to use as a mask. If null or omitted, a Rectangle will be created in the parent timeline of mc.	  
* @param effect (String) Specifies the mask move FX.
* @param adjustmentObj (Object) Optional. Object with five properties that overwrite the default properties that define the move effect of the mask. You only need this parameter if you are not contented with the default move effect of the mask or if you use the CUSTOM move effect.
* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
* @param callback (String) Function to invoke after animation. See AnimationCore class.
*/
class de.alex_uhlmann.animationpackage.animation.MaskMoveFX 
												extends MaskCore 
												implements ISingleAnimatable  {
	
	/*animationStyle properties inherited from AnimationCore*/
	/** 
	* @property movieclip (MovieClip) Movieclip to be masked.
	* @property maskMovieclip (MovieClip) Movieclip to use as a mask.
	* @property duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @property easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @property callback (String) Function to invoke after animation. See AnimationCore class. 
	*/
	private var myMove:Move;
	
	public function MaskMoveFX(mc:MovieClip, mask_mc:MovieClip, 
								effect:String, adjustmentObj:Object, 
								duration:Object, easing:Object, callback:String) {
		super(mc, mask_mc);
		if(arguments.length > 2) {			
			this.initAnimation.apply(this, arguments.slice(2));
		}
	}
	
	private function initAnimation(effect:String, adjustmentObj:Object, 
						duration:Object, easing:Object, callback:String):Void {		
		
		this.effect = effect;
		this.adjustmentObj = adjustmentObj;		
		var temp;
		var paramLen:Number = 4;		
		if(typeof(adjustmentObj) == "number") {
			temp = adjustmentObj;
			var temp_ms:Number = temp;                  
			var temp_easing = duration;
			temp = easing;
			easing = temp_easing;
			callback = temp;			
			this.animationStyle(temp_ms, easing, callback);
		} else if (arguments.length > paramLen) {			
			temp = duration;
			this.animationStyle(temp, easing, callback);
		} else {
			this.animationStyle(this.duration, this.easing, this.callback);
		}
		this.getBounds();
		var scaleOffset:Number = this.adjustmentObj.scaleOffset;
		if(effect == "L" || effect == "R" || effect == "T" || effect == "B" || effect == "CUSTOM") {
			this.matchSize(scaleOffset);
		} else if(effect == "TL" || effect == "TR" || effect == "BL" || effect == "BR") {
			if(scaleOffset == null) {
				scaleOffset = 160;
			}
			this.matchSize(scaleOffset);
		}
	}
	
	private function invokeAnimation(start:Number, end:Number):Void {		
		this.startInitialized = false;
		
		var goto:Boolean;
		var percentage:Number = start;
		if(end == null) {
			goto = true;
			end = start;
			start = 0;
			end = 100 - end;
			if(omitEvent) {
				return;
			}
		} else {
			goto = false;
		}
		this.tweening = true;
		var effect:String = this.effect;
		
		var adjustmentObj:Object = this.adjustmentObj;
		if(adjustmentObj.start != null 
			&& adjustmentObj.end != null) {
			
			start = adjustmentObj.start;
			end = adjustmentObj.end;
		}
		
		var posStartRel:Number;
		var posEndRel:Number;
		var startObj:Object = new Object();
		var endObj:Object = new Object();
		var mcPath:String = targetPath(this.mc);
		var mask_mcPath:String = targetPath(this.mask_mc);
		var mcPathCont:String  = mcPath.substring(0, mcPath.indexOf(".",8));
		var mask_mcPathCont:String = mask_mcPath.substring(0, mask_mcPath.indexOf(".",8));
		this.getBounds();
		var mcW:Number = this.mcBounds.xMax - this.mcBounds.xMin;
		var mcH:Number = this.mcBounds.yMax - this.mcBounds.yMin;
		var mask_mcW:Number = this.mask_mcBounds.xMax - this.mask_mcBounds.xMin;
		var mask_mcH:Number = this.mask_mcBounds.yMax - this.mask_mcBounds.yMin;
		/*
		* Since all shapes of the de.alex_uhlmann.animationpackage.drawing package
		* are centered by default, meaning that the point at 0,0 is exactly the center of the shape, 
		* this class treats all movieclips used as a mask, like if they would be centered. 
		* Masked movieclips can be centered any way.
		* TODO: Needs refactoring even more badly.
		*/
		if(effect == "L") {			
			posStartRel = (100 - start) / 100 * mcW;
			posEndRel = (100 - end) / 100 * mcW;	
			startObj.x = (this.mcBounds.xMin + posEndRel) + (mask_mcW / 2);
			startObj.y = this.mcBounds.yMin + (mask_mcH / 2) - ((mask_mcH - mcH) / 2);	
			endObj.x = (this.mcBounds.xMin + posStartRel) + (mask_mcW / 2);
			endObj.y = this.mcBounds.yMin + (mask_mcH / 2) - ((mask_mcH - mcH) / 2);			
			if(mcPathCont == mask_mcPathCont) {				
				this.mc._parent.globalToLocal(startObj);
				this.mc._parent.globalToLocal(endObj);			
			}	
			this.mask_mc._x = startObj.x;
			this.mask_mc._y = startObj.y;			
			if(start == 100) {				
				endObj.x -= (mask_mcW - mcW) / 2 ;			
			}				
			
		} else if(effect == "R") {			
			posStartRel = (100 - start) / 100 * mcW;
			posEndRel = (100 - end) / 100 * mcW;					
			startObj.x = (this.mcBounds.xMin - posEndRel) + (mask_mcW / 2) - (mask_mcW - mcW);
			startObj.y = this.mcBounds.yMin + (mask_mcH / 2) - ((mask_mcH - mcH) / 2);
			endObj.x = (this.mcBounds.xMin - posStartRel) + (mask_mcW / 2) - ((mask_mcW - mcW));
			endObj.y = this.mcBounds.yMin + (mask_mcH / 2) - ((mask_mcH - mcH) / 2);			
			if(mcPathCont == mask_mcPathCont) {				
				this.mc._parent.globalToLocal(startObj);
				this.mc._parent.globalToLocal(endObj);			
			}
			this.mask_mc._x = startObj.x;
			this.mask_mc._y = startObj.y;			
			if(start == 100) {
				endObj.x += ((mask_mcW - mcW) / 2);			
			}			
			
		} else if(effect == "T") {
			posStartRel = (100 - start) / 100 * mcH;
			posEndRel = (100 - end) / 100 * mcH;		
			startObj.x = this.mcBounds.xMin + (mask_mcW / 2) - ((mask_mcW - mcW) / 2);
			startObj.y = (this.mcBounds.yMin + posEndRel) + (mask_mcH / 2);	
			endObj.x = this.mcBounds.xMin + (mask_mcW / 2) - ((mask_mcW - mcW) / 2);
			endObj.y = (this.mcBounds.yMin + posStartRel) + (mask_mcH / 2);				
			if(mcPathCont == mask_mcPathCont) {				
				this.mc._parent.globalToLocal(startObj);
				this.mc._parent.globalToLocal(endObj);			
			}
			this.mask_mc._x = startObj.x;
			this.mask_mc._y = startObj.y;	
			if(start == 100) {
				endObj.y -= ((mask_mcH - mcH) / 2);			
			}
		
		} else if(effect == "B") {
			posStartRel = (100 - start) / 100 * mcH;
			posEndRel = (100 - end) / 100 * mcH;						
			startObj.x = this.mcBounds.xMin + (mask_mcW / 2) - ((mask_mcW - mcW) / 2);
			startObj.y = (this.mcBounds.yMin - posEndRel) + (mask_mcH / 2) - (mask_mcH - mcH);
			endObj.x = this.mcBounds.xMin + (mask_mcW / 2) - ((mask_mcW - mcW) / 2);
			endObj.y = (this.mcBounds.yMin - posStartRel) + (mask_mcH / 2) - ((mask_mcH - mcH));
			if(mcPathCont == mask_mcPathCont) {				
				this.mc._parent.globalToLocal(startObj);
				this.mc._parent.globalToLocal(endObj);			
			}
			this.mask_mc._x = startObj.x;
			this.mask_mc._y = startObj.y;	
			if(start == 100) {
				endObj.y += ((mask_mcH - mcH) / 2);		
			}
			
		} else if(effect == "TL") {
			posStartRel = (100 - start) / 100 * mcW;
			posEndRel = (100 - end) / 100 * mcW;	
			this.mask_mc._rotation = 45;			
			startObj.x = (this.mcBounds.xMin + posEndRel) + (mask_mcW / 2) - ((mask_mcW - mcW) / 2);
			startObj.y = (this.mcBounds.yMin + posEndRel) + (mask_mcH / 2) - ((mask_mcH - mcH) / 2);
			endObj.x = (this.mcBounds.xMin + posStartRel) + (mask_mcW / 2) - ((mask_mcW - mcW) / 2);
			endObj.y = (this.mcBounds.yMin + posStartRel) + (mask_mcH / 2) - ((mask_mcH - mcH) / 2);			
			if(mcPathCont == mask_mcPathCont) {				
				this.mc._parent.globalToLocal(startObj);
				this.mc._parent.globalToLocal(endObj);			
			}
			this.mask_mc._x = startObj.x;
			this.mask_mc._y = startObj.y;	
			
		} else if(effect == "TR") {
			posStartRel = (100 - start) / 100 * mcW;
			posEndRel = (100 - end) / 100 * mcW;	
			this.mask_mc._rotation = 45;			
			startObj.x = (this.mcBounds.xMin - posEndRel) + (mask_mcW / 2) - ((mask_mcW - mcW) / 2);
			startObj.y = (this.mcBounds.yMin + posEndRel) + (mask_mcH / 2) - ((mask_mcH - mcH) / 2);
			endObj.x= (this.mcBounds.xMin - posStartRel) + (mask_mcW / 2) - ((mask_mcW - mcW) / 2);
			endObj.y = (this.mcBounds.yMin + posStartRel) + (mask_mcH / 2) - ((mask_mcH - mcH) / 2);			
			if(mcPathCont == mask_mcPathCont) {				
				this.mc._parent.globalToLocal(startObj);
				this.mc._parent.globalToLocal(endObj);			
			}
			this.mask_mc._x = startObj.x;
			this.mask_mc._y = startObj.y;	
		
		} else if(effect == "BL") {
			posStartRel = (100 - start) / 100 * mcW;
			posEndRel = (100 - end) / 100 * mcW;		
			this.mask_mc._rotation = 45;		
			startObj.x = (this.mcBounds.xMin + posEndRel) + (mask_mcW / 2) - ((mask_mcW - mcW) / 2);
			startObj.y = (this.mcBounds.yMin - posEndRel) + (mask_mcH / 2) - ((mask_mcH - mcH) / 2);
			endObj.x = (this.mcBounds.xMin + posStartRel) + (mask_mcW / 2) - ((mask_mcW - mcW) / 2);
			endObj.y = (this.mcBounds.yMin - posStartRel) + (mask_mcH / 2) - ((mask_mcH - mcH) / 2);			
			if(mcPathCont == mask_mcPathCont) {				
				this.mc._parent.globalToLocal(startObj);
				this.mc._parent.globalToLocal(endObj);			
			}
			this.mask_mc._x = startObj.x;
			this.mask_mc._y = startObj.y;	
			
		} else if(effect == "BR") {
			posStartRel = (100 - start) / 100 * mcW;
			posEndRel = (100 - end) / 100 * mcW;
			this.mask_mc._rotation = 45;			
			startObj.x = (this.mcBounds.xMin - posEndRel) + (mask_mcW / 2) - ((mask_mcW - mcW) / 2);
			startObj.y = (this.mcBounds.yMin - posEndRel) + (mask_mcH / 2) - ((mask_mcH - mcH) / 2);
			endObj.x= (this.mcBounds.xMin - posStartRel) + (mask_mcW / 2) - ((mask_mcW - mcW) / 2);
			endObj.y = (this.mcBounds.yMin - posStartRel) + (mask_mcH / 2) - ((mask_mcH - mcH) / 2);
			if(mcPathCont == mask_mcPathCont) {				
				this.mc._parent.globalToLocal(startObj);
				this.mc._parent.globalToLocal(endObj);			
			}
			this.mask_mc._x = startObj.x;
			this.mask_mc._y = startObj.y;	
			
		} else if(effect == "CUSTOM") {
			
		}
		
		this.unhideMask();
		this.setMask();		
		var endObj2:Object = new Object();
		startObj.x = adjustmentObj.startX;
		startObj.y = adjustmentObj.startY;		
		endObj2.x = adjustmentObj.endX;
		endObj2.y = adjustmentObj.endY;
		if(mcPathCont == mask_mcPathCont) {			
			this.mc._parent.globalToLocal(startObj);
			this.mc._parent.globalToLocal(endObj2);			
		}		
		if(adjustmentObj.startX != null) {			
			this.mask_mc._x = startObj.x;			
		}
		if(adjustmentObj.startY != null) {			
			this.mask_mc._y = startObj.y;			
		}
		if(adjustmentObj.endX != null) {			
			endObj.x = endObj2.x;			
		}
		if(adjustmentObj.endY != null) {
			endObj.y = endObj2.y;		
		}
		this.myMove = new Move(this.mask_mc,endObj.x,endObj.y);
		this.myMaskAnimation = this.myMove;
		this.myMove.animationStyle(this.duration, this.easing);
		this.myMove.addEventListener("onStart", this);
		this.myMove.addEventListener("onUpdate", this);
		this.myMove.addEventListener("onEnd", this);		
		if(goto == false) {
			this.myMove.animate(0,100);
		} else {
			this.myMove.goto(percentage);
		}
		this.myAnimator = this.myMove.myAnimator;
		this.setStartValues(this.myMove.getStartValues());
		this.setEndValues(this.myMove.getEndValues());
	}
	
	/**
	* @method run
	* @description   Animates a mask using move effects from and to a specified amount in a specified time and easing equation. 
	* 				See class description for details.
	* @usage   <pre>myMaskMoveFX.run(effect, start, end);</pre>
	* 		<pre>myMaskMoveFX.run(effect, start, end, duration);</pre>
	* 		<pre>myMaskMoveFX.run(effect, start, end, duration, callback);</pre>
	*		<pre>myMaskMoveFX.run(effect, start, end, duration, easing, callback);</pre>
	* 		<pre>myMaskMoveFX.run(effect, start, end, adjustmentObj);</pre>
	* 		<pre>myMaskMoveFX.run(effect, start, end, adjustmentObj, duration);</pre>
	* 		<pre>myMaskMoveFX.run(effect, start, end, adjustmentObj, duration, callback);</pre>
	*		<pre>myMaskMoveFX.run(effect, start, end, adjustmentObj, duration, easing, callback);</pre>
	* 	  
	* @param effect (String) Specifies the mask move FX.
	* @param start (Number) Amount to animated from. Percentage.
	* @param end (Number) Targeted amount to animated to. Percentage.
	* @param adjustmentObj (Object) Optional. Object with five properties that overwrite the default properties that define the move effect of the mask. You only need this parameter if you are not contented with the default move effect of the mask or if you use the CUSTOM move effect.
	* @param duration (Object) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @param callback (String) Function to invoke after animation. See APCore class.
	* @return void
	*/
	public function run():Void {		
		var start:Number = arguments[1];
		var end:Number = arguments[2];
		arguments.splice(1, 2);		
		this.initAnimation.apply(this, arguments);		
		this.invokeAnimation(start, end);	
	}
	
	/**
	* @method animate
	* @description 	similar to the run() method. Offers start and end parameters.
	* @usage   <pre>myMaskMoveFX.animate(start, end);</pre> 	  
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
	* @description 	returns the original, starting values of the current tween. _x and _y properties.
	* @usage   <tt>myInstance.getStartValues();</tt>
	* @return (Array) First value is _x, second is _y.
	*/
	
	/**
	* @method getEndValues
	* @description 	returns the targeted values of the current tween. _x and _y properties.
	* @usage   <tt>myInstance.getEndValues();</tt>
	* @return (Array) First value is _x, second is _y.
	*/

	/**
	* @method getCurrentValues
	* @description 	returns the current values of the current tween. _x and _y properties.
	* @usage   <tt>myInstance.getCurrentValues();</tt>
	* @return (Array) First value is _x, second is _y.
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
	* 		
	* @usage   <pre>myMaskMoveFX.addEventListener(event, listener);</pre>
	* 		    <pre>myMaskMoveFX.addEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myMaskMoveFX.removeEventListener(event, listener);</pre>
	* 		    <pre>myMaskMoveFX.removeEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>myMaskMoveFX.removeAllEventListeners();</pre>
	* 		    <pre>myMaskMoveFX.removeAllEventListeners(event);</pre>
	* 	  
	*@param event (String) Event to remove all subscribed listeners from. If not specified, all listeners to any event will be removed.
	*/
	
	/*inherited from APCore*/
	/**
	* @method eventListenerExists
	* @description 	GDispatcher specific feature. Checks if a listener is already subscribed to a certain event.
	* 		
	* @usage   <pre>myMaskMoveFX.eventListenerExists(event, listener);</pre>
	* 			<pre>myMaskMoveFX.eventListenerExists(event, listener, handler);</pre>
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
		return "MaskMoveFX";
	}
}