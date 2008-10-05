
/**
* @class BezierToolkit
* @author Alex Uhlmann
* @description  Offers common used methods for bezier curves. 
* 				Used by QuadCurve, CubicCurve, MoveOnQuadCurve, MoveOnCubicCurve
* @usage <tt>var myBezierToolkit:BezierToolkit = new BezierToolkit();</tt> 
*/
class de.alex_uhlmann.animationpackage.utility.BezierToolkit {			
	
	public function BezierToolkit() {}	
	
	/**
	* @method getPointsOnQuadCurve
	* @description Returns a point on a quadratic bezier curve with Robert Penner's optimization 
	*				of the standard equation:
	*				{x:p1.x * (1-t) * (1-t) + 2 * p2.x * t * (1-t) + p3.x * t * t,
	*		         y:p1.y * (1-t) * (1-t) + 2 * p2.y * t * (1-t) + p3.y * t * t }
	* @usage   <tt>myInstance.getPointsOnQuadCurve(targ, p1, p2, p3);</tt>
	* @param targ (Number)
	* @param p1 (Object)
	* @param p2 (Object)
	* @param p3 (Object)
	* @return Object
	*/
	/*Adapted from Robert Penner.*/
	public function getPointsOnQuadCurve(t:Number, p1:Object, p2:Object, p3:Object):Object {
		var v:Number = t / 100;
		var p:Object = {};
		p.x = p1.x + v*(2*(1-v)*(p2.x-p1.x) + v*(p3.x - p1.x));
		p.y = p1.y + v*(2*(1-v)*(p2.y-p1.y) + v*(p3.y - p1.y));	
		return p;
	}
	
	/**
	* @method getPointsOnCubicCurve
	* @description
	* @usage   <tt>myInstance.getPointsOnCubicCurve(targ, p1, p2, p3, p4);</tt>
	* @param targ (Number)
	* @param p1 (Object)
	* @param p2 (Object)
	* @param p3 (Object)
	* @param p4 (Object)
	* @return Object
	*/	
	/*Adapted from Paul Bourke.*/
	public function getPointsOnCubicCurve(targ:Number, p1:Object, p2:Object, p3:Object, p4:Object):Object {
		var a:Number,b:Number,c:Number;	
		var v:Number = targ / 100;	
		a = 1 - v;
		b = a * a * a;
		c = v * v * v;
		var p:Object = {};
		p.x = b * p1.x + 3 * v * a * a * p2.x + 3 * v * v * a * p3.x + c * p4.x;
		p.y = b * p1.y + 3 * v * a * a * p2.y + 3 * v * v * a * p3.y + c * p4.y;		
		return p;
	}
	
	/**
	* @method getQuadControlPoints
	* @description
	* @usage   <tt>myInstance.getQuadControlPoints(startX, startY, x2, y2, endX, endY);</tt>
	* @param targ (Number)
	* @param startX (Number)
	* @param startY (Number)
	* @param x2 (Number)
	* @param y2 (Number)
	* @param endX (Number)
	* @param endY (Number)
	* @return Object
	*/
	/*Adapted from Robert Penner's drawCurve3Pts() method*/
	public function getQuadControlPoints(startX:Number, startY:Number, 
						        x2:Number, y2:Number, 
						        endX:Number, endY:Number):Object {
							        
		var c:Object = new Object();
		c.x = (2 * x2) - .5 * (startX + endX);
		c.y = (2 * y2) - .5 * (startY + endY);        
		return c;
	}	
	
	/**
	* @method getCubicControlPoints
	* @description 	if anybody finds a generic method to compute control points 
	* 				for bezier curves with n control points, 
	* 				if only the points on the curve are given, please let me know!
	* @usage   <tt>myInstance.getCubicControlPoints(startX, startY, throughX1, throughY1, throughX2, throughY2, endX, endY);</tt>
	* @param targ (Number)
	* @param startX (Number)
	* @param startY (Number)
	* @param throughX1 (Number)
	* @param throughY1 (Number)
	* @param throughX2 (Number)
	* @param throughY2 (Number)
	* @param endX (Number)
	* @param endY (Number)
	* @return Object
	*/	
	public function getCubicControlPoints(startX:Number, startY:Number, 
						        throughX1:Number, throughY1:Number, 
							throughX2:Number, throughY2:Number, 
						        endX:Number, endY:Number):Object {
		
		var c:Object = new Object();
		c.x1 = -(10 * startX - 3 * endX - 8 * (3 * throughX1 - throughX2)) / 9;
		c.y1 = -(10 * startY - 3 * endY - 8 * (3 * throughY1 - throughY2)) / 9;
		c.x2 = (3 * startX - 10 * endX - 8 * throughX1 + 24 * throughX2) / 9;
		c.y2 = (3 * startY - 10 * endY - 8 * throughY1 + 24 * throughY2) / 9;
		return c;
	}
	
	/**
	* @method toString
	* @description 	returns the name of the class.
	* @usage   <tt>myInstance.toString();</tt>
	* @return String
	*/	
	public function toString(Void):String {
		return "BezierToolkit";
	}	
}