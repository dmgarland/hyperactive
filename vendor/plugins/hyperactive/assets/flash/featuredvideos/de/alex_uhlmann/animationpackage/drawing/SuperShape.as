import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.IMultiAnimatable;
import de.alex_uhlmann.animationpackage.drawing.Shape;
import de.alex_uhlmann.animationpackage.utility.Animator;

/**
* @class SuperShape
* @author Alex Uhlmann
* @description SuperShape allows you to draw many different shapes based on the Superformula developed by 
* 			<a href="http://www.genicap.com/">Johan Gielis</a>.
* 			The Superformula used by SuperShape is one simple equation that can generate a vast diversity of natural shapes.
*			 It produces everything from simple triangles and pentagons, to stars, spirals and petals.
* 			More information on the Superformula: <a href="http://astronomy.swin.edu.au/~pbourke/curves/supershape">Paul Bourke</a>.
* 			Based on the first Flash implementations of <a href="http://www.flashforum.de/forum/showthread.php?s=&threadid=120213">Flashforum members</a>,
* 			Especially based on e2e4 and i++ contributions. 
* 			If you specify a movieclip as first parameter, the shape will be drawn inside this movieclip.
* 			If you omit the mc parameter, the class will create a new movieclip in _root.apContainer_mc.
* 			<p>
* 			Here is an application that may help you testing different parameters of SuperShape: <a href="SuperShape_preview.html">(Testing application)</a>
* 			<p>
* 			Example 1: Some shape manipulations. <a href="SuperShape_01.html">(Example .swf)</a> 
* 			<blockquote><pre>
*			var mySuperShape:SuperShape = new SuperShape(300,300);
*			//like the MovieClip lineStyle(), lineStyle in AnimationPackage also omits the line if you call it without a parameter.
*			mySuperShape.lineStyle();
*			mySuperShape.fillStyle(0xff0000);
*			
*			mySuperShape.animationStyle(3000,Sine.easeInOut,"onStart");
*			mySuperShape.setPreset("burst");
*			
*			mySuperShape.addPreset({label:"rounded Polygon", data:{m:5, n1:1, n2:1.7, n3:1.7, range:2, scaling:2, detail:1000}});
*			
*			mySuperShape.morph("burst","rounded Polygon");
*			
*			myListener.onStart = function() {	
*				mySuperShape.callback = "onRoundStar";
*				mySuperShape.animateProps(["n1"],[0.09]);
*			}
*			myListener.onRoundStar = function() {	
*				mySuperShape.callback = "onN1Out";
*				mySuperShape.animateProps(["n1"],[1]);
*			}
*			myListener.onN1Out = function() {	
*				mySuperShape.callback = "onN2In";
*				mySuperShape.animateProps(["n2"],[6]);
*			}
*			myListener.onN2In = function() {	
*				mySuperShape.callback = "onN2Out";
*				mySuperShape.animateProps(["n2"],[1]);
*			}
*			myListener.onN2Out = function() {		
*				mySuperShape.callback = "onN3In";
*				mySuperShape.animateProps(["n2","n3"],[6,6]);
*			}
*			myListener.onN3In = function() {
*				mySuperShape.callback = null;
*				mySuperShape.animateProps(["n2","n3"],[1,1]);
*			}
* 			</pre></blockquote>
* 			<p>
* 			Example 2: Some other shape manipulations. <a href="SuperShape_02.html">(Example .swf)</a>
* 			<blockquote><pre>
* 			var mySuperShape:SuperShape = new SuperShape(300,300);
*			mySuperShape.lineStyle(3,0xff0000);
*			mySuperShape.fillStyle();
*			mySuperShape.animationStyle(3000,Sine.easeInOut,"on01");
*			mySuperShape.addPreset({label:"0", data:{m:10, n1:0, n2:1.7, n3:0, range:2, scaling:2, detail:1000}});
*			mySuperShape.addPreset({label:"1", data:{m:10, n1:1, n2:1.7, n3:1.7, range:2, scaling:2, detail:1000}});
*			mySuperShape.morph("0","1");
*			myListener.on01 = function() {	
*				mySuperShape.callback = "on23";
*				mySuperShape.addPreset({label:"2", data:{m:10, n1:3, n2:1.3, n3:8, range:2, scaling:2, detail:1000}});
*				mySuperShape.morph("1","2");
*			}
*			myListener.on23 = function() {	
*				mySuperShape.callback = "on34";
*				mySuperShape.addPreset({label:"3", data:{m:10, n1:.2, n2:1.3, n3:8, range:2, scaling:2, detail:1000}});
*				mySuperShape.morph("2","3");
*			}
*			myListener.on34 = function() {	
*				mySuperShape.callback = "on45";
*				mySuperShape.addPreset({label:"4", data:{m:10, n1:1.1, n2:0.5, n3:8, range:2, scaling:2, detail:1000}});
*				mySuperShape.morph("3","4");
*			}
*			myListener.on45 = function() {	
*				mySuperShape.callback = "on56";
*				mySuperShape.addPreset({label:"5", data:{m:10, n1:0.5, n2:0.1, n3:16.4, range:2, scaling:2, detail:1000}});
*				mySuperShape.morph("4","5");
*			}
*			myListener.on56 = function() {		
*				mySuperShape.callback = "on67";
*				mySuperShape.addPreset({label:"6", data:{m:10, n1:0.5, n2:0.1, n3:1, range:2, scaling:2, detail:1000}});
*				mySuperShape.morph("5","6");
*			}
*			myListener.on67 = function() {
*				mySuperShape.callback = null;
*				mySuperShape.addPreset({label:"7", data:{m:10, n1:0.5, n2:0.1, n3:.1, range:2, scaling:2, detail:2000}});
*				mySuperShape.morph("6","7");
*			}
* 			</pre></blockquote>
* 			Reader Exercise: Do some shape manipulations via the gradientStyle method.
* @usage  <pre>var mySuperShape:SuperShape = SuperShape();</pre>
* 		<pre>var mySuperShape:SuperShape = SuperShape(x, y, m, n1, n2, n3, range, scaling, detail);</pre>
* 		<pre>var mySuperShape:SuperShape = SuperShape(mc, x, y, m, n1, n2, n3, range, scaling, detail);</pre>
* @param mc (MovieClip) existing movieclip to draw in.
* @param x (Number) X position of the drawing. Center point.
* @param y (Number) Y position of the drawing. Center point.
* @param m (Number) 0 - 20. Defaults to 4.
* @param n1 (Number) 0 - 10000. Defaults to 1.
* @param n2 (Number) 0 - 10000. Defaults to 1.
* @param n3 (Number) 0 - 10000. Defaults to 1.
* @param range (Number) 0.5 - 20*PI. Defaults to 12.
* @param scaling (Number) 1 - 5. Defaults to 200.
* @param detail (Number) 1000 - 50000. Defaults to 10000.
*/
class de.alex_uhlmann.animationpackage.drawing.SuperShape 
											extends Shape 
											implements ISingleAnimatable, 
														IMultiAnimatable {

	/*static default properties*/
	/*lineStyle properties inherited from Shape*/
	/*fillStyle properties inherited from Shape*/
	/**
	* @property m_def (Number)(static) default property. Defaults to 4.
	* @property n1_def (Number)(static) default property. Defaults to 1.
	* @property n2_def (Number)(static) default property. Defaults to 1.
	* @property n3_def (Number)(static) default property. Defaults to 1.
	* @property range_def (Number)(static) default property. Defaults to 12.
	* @property scaling_def (Number)(static) default property. Defaults to 200.
	* @property detail_def (Number)(static) default property. Defaults to 10000.
	*
	* @property m (Number) Property of Superformula.
	* @property n1 (Number) Property of Superformula.
	* @property n2 (Number) Property of Superformula.
	* @property n3 (Number) Property of Superformula.
	* @property range (Number) Property of Superformula.
	* @property scaling (Number) Property of Superformula.
	* @property detail (Number) Property of Superformula.
	* @property animateFromCenter (Boolean) Causes the shape to be animated from the center. Default is set to false.
	*
	* @property movieclip (MovieClip)(read only) Movieclip that contains the drawing.
	* @property lineThickness (Number) Outline thickness.
	* @property lineRGB (Number) Outline color of the drawing as hex number.
	* @property lineAlpha (Number) Outline transparency (alpha).
	* @property fillRGB (Number) Fill color of the drawing.
	* @property fillAlpha (Number) Fill transparency.
	*/
	public static var m_def:Number = 4;
	public static var n1_def:Number = 1;
	public static var n2_def:Number = 1;
	public static var n3_def:Number = 1;
	public static var range_def:Number = 12;
	public static var scaling_def:Number = 200;
	public static var detail_def:Number = 10000;
	private var x:Number = 0;
	private var y:Number = 0;
	private var m_m:Number;
	private var m_n1:Number;
	private var m_n2:Number;
	private var m_n3:Number;
	private var m_range:Number;
	private var m_scaling:Number;
	private var m_detail:Number;
	private var presets:Object;
	private var forward:Boolean = true;
	private var redrawBool:Boolean = true;
	private var counter:Number;
	private var counterMax:Number;
	private var multipleValues:Boolean = false;
	/* if true, shape gets drawn from the center.*/
	private var m_animateFromCenter:Boolean = false;
	/*points already calculated by getPointsOnCurve*/
	private var calculatedPoints:Array;

	public function SuperShape() {
		super();
		this.init.apply(this,arguments);
		this.fillStyle(null);
	}

	private function init():Void {
		if(typeof(arguments[0]) == "movieclip") {
			this.initCustom.apply(this,arguments);
		} else {
			this.initAuto.apply(this,arguments);
		}
	}

	private function initCustom(mc:MovieClip, x:Number, y:Number,
						m:Number, n1:Number, n2:Number, n3:Number,
						range:Number, scaling:Number, detail:Number):Void {

		this.mc = this.createClip({mc:mc, x:x, y:y});
		this.initShape.apply(this,arguments.slice(1));
	}

	private function initAuto( x:Number, y:Number,
						m:Number, n1:Number, n2:Number, n3:Number,
						range:Number, scaling:Number, detail:Number):Void {

		this.mc = this.createClip({name:"apDraw", x:x, y:y});
		this.initShape.apply(this,arguments);
	}

	private function initShape( x:Number, y:Number,
						m:Number, n1:Number, n2:Number, n3:Number,
						range:Number, scaling:Number, detail:Number):Void {

		this.initPresets();
		this.initParams.apply(this,arguments.slice(2));
	}

	private function initPresets(Void):Void {
		this.presets = new Object();
		this.addPreset({label:"circle", data:{m:0, n1:1, n2:1, n3:1, range:2, scaling:2, detail:1000}});
		this.addPreset({label:"square", data:{m:4, n1:1, n2:1, n3:1, range:2, scaling:2, detail:1000}});
		this.addPreset({label:"triangle", data:{m:3, n1:1, n2:1, n3:1, range:2, scaling:2, detail:1000}});
		this.addPreset({label:"burst", data:{m:5, n1:1, n2:1, n3:1, range:2, scaling:2, detail:1000}});
		this.addPreset({label:"radioactive", data:{m:3, n1:10000, n2:9999, n3:9999, range:2, scaling:2, detail:1000}});
		this.addPreset({label:"windmill", data:{m:15, n1:10000, n2:9000, n3:9000, range:2, scaling:2, detail:1000}});
		this.addPreset({label:"drop", data:{m:1 / 6, n1:.3, n2:.3, n3:.3, range:12, scaling:2, detail:1000}});
		this.addPreset({label:"star3peaks", data:{m:3, n1:.3, n2:.3, n3:.3, range:12, scaling:2, detail:1000}});
		this.addPreset({label:"star4peaks", data:{m:4, n1:.3, n2:.3, n3:.3, range:12, scaling:2, detail:1000}});
		this.addPreset({label:"star5peaks", data:{m:5, n1:.3, n2:.3, n3:.3, range:12, scaling:2, detail:1000}});
	}

	private function initParams(m:Number, n1:Number, n2:Number, n3:Number,
					range:Number, scaling:Number, detail:Number):Void {

		this.m_m = (m == null) ? SuperShape.m_def : m;
		this.m_n1 = (n1 == null) ?SuperShape.n1_def : n1;
		this.m_n2 = (n2 == null) ? SuperShape.n2_def : n2;
		this.m_n3 = (n3 == null) ? SuperShape.n3_def : n3;
		this.m_range = (range == null) ? SuperShape.range_def : range;
		this.m_scaling = (scaling == null) ? SuperShape.scaling_def : scaling *= 100;
		this.m_detail = (detail == null) ? SuperShape.detail_def : detail;
	}
	
	/**
	* @method draw
	* @description 	Draws supershape.
	* @usage <pre>mySuperShape.draw();</pre>
	* 		<pre>mySuperShape.draw(start, end);</pre>
	* @param start (Number) optional. value to beginn the drawing.
	* @param end (Number) optional. value to end the drawing.
	*/
	public function draw(Void):Void {
		var start:Number = arguments[0];
		var end:Number = arguments[1];
		this.redrawBool = false;
		if(start == null && end == null) {
			start = 0;
			end = 100;
		}
		var endDetail:Number = end / 100 * this.m_detail;
		if(start > end) {
			this.forward = false;
		} else {
			this.forward = true;
		}
		this.drawNewShape(endDetail);
	}

	/*
	* redraws the shape in each iteration like every animated shape in AnimationPackage.
	* Bounce, Elastic and Back Easing is possible. Due to the complex operations for the superformula
	* this can be very slow.
	*/
	/**
	* @method animate
	* @description 	Draws an animated supershape.
	*			<p>
	* 			Example 1: <a href="SuperShape_animate_01.html">(Example .swf)</a> draw a circle backwards with default parameters.
	*			<blockquote><pre>
	* 			var mySuperShape:SuperShape = new SuperShape(275,200);
	*			mySuperShape.setPreset("circle");
	* 			mySuperShape.fillStyle(0xff0000);	
	*			mySuperShape.animate(100,0);
	*			</pre></blockquote>
	* 			Example 2: <a href="SuperShape_animate_02.html">(Example .swf)</a> draw a more complex star with custom parameters.
	*			<blockquote><pre>
	* 			var mySuperShape:SuperShape = new SuperShape(200, 200, 19/6, .3, .3, .3, 12, 2, 5000);
	*			mySuperShape.fillStyle();
	*			mySuperShape.animationStyle(10000);
	*			mySuperShape.animate(0,100);
	*			</pre></blockquote>
	*
	* @usage  <pre>mySuperShape.animate(start, end);</pre>
	* @param start (Number) Value to beginn the drawing.
	* @param end (Number) Value to end the drawing.
	*/
	public function animate(start:Number, end:Number):Void {
		this.redrawBool = true;
		this.invokeAnimation(start, end);
	}	
	
	/**
	* @method animateProps
	* @description 	Animates a property or properies specified as a String in propArr to the specified number value or values in endArr.
	* 				<p>
	* 				Example 1: <a href="SuperShape_animateProps_01.html">(Example .swf)</a> manipulate the border of a circle.
	* 				<blockquote><pre>
	* 				var mySuperShape:SuperShape = new SuperShape(275,200);
	*				mySuperShape.lineStyle(6);
	*				mySuperShape.fillStyle(0xff0000);
	*				mySuperShape.animationStyle(6000,Circ.easeOut,"onDetailOut");
	*				mySuperShape.setPreset("circle");
	*				mySuperShape.animateProps(["detail"],[3]);
	*				myListener.onDetailOut = function() {
	*					mySuperShape.animationStyle(6000,Circ.easeIn,null);
	*					mySuperShape.animateProps(["detail"],[1000]);
	*				}
	* 				</pre></blockquote><p>
	* 				See class documentation for another example.
	* @usage <pre>mySuperShape.animateProps(propArr, endArr);</pre>
	* @param propArr (Array) Array of Strings. See class properties for available properties.
	* @param endArr (Array) Array of Numbers.
	*/
	public function animateProps(propArr:Array, endArr:Array):Void {
		this.myAnimator = new Animator();
		this.myAnimator.animationStyle(this.duration, this.easing, this.callback);
		this.myAnimator.caller = this;
		var startArr:Array = new Array();
		var setterArr:Array = new Array();
		var i:Number = propArr.length;
		while(--i>-1) {
			startArr.push(this["m_"+propArr[i]]);
			setterArr.push(new Array(this,"a_"+propArr[i]));
		}
		this.counter = 0;
		this.counterMax = startArr.length;
		if(this.counterMax > 1) {
			this.multipleValues = true;
			this.startValues = startArr;
			this.endValues = endArr;
		} else {
			this.multipleValues = false;
			this.startValue = startArr[0];
			this.endValue = endArr[0];
		}
		this.myAnimator.start = startArr;
		this.myAnimator.end = endArr;
		this.myAnimator.setter = setterArr;
		this.myAnimator.run();
	}

	private function a_m(v:Number):Void {
		this.m_m = v;
		this.collect();
	}
	private function a_n1(v:Number):Void {
		this.m_n1 = v;
		this.collect();
	}
	private function a_n2(v:Number):Void {
		this.m_n2 = v;
		this.collect();
	}
	private function a_n3(v:Number):Void {
		this.m_n3 = v;
		this.collect();
	}
	private function a_range(v:Number):Void {
		this.m_range = v;
		this.collect();
	}
	private function a_scaling(v:Number):Void {
		this.m_scaling = v;
		this.collect();
	}
	private function a_detail(v:Number):Void {
		this.m_detail = v;
		this.collect();
	}

	private function collect(Void):Void {
		this.counter++;
		if(this.counter == this.counterMax) {
			this.counter = 0;			
			this.drawNewShape(this.m_detail);
		}
	}	

	/**
	* @method morph
	* @description 	Morphs a shape from a specified preset to another.
	* 				To read about presets, take a look at addPreset() and setPreset().
	* 				See class documentation for an example.
	* @usage <pre>mySuperShape.morph(presetStart, presetEnd);</pre>
	* @param presetStart (String) preset label to start mophing.
	* @param presetEnd (String) preset label to moph to.
	*/
	public function morph(presetStart:String, presetEnd:String):Void {
		var p1:Object = this.presets[presetStart];
		var p2:Object = this.presets[presetEnd];
		this.initParams(p1.m, p1.n1, p1.n2, p1.n3, p1.range, p1.scaling, p1.detail);
		this.myAnimator = new Animator();
		this.myAnimator.animationStyle(this.duration, this.easing, this.callback);
		this.myAnimator.caller = this;
		var startArr:Array = new Array();
		var endArr:Array = new Array();
		var setterArr:Array = new Array();
		/*determine difference between preset shapes and animate with Animator.*/
		if(p1.m != p2.m) {
			startArr.push(p1.m);
			endArr.push(p2.m);
			setterArr.push(new Array(this,"a_m"));
		}
		if(p1.n1 != p2.n1) {
			startArr.push(p1.n1);
			endArr.push(p2.n1);
			setterArr.push(new Array(this,"a_n1"));
		}
		if(p1.n2 != p2.n2) {
			startArr.push(p1.n2);
			endArr.push(p2.n2);
			setterArr.push(new Array(this,"a_n2"));
		}
		if(p1.n3 != p2.n3) {
			startArr.push(p1.n3);
			endArr.push(p2.n3);
			setterArr.push(new Array(this,"a_n3"));
		}
		if(p1.range != p2.range) {
			startArr.push(p1.range);
			endArr.push(p2.range);
			setterArr.push([this,"a_range"]);
		}
		if(p1.scaling != p2.scaling) {
			startArr.push(p1.scaling);
			endArr.push(p2.scaling);
			setterArr.push([this,"a_scaling"]);
		}
		if(p1.detail != p2.detail) {
			startArr.push(p1.detail);
			endArr.push(p2.detail);
			setterArr.push([this,"a_detail"]);
		}
		this.counter = 0;
		this.counterMax = startArr.length;
		if(this.counterMax > 1) {
			this.multipleValues = true;
			this.startValues = startArr;
			this.endValues = endArr;
		} else {
			this.multipleValues = false;
			this.startValue = startArr[0];
			this.endValue = endArr[0];
		}
		this.myAnimator.start = startArr;
		this.myAnimator.end = endArr;
		this.myAnimator.setter = setterArr;
		this.myAnimator.run();
	}

	/**
	* @method addPreset
	* @description 	Adds a new preset object to SuperShape. Overwrites an existing preset with the same label.
	*			A preset is an object that contains parameters that represent a shape.
	*			<p>
	* 			Example 1: <a href="SuperShape_addPreset_01.html">(Example .swf)</a> Add the the german military logo as a preset
	* 			and draw it with default parameters.
	*			<blockquote><pre>
	* 			var mySuperShape:SuperShape = new SuperShape(275,200);
	*			mySuperShape.addPreset({label:"Bundeswehr", data:{m:4, n1:10000, n2:8000, n3:8000, range:2, scaling:2, detail:1000}});
	*			mySuperShape.setPreset("Bundeswehr");
	*			mySuperShape.draw();
	*			</pre></blockquote>
	*
	* @usage  <pre>mySuperShape.addPreset(item);</pre>
	* @param item (Object) the object that defines the preset. Like an item of the Macromedia DataProvider, item needs to have another label and data object inside.
	*/
	public function addPreset(item:Object):Void {
		if(this.presets[item.label] != null) {
			trace("Preset "+this.presets[item.label]+" overwritten!");
		}
		this.presets[item.label] = item.data;
	}

	/**
	* @method getPreset
	* @description 	Returns the preset object.
	* 			A preset is an object that contains parameters that represent a shape.
	* 			If you specify the label of an available preset as a parameter, only
	* 			the chosen preset is return. If you don't send a parameter,
	* 			all presets will be returned.
	* @usage  <pre>mySuperShape.getPreset();</pre>
	* 		<pre>mySuperShape.getPreset(preset);</pre>
	* @param preset (String) the label of an available preset.
	* @return Object that contains the preset.
	*/
	public function getPreset(preset:String):Object {
		if(preset != null) {
			return this.presets[preset];
		}
		return this.presets;
	}

	/**
	* @method setPreset
	* @description 	Sets the preset object.
	*			A preset is an object that contains parameters that represent a shape. There are predefined presets available.
	* 			You can add further presets with addPreset().
	*			<p>
	* 			Example 1: <a href="SuperShape_setPreset_01.html">(Example .swf)</a> draw a circle with default parameters.
	*			<blockquote><pre>
	* 			var mySuperShape:SuperShape = new SuperShape(275,200);
	*			mySuperShape.setPreset("circle");
	*			mySuperShape.draw();
	*			</pre></blockquote>
	* 			Example 2: <a href="SuperShape_setPreset_02.html">(Example .swf)</a> draw an animated square with custom parameters.
	*			<blockquote><pre>
	* 			var mySuperShape:SuperShape = new SuperShape(275,200);
	* 			mySuperShape.lineStyle(0);
	*			mySuperShape.fillStyle(0xff0000);
	*			mySuperShape.animationStyle(10000,Sine.easeOut);
	*			mySuperShape.setPreset("square");
	*			mySuperShape.animate(0,100);
	*			</pre></blockquote>
	*
	* @usage  <pre>mySuperShape.setPreset(preset);</pre>
	* @param preset (String) the label of an available preset.
	*/
	public function setPreset(preset:String):Void {
		var p:Object = this.presets[preset];
		this.initParams(p.m, p.n1, p.n2, p.n3, p.range, p.scaling, p.detail);
	}
	
	private function invokeAnimation(start:Number, end:Number):Void {
		this.startInitialized = false;
		
		this.calculatedPoints = new Array();
		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		var startDetail:Number = 0;
		this.myAnimator.start = [startDetail];
		this.setStartValue(startDetail);
		this.multipleValues = false;
		var endDetail:Number = this.m_detail;
		if(start > end) {
			this.forward = false;
		} else {
			this.forward = true;
		}
		this.myAnimator.end = [endDetail];
		this.setEndValue(endDetail);
		this.myAnimator.setter = [[this,"drawNewShape"]];
		if(end != null) {
			this.myAnimator.animationStyle(this.duration, this.easing, this.callback);
			this.myAnimator.animate(start, end);
		} else {
			this.myAnimator.goto(start);
		}
	}
	
	private function drawNewShape(s:Number):Void {
		this.clearDrawing();
		if (this.fillRGB != null && this.fillGradient == false) {
			this.mc.beginFill(this.fillRGB, this.fillAlpha);
		} else if (this.fillGradient == true){
			this.mc.beginGradientFill(this.gradientFillType, this.gradientColors, this.gradientAlphas, this.gradientRatios, this.gradientMatrix);
		}
		this.drawShape(s);
		this.mc.endFill();
	}
	
	/* Optimized, less readable code.*/
	private function drawShape(s:Number):Void {
		var mc:MovieClip = this.mc;
		var m:Number = this.m_m;
		var n1:Number = this.m_n1;
		var n2:Number = this.m_n2;
		var n3:Number = this.m_n3;
		var ra:Number = this.m_range;
		var sc:Number = this.m_scaling;
		var d:Number = this.m_detail;
		if(s == null) {
			s = d;
		}
		var phi:Number;
		var pi:Number = Math.PI;
		/*
		* getPoint() variables. To improve performance, 
		* the implementation of getPoint() is also included in drawShape, 
		* saving another function call in loops.
		*/
		var r:Number;
		var x:Number, y:Number;
		var cos:Function = Math.cos;
		var sin:Function = Math.sin;
		var pow:Function = Math.pow;
		var abs:Function = Math.abs;		
		var p:Number;
		var q:Object;
		//cache
		var calc:Array = this.calculatedPoints;
		/*calculate starting point if not animated from center*/				
		if(this.animateFromCenter == false) {			
			var pos1:Object = this.getPoint(m, n1, n2, n3, 0);
			mc.moveTo(pos1.x * sc, pos1.y * sc);
		}
		var i:Number;
		if(this.forward) {
			for(i = 0; i <= s; i++) {
				if(calc[i] == null) {
					phi = ra * pi * (i / d);				
					p = m * phi / 4;		
					r = pow(pow(abs(cos(p) / 1), n2) -(-pow(abs(sin(p) / 1), n3)), 1 / n1);
					if (r == 0) {
						x = y = 0;
					}
					else {
						r = 1 / r;
						x = r * cos(phi) * sc;
						y = r * sin(phi) * sc;
					}
					q = calc[i] = {x:x, y:y};
				} else {
					q = calc[i];
				}
				mc.lineTo(q.x, q.y);
			}
		} else {
			i = s;
			while(--i>-1) {
				if(calc[i] == null) {
					phi = ra * pi * (i / d);				
					p = m * phi / 4;		
					r = pow(pow(abs(cos(p) / 1), n2) -(-pow(abs(sin(p) / 1), n3)), 1 / n1);
					if (r == 0) {
						x = y = 0;			
					}
					else {
						r = 1 / r;
						x = r * cos(phi) * sc;
						y = r * sin(phi) * sc;
					}
					q = calc[i] = {x:x, y:y};
				} else {
					q = calc[i];
				}		
				mc.lineTo(q.x, q.y);
			}
		}	
	}
	
	/* Optimized, less readable code.*/
	private function getPoint(m:Number, n1:Number, n2:Number, n3:Number, phi:Number):Object {		
		var r:Number;		
		var x:Number, y:Number;
		var cos:Function = Math.cos;
		var sin:Function = Math.sin;
		var pow:Function = Math.pow;
		var abs:Function = Math.abs;		
		var p:Number;
		p = m * phi / 4;		
		r = pow(pow(abs(cos(p) / 1), n2) -(-pow(abs(sin(p) / 1), n3)), 1 / n1);
		if (r == 0) {
			x = y = 0;			
		}
		else {
			r = 1 / r;
			x = r * cos(phi);
			y = r * sin(phi);
		}		
		return {x:x, y:y};
	}
	
	/*getter / setter*/
	public function get m():Number {
		return this.m_m;
	}

	public function set m(m:Number):Void {
		this.m_m = m;
	}

	public function get n1():Number {
		return this.m_n1;
	}

	public function set n1(n1:Number):Void {
		this.m_n1 = n1;
	}

	public function get n2():Number {
		return this.m_n2;
	}

	public function set n2(n2:Number):Void {
		this.m_n2 = n2;
	}

	public function get n3():Number {
		return this.m_n3;
	}

	public function set n3(n3:Number):Void {
		this.m_n3 = n3;
	}

	public function get range():Number {
		return this.m_range;
	}

	public function set range(range:Number):Void {
		this.m_range = range;
	}

	public function get scaling():Number {
		return this.m_scaling;
	}

	public function set scaling(scaling:Number):Void {
		this.m_scaling = scaling;
	}

	public function get detail():Number {
		return this.m_detail;
	}

	public function set detail(detail:Number):Void {
		this.m_detail = detail;
	}	
	
	public function get animateFromCenter():Boolean {
		return this.m_animateFromCenter;
	}

	public function set animateFromCenter(bool:Boolean):Void {
		this.m_animateFromCenter = bool;
	}	
	
	public function getStartValue(Void):Number {		
		return 0;
	}
	
	public function getEndValue(Void):Number {		
		return 100;
	}
	
	public function getCurrentValue(Void):Number {
		var start:Number;
		var end:Number;
		var current:Number;		
		var multipleValues:Boolean;
		
		if(this.multipleValues) {
			start = this.startValues[0];
			end = this.endValues[0];
			current = this.currentValues[0];
		} else {
			start = this.startValue;
			end = this.endValue;
			current = this.currentValue;
		}
		if(start < end) {				
			return (current - start) / (end - start) * 100;
		} else {
			return 100 - ((current - end) / (start - end) * 100);
		}
	}	
	
	/*inherited from Shape*/
	/**
	* @method lineStyle
	* @description 	define outline.
	*
	* @usage   <pre>mySuperShape.lineStyle();</pre>
	* 		<pre>mySuperShape.lineStyle(lineThickness, lineRGB, lineAlpha);</pre>
	*
	* @param lineThickness (Number) Outline thickness.
	* @param lineRGB (Number) Outline color of the drawing as hex number.
	* @param lineAlpha (Number) Outline transparency (alpha).
	*/

	/*inherited from Shape*/
	/**
	* @method fillStyle
	* @description 	define fill.
	*
	* @usage   <pre>mySuperShape.fillStyle();</pre>
	* 		<pre>mySuperShape.fillStyle(fillRGB, fillAlpha);</pre>
	*
	* @param fillRGB (Number) Fill color of the drawing.
	* @param fillAlpha (Number) Fill transparency.
	*/
	
	/**
	* @method gradientStyle
	* @description	 Same interface as MovieClip.beginGradientFill(). See manual.
	* 		
	* @usage   <pre>mySuperShape.gradientStyle(fillType, colors, alphas, ratios, matrix);</pre>
	* 	  
	* @param fillType (String)  Gradient property. See MovieClip.beginGradientFill().
	* @param colors (Array)  Gradient property. See MovieClip.beginGradientFill().
	* @param alphas (Array)  Gradient property. See MovieClip.beginGradientFill().
	* @param ratios (Array)  Gradient property. See MovieClip.beginGradientFill().
	* @param matrix (Object)  Gradient property. See MovieClip.beginGradientFill().
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
	* @usage   <pre>mySuperShape.animationStyle(duration);</pre>
	* 		<pre>mySuperShape.animationStyle(duration, callback);</pre>
	* 		<pre>mySuperShape.animationStyle(duration, easing, callback);</pre>
	*
	* @param duration (Number) Duration of animation in milliseconds or frames. Default is milliseconds.
	* @param easing (Object) Easing equation in Robert Penner style. Default equation is Linear.easeNone. www.robertpenner.com/easing/
	* @param callback (String) Function to invoke after animation. See APCore class.
	*/
	
	/**
	* @method clear
	* @description 	removes all drawings. Identical to myInstance.movieclip.clear();
	* @usage <pre>myInstance.clear();</pre>
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
	* @usage   <pre>mySuperShape.addEventListener(event, listener);</pre>
	* 		    <pre>mySuperShape.addEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>mySuperShape.removeEventListener(event, listener);</pre>
	* 		    <pre>mySuperShape.removeEventListener(event, listener, handler);</pre>
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
	* @usage   <pre>mySuperShape.removeAllEventListeners();</pre>
	* 		    <pre>mySuperShape.removeAllEventListeners(event);</pre>
	*
	*@param event (String) Event to remove all subscribed listeners from. If not specified, all listeners to any event will be removed.
	*/

	/*inherited from APCore*/
	/**
	* @method eventListenerExists
	* @description 	GDispatcher specific feature. Checks if a listener is already subscribed to a certain event.
	*
	* @usage   <pre>mySuperShape.eventListenerExists(event, listener);</pre>
	* 			<pre>mySuperShape.eventListenerExists(event, listener, handler);</pre>
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
		return "SuperShape";
	}
}