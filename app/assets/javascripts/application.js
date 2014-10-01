// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree.

/*
function popupCenter(url, width, height, name) {
 var left = (screen.width/2)-(width/2);
 var top = (screen.height/2)-(height/2);
 popupValue = "on";
 var targetWin = window.open(url, name, "menubar=no,toolbar=no,status=no,width="+width+",height="+height+",toolbar=no,left="+left+",top="+top);

}*/


function popupCenter(url, width, height, name)
{
 var left = (screen.width/2)-(width/2);
 var top = (screen.height/2)-(height/2);
 popupValue = "on";
    var newwindow=window.open(url, name, "menubar=no,toolbar=no,status=no,width="+width+",height="+height+",toolbar=no,left="+left+",top="+top);
    //newwindow.focus(document.URL)
    //return false;
}

$(document).ready(function(){
$("a.popup").click(function(e) {
	popupCenter($(this).attr("href"), $(this).attr("data-width"), $(this).attr("data-height"), "authPopup");
e.stopPropagation(); return false;
});

if(window.opener && window.opener.popupValue === 'on') {
 delete window.opener.popupValue;
 window.opener.location.reload(false);
 //window.close();
}
});

$(document).ready(function(){
	$(".line").tooltip();
});	

(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&appId=1479370212327640&version=v2.0";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));
