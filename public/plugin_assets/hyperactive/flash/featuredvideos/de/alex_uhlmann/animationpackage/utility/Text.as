import de.alex_uhlmann.animationpackage.APCore;

/**
* @class Text
* @author Alex Uhlmann
* @description  Easy way to setup textfield movieclips. Besides the examples of the Text class, there are 
* 				more examples using Text in the class documentation of Sequence and MoveOnCurve.
* @usage <tt>var myText:Text = new Text();</tt> 
*/
class de.alex_uhlmann.animationpackage.utility.Text extends APCore {	
	
	/** 
	* @property movieclip (MovieClip) Movieclip that contains the textfield.
	* @property style (TextFormat) Instance of TextFormat object. See Flash docs for further information.
	*/
	private var m_style:TextFormat;
	private var mc:MovieClip;
	
	public function Text() {		
		super.init(true);
	}
		
	/**
	* @method getText
	* @description 	returns the textfield instance of a textfield movieclip.
	* 			<p>
	* 			Example 1: outputs by default apContainer_mc location: 
	* 						"_level0.apContainer_mc.apText0_mc.apText0_txt"
	* 			<blockquote><pre>			
	*			var myText:Text = new Text();
	*			txt_mc = myText.setText("Hello World");
	*			trace(myText.getText());
	* 			</pre></blockquote>
	* 			Example 2: You can also send a textfield movieclip as a parameter to output 
	* 			the containing textfield. 
	* 			<blockquote><pre>
	*			myText.getText(someOtherText_mc)
	* 			</pre></blockquote>
	* 
	* @usage   <pre>myText.getText();</pre>
	*		<pre>myText.getText(text_mc);</pre>
	* 	  
	* @param text_mc (MovieClip) Textfield movieclip made with AnimationPackage.	
	* @return TextField
	*/	
	public function getText(mc:MovieClip):TextField {		
		if(mc == null) {
			mc = this.mc;
		}
		return mc.txtfield;
	}
		
	/**
	* @method setText
	* @description 	create a textfield movieclip. You can easily animate textfield movieclips 
	* 			since they are only textfields inside movieclips. All textfields will be centered 
	* 			inside their movieclip.
	* 			<p>
	* 			Example 1: Create a textfield, positioned at 0,0.
	* 			<blockquote><pre>			
	*			var myText:Text = new Text();
	*			myText.setText("Hello World");
	*			</pre></blockquote>
	* 			Example 2: create and format a textfield, using an embeded font. Note: you need to 
	* 			create a font symbol in your library and name the identifier to "arialblack".
	* 			<blockquote><pre>
	* 			var myTF:TextFormat = new TextFormat();
	*			myTF.font = "arialblack";
	*			myTF.color = 0xff0000;
	*			myTF.size = 20;
	*			var myText:Text = new Text();
	*			myText.setText("Hello World", 100, 100, myTF);
	* 			</pre></blockquote>
	* 			Example 3: Same like above, just using the setter properties.
	* 			<blockquote><pre>
	* 			var myTF:TextFormat = new TextFormat();
	*			myTF.font = "arialblack";
	*			myTF.color = 0xff0000;
	*			myTF.size = 20;
	*			var myText:Text = new Text();
	*			myText.style = myTF;
	*			myText.setText("Hello World",100,100);
	* 			</pre></blockquote>
	* 
	* @usage   <pre>myText.setText(txt);</pre>
	*		<pre>myText.setText(txt, x, y);</pre>
	* 		<pre>myText.setText(txt, x, y, style);</pre>
	* 	  
	* @param txt (String) Text to be displayed in the textfield.
	* @param x (Number) Coordinate point. Defaults to 0.
	* @param y (Number) Coordinate point. Defaults to 0.
	* @param style (TextFormat) Instance of TextFormat object. See Flash docs for further information.
	* @return MovieClip
	*/
	public function setText(txt:String, x:Number, y:Number, style:TextFormat):MovieClip {
		if(txt == null) {
			txt = "";
		}
		if(x == null) {
			x = 0;
		}
		if(y == null) {
			y = 0;
		}
		if(style != null) {
			this.style = style;
		}		
		this.mc = this.createClip({name:"apDraw"});
		/*Flash Player 7 feature disabled*/
		//var depth:Number = this.mc.getNextHighestDepth();			
		var depth:Number = this.getNextDepth(this.mc);	
		this.mc.createTextField("apText"+depth+"_txt", depth, 0, 0, 0, 0);
		this.mc.txtfield = this.mc["apText"+depth+"_txt"];	
		this.mc.txtfield.autoSize = "left";
		this.mc.txtfield.selectable = false;	
		this.mc.txtfield.text = txt;
		if (this.style != null) {			
			this.mc.txtfield.setTextFormat(this.style);
			this.mc.txtfield.embedFonts = true;
		}
		var halfWidth:Number = this.mc._width / 2;
		var halfHeight:Number = this.mc._height / 2;	
		this.mc.txtfield._x -= halfWidth;
		this.mc.txtfield._y -= halfHeight;		
		this.mc._x = x + halfWidth;
		this.mc._y = y + halfHeight;
		return this.mc;
	}
	
	/**
	* @method updateText
	* @description 	updates the text inside an already via setText() created textfield 
	* 			movieclip. (like yourTextfield.text = txt)
	* 
	* @usage   <pre>myText.updateText(txt);</pre>
	* 	  
	* @param txt (String) Text to be displayed in the textfield.
	*/	
	public function updateText(txt:String):Void {
		this.mc.txtfield.text = txt;
	}
	
	/**
	* @method addText
	* @description 	adds a text inside an already via setText() created textfield 
	* 			movieclip. (like yourTextfield.text += txt)
	* 
	* @usage   <pre>myText.addText(txt);</pre>
	* 	  
	* @param txt (String) Text to be displayed in the textfield.
	*/	
	public function addText(txt:String):Void {
		this.mc.txtfield.text += txt;
	}
	
	/**
	* @method clearText
	* @description 	clears a text inside an already via setText() created textfield 
	* 			movieclip. (like yourTextfield.text = "")
	* 
	* @usage   <pre>myText.clearText();</pre>
	*/	
	public function clearText(Void):Void {
		this.mc.txtfield.text = "";
	}	
	
	public function get movieclip():MovieClip {
		return this.mc;
	}
	
	public function set movieclip(mc:MovieClip):Void {
		this.mc = mc;
	}	
	
	public function get style():TextFormat {
                return this.m_style;
	}
        
	public function set style(style:TextFormat):Void {
                this.m_style = style;
	}	
	
	/**
	* @method getID
	* @description 	returns a unique ID of the instance. Usefull for associative arrays.
	* @usage   <tt>myInstance.getID();</tt>
	* @return Number
	*/
	
	/**
	* @method toString
	* @description 	returns the name of the class.
	* @usage   <tt>myInstance.toString();</tt>
	* @return String
	*/	
	public function toString(Void):String {
		return "Text";
	}
}