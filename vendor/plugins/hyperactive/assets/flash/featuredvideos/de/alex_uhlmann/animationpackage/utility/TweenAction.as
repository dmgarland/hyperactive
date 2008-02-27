import de.alex_uhlmann.animationpackage.APCore;
import de.alex_uhlmann.animationpackage.utility.Animator;

/*
* @class TweenAction
* @author Alex Uhlmann
* @description  Class that handles callbacks of the mx.effects.Tween and 
* 				de.alex_uhlmann.animationpackage.utility.FrameTween. 
* 				See Animator class for more details.  
*/

class de.alex_uhlmann.animationpackage.utility.TweenAction {		

	private var scope:Object;
	private var targetStr:String;
	private var identifier:Function;
	private var ref:Animator;
	private var len:Number;
	/*relaxed type to accommodate numbers or arrays*/
	private var initVal:Object;
	private var endVal:Object;
	private var singleMode:Boolean;

	public function TweenAction(ref:Animator, startVal:Object, endVal:Object) {
		this.ref = ref;
		this.initVal = initVal;
		this.endVal = endVal;		
	}	
		
	public function initSingleMode(scope:Object, targetStr:String, identifier:Function):Void {
		this.scope = scope;
		this.targetStr = targetStr;
		this.identifier = identifier;
		this.singleMode = true;	
	}
	
	public function initMultiMode(len:Number):Void {
		this.scope = scope;
		this.targetStr = targetStr;
		this.identifier = identifier;
		this.len = len;
		this.singleMode = false;
	}	
	
	/* Optimized, less readable code. See m */
	public function o(v:Number):Void {		
		var p:Object = this.scope;
		var t:String = this.targetStr;
		var f:Function = this.identifier;
		if(typeof(f) != "number") {
			p[t](v);
		} else {
			p[t] = v;
		}
		var r:Object = this.ref;	
		r.caller.currentValue = v;
		r.caller["dispatchEvent"]({type:"onUpdate", target: r.caller, value: v});
	}
	
	/*onTweenUpdateOnce with rounded values to integers*/
	public function o2(v:Number):Void {		
		var p:Object = this.scope;
		var t:String = this.targetStr;
		var f:Function = this.identifier;		
		v = Math.round(v);
		if(typeof(f) != "number") {
			p[t](v);
		} else {
			p[t] = v;			
		}
		var r:Object = this.ref;	
		r.caller.currentValue = v;
		r.caller["dispatchEvent"]({type:"onUpdate", target: r.caller, value: v});
	}
	
	/* Optimized, less readable code.
	* o = onTweenUpdateOnce
	* m = onTweenUpdateMulitple
	* r = reference to Animator class.
	* s = setter: (Array) setter property from Animator class.
	* p = object, scope: first element of setter property from Animator class.
	* t = targetString: second element of setter property from Animator class.
	* f = function: identifier. Combination of o and t. 
	* v = value parameter.
	* u = onUpdateOnce
	* w = onUpdateMultiple
	*/	
	public function m(v:Array):Void {		
		var r:Object = this.ref;
		var s:Array = r.setter;
		var p:Object;
		var t:String;
		var f:Function;
		var i:Number = this.len;
		while(--i>-1) {
			p = s[i][0];
			t = s[i][1];
			f = p[t];			
			if(typeof(f) != "number") {
				p[t](v[i]);
			} else {
				p[t] = v[i];
			}		
		}
		r.caller.currentValues = v;
		r.caller["dispatchEvent"]({type:"onUpdate", target: r.caller, value: v});
	}
	
	/*onTweenUpdateMultiple with rounded values to integers*/
	public function m2(v:Number):Void {		
		var r:Object = this.ref;
		var s:Array = r.setter;
		var p:Object;
		var t:String;
		var f:Function;
		var i:Number = this.len;
		var m:Function = Math.round;
		while(--i>-1) {
			v[i] = m(v[i]);
			p = s[i][0];
			t = s[i][1];
			f = p[t];			
			if(typeof(f) != "number") {
				p[t](v[i]);
			} else {
				p[t] = v[i];
			}		
		}
		r.caller.currentValues = v;
		r.caller["dispatchEvent"]({type:"onUpdate", target: r.caller, value: v});
	}
	
	
	
	
	
	
	
	/* 
	* Same functions as above, just one row for methods only and one row for properties only. 
	* For the sake of higher performance.
	*/	
	//for properties only
	public function op(v:Number):Void {	
		var p:Object = this.scope;
		var t:String = this.targetStr;			
		p[t] = v;
		var r:Object = this.ref;	
		r.caller.currentValue = v;
		r.caller["dispatchEvent"]({type:"onUpdate", target: r.caller, value: v});
	}	
	
	public function o2p(v:Number):Void {		
		var p:Object = this.scope;
		var t:String = this.targetStr;	
		v = Math.round(v);
		p[t] = v;
		var r:Object = this.ref;	
		r.caller.currentValue = v;
		r.caller["dispatchEvent"]({type:"onUpdate", target: r.caller, value: v});
	}	

