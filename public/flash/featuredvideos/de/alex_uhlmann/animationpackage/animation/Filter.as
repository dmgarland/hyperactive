import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.Animator;
import flash.filters.BitmapFilter;

/*
* @class Filter
* @author Alex Uhlmann
* @description  Base class for all filter classes.
* 			<p>
*/
class de.alex_uhlmann.animationpackage.animation.Filter 
											extends AnimationCore {
	

	public var filterIndex:Number;
	public var filters:Array;
	
	private var initialized:Boolean = false;
	private var myInstances:Array;
	private var hasStartValues:Boolean = false;
	//abstract methods
	private var createEmptyFilter:Function;
	private var isFilterOfCorrectType:Function;
	private var updateProperties:Function;

	public function Filter() {
		super();
	}
	
	private function init():Void {
		if(typeof(arguments[0]) != "number") {
			arguments.unshift(null);
		}
		if(arguments[1] instanceof Array) {
			var values:Array = arguments[1];
			var endValues:Array = values.slice(-1);
			arguments.splice(1, 1, endValues[0]);
			this.initAnimation.apply(this, arguments);
			this.setStartValues([values[0]]);
		} else {
			this.initAnimation.apply(this, arguments);
		}
	}
	
	private function invokeAnimation(start:Number, end:Number):Void {
		
		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		this.myAnimator.end = this.endValues;

		if(this.mc != null) {
			this.initSingleMC();			
		} else {			
			this.initMultiMC();			
		}
		
		if(end != null) {
			this.myAnimator.animationStyle(this.duration, this.easing, this.callback);
			this.myAnimator.animate(start, end);
		} else {
			this.myAnimator.goto(start);
		}

		this.startInitialized = false;
	}
	
	private function addFilter(filter:BitmapFilter):Void {				
		if(hasFilters(this.mc.filters)) {			
			this.addToEnd(filter);
		} else {
			this.createFilters(filter);
		}		
		this.filters.push(filter);
	}	

	private function addToEnd(filter:BitmapFilter):Void {
		this.filters = this.mc.filters;
		this.filterIndex = this.filters.length;
	}
	
	private function createFilters(filter:BitmapFilter):Void {
		this.filters = new Array();
		this.filterIndex = 0;
	}
	
	private function findFilter(filterIndex:Number):BitmapFilter {
		var filter:BitmapFilter = this.mc.filters[filterIndex];
		
		var isOfCorrectType:Boolean = this.isFilterOfCorrectType(filter);

		if(!isOfCorrectType && filter != null) {
			trace("Warning: de.alex_uhlmann.animationpackage.animation."+this+": "
				+"Element "+filterIndex+" of "+this.mc+".filters will be overwritten.");
		}
		
		if(filter == null || !isOfCorrectType) {
			filter = this.createEmptyFilter();
		}
		return filter;
	}	
	
	private function hasFilters(filters:Array):Boolean {
		return (filters.length > 0);
	}

	public function toString(Void):String {
		return "Filter";
	}
}