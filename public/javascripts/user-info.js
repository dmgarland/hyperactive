var UserInfo = new Object();

UserInfo.data = {};

UserInfo.transferFromCookies = function() {
  var data = Cookie.get("user_info");
  if(!data) data = "";
  UserInfo.data = data;
};

UserInfo.writeDataTo = function(name, element) {
  element = $(element);
  var content = "";
  if(UserInfo.data) {
    content = UserInfo.data;
  }
  if(content != "anonymous")
    element.innerHTML = "Currently logged in as: " + unescape(content);
};
