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
  if(content)
    element.innerHTML = "You are currently logged in as: <strong>" + unescape(content) + "</strong>. You can <a href='/account'>view your account page</a> or <a href='/logout'>log out</a>.";
};
