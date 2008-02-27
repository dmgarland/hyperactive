/*
© Ivan Dembicki, 2004, dembicki@narod.ru
please check updates: http://www.dembicki.org

Path class 
version 1.3
version 1.2: http://www.dembicki.org/Path1_2.as
version 1.1: http://www.dembicki.org/Path1_1.as
version 1.0: http://www.dembicki.org/Path1_0.as
*/
class org.dembicki.Path {
	var path_points:String = "", path_length:Number = 0;
	var segments:Number = 0;
	private var ln_array:Array = [];
	function Path() {
		var arg = typeof arguments[0] == "number" ? arguments : arguments[0];
		this.path_points=arg.toString(), this.path_length=0;
		var k = 0, i;
		var len = arg.length;
		var x0 = arg[0] || 0, y0 = arg[1] || 0, x1, y1, x2, y2, ln, o, a1, a2, a3, a4, a, b, c, d, e, a2t, sa;
		for (i=2; i<len; i += 4) {
			x1 = arg[i] || 0;
			y1 = arg[i+1] || 0;
			if (i == (len-2)) {
				x2 = arg[i+2] ? arg[i+2] : (arg[0] || 0);
				y2 = arg[i+3] ? arg[i+3] : (arg[1] || 0);
			} else {
				x2 = arg[i+2] || 0;
				y2 = arg[i+3] || 0;
			}
			ln = this.ln_array[k++]=[{_y:y0, _x:x0}, {_y:y1, _x:x1}, {_y:y2, _x:x2}];
			o = ln[3]={};
			a1 = o.a1=x0-2*x1+x2;
			a2 = o.a2=y0-2*y1+y2;
			a3 = o.a3=x0-x1;
			a4 = o.a4=y0-y1;
			a = o.a=4*(a1*a1+a2*a2);
			b = o.b=-8*(a1*a3+a2*a4);
			c = o.c=4*(a3*a3+a4*a4);
			e = o.e=Math.sqrt(c);
			d = Math.sqrt(c+b+a);
			sa = Math.sqrt(a);
			a2t = a*2;
			ln[4] = (2*sa*(d*(b+a2t)-e*b)+(b*b-4*a*c)*(Math.log(2*e+b/sa)-Math.log(2*d+(b+a2t)/sa)))/(8*Math.pow(a, (3/2)));
			if (isNaN(ln[4])) {
				var del = 100000;
				arg[i] += Math.random()/del;
				arg[i+1] += Math.random()/del;
				arg[i+2] += Math.random()/del;
				arg[i+3] += Math.random()/del;
				arg[i+4] += Math.random()/del;
				arg[i+5] += Math.random()/del;
				i -= 4;
				k--;
			} else {
				this.path_length += ln[4];
				x0 = x2;
				y0 = y2;
			}
		}
		this.segments = k--;
	}
	public function getPoint(poz:Number, omit_rotation:Boolean) {
		
		//added
		if (poz > this.path_length) {
			poz = this.path_length;
		} else if (poz < 0) {
			poz = 0;
		}
		//end added
		
		poz = poz%this.path_length;
		//poz<0 ? poz += this.path_length : "";
		if(poz<0)poz += this.path_length;
		if(!poz)poz += .00001;
		if (this.segments<1) {
			return false;
		}
		var i = 0, ln, len = 0, ff = 0;
		for (i; i<=this.segments; i++) {
			ln=this.ln_array[i], len += ln[4];
			if (len>poz) {
				ff = (poz-(len-ln[4]))/ln[4];
				break;
			}
		}
		var fn = function (ff) {
			var o = ln[3], a1 = o.a1, a2 = o.a2, a3 = o.a3, a4 = o.a4, a = o.a, b = o.b, c = o.c, e = o.e, i = 1, st = 1, f_l = ln[4], t_l = ff*f_l, max_i = 100, d, sa, a2i;
			while (max_i--) {
				d=Math.sqrt(c+i*(b+a*i)), sa=Math.sqrt(a), a2i=a*2*i, f_l=(2*sa*(d*(b+a2i)-e*b)+(b*b-4*a*c)*(Math.log(2*e+b/sa)-Math.log(2*d+(b+a2i)/sa)))/(8*Math.pow(a, (3/2)));
				if (Math.abs(f_l-t_l)<.000001) {
					return i;
				}
				st /= 2, i += f_l<t_l ? st : f_l>t_l ? -st : 0;
			}
			return i;
		};
		var f = fn(ff), p0 = ln[0], p1 = ln[1], p2 = ln[2], e = 1-f, ee = e*e, ff = f*f, b = 2*f*e;
		return omit_rotation ? {_x:p2._x*ff+p1._x*b+p0._x*ee, _y:p2._y*ff+p1._y*b+p0._y*ee} : {_x:p2._x*ff+p1._x*b+p0._x*ee, _y:p2._y*ff+p1._y*b+p0._y*ee, _rotation:Math.atan2(p0._y-p1._y+(2*p1._y-p0._y-p2._y)*f, p0._x-p1._x+(2*p1._x-p0._x-p2._x)*f)/(Math.PI/180)};
	}
}