	public function mp(v:Array):Void {		
		var r:Object = this.ref;
		var s:Array = r.setter;
		var i:Number = this.len;
		while(--i>-1) {
			s[i][0][s[i][1]] = v[i];			
		}
		r.caller.currentValues = v;
		r.caller["dispatchEvent"]({type:"onUpdate", target: r.caller, value: v});
	}
	
	public function m2p(v:Array):Void {		
		var r:Object = this.ref;
		var s:Array = r.setter;
		var i:Number = this.len;
		var m:Function = Math.round;
		while(--i>-1) {
			v[i] = m(v[i]);
			s[i][0][s[i][1]] = v[i];		
		}
		r.caller.currentValues = v;
		r.caller["dispatchEvent"]({type:"onUpdate", target: r.caller, value: v});
	}	
	
	//for methods only
	public function om(v:Number):Void {
		var p:Object = this.scope;
		var t:String = this.targetStr;		
		p[t](v);
		var r:Object = this.ref;	
		r.caller.currentValue = v;
		r.caller["dispatchEvent"]({type:"onUpdate", target: r.caller, value: v});		
	}	
	
	public function o2m(v:Number):Void {		
		var p:Object = this.scope;
		var t:String = this.targetStr;	
		v = Math.round(v);	
		p[t](v);
		var r:Object = this.ref;	
		r.caller.currentValue = v;
		r.caller["dispatchEvent"]({type:"onUpdate", target: r.caller, value: v});
	}	

	public function mm(v:Array):Void {		
		var r:Object = this.ref;
		var s:Array = r.setter;
		var i:Number = this.len;
		while(--i>-1) {
			s[i][0][s[i][1]](v[i]);
		}
		r.caller.currentValues = v;
		r.caller["dispatchEvent"]({type:"onUpdate", target: r.caller, value: v});
	}
	
	public function m2m(v:Array):Void {		
		var r:Object = this.ref;
		var s:Array = r.setter;
		var i:Number = this.len;
		var m:Function = Math.round;
		while(--i>-1) {
			v[i] = m(v[i]);
			s[i][0][s[i][1]](v[i]);
		}
		r.caller.currentValues = v;
		r.caller["dispatchEvent"]({type:"onUpdate", target: r.caller, value: v});
	}
	
	
	
	
	public function mu(v:Array):Void {		
		var r:Object = this.ref;
		var s:Array = r.setter;
		var p:Object;
		var t:String;
		var f:Function;
		p = s[0][0];
		t = s[0][1];
		f = p[t];
		f.apply(p,v);
		r.caller.currentValues = v;
		r.caller["dispatchEvent"]({type:"onUpdate", target: r.caller, value: v});
	}	
	
	public function mu2(v:Array):Void {		
		var r:Object = this.ref;
		var s:Array = r.setter;
		var p:Object;
		var t:String;
		var f:Function;		
		var i:Number = this.len;
		var m:Function = Math.round;
		while(--i>-1) {
			v[i] = m(v[i]);
		}
		p = s[0][0];
		t = s[0][1];
		f = p[t];	
		f.apply(p,v);
		r.caller.currentValues = v;
		r.caller["dispatchEvent"]({type:"onUpdate", target: r.caller, value: v});
	}	
	
	/* Optimized, less readable code.	
	* e = onTweenEnd
	*/	
	public function e(v):Void {		
		var r:Object = this.ref;
		/*
		* It is possible that time based tweening does not 
		* reach the exact end value of the animation child.
		* If the forceEndVal property is true (default), TweenAction will 
		* invoke the update function again to force the end value.
		*/
		if(r.caller.forceEndVal) {
			v = this.endVal;
			this[r.myTween.updateMethod](v);			
		} else {
			if(this.singleMode) {
				/*
				* check for closest value to be as precise as possible:
				* v = current value not set.
				* ev = targeted value. end value in theory.
				* r.caller.currentValue = current value, last value set.
				* if the overshoot (v - ev) is smaller 
				* than the difference between the targeted value 
				* and the last value set, than set the overshoot.
				* Otherwise go with the last value set.
				*/
				var ev = this.endVal;
				if((v - ev) < (ev - r.caller.currentValue)) {
					this[r.myTween.updateMethod](v);
					v = r.caller.currentValue;
				} else {
					if(r.caller.rounded) {						
						v = Math.round(r.caller.currentValue);
					} else {
						v = r.caller.currentValue;
					}			
				}
			} else {
				/*
				* for multiple values we always set the last value set 
				* as end value.
				*/
				v = r.caller.currentValue;
			}		
		}
		
		r.deleteAnimation();
		
		/*invoke the callback through all listeners*/
		r.caller.tweening = false;
		r.finished = true;
		APCore.broadcastMessage(r.callback, r.caller, v);
		r.caller["dispatchEvent"]({type:"onEnd", target:r.caller, value: v});
	}

	public function toString(Void):String {
		return "TweenAction";
	}
}