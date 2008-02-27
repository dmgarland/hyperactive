/*
* Class for drawing cubic bezier curves. 
* Adapted from bezier_draw_cubic.as and drawing_api_core_extensions.as by Alex Uhlmann. 
* Approved by Robert Penner.
* @author Robert Penner, Alex Uhlmann
* @version 0.3 ALPHA
* -note that line 92 this.mc.moveTo (p1.x, p1.y); is commented out.
*/
class com.robertpenner.bezier.CubicCurve {	
	
	private var _xpen:Number;
	private var _ypen:Number;
	private var mc:MovieClip;

	public function CubicCurve(mc) {
		this.mc = mc;
	}

	private function intersect2Lines(p1:Object, p2:Object, p3:Object, p4:Object):Object {		
		var x1:Number = p1.x; 
		var y1:Number = p1.y;
		var x4:Number = p4.x; 
		var y4:Number = p4.y;
		
		var dx1:Number = p2.x - x1;
		var dx2:Number = p3.x - x4;
		if (!(dx1 || dx2)) {
			return NaN;
		}
		
		var m1:Number = (p2.y - y1) / dx1;
		var m2:Number = (p3.y - y4) / dx2;
		
		if (!dx1) {
			// infinity
			return { x:x1,
				 y:m2 * (x1 - x4) + y4 };
		
		} else if (!dx2) {
			// infinity
			return { x:x4,
				 y:m1 * (x4 - x1) + y1 };
		}
		var xInt:Number = (-m2 * x4 + y4 + m1 * x1 - y1) / (m1 - m2);
		var yInt:Number = m1 * (xInt - x1) + y1;
		return { x:xInt, y:yInt };
	}
	
	private function midLine(a:Object, b:Object):Object {		
		return { x:(a.x + b.x)/2, y:(a.y + b.y)/2 };
	}
	
	private function bezierSplit(p0:Object, p1:Object, p2:Object, p3:Object):Object {		
		var m:Function = this.midLine;
		var p01:Object = m(p0, p1);
		var p12:Object = m(p1, p2);
		var p23:Object = m(p2, p3);
		var p02:Object = m(p01, p12);
		var p13:Object = m(p12, p23);
		var p03:Object = m(p02, p13);
		return {
			b0:{a:p0,  b:p01, c:p02, d:p03},
			b1:{a:p03, b:p13, c:p23, d:p3 }  
		};
	}

	private function _cBez(a:Object, b:Object, c:Object, d:Object, k:Number):Void {		
		// find intersection between bezier arms
		var s:Object = this.intersect2Lines (a, b, c, d);
		// find distance between the midpoints
		var dx:Number = (a.x + d.x + s.x * 4 - (b.x + c.x) * 3) * .125;
		var dy:Number = (a.y + d.y + s.y * 4 - (b.y + c.y) * 3) * .125;
		// split curve if the quadratic isn't close enough
		if (dx*dx + dy*dy > k) {
			var halves:Object = this.bezierSplit (a, b, c, d);
			var b0:Object = halves.b0; var b1 = halves.b1;
			// recursive call to subdivide curve
			this._cBez (a, b0.b, b0.c, b0.d, k);
			this._cBez (b1.a,  b1.b, b1.c, d,    k);
		} else {
			// end recursion by drawing quadratic bezier
			this.mc.curveTo (s.x, s.y, d.x, d.y);
			this._xpen = d.x;
			this._ypen = d.y;
		}
	}
	
	private function drawBezierPts(p1:Object, p2:Object, p3:Object, p4:Object, tolerance:Number):Void {		
		if (tolerance == undefined) {
			tolerance = 5;
		}
		//this.mc.moveTo (p1.x, p1.y);
		this._xpen = p1.x;
		this._ypen = p1.y;
		this._cBez (p1, p2, p3, p4, tolerance*tolerance);
	}

	public function drawBezier(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, 
							x4:Number, y4:Number, tolerance:Number):Void {	
		
		this.drawBezierPts ({x:x1, y:y1},
						{x:x2, y:y2},
						{x:x3, y:y3},
						{x:x4, y:y4},
						tolerance);
	}

	private function curveToCubic(x1:Number, y1:Number, x2:Number, y2:Number, 
								x3:Number, y3:Number, tolerance:Number):Void {		
		
		if (tolerance == undefined) {
			tolerance = 5;
		}
		this._cBez (
			{x:this._xpen, y:this._ypen},
			{x:x1, y:y1},
			{x:x2, y:y2},
			{x:x3, y:y3},
			tolerance*tolerance );
	}

	private function curveToCubicPts(p1:Object, p2:Object, p3:Object, tolerance:Number):Void {		
		if (tolerance == undefined) {
			tolerance = 5;
		}
		this._cBez (
			{x:this._xpen, y:this._ypen},
			p1, p2, p3, tolerance*tolerance );
	}
	
	public function toString():String {
		return "com.robertpenner.bezier.CubicCurve";
	}
}