import de.alex_uhlmann.animationpackage.APCore;

class de.alex_uhlmann.animationpackage.utility.Clip extends APCore {	
	
	public function Clip() {
		super.init(true);
	}
	
	public function attach(id:String, x:Number, y:Number, 
						   initObj:Object):MovieClip {
		
		/*Flash Player 7 feature disabled*/
		//var depth:Number = this.animationClip.getNextHighestDepth();			
		var containerClip:MovieClip = APCore.getAnimationClip();
		var depth:Number = this.getNextDepth(containerClip);			
		var mc:MovieClip;
		if(initObj == null)
			mc = containerClip.attachMovie(id,"apAttached_mc"+depth, depth);
		else
			mc = containerClip.attachMovie(id,"apAttached_mc"+depth, depth, initObj);	
		mc._x = x;
		mc._y = y;
		return mc;			
	}	
				
	public function remove(mc:MovieClip):Void {
		mc.removeMovieClip();	
	}		
		
	public function create(name:String):MovieClip {
		return this.createClip({name:name});		
	}
	
	public function getNextDepth(mc:MovieClip):Number {
		return super.getNextDepth(mc);
	}	

	public function toString(Void):String {
		return "Clip";
	}
}