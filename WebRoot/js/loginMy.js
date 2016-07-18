
//获取input的所有id
var user = document.getElementById("user");
var pwd = document.getElementById("pwd");
var surePwd = document.getElementById("surePwd");

//获取span的所有id
var user_pass = document.getElementById("user_pass");
var pwd_pass = document.getElementById("pwd_pass");
var surePwd_pass = document.getElementById("surePwd_pass");

var code ; //在全局 定义验证码


function checkUser(){
    //如果昵称未输入，则提示输入昵称
    if(!user.value){
        user_pass.style.fontSize = "13px";
        user_pass.style.width="31%";
        user_pass.style.height="2em";
        user_pass.style.textAlign="center";
        user_pass.style.lineHeight="2em";
        user_pass.style.marginTop='0.05%'
        user_pass.innerHTML = '你还没有填写用户名哦。';
        user_pass.style.display="block";
    }
    else if(user.value){
        user_pass.style.display="none";
    }
}

//输入密码提示
function checkUser1(){
    //如果未输入密码，则提示请输入密码
    if(!pwd.value){
        pwd_pass.style.fontSize = "13px";
        pwd_pass.style.width="31%";
        pwd_pass.style.height="2em";
        pwd_pass.style.textAlign="center";
        pwd_pass.style.lineHeight="2em";
        pwd_pass.innerHTML = '你还没有填写密码哦。';
        pwd_pass.style.display="block";
    }
    else{
        pwd_pass.innerHTML ='';
        pwd_pass.style.backgroundColor= "#fff";
        pwd_pass.style.border="none";
        pwd_pass.style.display="none";

    }

}


function  submitB(){
	
    if(!validate()){
    	return false;
    }
    else{
        var f = sendParam();
        return f;
    }

}
/* 新添加验证码验证功能 */
function createCode(){ 
	code = new Array();
	var codeLength = 4;//验证码的长度
	var checkCode = document.getElementById("checkCode");
	checkCode.value = "";

	var selectChar = new Array(2,3,4,5,6,7,8,9,'A','B','C','D','E','F','G','H','J','K','L','M','N','P','Q','R','S','T','U','V','W','X','Y','Z');

	for(var i=0;i<codeLength;i++) {
		var charIndex = Math.floor(Math.random()*32);
		code +=selectChar[charIndex];
	}
	if(code.length != codeLength){
		createCode();
	}
	checkCode.value = code;
}
function validate() {

    var inputCode = document.getElementById("surePwd").value.toUpperCase();
	
	if(inputCode.length <=0) {
	alert("请输入验证码！");
	createCode();
	return false;
	}
	else if(inputCode != code ){
	alert("验证码输入错误！");
	createCode();
	return false;
	}
	else {
	return true;
	}
}
