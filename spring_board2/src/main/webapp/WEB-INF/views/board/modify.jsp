<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@include file="../includes/header.jsp" %>
<link rel="stylesheet" href="/resources/dist/css/upload.css"/>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Board Modify</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>            
            <div class="row">
                <div class="col-lg-12">
                	<div class="panel panel-default">
                        <div class="panel-heading" style="display: flex; justify-content: space-between;">
                           <div>Board Read Page</div>
                           <div style="font-size: 10px;"><fmt:formatDate pattern="yyyy-MM-dd HH-mm-ss" value="${vo.regdate }"/>
                           ||
                           <fmt:formatDate pattern="yyyy-MM-dd HH-mm-ss" value="${vo.updatedate }"/></div>
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                			<form action="update" method="post" role="form" class="fo">
                				<div class="form-group">
                					<label>Bno</label>
                					<input class="form-control" name="bno" readonly="readonly" value="${vo.bno}">                				
                				</div> 
                				<div class="form-group">
                					<label>Title</label>
                					<input class="form-control" name="title" value="${vo.title}" required="required">                				
                				</div>  
                				<div class="form-group">
                					<label>Content</label>
                					<textarea class="form-control" rows="3" name="content" required="required">${vo.content}</textarea>               				
                				</div> 
                				<div class="form-group">
                					<label>Writer</label>
                					<input class="form-control" name="writer" readonly="readonly" value="${vo.writer}">                				
                				</div>  
                				<sec:authentication property="principal" var="info"/>
                				<sec:authorize access="isAuthenticated()">
                				<c:if test="${info.username == vo.writer}">
                				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                				<button type="submit" data-oper='update' class="btn btn-default">Modify</button>              			
                				<button type="button" data-oper='remove' class="btn btn-danger">Remove</button>              			
                				</c:if>
                				</sec:authorize>
                				<button type="button" data-oper='list' class="btn btn-info">List</button>              			
                			</form>
                		</div>
                	</div>
                </div>
            </div>
                     <!-- 첨부 파일 영역 -->
<div class="bigPictureWrapper">
   <div class="bigPicture"></div>
