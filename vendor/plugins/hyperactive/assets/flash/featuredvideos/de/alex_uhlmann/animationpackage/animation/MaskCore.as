import de.alex_uhlmann.animationpackage.APCore;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.drawing.Rectangle;

/*
* @class MaskCore
* @author Alex Uhlmann, Ben Jackson
*/
class de.alex_uhlmann.animationpackage.animation.MaskCore extends AnimationCore {
	
	private var mask_mc:MovieClip;
	private var mcBounds:Object;
	private var mask_mcBounds:Object;	
	private var mask_mcW:Number;
	private var mask_mcH:Number;
	private var resetXscale:Number;
	private var resetYscale:Number;	
	private var effect:String;
	private var adjustmentObj:Object;
	private var myMaskAnimation:Object;
	
	private function MaskCore(mc:MovieClip, mask_mc:MovieClip) {
		super();
		this.init.apply(this,arguments);
	}
	
	private function init():Void {	
		var mc:MovieClip = arguments[0];
		var mask_mc:MovieClip = arguments[1];
		this.mc = mc;
		if (mask_mc == null) {
			var dp:Number = this.getNextDepth(mc._parent);
			mask_mc = this.createClip({parentMC:mc._parent, name:"apMask", x:0, y:0});
			var myRectangle:Rectangle = new Rectangle(mask_mc, mc._width/2, mc._height/2, mc._width, mc._height);
			myRectangle.draw();
		}
		this.mask_mc = mask_mc;
		this.hideMask();
	}
	
	private function hideMask(Void):Void {	
		this.mask_mc._visible = false;	
	}
	
	private function unhideMask(Void):Void {	
		this.mask_mc._visible = true;		
	}
	
	private function getBounds(Void):Void {			
		this.mcBounds = this.mc.getBounds(_root);		
		this.mask_mcBounds = this.mask_mc.getBounds(_root);		
	}
	
	public function matchSize(amount:Number):Void {				
		this.unhideMask();
		if(amount === undefined) {
			amount = 120;
		} else if(amount === null) {
			return;
		}
		var areaWidth:Number = this.mcBounds.xMax - this.mcBounds.xMin;
		var areaHeight:Number = this.mcBounds.yMax - this.mcBounds.yMin;
		var mask_mcWidth:Number = this.mask_mcBounds.xMax - this.mask_mcBounds.xMin;
		var mask_mcHeight:Number = this.mask_mcBounds.yMax - this.mask_mcBounds.yMin;	
		var distXrel:Number;
		if(mask_mcWidth > mask_mcHeight) {			
			distXrel = areaWidth / mask_mcWidth * amount;						
		} else {			
			distXrel = areaHeight / mask_mcHeight * amount;				
		}		
		this.mask_mc._xscale = distXrel;			
		this.mask_mc._yscale = distXrel;		
		this.resetXscale = this.mask_mc._xscale;
		this.resetYscale = this.mask_mc._yscale;
		this.hideMask();
	}
	
	public function forceEnd(forceEndVal:Boolean):Void {
		this.myMaskAnimation.forceEnd(forceEndVal);
	}
	
	public function setMask(Void):Void {		
		this.mc.setMask(this.mask_mc);
	}
	
	public function deleteMask(Void):Void {		
		this.mc.setMask(null);
	}	

	public function getStartValues(Void):Array {		
		return this.myMaskAnimation.getStartValues();
	}
	
	public function getEndValues(Void):Array {		
		return this.myMaskAnimation.getEndValues();
	}	
	
	public function getCurrentValues(Void):Array {		
		return this.myMaskAnimation.getCurrentValues();
	}
	
	public function getCurrentPercentage(Void):Number {
		return this.myMaskAnimation.getCurrentPercentage();
	}
	
	public function get maskMovieclip():MovieClip {
		return this.mask_mc;
	}
	
	public function set maskMovieclip(mask_mc:MovieClip):Void {
		this.mask_mc = mask_mc;
	}
	
	private function onStart(eventObject:Object):Void {		
		this.dispatchEvent({type:eventObject.type, value:this.getStartValues()});
	}
	
	private function onUpdate(eventObject:Object):Void {
		this.dispatchEvent({type:eventObject.type, value:this.getCurrentValues()});
	}
	
	private function onEnd(eventObject:Object):Void {		
		this.tweening = false;
		APCore.broadcastMessage(this.callback, this, this.getCurrentValues());
		this.dispatchEvent({type:eventObject.type, value:this.getCurrentValues()});
	}
	
	public function toString(Void):String {		
		return "MaskCore";
	}
}