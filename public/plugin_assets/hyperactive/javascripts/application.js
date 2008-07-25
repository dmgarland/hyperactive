// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function toggleTag(cbValue, checked) {
    var tagFound = false;
    var tagField = $('tags');
    var tags = tagField.value.trim();
    var tagsArray = tags.split(" "); //.invoke('trim');
    if(checked) {
        if(tagsArray.detect(function(tag) { return tag.trim() == cbValue.trim(); })){
            if(tags.length > 0) {
                tagField.value += " " + cbValue;
            } else {
                tagField.value = cbValue;
            }
        } else {
            if(tags.length > 0) {
                tagField.value += " " + cbValue;
            }else{
                tagField.value = cbValue;
            }
            
        }
    } else {
        tagsArray = tagsArray.without(cbValue);
        tagField.value = tagsArray.join(" ");
    }
}

String.prototype.trim = function() { return this.replace(/^\s+|\s+$/, ''); };

// Gets user info from a cookie so that we can change the DOM to show customized pages.  This allows us to do 
// pseudo-customization of otherwise cached pages.

var UserInfo = new Object();

UserInfo.data = {};

UserInfo.transferFromCookies = function() {
  var data = JSON.parse(unescape(Cookie.get("user-info")));
  if(!data) data = {};
  UserInfo.data = data;
};

UserInfo.writeDataTo = function(name, element) {
  element = $(element);
  var content = "";
  if(UserInfo.data[name]) {
    content = UserInfo.data[name].toString().gsub(/\+/, ' ');
  }
  element.innerHTML = unescape(content);
};

