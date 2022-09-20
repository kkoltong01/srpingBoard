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
   		   // �ߺ����� ���(result=1 : ����Ҽ��ִ� ���̵�, 0 : ����Ҽ����� ���̵�)
   		 	if(result==1) {
   		 		$("#checkMessage").html("����� �� �ִ� ���̵��Դϴ�.");
   		 		$("#checkType").attr("class","modal-content panel-success");
   		 	} else {
   		 		$("#checkMessage").html("����� �� ���� ���̵��Դϴ�.");
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
		  $("#passMessage").html("��й�ȣ�� ���� ��ġ���� �ʽ��ϴ�.");
	  } else {
		  $("#passMessage").html("");
		  $("#memPassword").val(memPwd1);
	  }
  }
  function goInsert() {
	  var memAge=$("#memAge").val();
	  if(memAge==null || memAge=="" || memAge==0) {
		  alert("���̸� �Է��ϼ���");
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
    <div class="panel-heading">ȸ������</div>
    <div class="panel-body">
    	<form name="frm" action="${contextPath}/memRegister.do" method="post">
    		<input type="hidden" id="memPassword" name="memPassword" value=""/>
		    <table class="table table-bordered" style="text-align: center; border :1px solid black;">
		    	<tr>
		    		<td style="width:15%; vertical-align:middle;">���̵�</td>
		    		<td><input type="text" id="memID" name="memID" class="form-control" placeholder="���̵� �Է����ּ���." maxlength="20"/></td>
		    		<td><button class="btn btn-primary btn-sm" type="button" onclick="registerCheck()">�ߺ�Ȯ��</button></td>
		    	</tr>
		    	<tr>
		    		<td style="width:15%; vertical-align:middle;">��й�ȣ</td>
		    		<td colspan="2"><input type="password" id="memPwd1" name="memPwd1" class="form-control" onkeyup="passwordCheck()" placeholder="��й�ȣ�� �Է����ּ���." maxlength="20"/></td>
		    	</tr>
		    	<tr>
		    		<td style="width:15%; vertical-align:middle;">��й�ȣȮ��</td>
		    		<td colspan="2"><input type="password" id="memPwd2" name="memPwd2" class="form-control" onkeyup="passwordCheck()" placeholder="��й�ȣ�� �Է����ּ���." maxlength="20"/></td>
		    	</tr>
		    	<tr>
		    		<td style="width:15%; vertical-align:middle;">�̸�</td>
		    		<td colspan="2"><input type="text" id="memName" name="memName" class="form-control" placeholder="�̸��� �Է����ּ���." maxlength="20"/></td>
		    	</tr>
		    	<tr>
		    		<td style="width:15%; vertical-align:middle;">����</td>
		    		<td colspan="2"><input type="text" id="memAge" name="memAge" class="form-control" placeholder="���̸� �Է����ּ���." maxlength="20" value="0"/></td>
		    	</tr>
		    	<tr>
		    		<td style="width:15%; vertical-align:middle;">����</td>
		    		<td colspan="2">
		    			<div class="form-group" style="text-align:center; marghin:0 outo;">
		    				<div class="btn-group" data-toggle="buttons">
		    					<label>
		    						<input type="radio" id="memGender" name="memGender" autocomplete="off" value="����">����</input>
		    					</label>
		    					<label>
		    						<input type="radio" id="memGender" name="memGender" autocomplete="off" value="����"/>����</input>
		    					</label>
		    				</div>
		    			</div>
		    		</td>
		    	</tr>
		    	<tr>
		    		<td style="width:15%; vertical-align:middle;">�̸���</td>
		    		<td colspan="2"><input type="text" id="memEmail" name="memEmail" class="form-control" placeholder="�̸����� �Է����ּ���." maxlength="20"/></td>
		    	</tr>
		    	<tr>
		    		<td colspan="3" style="text-align: left;">
                		<span id="passMessage" style="color: red"></span><input type="button" class="btn btn-primary btn-sm pull-right" value="���" onclick="goInsert()"/>
             		</td>
		    	</tr>
		    </table>
    	</form>
    </div>
    <!-- ���̵��ߺ� Ȯ�� ���  -->
    <div id="myModal" class="modal fade" role="dialog">
  <div class="modal-dialog">
    <!-- Modal content-->
    <div id="checkType" class="modal-content panel-info">
      <div class="modal-header panel-heading">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">���̵� �ߺ�Ȯ��</h4>
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

<!-- ȸ������ ��� -->
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
