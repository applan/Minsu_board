<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@include file="../includes/header.jsp" %>
<link rel="stylesheet" href="/resources/dist/css/upload.css" />
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Board Register</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>            
            <div class="row">
                <div class="col-lg-12">
                	<div class="panel panel-default">
                        <div class="panel-heading">
                           Board Register Page
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                			<form action="/board/insert" method="post" role="form">
                				<div class="form-group">
                					<label>Title</label>
                					<input class="form-control" name="title" required="required">                				
                				</div>  
                				<div class="form-group">
                					<label>Content</label>
                					<textarea class="form-control" rows="3" name="content" required="required" placeholder="최소 한글자 이상 입력하세요"></textarea>
                					<div id="length"style="position: absolute; top:200px; right:9%; color:#BDBDBD">/2000</div>               				
                				</div> 
                				<div class="form-group">
                					<label>Writer</label>
                					<input class="form-control" name="writer" required="required" 
                					value='<sec:authentication property="principal.username"/>' readonly="readonly">                				
                				</div>  
                				<button type="submit" class="btn btn-default sub">Submit</button>              			
                				<button type="reset" class="btn btn-default">reset</button>   
                				<%-- post 로 보내는 모든 폼은 csrf 토큰을 같이 보내야 함  (보안적인 의미에서 검 ) [ post면 모두 걸어줘야함 ] --%>           			
                				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                			</form>
                		</div>
                	</div>
                </div>
            </div>           
<div class="row">
<div class="col-lg-12">
 <div class="panel panel-default">
    <div class="panel-heading">
      File Attach
    </div>
    <div class="panel-body">
      <div class="form-group uploadDiv">
        <input type="file" name="uploadFile" multiple="multiple"/>
      </div>
      <div class="uploadResult">
         <ul></ul>
      </div>
    </div>
 </div>
 </div>
</div>

