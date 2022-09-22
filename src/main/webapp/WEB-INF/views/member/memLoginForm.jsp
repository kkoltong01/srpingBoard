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
</head>
<body>
<div class="container">
 <jsp:include page="../common/header.jsp"/>
  <h2>SPRING MVC03</h2>
  <div class="panel panel-default">
    <div class="panel-heading">로그인화면</div>
    <div class="panel-body">
    	<form action="${contextPath}/memLogin.do" method="post">
		    <table class="table table-bordered" style="text-align: center; border :1px solid black;">
		    	<tr>
		    		<td style="width:15%; vertical-align:middle;">아이디</td>
		    		<td><input type="text" id="memID" name="memID" class="form-control" placeholder="아이디를 입력해주세요." maxlength="20"/></td>
		    	</tr>
		    	<tr>
		    		<td style="width:15%; vertical-align:middle;">비밀번호</td>
		    		<td colspan="2"><input type="password" id="memPassword" name="memPassword" class="form-control" placeholder="비밀번호를 입력해주세요." maxlength="20"/></td>
		    	</tr>
		    	<tr>
		    		<td colspan="3" style="text-align: left;">
                		<input type="submit" class="btn btn-primary btn-sm pull-right" value="로그인"/>
             		</td>
		    	</tr>
		    </table>
		    <!-- CSRF 토큰 넘겨주자 -->
		     <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
    	</form>
    </div>
    <div class="panel-footer">Spring_test</div>
  </div>
</div>

</body>
</html>
