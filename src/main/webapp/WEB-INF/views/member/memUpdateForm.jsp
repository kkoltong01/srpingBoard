<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="security" uri="http://www.springframework.org/security/tags" %>   
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<c:set var="mvo" value="${SPRING_SECURITY_CONTEXT.authentication.principal}"/> 
<c:set var="auth" value="${SPRING_SECURITY_CONTEXT.authentication.authorities}"/> 
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
  function goUpdate() {
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
    <div class="panel-heading">회원정보수정</div>
    <div class="panel-body">
    	<form name="frm" action="${contextPath}/memUpdate.do" method="post">
    		<input type="hidden" id="memID" name="memID" value="${mvo.member.memID }"/>
    		<input type="hidden" id="memPassword" name="memPassword" value=""/>
		    <table class="table table-bordered" style="text-align: center; border :1px solid black;">
		    	<tr>
		    		<td style="width:15%; vertical-align:middle;">아이디</td>
		    		<td>${mvo.member.memID }</td>
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
		    		<td style="width:15%; vertical-align:middle;">사용자이름</td>
		    		<td colspan="2"><input type="text" id="memName" name="memName" class="form-control" placeholder="이름을 입력해주세요." maxlength="20" value="${mvo.member.memName }"/></td>
		    	</tr>
		    	<tr>
		    		<td style="width:15%; vertical-align:middle;">나이</td>
		    		<td colspan="2"><input type="text" id="memAge" name="memAge" class="form-control" placeholder="나이를 입력해주세요." maxlength="20" value="0" value="${mvo.member.memAge }"/></td>
		    	</tr>
		    	<tr>
		    		<td style="width:15%; vertical-align:middle;">성별</td>
		    		 <td colspan="2">
		                <div class="form-group" style="text-align: center; margin: 0 auto;">
		                    <div class="btn-group" data-toggle="buttons">
		                       <label class="btn btn-primary <c:if test="${mvo.member.memGender eq '남자'}"> active</c:if>">
		                         <input type="radio"  name="memGender" autocomplete="off" value="남자" 
		                           <c:if test="${mvo.member.memGender eq '남자'}"> checked</c:if> />남자
		                       </label>
		                        <label class="btn btn-primary <c:if test="${mvo.member.memGender eq '여자'}"> active</c:if>">
		                         <input type="radio"  name="memGender" autocomplete="off" value="여자"
		                           <c:if test="${mvo.member.memGender eq '여자'}"> checked</c:if> />여자
		                       </label>
		                    </div>
		                </div>
		             </td>
		    	</tr>
		    	<tr>
		    		<td style="width:15%; vertical-align:middle;">이메일</td>
		    		<td colspan="2"><input type="text" id="memEmail" name="memEmail" class="form-control" placeholder="이메일을 입력해주세요." maxlength="20" value="${mvo.member.memEmail }"/></td>
		    	</tr>
		    	<tr>
		    		<td style="width:15%; vertical-align:middle;">사용자 권한</td>
		    		<td colspan="2">
		    			<input type="checkbox" name="authList[0].auth" value="ROLE_USER" 
		                  <security:authorize access="hasRole('ROLE_USER')">
		                    checked
		                  </security:authorize>
		                 /> ROLE_USER  
                 
		                 <input type="checkbox" name="authList[1].auth" value="ROLE_MANAGER"
		                   <security:authorize access="hasRole('ROLE_MANAGER')">
		                    checked
		                  </security:authorize>
		                  /> ROLE_MANAGER
                
		                 <input type="checkbox" name="authList[2].auth" value="ROLE_ADMIN"
		                   <security:authorize access="hasRole('ROLE_ADMIN')">
		                    checked
		                  </security:authorize>
		                  /> ROLE_ADMIN
		    		</td>
		    	</tr>
		    	<tr>
		    		<td colspan="3" style="text-align: left;">
                		<span id="passMessage" style="color: red"></span><input type="button" class="btn btn-primary btn-sm pull-right" value="수정" onclick="goUpdate()"/>
             		</td>
		    	</tr>
		    </table>
		    <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
    	</form>
    </div>
<!-- 회원수정 모달 -->
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
