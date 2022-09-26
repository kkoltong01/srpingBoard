<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<c:set var="mvo" value="${SPRING_SECURITY_CONTEXT.authentication.principal}"/> 
<c:set var="auth" value="${SPRING_SECURITY_CONTEXT.authentication.authorities}"/>
<!DOCTYPE html>
<html>
<head>
  <title>spring03</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
	<script>
		var csrfHeaderName = "${_csrf.headerName}";
    	var csrfTokenValue = "${_csrf.token}";
    
		$(document).ready(function() {
			loadList();
		});
		function loadList(){
			// 서버와 통신 : 게시판 리스트 가져오기
			$.ajax({
				url:"board/all",
				type: "get",
				dataType : "json",
				success : makeView,
				error : function() {alert("error")}
			});
		}
		function makeView(data) {
			var listHtml= "<table class='table table-bordered'>";
			listHtml+="<tr>";
			listHtml+="<td>번호</td>";
			listHtml+="<td>제목</td>";
			listHtml+="<td>작성자</td>";
			listHtml+="<td>작성일</td>";
			listHtml+="<td>조회수</td>";
			listHtml+="</tr>";
			$.each(data, function(index,obj) { //obj={"idx":5,"title":"게시판"~~}
				listHtml+="<tr>";
				listHtml+="<td>"+obj.idx+"</td>";
				listHtml+="<td id='t"+obj.idx+"'><a href='javascript:goContent("+obj.idx+")'>"+obj.title+"</a></td>";
				listHtml+="<td>"+obj.writer+"</td>";
				listHtml+="<td>"+obj.indate.split(' ')[0]+"</td>";
				listHtml+="<td id='cnt"+obj.idx+"'>"+obj.count+"</td>";
				listHtml+="</tr>";
			
				listHtml+="<tr id='n"+obj.idx+"' style='display:none'>";
				listHtml+="<td>내용</td>";
				listHtml+="<td colspan='4'>";
				listHtml+="<textarea id='c"+obj.idx+"' rows='7' class='form-control' readonly></textarea>";
				if("${mvo.member.memID}"==obj.memID) {
					listHtml+="</br>";
					listHtml+="<span id='ub"+obj.idx+"'><button class='btn btn-success btn-sm' onclick='goUpdateForm("+obj.idx+")'>수정화면</button></span>&nbsp";
					listHtml+="<button class='btn btn-warning btn-sm' onclick='goDelete("+obj.idx+")'>삭제</button>";
				} 
				listHtml+="</td>";
				listHtml+="</tr>";
			});
			if(${!empty mvo.member}) {
				listHtml+="<tr>";
				listHtml+="<td colspan='5'>";
				listHtml+="<button class='btn btn-primary btn-sm' onclick='goForm()'>글쓰기</button>";
				listHtml+="</td>";
				listHtml+="</tr>";
			}
			listHtml+="</table>";
			$("#view").html(listHtml);
			
			$("#view").css("display","block"); 
			$("#wForm").css("display","none");
		}
		function goForm() {
			$("#view").css("display","none"); //감추고
			$("#wForm").css("display","block"); //보이고
		}
		function goList() {
			$("#view").css("display","block"); 
			$("#wForm").css("display","none"); 
		}
		function goInsert() {
			//var title=$("#title").val();
			//var content=$("#content").val();
			//var writer=$("#writer").val();
			var fData=$("#frm").serialize(); //form 안에 id 값(파라메터들)을 다 가져온다
			$.ajax({
				url:"board/new",
				type:"post",
				data:fData,
				beforeSend: function(xhr){
	    			 xhr.setRequestHeader(csrfHeaderName, csrfTokenValue)},
				success:loadList,
				error:function() {alert("error");}
			});
			
			//$("#title").val("");
			//$("#content").val("");
			//$("#writer").val("");
			$("#fclear").trigger("click");
		}
		function goContent(idx) {
			if($("#n"+idx).css("display")=="none") {
				
				// 제목 눌렀을 때 content 값 가져오기
				$.ajax({
					url: "board/"+idx,
					type:"get",
					dataType:"json",
					success: function(data) {
						$("#c"+idx).val(data.content);
					},
					error : function() {alert("error");}
				});
				//카운트 수 증가
				$.ajax({
					url: "board/count/"+idx,
					type:"put",
					dataType:"json",
					 beforeSend: function(xhr){
	        			 xhr.setRequestHeader(csrfHeaderName, csrfTokenValue)
	        		 },
					success: function(data) {
						$("#cnt"+idx).text(data.count);
					},
					error : function() {alert("error");}
				});
				
				$("#n"+idx).css("display","table-row"); // tr은 block이 아니고 table-row로 해야 넓이가 먹힘				
				$("#c"+idx).attr("readonly",true);
				
				
			} else {
				$("#n"+idx).css("display","none");
			}
		}
		function goDelete(idx) {
			$.ajax({
				url:"board/"+idx,
				type:"delete",
				 beforeSend: function(xhr){
        			 xhr.setRequestHeader(csrfHeaderName, csrfTokenValue)
        		 },
				success:loadList,
				error:function(){alert("error");}
			});
		}
		function goUpdateForm(idx){
			$("#c"+idx).attr("readonly",false);
			var title=$("#t"+idx).text();
			var newInput="<input type='text' id='nt"+idx+"' value='"+title+"' class='form-control'/>"
			$("#t"+idx).html(newInput);
			
			var newButton="<button class='btn btn-primary btn-sm' onclick='goUpdate("+idx+")'>수정</button>";
			$("#ub"+idx).html(newButton);
		}
		function goUpdate(idx) {
			var title=$("#nt"+idx).val();
			var content=$("#c"+idx).val();
			$.ajax({
				url:"board/"+idx,
				type:"put",
				contentType:'application/json;charset=utf-8',
				data:JSON.stringify({"idx":idx,"title":title,"content":content}),
				 beforeSend: function(xhr){
        			 xhr.setRequestHeader(csrfHeaderName, csrfTokenValue)
        		 },
				success:loadList,
				error:function(){alert("error");}
			});
		}
	</script>
</head>
<body>
<jsp:include page="../common/header.jsp"/>
	<div class="container">
	  <h2>회원게시판</h2>
	  <div class="panel panel-default">
	    <div class="panel-heading">BOARD</div>
	    <div class="panel-body" id="view">Panel Content</div>
	    <div class="panel-body" id="wForm" style="display :none">
	    	<form id="frm">
	    	<input type="hidden" id="memID" name="memID" value="${mvo.member.memID}"/>
	    	<table style="width: 100%">
		    	<tr>
		    		<td>제목</td>
		    		<td><input type="text" id="title" name="title" class="form-control"/></td>
		    	</tr>
		    	<tr>
		    		<td>내용</td>
		    		<td><textarea rows="7" id="content" class="form-control" name="content"></textarea></td>
		    	</tr>
		    	<tr>
		    		<td>작성자</td>
		    		<td><input type="text" id="writer" name="writer" class="form-control" readonly value="${mvo.member.memName }"/></td>
		    	</tr>
		    	<td colspan="2" align="center">
		    		<button type="button" class="btn btn-success btn-sm" onclick="goInsert()">등록</button>
		    		<button type="reset" class="btn btn-warning btn-sm" id="fclear">취소</button>
		    		<button type="button" class="btn btn-info btn-sm" onclick="goList()">목록</button>
		    	</td>
	    	</table>
	    </form>
	    </div>
	    <div class="panel-footer">게시판 테스트</div>
	  </div>
	</div>
</body>
</html>
