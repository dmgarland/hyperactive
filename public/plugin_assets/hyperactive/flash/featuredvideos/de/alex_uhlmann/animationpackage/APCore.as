/*
* AnimationPackage by default uses Grant Skinner's GDispatcher 
* instead of Macromedia's EventDispatcher. Swop this line 
* with the line below if you want to use Macromedia's EventDispatcher 
* instead of GDispatcher. Also swop the initialize method 
* invocations in APCore.init() at line 91.
*/
//import mx.events.EventDispatcher;
import com.gskinner.events.GDispatcher;

import ascb.util.Proxy;
import de.alex_uhlmann.animationpackage.IAnimationPackage;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.andre_michelle.events.ImpulsDispatcher;

/**
* @class APCore
* @author Alex Uhlmann
* @description         Most classes in AnimationPackage subclass the singelton APCore, either directly or indirectly.
*                        It implements listener functionality and common used methods 
*                        and creates the animationClip (apContainer_mc) in _root timeline, 
*                        which is a movieclip that contains everything made by AnimationPackage unless you explicitly prevent this.
* 			For example if you use the classes of de.alex_uhlmann.animationpackage.drawing you are able to specify a movieclip of any timeline 
* 			that will be used to draw the shape. If you don't specify anything, a new movieclip, created in _root.apContainer_mc will be used to draw the shape.
*                 
* @usage     <tt>private class constructor</tt> <p>
* 			<b>Event handling</b>
* 			<p>
* 			There are basically two ways to handle events in AnimationPackage. One way is using callbacks.
* 			(based on the internal AsBroadcaster)
* 			The other is using com.gskinner.events.GDispatcher or mx.events.EventDispatcher. 
* 			Take a look into the readme.htm under "usage" for more information. Since you need the static initialize(), addListener(), 
* 			and removeListener() methods of APCore to use callbacks, here is an example using the callback structure to handle custom events.
* 			<p>
* 			To subscribe an object to events use
*                 <tt>APCore.addListener(obj);</tt>
*                i.e. if you want a movieclip to move back and forth, you can do it like:
*                <blockquote><pre>               
* 			APCore.initialize();
* 			var myListener:Object = new Object();
*			APCore.addListener(myListener);
*			var myMove:Move = new Move(mc);
*			myMove.animationStyle(2000,Expo.easeInOut,"onCallback");
*			myMove.run(500,200);
*			myListener.onCallback = function()
*			{
*				myMove.callback = "onCallback2";
*				myMove.run(100,200);
*			}
*			myListener.onCallback2 = function()
*			{		
*				myMove.callback = "onCallback";	
*				myMove.run(500,200);
*			}
*                </pre></blockquote>	
* 			<a href="APCore_01.html">(Example .swf)</a> 
* 			<p>
* 			<b>Controlling your frame rate</b>
* 			<p>
* 			APCore offers some methods concerning your movie's frame rate (fps = frames per second). 
* 			As soon as you use a class of AnimationPackage the APCore.initialize method is called and 
* 			calculates your movie's fps. This calculation takes one second till it gets the only result. 
* 			Then, due to performance reasons, the calculation will not be continued. If you still want to calculate your fps 
* 			you can do so by calling APCore.watchFPS(). Stop watching the fps with APCore.unwatchFPS(). 
* 			For duration mode "MS" in tween mode "FRAMES" you might even set the fps with APCore.setFPS(). 
* 			Note, that this will not modify your movie's actual fps (this is not possible with ActionScript). 
* 			See AnimationCore class and AnimationCore.setDurationMode for details.
*/
dynamic class de.alex_uhlmann.animationpackage.APCore 
											implements IAnimationPackage {       
	
	private static var animationClip:MovieClip;
	private static var apCoreInstance:APCore;
	private static var apCentralMC:MovieClip;
	private static var fps:Number = 0;
	private static var isCalculatingFPS:Boolean = false;
	private static var instanceCount: Number = 0;
	private var ID:Number;
	
	//EventDispatcher mix-in
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;
	//EventDispatcher methods used for overriding mix-in
	private var dispatchEventOrig:Function;
	private var dispatchEventOverridden:Function;		
	public var addEventListenerOrig:Function;
	public var addEventListenerOverridden:Function;
	public var removeEventListenerOrig:Function;
	public var removeEventListenerOverridden:Function;
	//optional GDispatcher mix-in
	public var eventListenerExists:Function;
	public var removeAllEventListeners:Function;	
	//AsBroadcaster
	public static var addListener:Function;
	public static var removeListener:Function;
	public static var broadcastMessage:Function;

	private function APCore() {}
	
	private function init():Void {
		this.ID = ++APCore.instanceCount;
		if(!arguments[0]) {
			//this enabled subclasses to overwrite mix-in methods.
			dispatchEventOverridden = this.dispatchEvent;
			addEventListenerOverridden = this.addEventListener;
			removeEventListenerOverridden = this.removeEventListener;
			
			//EventDispatcher.initialize(this);
			GDispatcher.initialize(this);
			
			//this enabled subclasses to overwrite mix-in methods.
			dispatchEventOrig = this.dispatchEvent;
			addEventListenerOrig = this.addEventListener;
			removeEventListenerOrig = this.removeEventListener;
		}
	}
	
	/**
	* @method APCore.initialize
	* @description 	static, Initializes AnimationPackage including the internal broadcaster. Every class that needs listener 
	*				functionality will call this method. Needed if no other class of AnimationPackage that needs 
	*				listener functionality was constructed before or if you want to access 
	* 				the only APCore instance (i.e. for getNextDepth() or createClip() methods). APCore is a Singelton [GoF].
	* @usage   <tt>APCore.initialize();</tt> 	  
	* @return (APCore) the only instance of APCore. Singelton [GoF]
	*/
	/*
	* initialize listener functionality, create needed container movieclips and calculate the frame rate for one second. 
	* Singelton [GoF]
	*/
	public static function initialize(Void):APCore {		
		if(APCore.apCoreInstance == null) {			
			APCore.apCoreInstance = new APCore();
			AsBroadcaster.initialize(APCore);
			if (APCore.animationClip == null) {			
				APCore.setAnimationClip(_root);
			}
			APCore.createCentralMC();
			APCore.calculateFPS();	
			/*
			* The Macromedia Flex compiler doesn't understand the assignment 
			* done in Line 56 of AnimationCore: 
			* public static var easing_def:Function = Linear.easeNone;
			* Therefore, I have to assign the full path of Linear.easeNone to 
			* AnimationCore.easing_def at runtime. Because of performance reasons 
			* this is done in APCore.
			*/
			AnimationCore.easing_def = _global.com.robertpenner.easing.Linear.easeNone;
		}
		return APCore.apCoreInstance;
	}	
	
	/**
	* @method APCore.getAnimationClip
	* @description 	static, residence of the animationClip. See class documentation and APCore.setAnimationClip.
	* @usage   <tt>APCore.getAnimationClip(target);</tt>
	* @return (MovieClip) movieclip in which the apContainer_mc has been created.
	*/
	public static function getAnimationClip(Void):MovieClip {
		return APCore.animationClip;
	}
	
	/**
	* @method APCore.setAnimationClip
	* @description 	static, allow to set the timeline for the animationClip (apContainer_mc). Default is _root timeline.
	*                        The animationClip is a movieclip that contains everything made by AnimationPackage 
	* 			unless you explicitly prevent this. See class documentation.
	* @usage   <tt>APCore.setAnimationClip(target);</tt>
	* @param target (MovieClip) movieclip in which the apContainer_mc will be created.
	*/
	public static function setAnimationClip(target:MovieClip):Void {
		var apCoreInstance:APCore = APCore.apCoreInstance;
		APCore.animationClip =
			target.createEmptyMovieClip("apContainer_mc", apCoreInstance.getNextDepth(target));
		APCore.animationClip.onUnload = 
			Proxy.create(apCoreInstancee, apCoreInstance.onAnimationClipOverwrite);
	}
	
	private function onAnimationClipOverwrite(Void):Void {
		trace("ERROR: APCore.animationClip in "+this+" has been overwritten."
			+" Check your code for any depth overwriting or initialize AP" 
			+" within a specified Movieclip. See APCore.setAnimationClip.");
	}
	
	private static function createCentralMC(Void):Void {
		if(APCore.apCentralMC == null) {
			APCore.apCentralMC = 
				APCore.animationClip.createEmptyMovieClip("apCentral_mc", 
					APCore.apCoreInstance.getNextDepth(APCore.animationClip));		
			ImpulsDispatcher.initialize(APCore.apCentralMC);
		}		
	}
	
	public static function getCentralMC(Void):MovieClip {
		return APCore.apCentralMC;
	}
	
	public static function calculateFPS(Void):Void {
		if(APCore.fps == 0 && APCore.isCalculatingFPS == false) {			
			APCore.watchFPS();			
			APCore.addListener(APCore);
		}
	}
	
	private static function onFPSCalculated(Void):Void {		
		APCore.unwatchFPS();
	}
	
	private static function checkFPS(Void):Void {
		var fpsLocal:Number = ImpulsDispatcher.getFPS();
		if(fpsLocal != 0) {			
			APCore.fps = fpsLocal;
			APCore.broadcastMessage("onFPSCalculated", APCore.fps);
			ImpulsDispatcher.removeImpulsListener(APCore);
		}
	}
	
	/**
	* @method APCore.watchFPS
	* @description 	static, watches your movie's frame rate (fps = frames per second). 
	* 				Each second it receives a new result.
	* @usage   <tt>APCore.watchFPS();</tt>
	*/
	public static function watchFPS(Void):Void {		
		if(APCore.isCalculatingFPS == true) {
			APCore.removeListener(APCore);			
		} else {			
			ImpulsDispatcher.watchFPS();
			ImpulsDispatcher.addImpulsListener(APCore , "checkFPS");
			APCore.isCalculatingFPS = true;
		}		
	}
	
	/**
	* @method APCore.unwatchFPS
	* @description 	static, stop watching your movie's frame rate (fps = frames per second). 
	* 				Since watching your fps costs a little performance, I recommend to stop 
	* 				watching your fps if  you don't need to anymore.
	* @usage   <tt>APCore.unwatchFPS();</tt>
	*/
	public static function unwatchFPS(Void):Void {		
		APCore.isCalculatingFPS = false;
		ImpulsDispatcher.unwatchFPS();		
	}

	/**
	* @method APCore.getFPS
	* @description 	static, returns the last calculated value of your movie's frame rate (fps = frames per second). 
	* @usage   <tt>APCore.getFPS();</tt>
	* @return Number that specifies the number of frames your movie plays in one second.
	*/
	public static function getFPS(Void):Number {		
		var fpsLocal:Number = ImpulsDispatcher.getFPS();
		if(fpsLocal == 0 && APCore.fps != 0) {
			fpsLocal = APCore.fps;
		}		
		return fpsLocal;
	}
	
	/**
	* @method APCore.setFPS
	* @description 	static, sets the frame rate (fps = frames per second) stored in AnimationPackage.
	* 			For duration mode "MS" in tween mode "FRAMES" you might set the fps with APCore.setFPS(). 
	* 			Note, that this will not modify your movie's actual fps (this is not possible with ActionScript). 
	* 			See AnimationCore class and AnimationCore.setDurationMode for details.
	* @usage   <tt>APCore.setFPS();</tt>
	* @param fps_local (Number) that specifies the number of frames your movie plays in one second. (fps)
	*/
	public static function setFPS(fps_local:Number):Void {
		APCore.fps = fps_local;	
	}
	
	/**
	* @method APCore.milliseconds2frames
	* @description 	static, converts milliseconds to frames according to the current fps (frames per second) 
	* 				stored in AnimationPackage.
	* @usage   <tt>APCore.milliseconds2frames();</tt>
	* @param ms (Number) milliseconds to convert to frames.
	* @return Number of frames that are expected to run in one second.
	*/
	public static function milliseconds2frames(ms:Number):Number {
		return Math.round(ms / 1000 * APCore.getFPS());
	}
	
	/*common used methods*/	
	public function createClip(timelineObj:Object):MovieClip {
		
		var mc:MovieClip = timelineObj.mc;
		var parentMC:MovieClip = timelineObj.parentMC;
		var name:String =  timelineObj.name;		
		var x:Number = timelineObj.x;
		var y:Number = timelineObj.y;
		/*
		* Either
		* -create a new movieclip inside another
		* -create a new movieclip inside animationClip.
		* -positions an already created movieclip.
		*/
		if(parentMC != null) {
			mc = this.createMC(parentMC, name);
		} else if(mc == null) {
			var containerClip:MovieClip;
			containerClip = APCore.animationClip;		
			mc = this.createMC(containerClip, name);
		}
		if(x != null && y != null) {		    
			mc._x = x;
			mc._y = y;
		}
		return mc;
	}
	
	private function createMC(parentMC:MovieClip, name:String):MovieClip {
		/*Flash Player 7 feature disabled*/
		//var depth:Number = animationClip.getNextHighestDepth();
		var depth:Number = this.getNextDepth(parentMC);	
		return parentMC.createEmptyMovieClip(name+depth+"_mc", depth);
	}
	
	/* Adapted from Fernando Flórez - fernando@onelx.com - www.onelx.com */ 
	public function getNextDepth(mc:MovieClip):Number {		
		var t:Number = -Infinity;		
		var i:String;		
		for(i in mc){
			var p:Object = mc[i];
			if(p.getDepth() != null && p._parent == mc) {
				t = Math.max(t,p.getDepth());
			}
		}	
		return (t > -1) ? ++t : 0;
	}
	
	/*listener functionality, internal AsBroadcaster is used*/
	/**
	* @method APCore.addListener
	* @description  To subscribe an object to all events from AnimationPackage. 
	* @usage    <tt>APCore.addListener(obj);</tt>  
	* @returns   <code>true</code> if subscription was successful, 
	*                  <code>false</code> if not successful.
	*/
	
	/*internal AsBroadcaster is used*/
	/**
	* @method APCore.removeListener
	* @description        To unsubscribe an object to all events from AnimationPackage.                
	* @usage   <tt>APCore.removeListener(obj);</tt>
	* @returns <code>true</code> if successful, <code>false</code> 
	*                 if not successful.
	*/
	
	public function getID(Void):Number {
		return this.ID;
	}	

	/**
	* @method toString
	* @description 	returns the name of the class.
	* @usage   <tt>myInstance.toString();</tt>
	* @return String
	*/
	
	public function toString(Void):String {
		return "APCore";
	}
}