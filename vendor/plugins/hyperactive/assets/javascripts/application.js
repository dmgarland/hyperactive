// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function toggleTag(cbValue, checked) {
    var tagFound = false;
    var tagField = $('tags');
    var tags = tagField.value.trim();
    var tagsArray = tags.split(",").invoke('trim');
    if(checked) {
        if(tagsArray.detect(function(tag) { return tag.trim() == cbValue.trim(); })){
            if(tags.length > 0) {
                tagField.value += ", " + cbValue;
            } else {
                tagField.value = cbValue;
            }
        } else {
            if(tags.length > 0) {
                tagField.value += ", " + cbValue;
            }else{
                tagField.value = cbValue;
            }
            
        }
    } else {
        tagsArray = tagsArray.without(cbValue);
        tagField.value = tagsArray.join(", ");
    }
}

String.prototype.trim = function() { return this.replace(/^\s+|\s+$/, ''); };
