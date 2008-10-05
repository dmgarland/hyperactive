import de.alex_uhlmann.animationpackage.APCore;
import de.alex_uhlmann.animationpackage.drawing.IDrawable;
import de.alex_uhlmann.animationpackage.utility.IVisitor;
import de.alex_uhlmann.animationpackage.utility.IVisitorElement;
import de.alex_uhlmann.animationpackage.utility.IComposite;

/**
* @class ShapeComposite
* @author e2e4, Alex Uhlmann
* @description  ShapeComposite allows you to treat the classes of 
* 			de.alex_uhlmann.animationpackage.drawing in a uniform manner.
* 			ShapeComposite uses the composite design pattern. [GoF]
* 			<p>
* 			Example 1: <a href="ShapeComposite_01.html">(Example .swf)</a> 	
* 			<pre><blockquote> 
*			//Draw standard rectangles. Primitives.
*			var myRect1:IDrawable = new Rectangle(100,100,100,90);
*			var myRect2:IDrawable = new Rectangle(100,200,100,90);
*			var myRect3:IDrawable = new Rectangle(100,300,100,90);
*			
*			//add the rectangle (primitives, leafs) to the composite myRectangles. The identifier allows you to remove rectangles at a later time with removeChild().		
*			var myRectangles:ShapeComposite = new ShapeComposite();
*			myRectangles.addChild(myRect1,"myRect1");
*			myRectangles.addChild(myRect2,"myRect2");
*			myRectangles.addChild(myRect3,"myRect3");
*			
*			//draw different shapes
*			var myStar:IDrawable = new Star(250,100,50,25,6);
*			var myGear:IDrawable = new Gear(250,200,40,50,8,15,10);
*			var myBurst:IDrawable = new Burst(250,300,40,50,10);
*			var myPoly:IDrawable = new Poly(400,100,50,6);
*			var myRoundRectangle:IDrawable = new RoundRectangle(400,200,50,50,10);
*			var myEllipse:IDrawable = new Ellipse(400,300,80,40);
*			var myArc:IDrawable = new Arc(525,100,40,0,270,"CHORD");
*			var myOpenArc:IDrawable = new Arc(525,200,40,0,270,"OPEN");
*			var myPie:IDrawable = new Arc(525,300,40,0,300,"PIE");
*			
*			//add the shapes (primitives, leafs) to the composite allMyShapes.
*			var allMyShapes:ShapeComposite = new ShapeComposite();
*			allMyShapes.addChild(myStar,"myStar");
*			allMyShapes.addChild(myGear,"myGear");
*			allMyShapes.addChild(myBurst,"myBurst");
*			allMyShapes.addChild(myPoly,"myPoly");
*			allMyShapes.addChild(myRoundRectangle,"myRoundRectangle");
*			allMyShapes.addChild(myEllipse,"myEllipse");
*			allMyShapes.addChild(myArc,"myArc");
*			allMyShapes.addChild(myOpenArc,"myOpenArc");
*			allMyShapes.addChild(myPie,"myPie");
*			
*			//add all the rectangles (composite) to the composite allMyShapes.
*			allMyShapes.addChild(myRectangles,"myRectangles");
*			
*			//treat everything inside the composite allMyShapes in a uniform manner.
*			allMyShapes.lineStyle(2,0x990000);
*			allMyShapes.fillStyle(0xff0000,100);
*			allMyShapes.draw();
*			
*			//animate everything in allMyShapes.
*			var shapeArr:Array = allMyShapes.getChilds();
*			for(var i = 0; i < shapeArr.length; i++) {	
*				var mc:MovieClip = shapeArr[i].movieclip;
*				new ColorTransform(mc).run(0x00ff00,50,10000);	
*				new Rotation(mc).run(360,10000,Elastic.easeOut);
*			}
* 			</pre></blockquote>
* 			<p> 			
* @usage <tt>var myShapeComposite:ShapeComposite = new ShapeComposite();</tt> 
*/
class de.alex_uhlmann.animationpackage.drawing.ShapeComposite 
											extends APCore 
											implements IDrawable, 
													IVisitorElement, 
													IComposite {	
	
	private var childs:Object;
	private var identifier:Number;
	
	public function ShapeComposite() {		
		super.init(true);
		this.childs = {};
		this.identifier = 0;
	}
	
	/**
	* @method draw
	* @description 	Draws all the shapes of the composite.		
	* @usage <pre>myShapeComposite.draw();</pre>
	*/
	public function draw(Void):Void {
		var identifier:String;
		for (identifier in this.childs) {
			this.childs[identifier].draw(); 
		}
	}
	
	/**
	* @method drawBy
	* @description 	draws all the shapes of the composite.		
	* @usage <pre>myShapeComposite.draw();</pre>
	*/
	public function drawBy(Void):Void {
		var identifier:String;
		for (identifier in this.childs) {
			this.childs[identifier].drawBy(); 
		}
	}	
	
	/**
	* @method lineStyle
	* @description 	define outline.		
	* 		
	* @usage   <pre>myShapeComposite.lineStyle();</pre>
	* 		<pre>myShapeComposite.lineStyle(lineThickness, lineRGB, lineAlpha);</pre>
	* 	  
	* @param lineThickness (Number) Outline thickness.
	* @param lineRGB (Number) Outline color as hex number.	
	* @param lineAlpha (Number) Outline transparency (alpha).
	*/	
	public function lineStyle(lineThickness:Number, lineRGB:Number, lineAlpha:Number):Void {		
		var identifier:String;
		for (identifier in this.childs) {
			this.childs[identifier].lineStyle(lineThickness, lineRGB, lineAlpha);
		}
	}
	
	/**
	* @method fillStyle
	* @description 	 define fill.		
	* 		
	* @usage   <pre>myShapeComposite.fillStyle();</pre>
	* 		<pre>myShapeComposite.fillStyle(fillRGB, fillAlpha);</pre>
	* 	  
	* @param fillRGB (Number) Fill color.
	* @param fillAlpha (Number) Fill transparency.
	*/
	public function fillStyle(fillRGB:Number, fillAlpha:Number):Void {
		var identifier:String;
		for (identifier in this.childs) {			
			this.childs[identifier].fillStyle(fillRGB, fillAlpha);
		}
	}
	
	/**
	* @method gradientStyle
	* @description	 Same interface as MovieClip.beginGradientFill(). See manual.
	* 		
	* @usage   <pre>myShapeComposite.gradientStyle(fillType, colors, alphas, ratios, matrix);</pre>
	* 	  
	* @param fillType (String)  Gradient property. See MovieClip.beginGradientFill().
	* @param colors (Array)  Gradient property. See MovieClip.beginGradientFill().
	* @param alphas (Array)  Gradient property. See MovieClip.beginGradientFill().
	* @param ratios (Array)  Gradient property. See MovieClip.beginGradientFill().
	* @param matrix (Object)  Gradient property. See MovieClip.beginGradientFill().
	*/
	public function gradientStyle(fillType:String, colors:Array, alphas:Array, ratios:Array, matrix:Object):Void {
		var identifier:String;
		for (identifier in this.childs) {			
			this.childs[identifier].gradientStyle(fillType, colors, alphas, ratios, matrix);
		}
	}
	
	/**
	* @method clear
	* @description 	removes all drawings. Identical to myInstance.movieclip.clear();
	* @usage <pre>myInstance.clear();</pre>
	*/
	public function clear(Void):Void {
		var identifier:String;
		for (identifier in this.childs) {			
			this.childs[identifier].clear();
		}
	}
	
	/**
	* @method setRegistrationPoint
	* @description 	Sets the registration point of the composite.
	* @usage <pre>myInstance.setRegistrationPoint(registrationObj);</pre>
	* @param registrationObj (Object)
	*/
	public function setRegistrationPoint(registrationObj:Object):Void {
		var identifier:String;
		for (identifier in this.childs) {			
			this.childs[identifier].setRegistrationPoint(registrationObj);
		}
	}	
	
	/**
	* @method getChilds
	* @description 	returns all stored composites and primitives as primitives. 
	* 				Note that this method ignores hierarchies in your composite 
	* 				for the sake of easy manipulation of all IDrawable shapes. See class description for an example.
	* @usage  <pre>myShapeComposite.getChilds();</pre>		
	* @return Array that returns the stored composites and primitives as primitves.
	*/
	public function getChilds(Void):Array {		
		/*copy the childs object into an array for easy manipulation.*/		
		var childArr:Array = new Array();
		var identifier:String;
		for (identifier in this.childs) {			
			var child:Object = childs[identifier];
			if(child instanceof ShapeComposite) {					
				var innerChild:Array = child.getChilds();
				var len:Number = innerChild.length;
				while(len--) {					
					childArr.push(innerChild[len]);
				}				
			} else {
				childArr.push(child);
			}			
		}	
		return childArr;		
	}
	
	/**
	* @method addChild
	* @description 	adds a primitive or composite to the composite instance of ShapeComposite 
	* See class description.
	* @usage  <pre>myShapeComposite.addChild(shape, identifier);</pre>
	* @param component (IDrawable) Must be compatible to IDrawable.
	* @param identifier (String) String that identifies shape to the user.	
	* @return IDrawable component that was added.
	*/
	public function addChild(component:IDrawable, identifier:String):IDrawable {		
		if(!identifier) {
			identifier = this.generateIdentifier();
		}
		this.childs[identifier] = component;
		return component;
	}
	
	/**
	* @method removeChild
	* @description 	removes a primitive or composite from the composite instance of ShapeComposite 
	* See class description.
	* @usage  <pre>myShapeComposite.removeChild(identifier);</pre>
	* @param identifier (String) String that identifies shape to the user.	
	*/
	public function removeChild(identifier:String):Void {		
		if(this.childs[identifier]) {
			delete this.childs[identifier];
		}
	}
	
	/**
	* @method accept
	* @description 	Allow a visitor to visit its elements. See Visitor design pattern [GoF].
	* @usage  <pre>myInstance.accept(visitor);</pre>
	* @param visitor (IVisitor) Must be compatible to de.alex_uhlmann.animationpackage.utility.IVisitor.	
	*/
	public function accept(visitor:IVisitor):Void {
		var identifier:String;
		for (identifier in this.childs) {
			visitor.visit(this.childs[identifier]);
		}
	}	
	
	private function generateIdentifier(Void):String {
		return String(++this.identifier);
	}
	
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
		return "ShapeComposite";
	}
}