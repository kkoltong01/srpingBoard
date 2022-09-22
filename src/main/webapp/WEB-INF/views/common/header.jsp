<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

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
      <c:if test="${empty mvo}">
	      <ul class="nav navbar-nav navbar-right">
	            <li><a href="${contextPath}/memLoginForm.do"><span class="glyphicon glyphicon-log-in"></span> 로그인</a></li>
	            <li><a href="${contextPath}/memJoin.do"><span class="glyphicon glyphicon-user"></span> 회원가입</a></li>
	      </ul>
      </c:if>
      <c:if test="${!empty mvo }">
	      <ul class="nav navbar-nav navbar-right">
	      	<c:if test="${!empty mvo }">
				<c:if test="${empty mvo.memProfile}">
			  		<li style="color:white"><img class="img-circle" src="../${contextPath}/resources/images/person.jpg" style="width:50px; height:50px"/> ${mvo.memName}님</li>
			    </c:if>
			    <c:if test="${!empty mvo.memProfile}">
			  		<li style="color:white"><img class="img-circle" src="../${contextPath}/resources/images/${mvo.memProfile}" style="width:50px; height:50px"/> ${mvo.memName}님</li>
			  	</c:if>
			</c:if>
	      <li class="dropdown">
	         <a class="dropdown-toggle" data-toggle="dropdown" href="#">내정보<span class="caret"></span></a>
	         <ul class="dropdown-menu">
	           <li><a href="${contextPath }/memUpdateForm.do"><span class="glyphicon glyphicon-wrench"></span> 회원정보수정</a></li>
	           <li><a href="${contextPath }/memImageForm.do"><span class="glyphicon glyphicon-picture"></span> 프로필사진등록</a></li>
	         </ul>
	      </li>
	       <li><a href="${contextPath }/memLogout.do">로그아웃</a></li>
	      </ul>
      </c:if>
    </div>
  </div>
</nav>