</div>
<div class="row">
<div class="col-lg-12">
 <div class="panel panel-default">
    <div class="panel-heading">
      Files
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
			<%-- remove와 list를 위한 폼--%>
            <form id="operForm" action="/board/delete" method="post">
               <input type="hidden" name="bno" value="${vo.bno}"/>
               <input type="hidden" name="pageNum" value="${cri.pageNum}"/>
               <input type="hidden" name="amount" value="${cri.amount}"/>
               <input type="hidden" name="keyword" value="${cri.keyword }"/>
               <input type="hidden" name="type" value="${cri.type }"/>
               <input type="hidden" name="writer" value="${vo.writer }"/>
               <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </form>
			<%-- 스크립트 --%>
			<script>
			 $(function() {
				// 첨부 파일 내용 : uuid,uploadPath,fileType,fileName필요
				 // ==> uploadResult ul li가 가지고 있기 떄문에 그 영역에 있는 값 수집하기 
				  
		      $(".btn-default").click(function(e) {
		    	  e.preventDefault();
		    	  var str="";
					 $(".uploadResult ul li").each(function(i,obj){
						 var job=$(obj);
						 
						 str+="<input type='hidden' name='attachList["+i+"].uuid' value='"+job.data("uuid")+"'>";
						 str+="<input type='hidden' name='attachList["+i+"].uploadPath' value='"+job.data("path")+"'>";
						 str+="<input type='hidden' name='attachList["+i+"].fileName' value='"+job.data("filename")+"'>";
						 str+="<input type='hidden' name='attachList["+i+"].fileType' value='"+job.data("type")+"'>";
					 });
			      $("form[role='form']").append(str).submit(); 
		      });
				 
				 
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
				    		show(result);
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
				 
				 var actionForm = $('.fo');
				 var form = $("#operForm");
				 console.log(form.find("input[name='pageNum']").val());
				 console.log(form.find("input[name='amount']").val());
				$(".btn-danger").click(function() {
					form.submit();
				});
				
				$(".btn-info").click(function() {
					form.find("input[name='bno']").remove();
					form.attr("action", "list").submit();
				});
				$(".btn-default").click(function(e) {
					e.preventDefault();
					actionForm.append("<input type='hidden' name='pageNum' value='"+$(form).find("input[name='pageNum']").val()+"'>");
					actionForm.append("<input type='hidden' name='amount' value='"+$(form).find("input[name='amount']").val()+"'>");
					actionForm.append("<input type='hidden' name='keyword' value='"+$(form).find("input[name='keyword']").val()+"'>");
					actionForm.append("<input type='hidden' name='type' value='"+$(form).find("input[name='type']").val()+"'>");
					actionForm.submit();
				
				});
			});
			 
			 // 이미지 가져오기
			 var bnoVal = ${vo.bno}
			 $.getJSON({ // dataType : "json"
				 
				 url : "findBno",
				 contentType : 'application/json;charset=utf-8',
				 data :{
					 bno : bnoVal
				 },
			     success: function(result){
			    	 show(result);
			     }
			 });
			 
			 
			 function show(result){
		    	 var uploadResult = $(".uploadResult ul");
		         var str="";
		         $(result).each(function(i,obj){
		            if(obj.fileType){//true이면 이미지
		               //썸네일 이미지 경로
		               var filePath=encodeURIComponent(obj.uploadPath+"\\s_"+obj.uuid+"_"+obj.fileName);
		               
		               str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"'";
		               str+=" data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"'>";
		               str+="<div><span>"+obj.fileName+" ";
		               str+="<button type='button' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button></span><br>";
		               str+="<div><a><img src='/display?fileName="+filePath+"'></a>";
		               str+="</div></li>";
		            }else{//이미지 외      \\ 는 경로 \ 하나만하면 인식을 못해서 \\를 2개넣어줌
		               str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"'";
		               str+=" data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"'>";
		               str+="<div><span>"+obj.fileName+" ";
		               str+="<button type='button' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button></span><br>";  
		               str+="<a><img src='/resources/img/attach.png'></a>";
		               str+="</div></li>";
		            }
		         });
		         uploadResult.append(str);
			 }
			 
			 
		     	// X를 클릭하면 첨부된 파일 삭제하기
		     	// 첨부물만 삭제하고 사용자가 수정버튼을 안 누르고 나갈 수도 있기 떄문에
		     	// 서버에 있는 파일을 지우면 안되고 최종적으로 수정버튼을 누르면
		     	// 그때 첨부파일 삭제하기 
	    	 $(".uploadResult").on("click","button",function(e){
	    		 
	    		 if(confirm("정말로 파일을 삭제하시겠습니까??")){
	    		 var targetLi = $(this).closest("li");
	    	      targetLi.remove(); 
	    		 }
	    		 // 다음 이벤트 종료 
	    		 e.stopPropagation();
	    		 }); // X클릭하면 첨부 파일 삭제 영역 
	    		 
	    	     // 첨부파일 동작 정의 : 일반파일 -> 다운로드, 이미지 파일 -> 원본이미지 보여주기
	    	     $(".uploadResult").on("click","li",function(){
	    	    	 var liObj = $(this);
	    	         var path = encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));
	    	         
	    	         if(liObj.data("type")){
	    	        	 showImage(path.replace(new RegExp(/\\/g),"/"));
	    	         }else{
	    	        	 self.location="/download?fileName="+path;
	    	         }
	    	     
	    	     });// 첨부파일 동작 정의 !!
	    	     
	    	     function showImage(filePath){
	    	      	  $(".bigPictureWrapper").css("display","flex").show();
	    	      	  
	    	      	  $(".bigPicture").html("<img src='/display?fileName="+filePath+"'>")
	    	      	  .animate({width:'100%',height:'100%'});
	    	      }
	    	     
	    	        $(".bigPictureWrapper").on("click",function(){
	    	            $(".bigPicture").animate({width:'0%', height:'0%'},1000);
	    	            setTimeout(function(){
	    	               $(".bigPictureWrapper").hide();
	    	            },1000)
	    	      })// 이미지 불러오기 !!!
		    	 
			</script>
<%@include file="../includes/footer.jsp" %>       