//= require jquery
//= require twitter/bootstrap
//= require countdown

onload=function(){
var e=document.getElementById("refreshed");
if(e.value=="no")e.value="yes";
else{e.value="no";location.reload();}
}