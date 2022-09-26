<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<c:set var="mvo" value="${SPRING_SECURITY_CONTEXT.authentication.principal}"/> 
<c:set var="auth" value="${SPRING_SECURITY_CONTEXT.authentication.authorities}"/>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<script>
	var csrfHeaderName= "${_csrf.headerName}";
	var csrfTokenValue= "${_csrf.token}";
	function logout() {
		$.ajax({
			url: "${contextPath}/logout",
			type:"post",
			beforeSend:function(xhr) {
				xhr.setRequestHeader(csrfHeaderName,csrfTokenValue)
			},
			success : function() {
				location.href="${contextPath}/"
			},
			error : function() { alert("error");}
		});
	}
</script>

<nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>                        
      </button>
      <a class="navbar-brand" href="#">WebSiteName</a>
    </div>
    <div class="collapse navbar-collapse" id="myNavbar">
      <ul class="nav navbar-nav">
        <li class="active"><a href="${contextPath }/">Home</a></li>
        <li><a href="boardMain.do">게시판</a></li>
      </ul>
      <security:authorize access="isAnonymous()">
	      <ul class="nav navbar-nav navbar-right">
	            <li><a href="${contextPath}/memLoginForm.do"><span class="glyphicon glyphicon-log-in"></span> 로그인</a></li>
	            <li><a href="${contextPath}/memJoin.do"><span class="glyphicon glyphicon-user"></span> 회원가입</a></li>
	      </ul>
      </security:authorize>
      <security:authorize access="isAuthenticated()">
	      <ul class="nav navbar-nav navbar-right">
				<c:if test="${empty mvo.member.memProfile}">
			  		<li style="color:white"><img class="img-circle" src="../${contextPath}/resources/images/person.jpg" style="width:50px; height:50px"/> ${mvo.member.memName}님
			    </c:if>
			    <c:if test="${!empty mvo.member.memProfile}">
			  		<li style="color:white"><img class="img-circle" src="../${contextPath}/resources/images/${mvo.member.memProfile}" style="width:50px; height:50px"/> ${mvo.member.memName}님
			  	</c:if>
	      <li class="dropdown">
	         <a class="dropdown-toggle" data-toggle="dropdown" href="#">내정보<span class="caret"></span></a>
	         <ul class="dropdown-menu">
	           <li><a href="${contextPath }/memUpdateForm.do"><span class="glyphicon glyphicon-wrench"></span> 회원정보수정</a></li>
	           <li><a href="${contextPath }/memImageForm.do"><span class="glyphicon glyphicon-picture"></span> 프로필사진등록</a></li>
	         </ul>
	      </li>
	       <li><a href="javascript:logout()">로그아웃</a></li>
	      </ul>
      </security:authorize>
    </div>
  </div>
</nav>