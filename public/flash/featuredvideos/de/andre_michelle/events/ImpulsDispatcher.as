class de.andre_michelle.events.ImpulsDispatcher
{
	static var _listeners: Array;
	static var _timeline: MovieClip;
	static var timer: Number;
	static var frames: Number;
	static var fps: Number;
	static var fpsInterval: Number;
	
	static function initialize ( timeline: MovieClip ): Void
	{		
		if ( _timeline ) decontrol();
		pause();
		_listeners = new Array();
		timer = getTimer();
		_timeline = timeline;
	}

	static function decontrol( timeline: MovieClip ): Void
	{
		_global.ASSetPropFlags( timeline , "onEnterFrame" , 0 , 7 );
		delete timeline.onEnterFrame;
		delete _listeners;
		delete _timeline;
		delete timer;
	}

	static function watchFPS(): Void
	{
		fpsInterval = setInterval( function(){ ImpulsDispatcher.fps = ImpulsDispatcher.frames; ImpulsDispatcher.frames = 0; } , 1000 );
		addImpulsListener( ImpulsDispatcher , 'countFrames' );
		frames = 0;		
	}

	static function unwatchFPS(): Void
	{
		clearInterval( fpsInterval );
		removeImpulsListener( ImpulsDispatcher );
		fps = undefined;
	}

	static function getFPS(): Number
	{		
		if ( fps == undefined ) return 0;
		return fps;
	}

	static function countFrames(): Void
	{		
		++frames;		
	}

	static function pause(): Void
	{
		_global.ASSetPropFlags( _timeline , "onEnterFrame" , 0 , 7 );
		delete _timeline.onEnterFrame;
		_global.ASSetPropFlags( _timeline , "onEnterFrame" , 7 );
		fps = undefined;
	}

	static function resume(): Void
	{		
		if ( _listeners.length == 0 ) return;
		_global.ASSetPropFlags( _timeline , "onEnterFrame" , 0 , 7 );
		_timeline.onEnterFrame = ImpulsDispatcher.onImpuls;
		_global.ASSetPropFlags( _timeline , "onEnterFrame" , 7 );
		timer = getTimer();
		frames = 0;
	}

	static function addImpulsListener( handler , callback: String ): Void
	{		
		_listeners.push( { o: handler, c: callback } );
		if ( _listeners.length == 1 ) resume();
	}

	static function removeImpulsListener( handler ): Boolean
	{
		var l: String;
		var listener;
		for ( l in _listeners )
		{
			listener = _listeners[ l ];
			if ( listener.o == handler )
			{
				_listeners.splice( Number(l) , 1 );
				if ( _listeners.length == 0 ) pause();
				return true;
			}
		}
		return false;
	}

	static function onImpuls(): Void
	{		
		var delta_t: Number = ( getTimer() - timer ) / 1000;
		timer = getTimer();
		var l: String;
		var listener;
		for ( l in _listeners )
		{
			listener = _listeners[ l ];
			listener.o[ listener.c ]( delta_t );
		}
	}
}