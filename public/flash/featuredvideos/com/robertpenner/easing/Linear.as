class com.robertpenner.easing.Linear {
	static function easeNone (t:Number, b:Number, c:Number, d:Number):Number {
		var a = c*t/d + b;		
		return a;
	}
	static function easeIn (t:Number, b:Number, c:Number, d:Number):Number {
		return c*t/d + b;
	}
	static function easeOut (t:Number, b:Number, c:Number, d:Number):Number {
		return c*t/d + b;
	}
	static function easeInOut (t:Number, b:Number, c:Number, d:Number):Number {
		return c*t/d + b;
	}
}
