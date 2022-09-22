<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Bootstrap Example</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
  <script>
  $(document).ready(function() {
	  if(${!empty msgType}) {
		  $("#messageType").attr("class","modal-content panel-warning");
		  $("#myMessage").modal("show");
	  }
  });
  function registerCheck(){
      var memID=$("#memID").val();
      $.ajax({
   	   url : "${contextPath}/memRegisterCheck.do",
   	   type : "get",
   	   data : { "memID" : memID},
   	   success : function(result){
   		   // 중복유무 출력(result=1 : 사용할수있는 아이디, 0 : 사용할수없는 아이디)
   		 	if(result==1) {
   		 		$("#checkMessage").html("사용할 수 있는 아이디입니다.");
   		 		$("#checkType").attr("class","modal-content panel-success");
   		 	} else {
   		 		$("#checkMessage").html("사용할 수 없는 아이디입니다.");
   		 		$("#checkType").attr("class","modal-content panel-warning");
   		 	}
   		    $("#myModal").modal("show");
   	   },    	   
   	   error : function(){ alert("error"); }    	   
      });
   }
  function passwordCheck() {
	  var memPwd1=$("#memPwd1").val();
	  var memPwd2=$("#memPwd2").val();
	  if(memPwd1 != memPwd2) {
		  $("#passMessage").html("비밀번호가 서로 일치하지 않습니다.");
	  } else {
		  $("#passMessage").html("");
		  $("#memPassword").val(memPwd1);
	  }
  }
  function goInsert() {
	  var memAge=$("#memAge").val();
	  if(memAge==null || memAge=="" || memAge==0) {
		  alert("나이를 입력하세요");
		  return false;
	  }
	  document.frm.submit();
  }
  </script>
</head>
<body>
<jsp:include page="../common/header.jsp"/>
<div class="container">
  <h2>SPRING TEST</h2>
  <div class="panel panel-default">
    <div class="panel-heading">회원가입</div>
    <div class="panel-body">
    	<form name="frm" action="${contextPath}/memRegister.do" method="post">
    		<input type="hidden" id="memPassword" name="memPassword" value=""/>
		    <table class="table table-bordered" style="text-align: center; border :1px solid black;">
		    	<tr>
		    		<td style="width:15%; vertical-align:middle;">아이디</td>
		    		<td><input type="text" id="memID" name="memID" class="form-control" placeholder="아이디를 입력해주세요." maxlength="20"/></td>
		    		<td><button class="btn btn-primary btn-sm" type="button" onclick="registerCheck()">중복확인</button></td>
		    	</tr>
		    	<tr>
		    		<td style="width:15%; vertical-align:middle;">비밀번호</td>
		    		<td colspan="2"><input type="password" id="memPwd1" name="memPwd1" class="form-control" onkeyup="passwordCheck()" placeholder="비밀번호를 입력해주세요." maxlength="20"/></td>
		    	</tr>
		    	<tr>
		    		<td style="width:15%; vertical-align:middle;">비밀번호확인</td>
		    		<td colspan="2"><input type="password" id="memPwd2" name="memPwd2" class="form-control" onkeyup="passwordCheck()" placeholder="비밀번호를 입력해주세요." maxlength="20"/></td>
		    	</tr>
		    	<tr>
		    		<td style="width:15%; vertical-align:middle;">이름</td>
		    		<td colspan="2"><input type="text" id="memName" name="memName" class="form-control" placeholder="이름을 입력해주세요." maxlength="20"/></td>
		    	</tr>
		    	<tr>
		    		<td style="width:15%; vertical-align:middle;">나이</td>
		    		<td colspan="2"><input type="text" id="memAge" name="memAge" class="form-control" placeholder="나이를 입력해주세요." maxlength="20" value="0"/></td>
		    	</tr>
		    	<tr>
		    		<td style="width:15%; vertical-align:middle;">성별</td>
		    		<td colspan="2">
		    			<div class="form-group" style="text-align:center; marghin:0 outo;">
		    				<div class="btn-group" data-toggle="buttons">
		    					<label>
		    						<input type="radio" id="memGender" name="memGender" autocomplete="off" value="남자">남자</input>
		    					</label>
		    					<label>
		    						<input type="radio" id="memGender" name="memGender" autocomplete="off" value="여자"/>여자</input>
		    					</label>
		    				</div>
		    			</div>
		    		</td>
		    	</tr>
		    	<tr>
		    		<td style="width:15%; vertical-align:middle;">이메일</td>
		    		<td colspan="2"><input type="text" id="memEmail" name="memEmail" class="form-control" placeholder="이메일을 입력해주세요." maxlength="20"/></td>
		    	</tr>
		    	<tr>
		    		<td colspan="3" style="text-align: left;">
                		<span id="passMessage" style="color: red"></span><input type="button" class="btn btn-primary btn-sm pull-right" value="등록" onclick="goInsert()"/>
             		</td>
		    	</tr>
		    </table>
		    <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
    	</form>
    </div>
    <!-- 아이디중복 확인 모달  -->
    <div id="myModal" class="modal fade" role="dialog">
  <div class="modal-dialog">
    <!-- Modal content-->
    <div id="checkType" class="modal-content panel-info">
      <div class="modal-header panel-heading">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">아이디 중복확인</h4>
      </div>
      <div class="modal-body">
        <p id="checkMessage"></p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<!-- 회원가입 모달 -->
<div id="myMessage" class="modal fade" role="dialog">
  <div class="modal-dialog">
    <!-- Modal content-->
    <div id="messageType" class="modal-content panel-info">
      <div class="modal-header panel-heading">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">${msgType}</h4>
      </div>
      <div class="modal-body">
        <p>${msg}</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>

  </div>
</div>
    <div class="panel-footer">Spring_test</div>
  </div>
</div>
</body>
</html>
