function loadScript(sScriptSrc, oCallback) {
   var oHead = document.getElementsByTagName('head')[0];
   // Save a list of scripts
   this.allscripts = sScriptSrc;
   var unloaded; 

   function increaseandload(){
      unloaded = unloaded + 1;
      if (unloaded < sScriptSrc.length)
      {
         loadnext();
      }
      else {
    	  //alert("about to callback");
         oCallback();
      }
   }

   function loadnext(){
         var oScript = document.createElement('script');
         oScript.type = 'text/javascript';
         oScript.src = sScriptSrc[unloaded];

         // most browsers
         oScript.onload = increaseandload;
         // IE 6 & 7
         oScript.onreadystatechange = function() {
         if (this.readyState == 'complete' || this.readyState == 'loaded') {
            increaseandload();
         }

         }
         oHead.appendChild(oScript);


   }

   this.loadall = function(){
      unloaded = 0;
      loadnext();

   };

}