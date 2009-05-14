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
    element.innerHTML = "<img src='/images/user_green.png' />You are currently logged in as: <strong>" + unescape(content) + "</strong>. You can <a href='/account'>view your account page</a>, <a href='/change_password'>change your password</a> or <a href='/logout'>log out</a>.";
};
