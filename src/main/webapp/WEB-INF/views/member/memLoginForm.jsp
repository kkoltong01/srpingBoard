<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
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
    <div class="panel-heading">�α���ȭ��</div>
    <div class="panel-body">
    	<form action="${contextPath}/memLogin.do" method="post">
		    <table class="table table-bordered" style="text-align: center; border :1px solid black;">
		    	<tr>
		    		<td style="width:15%; vertical-align:middle;">���̵�</td>
		    		<td><input type="text" id="memID" name="memID" class="form-control" placeholder="���̵� �Է����ּ���." maxlength="20"/></td>
		    	</tr>
		    	<tr>
		    		<td style="width:15%; vertical-align:middle;">��й�ȣ</td>
		    		<td colspan="2"><input type="password" id="memPassword" name="memPassword" class="form-control" placeholder="��й�ȣ�� �Է����ּ���." maxlength="20"/></td>
		    	</tr>
		    	<tr>
		    		<td colspan="3" style="text-align: left;">
                		<input type="submit" class="btn btn-primary btn-sm pull-right" value="�α���"/>
             		</td>
		    	</tr>
		    </table>
    	</form>
    </div>
    <div class="panel-footer">Spring_test</div>
  </div>
</div>

</body>
</html>
