// A simple javascipt to validate forms to avoid titles being empty
// This is a usability improvement: server side controls take care of
// the database consistency.

// Check it is called:
// alert('Hello World!');

function hasConstraints(aform){
   // Get all the labels in the form
   var all_labels = aform.getElementsByTagName('label');
   var constraint_elements = [];
   // Add all names
   for (i = 0; i < all_labels.length; i++)
   {  
      if (all_labels[i].innerHTML.include("*")){
         // Given that a label has a star (*) we require its field!
       
         var cands = $(all_labels[i]).nextSiblings();
         for (n = 0; n < cands.length; n++){

            if (cands[n].tagName.toLowerCase() == "input" || cands[n].tagName.toLowerCase() == "textarea") {
               constraint_elements = constraint_elements.concat( $(cands[n]) );
               break;
            }

         } 

       }
   }
   return constraint_elements;
}

// Toggle on and off the "warning" div after a field
function toggle_warning(elem){
   var ne = elem.next(); 
   if (ne && ne.className.toLowerCase() == 'warning')  {
      if ($F(elem) == ''){
         ne.show(); 
      }
      else {
         ne.hide();
      }
   }
   else
   {
      if ($F(elem) == ''){
         elem.insert({"after":"<span class='warning'><img src='../images/icons/error.png'/><span class='warningtext'> Required!</span></span>"});
      }
   }
}

function handle_submit(evt){
   // Get all fields with constraint
   var ce = hasConstraints(evt.target);

   // Find the captcha field
   var cap_input = Form.getInputs(Event.element(evt), 'text','captcha');
   if (cap_input){
      ce = ce.concat( cap_input[0] );
   }

   // Detect if we should prevent submission
   var should_stop = false;
   for (field = 0; field < ce.length; field++){
      if ($F(ce[field]) == ''){
          should_stop = true;
      }
      // DO SOMETHING TO INDICATE A PROBLEM
      toggle_warning(ce[field]);

   }

   // Stop the submission of the form
   // And display an error
   if (should_stop){
      Event.stop(evt);
      
      // Get the submit button and attach to it a warning
      var submit_control = Form.getInputs(Event.element(evt), 'submit')[0];
      if (submit_control.next() && submit_control.next().className.toLowerCase() == 'warning'){
          
      } else {
          submit_control.insert({"after":"<span class='warning'><img src='../images/icons/error.png'/><span class='warningtext'> Some required fields are missing! </span></span>"});
      }
   }
}

Event.observe(window, 'load', function(){
   // Get the prototype-extended form elements from this page
   var allforms = $(document.getElementsByTagName('form'));

   for (i = 0; i < allforms.length; i++){
      // Register a validator with each form
      Event.observe(allforms[i], 'submit', handle_submit);
   }
});
