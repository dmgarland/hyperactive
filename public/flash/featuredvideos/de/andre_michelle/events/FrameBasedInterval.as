import de.andre_michelle.events.*;

class de.andre_michelle.events.FrameBasedInterval
{
	static public var m_frame: Number = 0;
	static private var intervals: Array;

	public static function get frame(): Number
	{
		return m_frame;
	}

	static function addInterval( object: Object, method: String , intervalLength: Number ): Object
	{
		if ( intervals == undefined )
		{
			intervals = new Array();
			startMonitoring();
		}

		var interval: Object = {

			object: object,
			method: method,
			intervalLength: intervalLength,
			args: arguments.splice( 3 ),
			startFrame: m_frame
		};

		intervals.push( interval );

		return interval;
	}

	static function removeInterval( interval ): Boolean
	{
		var i: String;
		for ( i in intervals )
		{
			if ( intervals[i] == interval )
			{
				intervals.splice( Number(i) , 1 );
				if ( intervals.length == 0 )
				{
					delete intervals;
					stopMonitoring();
				}
				return true;
			}
		}

		return false;
	}

	static private function startMonitoring(): Void
	{
		ImpulsDispatcher.addImpulsListener( FrameBasedInterval , 'checkFrame' );
	}

	static private function stopMonitoring(): Void
	{
		ImpulsDispatcher.removeImpulsListener( FrameBasedInterval );
	}

	static function checkFrame(): Void
	{
		++m_frame;
		var i: String;
		for ( i in intervals )
		{
			var interval = intervals[i];
			if ( ( m_frame - interval.startFrame ) % interval.intervalLength == 0 )
			{
				var o = interval.object;
				o[ interval.method ].apply( o , interval.args );
			}
		}
	}
}