<script>
$(function() {
	$("#length").text($("textarea[name='content']").val().length+"/2000");
  $("textarea[name='content']").keyup(function() {
	console.log($(this).val().length);
	$("#length").text($(this).val().length+"/2000");
	
});
});
</script>
<script>
 // submit 버튼이 눌러지면 폼 전송 막기 
 $(function(){
	  // 처음 상태를 복제
	 // var cloneObj = $(".uploadDiv").clone();
	  var formObj = $("form[role='form']");
	 $(".sub").click(function(e) { // form전송하기
		 var inputTitle = $("input[name='title']").val();
		 var inputContent = $("input[name='content']").val();
		 var inputWriter = $("input[name='writer']").val();
	     e.preventDefault(); // 첨부 파일 내용을 가지고 같이 가야하기 때문에 막음
		 if(inputTitle.trim() == ""){
			 alert("타이틀 영역은 공백을 허용하지 않습니다.");
			 $("input[name='title']").focus();
		 }
/* 	     if(inputContent.trim() == ""){
	    	 alert("내용을 한글자 이상 입력하세요");
			 $("input[name='content']").focus();
	     }
	     if(inputWriter.trim() == ""){
	    	 alert("글쓴이 영역은 공백을 허용하지 않습니다.");
			 $("input[name='writer']").focus();
	     }
		 console.log(inputTitle); */
		 
		 
		 // 첨부 파일 내용 : uuid,uploadPath,fileType,fileName필요
		 // ==> uploadResult ul li가 가지고 있기 떄문에 그 영역에 있는 값 수집하기 
		 var str="";
		 $(".uploadResult ul li").each(function(i,obj){
			 var job=$(obj);
			 
			 str+="<input type='hidden' name='attachList["+i+"].uuid' value='"+job.data("uuid")+"'>";
			 str+="<input type='hidden' name='attachList["+i+"].uploadPath' value='"+job.data("path")+"'>";
			 str+="<input type='hidden' name='attachList["+i+"].fileName' value='"+job.data("filename")+"'>";
			 str+="<input type='hidden' name='attachList["+i+"].fileType' value='"+job.data("type")+"'>";
		 });
      formObj.append(str).submit();
		 
		 
	}); // submit 클릭하면 이벤트 막은 후 검증, 파일 정보 서버로 주기 
	
	// 파일첨부시 csrf 토큰 값 같이 보내기 
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
	
	
	
	$("input[name='uploadFile']").change(function(){
		console.log("upload 버튼 클릭 "); 
		
		// multipart/form-data 형태의 폼을 한꺼번에 가져오기
		var formData=new FormData();
		// file안에 들어있는 여러개의 첨부된 파일 가져오기 
		var inputFile=$("input[name='uploadFile']");
		var files=inputFile[0].files;
		
		for(var i=0; i<files.length; i++){
			if(!checkExtension(files[i].name,files[i].size)){
				return false;
			}
			formData.append("uploadFile",files[i]);
		}
	     // formData를 ajax 기술로 서버로 전송하기
	     $.ajax({
	    	url : "/uploadAjax",  // 가야할 컨트롤러 주소
	    	data : formData,      // 전송할 데이터
	    	processData : false,  // formData를 쓸때 무조건 필요함 ( 데이터를 어떤 방식으로 변환할 것인지 결정 )
	    	contentType : false,  // formData를 쓸때 무조건 필요함 ( formData가 기본적으로 application/x-www-form-urlencoded인 상황이라 false로 지정 )
	    	beforeSend:function(xhr){
	    		xhr.setRequestHeader(csrfHeaderName,csrfTokenValue); // 토큰값 가지고가기
	    	},
	    	type : "post",
	    	dataType : "json",    // 되돌아오는 데이터 타입 ( 전송이 잘 되면 success라는 문자열을 전송 받을 예정 )
	    	success:function(result){
	    		console.log(result);
	    		showUploadedFile(result);
	    		//$(".uploadDiv").html(cloneObj.html());
	    	}
	     });
	 });// #uploadBtn 종료
	 
	 // 첨부 파일의 크기의 확장자 제한
	 function checkExtension(fileName,fileSize){
		 var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		 var maxSize = 5242880;  // 5MB
		 
		 if(fileSize>maxSize){
			 alert("파일 사이즈 초과");
			 return false;
		 }
		 if(regex.test(fileName)){
			 alert("해당 파일의 확장자는 업로드 할 수 없습니다.");
			 return false;
		 }
		 return true;
	 }
	 
	// 서버에서 result를 받은 후 result 보여주기
	 function showUploadedFile(uploadResultArr){
		 // 결과를 보여줄 영역 가져오기
		 var uploadResult = $(".uploadResult ul");
	     // 
	     var str = "";
	     $(uploadResultArr).each(function(i,obj){ // 여기서 5i 는 for문의 i와 같음 obj는 uploadResultArr을 가리킴
	    	 if(obj.fileType){ //true 이면 이미지
	    		 // 썸네일 이미지 경로
	           var filePath=encodeURIComponent(obj.uploadPath+"\\s_"+obj.uuid+"_"+obj.fileName);
	    	 
	    	   // 원본 파일 이미지 경로
	    	   var oriPath=obj.uploadPath+"\\"+obj.uuid+"_"+obj.fileName;
	    	   // 서버에서 이미지 가지고 옴 
	    	   // 폴더 구분의 \를 /로 바꾸는 작업
	    	   oriPath=oriPath.replace(new RegExp(/\\/g),"/");
	    	 str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"'";
	    	 str+="data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"'>";
	    	 str+="<div>";
	    	 str+="<span>"+obj.fileName+"</span>";
	    	 str+="<button type='button' class='btn btn-warning btn-circle' data-file='"+filePath+"' data-type='image'><i class='fa fa-times'></i></button><br>";
	    	 str+="<a href=\"javascript:showImage(\'"+oriPath+"\')\">"; // \ 안 붙여주면 인식을 못함 ( "를 진짜 "로 인식시키기 위해 사용 ) 
	    	 str+="<img src='/display?fileName="+filePath+"'></a>"; // filePath내부에 파일에 대한 정보가 들어있음 
	    	 str+="</div></li>";

	    	 }else{  // 이미지 외 파일들 
	           var filePath=encodeURIComponent(obj.uploadPath+"\\"+obj.uuid+"_"+obj.fileName); // \\ = > \하나만 넣으면 인식 안 하기 떄문에 ( 경로 관련 )
            str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"'";
    	    str+="data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"'>";
    	    str+="<div>";
		    str+="<span>"+obj.fileName+"</span>";
		    str+="<button type='button' class='btn btn-warning btn-circle' data-file='"+filePath+"' data-type='file'><i class='fa fa-times'></i></button><br>";
	        str+="<a href='download?fileName="+filePath+"'>";
	    	str+="<img src='/resources/img/attach.png'></a>";
	    	str+="</div></li>";
	    		 
	    	 }
	     });
	     uploadResult.append(str);
	 } 
	
	// X를 클릭하면 첨부된 파일 삭제하기
	 $(".uploadResult").on("click","button",function(){
		 var targetFile= $(this).data("file");
		 var type=$(this).data("type");
		 
		 var targetLi = $(this).closest("li");
		 
		 // 가져온 데이터 서버로 전송
		 $.ajax({
			url: "/deleteFile",
			dataType : 'text',
			data:{
				 fileName : targetFile,
				 type:type
			},
			beforeSend:function(xhr){
	    		xhr.setRequestHeader(csrfHeaderName,csrfTokenValue); // 토큰값 가지고가기
	    	},
			type:'post',
			success:function(result){
				console.log(result);
				targetLi.remove();
			}
		 });
	 });
 });
</script>

<%@include file="../includes/footer.jsp" %>       