import de.alex_uhlmann.animationpackage.animation.IMultiAnimatable;
import de.alex_uhlmann.animationpackage.animation.Filter;
import flash.filters.BitmapFilter;
import flash.filters.DropShadowFilter;

/**
* @class DropShadow
* @author Alex Uhlmann
* @description  Animates the DropShadowFilter of a movieclip 
* 			or a number of movieclips. 
* 			<p>	
* 			Example 1: <a href="DropShadow_01.html">(Example .swf)</a> 
* 			apply a filter animation with default values. 
* 
* 			<blockquote><pre>
* 			import flash.filters.DropShadowFilter;
* 			
*			var filterEnd:DropShadowFilter = new DropShadowFilter();
*			new DropShadow(mc,filterEnd).animate(0,100);
* 			</pre></blockquote>
* 			<p>	
* 			Example 2: <a href="DropShadow_02.html">(Example .swf)</a> 
* 			do the same, just the other way around
* 
* 			<blockquote><pre>
* 			import flash.filters.DropShadowFilter;
* 			
*			var filterEnd:DropShadowFilter = new DropShadowFilter();
*			new DropShadow(mc,filterEnd).animate(100,0);
* 			</pre></blockquote>
* 			<p>	
* 			Example 3: <a href="DropShadow_02.html">(Example .swf)</a> 
* 			As with other IAnimatable classes 
* 			you can set specific start and end values. To do the same as 
* 			in example 2 you can apply a default filter instance 
* 			as start value and a "null" value as end value. null 
* 			defines a filter instance that won't be visible.
* 
* 			<blockquote><pre>
* 			import flash.filters.DropShadowFilter;
* 			
*			var filterStart:DropShadowFilter = new DropShadowFilter();
*			var myDropShadow:DropShadow = new DropShadow(mc,[filterStart,null]);
*			myDropShadow.animationStyle(1000,Linear.easeNone);
*			myDropShadow.animate(0,100);
* 			</pre></blockquote>
* 			<p>		
* 			Example 4: <a href="DropShadow_03.html">(Example .swf)</a> 
* 			Instances of the flash.filters classes are stacked 
* 			to the filters Array of the movieclip you use. AnimationPackage 
* 			offers you control if you want to animate existing 
* 			filters, if you want to create a new filter, or replace an 
* 			existing filter. By default, and in the examples above, we've 
* 			always added a new filter instance to our movieclip mc. If 
* 			you want to animate an existing filter you have to specify the 
* 			index of the element in the movieclip's filters Array you 
* 			want to manipulate. This example applies two different filters 
* 			to the filters Array of movieclip mc and then animates element 1, 
* 			which is the DropShadowFilter. You would replace the GlowFilter 
* 			at index 0 and add new filter with specifying either no filterIndex 
* 			as in the examples above or an index higher than 1.
* 			<blockquote><pre>
* 			import flash.filters.GlowFilter;
* 			import flash.filters.DropShadowFilter;
* 			
*			var glowFilter:GlowFilter = new GlowFilter();
*			mc.filters = [glowFilter];
*			var dropShadowFilter:DropShadowFilter = new DropShadowFilter();
*			mc.filters = [glowFilter,dropShadowFilter];
*			
*			var newDropShadowFilter:DropShadowFilter = new DropShadowFilter();
*			newDropShadowFilter.distance = 60;
*			var myDropShadowIn:DropShadow = new DropShadow(mc,1,newDropShadowFilter);
*			myDropShadowIn.animationStyle(1000,Circ.easeInOut);
*			myDropShadowIn.addEventListener("onEnd",this);
*			myDropShadowIn.animate(0,100);
* 			</pre></blockquote>
* 
* 			<p>
* 			Example 5: <a href="DropShadow_04.html">(Example .swf)</a> 
* 			Filter classes can have properties 
* 			that don't animate. You can set those properties either 
* 			as start value to the flash.filters instance or 
* 			to AnimationPackage's filter class itself as 
* 			done in this example. When the animation is invoked  
* 			the property will be applied. In the following we apply the knockout 
* 			property directly to the DropShadow instance. Only distance, blurX and blurY 
* 			will animate.
* 			<blockquote><pre>
*			import flash.filters.DropShadowFilter;
*			
*			var filterEnd:DropShadowFilter = new DropShadowFilter();
*			filterEnd.distance = 8;
*			filterEnd.blurX = 15;
*			filterEnd.blurY = 15;
*			var myDropShadow:DropShadow = new DropShadow(mc,filterEnd);
*			myDropShadow.knockout = true;
*			myDropShadow.animationStyle(3000,Sine.easeInOut);
*			myDropShadow.animate(0,100);
* 			</pre></blockquote>
*			<p>
* 			Example 6: <a href="DropShadow_05.html">(Example .swf)</a> 
* 			To animate many movieclips the same way, 
* 			this class also accepts an Array of movieclips instead of 
* 			one movieclip. This way yields to a better performance than 
* 			creating a new class instance for each movieclip you want 
* 			to animate. Different start values of your movieclip 
* 			properties are considered when animating multiple movieclips 
* 			within one animation instance. Here, we animate a drop shadow 
* 			in and out.
* 			<blockquote><pre>
*			import flash.filters.DropShadowFilter;
*			
*			var mcs:Array = new Array(mc1, mc2, mc3);
*			
*			var dropShadowFilter:DropShadowFilter = new DropShadowFilter();
*			var myDropShadowIn:DropShadow = new DropShadow(mcs,dropShadowFilter);
*			myDropShadowIn.setOptimizationMode(true);
*			myDropShadowIn.animationStyle(1000,Circ.easeOut);
*			myDropShadowIn.addEventListener("onEnd",this);
*			myDropShadowIn.animate(0,100);
*			function onEnd(e:Object) {
*				var myDropShadowOut:DropShadow = new DropShadow(mcs,0,null);
*				myDropShadowOut.animationStyle(1000,Circ.easeIn);
*				myDropShadowOut.animate(0,100);
*			}
*
* 			</pre></blockquote>
* 			<p>
* 			Example 7: <a href="DropShadow_06.html">(Example .swf)</a> 
* 			Showcase some of the DropShadow features in 
* 			a Sequence.
* 			<blockquote><pre>
* 				import flash.filters.DropShadowFilter;
*				
*				var filter1:DropShadowFilter = new DropShadowFilter();
*				var myDropShadow1:DropShadow = new DropShadow(mc,filter1);
*				
*				var filter2:DropShadowFilter = new DropShadowFilter();
*				filter2.distance = 50;
*				var myDropShadow2:DropShadow = new DropShadow(mc,filter2);
*				myDropShadow2.setStartValues([dropShadowFilter1]);
* 
*				var filter3:DropShadowFilter = new DropShadowFilter();
*				filter3.distance = 4;
*				var myDropShadow3:DropShadow = new DropShadow(mc,filter3);
*				myDropShadow3.setStartValues([dropShadowFilter2]);
* 
*				var filter4:DropShadowFilter = new DropShadowFilter();
*				filter4.angle = 180;
*				var myDropShadow4:DropShadow = new DropShadow(mc,filter4);
*				myDropShadow4.setStartValues([dropShadowFilter3]);
* 
*				var filter5:DropShadowFilter = new DropShadowFilter();
*				filter5.angle = 45;
*				filter5.blurX = 20;
*				filter5.blurY = 20;
*				var myDropShadow5:DropShadow = new DropShadow(mc,filter5);
*				myDropShadow5.setStartValues([dropShadowFilter4]);
* 
*				var filter6:DropShadowFilter = new DropShadowFilter();
*				filter6.strength = 4;
*				filter6.alpha = 50;
*				var myDropShadow6:DropShadow = new DropShadow(mc,filter6);
*				myDropShadow6.setStartValues([dropShadowFilter5]);
* 
*				var mySequence:Sequence = new Sequence();
*				mySequence.addChild(myDropShadow1);
*				mySequence.addChild(myDropShadow2);
*				mySequence.addChild(myDropShadow3);
*				mySequence.addChild(myDropShadow4);
*				mySequence.addChild(myDropShadow5);
*				mySequence.addChild(myDropShadow6);
*				
*				mySequence.addEventListener("onEnd",this,"knockout");
*				mySequence.animationStyle(3000,Circ.easeInOut);
*				mySequence.animate(0,100);
*				
*				var innerStatus:Text = new Text();
*				innerStatus.setText("inner "+false,0,0);
*				var knockoutStatus:Text = new Text();
*				knockoutStatus.setText("knockout "+false,0,15);
*				var hideObjectStatus:Text = new Text();
*				hideObjectStatus.setText("hideObject "+false,0,30);
*				
*				function knockout(e:Object) {	
*					innerStatus.updateText("inner "+false);
*					knockoutStatus.updateText("knockout "+true);
*					hideObjectStatus.updateText("hideObject "+false);
*				
*					var children:Array = mySequence.getChildren();
*					for(var i:Number=0; i &lt; children.length; i++) {
*						children[i].inner = false;
*						children[i].knockout = true;
*						children[i].hideObject = false;
*					}
*					mySequence.removeEventListener("onEnd",this,"knockout");
*					mySequence.addEventListener("onEnd",this,"inner");
*					mySequence.animate(0,100);
*				}
*				
*				function inner(e:Object) {
*					innerStatus.updateText("inner "+true);
*					knockoutStatus.updateText("knockout "+false);
*					hideObjectStatus.updateText("hideObject "+false);
*					
*					var children:Array = mySequence.getChildren();
*					for(var i:Number=0; i &lt; children.length; i++) {
*						children[i].knockout = false;
*						children[i].inner = true;
*						children[i].hideObject = false;
*					}
*					mySequence.removeEventListener("onEnd",this,"inner");
*					mySequence.addEventListener("onEnd",this,"innerAndKnockout");
*					mySequence.animate(0,100);
*				}
*				function innerAndKnockout(e:Object) {
*					innerStatus.updateText("inner "+true);
*					knockoutStatus.updateText("knockout "+true);
*					hideObjectStatus.updateText("hideObject "+false);
*					
*					var children:Array = mySequence.getChildren();
*					for(var i:Number=0; i &lt; children.length; i++) {
*						children[i].inner = true;
*						children[i].knockout = true;
*						children[i].hideObject = false;
*					}
*					mySequence.removeEventListener("onEnd",this,"innerAndKnockout");
*					mySequence.addEventListener("onEnd",this,"hideObject");
*					mySequence.animate(0,100);
*				}
*				
*				function hideObject(e:Object) {
*					innerStatus.updateText("inner "+false);
*					knockoutStatus.updateText("knockout "+false);
*					hideObjectStatus.updateText("hideObject "+true);	
*					
*					var children:Array = mySequence.getChildren();
*					for(var i:Number=0; i &lt; children.length; i++) {
*						children[i].inner = false;
*						children[i].knockout = false;		
*						children[i].hideObject = true;
*					}
*					mySequence.removeEventListener("onEnd",this,"hideObject");
*					mySequence.addEventListener("onEnd",this,"original");
*					mySequence.animate(0,100);
*				}
*				
*				function original(e:Object) {
*					innerStatus.updateText("inner "+false);
*					knockoutStatus.updateText("knockout "+false);
*					hideObjectStatus.updateText("hideObject "+false);		
*					
*					var children:Array = mySequence.getChildren();
*					for(var i:Number=0; i &lt; children.length; i++) {
*						children[i].inner = false;
*						children[i].knockout = false;		
*						children[i].hideObject = false;
*					}
*					mySequence.removeEventListener("onEnd",this,"original");
* 					mySequence.addEventListener("onEnd",this,"knockout");
*					mySequence.animate(0,100);
*				}
* 			</pre></blockquote>
*
* @usage      
* 			<pre>var myInstance:DropShadow = new DropShadow(mc);</pre> 
* 			<pre>var myInstance:DropShadow = new DropShadow(mc, filter, duration, callback);</pre> 
* 			<pre>var myInstance:DropShadow = new DropShadow(mc, filter, duration, easing, callback);</pre>
* 			<pre>var myInstance:DropShadow = new DropShadow(mc, filterIndex, filter, duration, callback);</pre> 
* 			<pre>var myInstance:DropShadow = new DropShadow(mc, filterIndex, filter, duration, easing, callback);</pre>
*			<pre>var myInstance:DropShadow = new DropShadow(mc, values);</pre> 
* 			<pre>var myInstance:DropShadow = new DropShadow(mc, values, duration, callback);</pre> 
* 			<pre>var myInstance:DropShadow = new DropShadow(mc, values, duration, easing, callback);</pre> 
*			<pre>var myInstance:DropShadow = new DropShadow(mc, filterIndex, values);</pre> 
* 			<pre>var myInstance:DropShadow = new DropShadow(mc, filterIndex, values, duration, callback);</pre> 
* 			<pre>var myInstance:DropShadow = new DropShadow(mc, filterIndex, values, duration, easing, callback);</pre> 
* 			<pre>var myInstance:DropShadow = new DropShadow(mcs);</pre> 
* 			<pre>var myInstance:DropShadow = new DropShadow(mcs, filter, duration, callback);</pre> 
* 			<pre>var myInstance:DropShadow = new DropShadow(mcs, filter, duration, easing, callback);</pre>
* 			<pre>var myInstance:DropShadow = new DropShadow(mcs, filterIndex, filter, duration, callback);</pre> 
* 			<pre>var myInstance:DropShadow = new DropShadow(mcs, filterIndex, filter, duration, easing, callback);</pre>
*			<pre>var myInstance:DropShadow = new DropShadow(mcs, values);</pre> 
* 			<pre>var myInstance:DropShadow = new DropShadow(mcs, values, duration, callback);</pre> 
* 			<pre>var myInstance:DropShadow = new DropShadow(mcs, values, duration, easing, callback);</pre> 
*			<pre>var myInstance:DropShadow = new DropShadow(mcs, filterIndex, values);</pre> 
* 			<pre>var myInstance:DropShadow = new DropShadow(mcs, filterIndex, values, duration, callback);</pre> 
* 			<pre>var myInstance:DropShadow = new DropShadow(mcs, filterIndex, values, duration, easing, callback);</pre> 
* @param mc (MovieClip) Movieclip to animate.
* @param mcs (Array) array of movieclips to animate.
* @param filterIndex (Number) position of the element in the Movieclip's filter property that shall be manipulated.
* @param filter (DropShadowFilter) Targeted DropShadowFilter object to animate to.
* @param values (Array) optional start and end values.
* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
* @param callback (String) Function to invoke after animation. See AnimationCore class.
*/
class de.alex_uhlmann.animationpackage.animation.DropShadow 
											extends Filter 
											implements IMultiAnimatable {
	
	/*animationStyle properties inherited from AnimationCore*/
	/**
	* @property filterIndex (Number)
	* @property filters (Array)
	* @property color (Number) 
	* @property quality (Number)
	* @property inner (Boolean)
	* @property knockout (Boolean) 
	* @property hideObject (Boolean) 
	* @property movieclip (MovieClip) Movieclip to animate.
	* @property movieclips (Array) Array of Movieclips to animate.
	* @property duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @property easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @property callback (String) Function to invoke after animation. See AnimationCore class. 
	*/
	public var filter:DropShadowFilter;
	private var m_color:Number = 0x000000;
	private var m_quality:Number = 1;
	private var m_inner:Boolean = false;
	private var m_knockout:Boolean = false;
	private var m_hideObject:Boolean = false;

	public function DropShadow() {
		if(typeof(arguments[0]) == "movieclip") {
			this.mc = arguments[0];
		} else {
			this.mcs = arguments[0];
		}
		arguments.shift();
		this.init.apply(this, arguments);
	}

	public function setStartValues(startValues:Array, optional:Boolean):Boolean {
		this.hasStartValues = optional ? false : true;
		
		if(startValues[0] == null) {
			startValues[0] = createEmptyFilter();
		}
		if(startValues[0] instanceof DropShadowFilter) {			
			var filter:DropShadowFilter = startValues[0];
			
			if(this.hasStartValues) {
				this.setNonAnimatedProperties(filter);
			}
			
			return super.setStartValues([filter.distance, filter.angle, 
										filter.alpha, filter.blurX, 
										filter.blurY, filter.strength], optional);			
		} else {
			return super.setStartValues(startValues, optional);
		}
	}
	
	public function setEndValues(endValues:Array):Boolean {
		
		if(endValues[0] == null) {
			endValues[0] = createEmptyFilter();
		}
		if(endValues[0] instanceof DropShadowFilter) {
			
			var filter:DropShadowFilter = endValues[0];
			this.setNonAnimatedProperties(filter);
			
			return super.setEndValues([filter.distance, filter.angle, 
										filter.alpha, filter.blurX, 
										filter.blurY, filter.strength]);		
		} else {
			return super.setEndValues(endValues);
		}

	}
	
	private function initAnimation(filterIndex:Number, filterEnd:DropShadowFilter, 
							duration:Number, easing:Object, callback:String):Void {

		if(arguments.length > 2) {
			this.animationStyle(duration, easing, callback);
		} else {			
			this.animationStyle(this.duration, this.easing, this.callback);
		}	
		
		this.initializeFilter(filterIndex, filterEnd);
		
		this.setStartValues([this.filter], true);
		this.setEndValues([filterEnd]);
	}
	
	private function initializeFilter(filterIndex:Number, filterEnd:DropShadowFilter):Void {		
		if(this.mc != null) {	
			
			if(filterIndex == null) {				
				
				this.filter = this.createEmptyFilter();
				this.addFilter(this.filter);
				
			} else {			
				
				//if no filter of correct type is found at filterIndex, 
				//a new filter will be created.
				this.modifyOrCreateFilter(filterIndex);
			}
			
		} else {
			
			this.filterIndex = filterIndex;
			this.filter = filterEnd;
			
		}
	}
	
	
	private function modifyOrCreateFilter(filterIndex:Number):Void {		
		this.filter = DropShadowFilter(this.findFilter(filterIndex));
		this.filters = this.mc.filters;
		this.filterIndex = filterIndex;
	}

	private function isFilterOfCorrectType(filter:BitmapFilter):Boolean {
		return (filter instanceof DropShadowFilter == true);
	}
	
	private function createEmptyFilter(Void):DropShadowFilter {
		var filter:DropShadowFilter = new DropShadowFilter();
		filter.distance = 0;
		filter.angle = 0;
		filter.alpha = 0;
		filter.blurX = 0;
		filter.blurY = 0;
		filter.strength = 0;
		return filter;
	}
	
	private function initSingleMC(Void):Void {
		this.myAnimator.start = this.startValues;
		
		if(this.getOptimizationMode() 
			&& this.myAnimator.hasEquivalents()) {
				
			this.myAnimator.setter = [[this,"setDistance"],
								[this,"setAngle"],
								[this,"setAlpha"],
								[this,"setBlurX"],
								[this,"setBlurY"],
								[this,"setStrength"]];							
		} else {				
			this.myAnimator.setter = [[this,"setShadow"]];	
		}
	}
	
	private function initMultiMC(Void):Void {
		var myInstances:Array = [];			
		var len:Number = this.mcs.length;
		var mcs:Array = this.mcs;
		var i:Number = len;
		while(--i>-1) {
			myInstances[i] = new DropShadow(mcs[i],this.filterIndex,this.filter);			
			var filter:DropShadowFilter = this.updateFilter(createEmptyFilter());
			myInstances[i].setNonAnimatedProperties(filter);
		}
		this.myInstances = myInstances;

		this.myAnimator.multiStart = ["getMultiDistanceValue","getMultiAngleValue",
									"getMultiAlphaValue","getMultiBlurXValue",
									"getMultiBlurYValue","getMultiStrengthValue"];
									
		this.myAnimator.multiSetter = [[this.myInstances,"setDistance"],
									[this.myInstances,"setAngle"],
									[this.myInstances,"setAlpha"],
									[this.myInstances,"setBlurX"],
									[this.myInstances,"setBlurY"],
									[this.myInstances,"setStrength"]];	

	}
	
	private function updateFilter(filter:DropShadowFilter):DropShadowFilter {		
		filter.color = this.m_color;
		filter.quality = this.m_quality;
		filter.inner = this.m_inner;
		filter.knockout = this.m_knockout;
		filter.hideObject = this.m_hideObject;		
		return filter;
	}
	
	private function updateProperties(filter:BitmapFilter):Void {
		this.filter = updateFilter(DropShadowFilter(filter));
		this.setStartValues([this.filter], true);		
	}
	
	private function setNonAnimatedProperties(filter:DropShadowFilter):Void {
		this.color = filter.color;
		this.quality = filter.quality;
		this.inner = filter.inner;
		this.knockout = filter.knockout;
		this.hideObject = filter.hideObject;
	}	
	
	public function getMultiDistanceValue(Void):Number {
		return this.filter.distance;
	}	
	
	public function getMultiAngleValue(Void):Number {
		return this.filter.angle;
	}
	
	public function getMultiAlphaValue(Void):Number {
		return this.filter.alpha;
	}
	
	public function getMultiBlurXValue(Void):Number {
		return this.filter.blurX;
	}
	
	public function getMultiBlurYValue(Void):Number {
		return this.filter.blurY;
	}
	
	public function getMultiStrengthValue(Void):Number {
		return this.filter.strength;
	}	
		
	public function setShadow(distance:Number, angle:Number, 
							alpha:Number, blurX:Number, 
							blurY:Number, strength:Number):Void {
		
		this.filter.distance = distance;
		this.filter.angle = angle;
		this.filter.alpha = alpha;
		this.filter.blurX = blurX;
		this.filter.blurY = blurY;
		this.filter.strength = strength;
		this.filters[this.filterIndex] = this.filter;
		this.mc.filters = this.filters;
	}

	public function setDistance(distance:Number):Void {		
		this.filter.distance = distance;		
		this.filters[this.filterIndex] = this.filter;
		this.mc.filters = this.filters;
	}	

	public function setAngle(angle:Number):Void {		
		this.filter.angle = angle;
		this.filters[this.filterIndex] = this.filter;
		this.mc.filters = this.filters;
	}	
	
	public function setAlpha(alpha:Number):Void {		
		this.filter.alpha = alpha;		
		this.mc.filters = [this.filter];
	}	

	public function setBlurX(blurX:Number):Void {		
		this.filter.blurX = blurX;
		this.filters[this.filterIndex] = this.filter;
		this.mc.filters = this.filters;
	}
	
	public function setBlurY(blurY:Number):Void {		
		this.filter.blurY = blurY;		
		this.filters[this.filterIndex] = this.filter;
		this.mc.filters = this.filters;
	}
	
	public function setStrength(strength:Number):Void {		
		this.filter.strength = strength;		
		this.filters[this.filterIndex] = this.filter;
		this.mc.filters = this.filters;
	}

	public function get color():Number {
		return this.m_color;
	}
	
	public function set color(color:Number):Void {
		this.filter.color = color;
		this.m_color = color;
	}
	
	public function get quality():Number {
		return this.m_quality;
	}
	
	public function set quality(quality:Number):Void {
		this.filter.quality = quality;
		this.m_quality = quality;
	}
	
	public function get inner():Boolean {
		return this.m_inner;
	}
	
	public function set inner(inner:Boolean):Void {
		this.filter.inner = inner;
		this.m_inner = inner;
	}	
	
	public function get knockout():Boolean {
		return this.m_knockout;
	}
	
	public function set knockout(knockout:Boolean):Void {
		this.filter.knockout = knockout;
		this.m_knockout = knockout;
	}
	
	public function get hideObject():Boolean {
		return this.m_hideObject;
	}
	
	public function set hideObject(hideObject:Boolean):Void {
		this.filter.hideObject = hideObject;
		this.m_hideObject = hideObject;
	}
	
	/*inherited from AnimationCore*/
	
	/**
	* @method run
	* @description  		
	* @usage   
	* 
	* 		the same overloading applies to this method as described in the 
	* 		constructor. Just without the mc and mcs parameters.
	*/
	
	/**
	* @method animate
	* @description 	similar to the run() method. Offers start and end parameters.
	* @usage   <pre>myInstance.animate(start, end);</pre> 	  
	* @param start (Number) start value. Percentage.
	* @param end (Number) end value. Percentage.
	* @return void
	*/
	
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
	* @usage   <pre>myInstance.animationStyle(duration);</pre>
	* 		<pre>myInstance.animationStyle(duration, callback);</pre>
	* 		<pre>myInstance.animationStyle(duration, easing, callback);</pre>
	* 	  
	* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @param callback (String) Function to invoke after animation. See APCore class.
	*/
	
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
	* @description 	returns the original, starting value of the current tween. In degrees.
	* @usage   <tt>myInstance.getStartValue();</tt>
	* @return Number
	*/

	/**
	* @method setStartValue
	* @description 	sets the original, starting value of the current tween. In degrees.
	* @usage   <tt>myInstance.setStartValue(startValue);</tt>
	* @param startValue (Number)	
	* @return Boolean, indicates if the assignment was performed.
	*/	
	
	/**
	* @method getEndValue
	* @description 	returns the targeted value of the current tween. In degrees.
	* @usage   <tt>myInstance.getEndValue();</tt>
	* @return Number
	*/
	
	/**
	* @method setEndValue
	* @description 	sets the targeted value of the current tween. In degrees.
	* @usage   <tt>myInstance.setEndValue(endValue);</tt>
	* @param endValue (Number)	
	* @return Boolean, indicates if the assignment was performed.
	*/	

	/**
	* @method getCurrentValue
	* @description 	returns the current value of the current tween. In degrees.
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
		return "DropShadow";
	}
}