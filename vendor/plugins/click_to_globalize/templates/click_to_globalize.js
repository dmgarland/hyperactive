Element.prototype = Object.extend(Element.prototype, {
  getText: function() {
    return (this.firstChild && this.firstChild.nodeValue) ? this.firstChild.nodeValue : '';    
  }
});

function $$$(value) {
  return $(document.body).descendants().select(function(element){
    if($w('text/javascript textarea').include(element.type)) return false;
    return $(element).getText() == value;
  });
}

Ajax.InPlaceEditor.prototype = Object.extend(Ajax.InPlaceEditor.prototype,{
  _initialize: Ajax.InPlaceEditor.prototype.initialize,
  _createForm: Ajax.InPlaceEditor.prototype.createForm,
  // Fix for: http://dev.rubyonrails.org/ticket/4579
  initialize: function(element, url, options) {
    element = $(element);
    if($w('TD TH').include(element.tagName)){
      element.observe('click', this.enterEditMode.bindAsEventListener(this));
      element.observe('mouseover', this.enterHover.bindAsEventListener(this));
      element.observe('mouseout', this.leaveHover.bindAsEventListener(this));
      element.innerHTML = "<span>" + element.textContent + "</span>";
      element = element.down();
    }
    this._initialize(element, url, options);
  },
  createForm: function(){
    this._createForm();
    this.createHiddenField();
  },
  createHiddenField: function(){
    var textField = document.createElement("input");
    textField.obj = this;
    textField.type = 'hidden';
    textField.name = 'key';
    textField.value = this.options.hiddenValue;
    var size = this.options.size || this.options.cols || 0;
    if (size != 0) textField.size = size;
    this.form.appendChild(textField);
  }
});

var ClickToGlobalize = {
  translateUrl:             '/locale/translate',
  translateUnformattedUrl:  '/locale/translate_unformatted',
  translationsUrl:          '/locale/translations',
  httpMethod:               'post',
  asynchronous:              true,
  textileElements: ['a', 'acronym', 'blockquote', 'bold', 'cite', 'code',
                    'del', 'em', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'i',
                    'img', 'ins', 'span', 'strong', 'sub', 'sup', 'table',
                    'td', 'th'].collect(function(element){return element.toUpperCase();}),
  textarea:        {rows: 5, cols: 40},
  inputText:       {rows: 1, cols: 20},
  textLength:      160,
  clickToEditText: 'Click to globalize',
  translations:    null,
  
  init: function(){
    this.setTranslationsFromServer();
    this.generateEditors();
  },
  generateEditors: function() {
    this.translations.keys().each(function(key){
      text = ClickToGlobalize.translations[key];
      $$$(text).each(function(element){
        ClickToGlobalize.bindEditor(element, key, text);
      });
    });
  },
  bindEditor: function(element, key, text) {
    dimensions = text.stripTags().length > this.textLength ? this.textarea : this.inputText;
    new Ajax.InPlaceEditor(element, this.translateUrl, {
      hiddenValue: key,
      rows: dimensions.rows,
      cols: dimensions.cols,
      ajaxOptions: {method: ClickToGlobalize.httpMethod, asynchronous: ClickToGlobalize.asynchronous},
      loadTextURL: this.translateUnformattedUrl+'?key='+key,
      clickToEditText: ClickToGlobalize.clickToEditText,
      onComplete: function(transport, element) {
        if(transport){
          ClickToGlobalize.unbindEditor(element, this);
          if(ClickToGlobalize.textileElements.include(element.tagName)) {
            parent_element = element.ancestors().first();
            parent_element = ClickToGlobalize.textileElements.include(parent_element.tagName) ? parent_element : element;
            html   = transport.responseText;
            parent_element.replace(html);
            element = $$$(html.stripTags()).first();
          }
          ClickToGlobalize.bindEditor(element, key, transport.responseText);
        }
      }
    });
  },
  unbindEditor: function(element, editor) {
    Event.stopObserving(element, 'click',     editor.onclickListener);
    Event.stopObserving(element, 'mouseover', editor.mouseoverListener);
    Event.stopObserving(element, 'mouseout',  editor.mouseoutListener);
  },
  setTranslationsFromServer: function() {
    new Ajax.Request(this.translationsUrl, {
      onSuccess: function(transport) {
        ClickToGlobalize.translations = $H(transport.responseText.evalJSON());
      },
      // Set on false, cause we have to wait until the end of the request
      // to add the events to the elements.
      asynchronous: false
    });
  }
};