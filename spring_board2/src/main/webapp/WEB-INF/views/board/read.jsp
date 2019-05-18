<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@include file="../includes/header.jsp" %>
<link rel="stylesheet" href="/resources/dist/css/upload.css"/>
<%
 String tf = (String)request.getAttribute("tf");
if(tf == null){
	tf = "";
}else if(tf.equals("true")){
	%>
	<script>
	 alert("수정 성공했습니다.");
	</script>
	<% 
}else if(tf.equals("false")){
	%>
	<script>
	 alert("수정 실패했습니다.");
	</script>
	<% 
}
%>
	<div class="row">
	    <div class="col-lg-12">
	        <h1 class="page-header">Board Read</h1>
	    </div>
	    <!-- /.col-lg-12 -->
	</div>            
	<div class="row">
	    <div class="col-lg-12">
	    	<div class="panel panel-default">
	            <div class="panel-heading fo" style="display: flex; justify-content: space-between;">
	              <div>Board Read Page</div>
	              <div style="font-size: 10px;"><fmt:formatDate pattern="yyyy-MM-dd HH-mm-ss" value="${vo.regdate }"/>
	              ||
	              <fmt:formatDate pattern="yyyy-MM-dd HH-mm-ss" value="${vo.updatedate }"/></div>
	           </div>
	           <!-- /.panel-heading -->
	           <div class="panel-body">
	   			<form action="modify" role="form" method="post">
	   				<div class="form-group">
	   					<label>Bno</label>
	   					<input class="form-control" name="bno" readonly="readonly" value="${vo.bno}">                				
	   				</div> 
	   				<div class="form-group">
	   					<label>Title</label>
	   					<input class="form-control" name="title" readonly="readonly" value="${vo.title }">                				
	   				</div>  
	   				<div class="form-group">
	   					<label>Content</label>
	   					<textarea class="form-control" rows="3" name="content" readonly="readonly">${vo.content }</textarea>               				
	   				</div> 
	   				<div class="form-group">
	   					<label>Writer</label>
	   					<input class="form-control" name="writer" readonly="readonly" value="${vo.writer }">                				
	    				</div>  
	    				<sec:authentication property="principal" var="info"/>
	    				<sec:authorize access="isAuthenticated()">
	    				 <c:if test="${info.username == vo.writer }">
	    				<button type="button" class="btn btn-default">Modify</button> 
	    				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>    			
	    				 </c:if>
	    				</sec:authorize>
	    				<button type="button" class="btn btn-info" >List</button>          		
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
      <div class="uploadResult">
         <ul></ul>
      </div>
    </div>
 </div>
 </div>
</div>
        <!-- 댓글 영역 종료 -->
        <!--  댓글 모달 -->
        <div class="modal fade" id="myModal">
         <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
             <button type="button" class="close" data-dismiss="modal">&times;</button>
             <h4 class="modal-title">Reply Modal</h4>
            </div>
            <div class="modal-body">
              <div class="form-group">
                <label for="">Reply</label>
                <input value="New Reply" name="reply" class="form-control" />
              </div>
              <div class="form-group">
                <label for="">Replyer</label>
                <input class="form-control" name="replyer" value="replyer" />
              </div>
              <div class="form-group">
                <label for="">Reply Date</label>
                <input class="form-control" name="replyDate" value="" />
              </div>
            </div>
            <div class="modal-footer">
              <button class="btn btn-warning" id="modalModBtn" type="button">Modify</button>
              <button class="btn btn-danger" id="modalRemoveBtn" type="button">Remove</button>
              <button class="btn btn-primary" id="modalRegisterBtn" type="button">Register</button>
              <button class="btn btn-success" id="modalCloseBtn" type="button">Close</button>
            </div>
          </div>
         </div>
        </div>
            <form id="operForm" action="/board/modify">
               <input type="hidden" name="bno" value="${vo.bno}"/>
               <input type="hidden" name="pageNum" value="${cri.pageNum}"/>
               <input type="hidden" name="amount" value="${cri.amount}"/>
               <input type="hidden" name="keyword" value="${cri.keyword }"/>
               <input type="hidden" name="type" value="${cri.type }"/>
            </form>
<!-- 댓글 영역 -->
<div class="row">
  <div class="col-lg-12">
     <div class="panel panel-default">
       <div class="panel-heading">
         <i class="fa fa-comments fa-fw"></i>
         Reply
         <sec:authorize access="isAuthenticated()">
         <button class="btn btn-primary btn-xs pull-right" id="addReplyBtn">New Reply</button>
         </sec:authorize>
       </div>
       <div class="panel-body">
         <ul class="chat">
          <li class="left clearfix" data-rno="12">
            <div>
             <div class="header">
               <strong class="primary-font">user0000</strong>
               <small class="pull-right text-muted">2019-04-12 00:00</small>
             </div>
             <p>Good Job!!</p>
            </div>
           </li>
          </ul>
       </div>
        <div class="panel-footer"> <!--  댓글 페이지 영역  -->
        </div>
     </div>
  </div>
</div>
<!-- 댓글 작업용 스크립트 -->
<script src="/resources/js/reply.js"></script>
<script>

  // 댓글 작업용 스크립트
  $(function(){
	 // 현재 글 번호 가져오기
	 var bnoVal = ${vo.bno}
	 
	 // 댓글 페이지 나누기 
	 var pageNum=1;
	 // 페이지 나누기 영역 가져오기
	 var replyPageFooter=$(".panel-footer");
	 
	 function showReplyPage(replyCnt){
		 var endNum=Math.ceil(pageNum/10.0)*10;
		 var startNum=endNum-9;
		 var prev=startNum!=1;
		 var next=false;
		 
		 if(endNum*10>=replyCnt){
			 endNum=Math.ceil(replyCnt/10.0);
		 }
		 if(endNum*10<replyCnt){
			 next=true;
		 }
		 
		 var str="<ul class='pagination pull-right'>";
		 if(prev){
			 str+="<li class='page-item'><a class='page-link' href='"+(startNum-1)+"'>Previous</a></li>";
		 }
		 for(var i=startNum;i<=endNum;i++){
			 var active = pageNum == i ? 'active':'';
			 str+="<li class='page-item"+active+"'><a class='page-link' href='"+i+"'>"+i+"</a></li>";
		 }
		 if(next){
			 str+="<li class='page-item'><a class='page-link' href='"+(endNum+1)+"'>Next</a></li>";
		 }
		 
		 str+="</ul></div>";
		 replyPageFooter.html(str);
	 }
	 
	 // 댓글리스트를 보여줄 영역 가져오기 
	 var replyUL=$(".chat");
	 showList(1); //현재 글의 페이지에 해당하는 댓글 가져오기 호출
	 
	 $("#modalRegisterBtn").on("click",function(){
		 var reply={
				 reply:modalInputReply.val(),
				 replyer:modalInputReplyer.val(),
				 bno:bnoVal
		 }
	  replyService.add(reply,function(result){
         modal.find("input").val("");
         modal.modal("hide");
         
         showList(-1); // 댓글 갱신 ( 항상 끝 페이지로 나옴 )
	  });  		 
	 });
	 
     // 댓글 페이지 번호 누르면 이동하기
     replyPageFooter.on("click","li a",function(e){
    	 e.preventDefault();       // 페이지 번호를 누르면 a태그가 가지고 있는 이벤트는 막기
    	 
    	 pageNum=$(this).attr("href");
    	 
    	 showList(pageNum);
     });
	 
	 function showList(page){
	 replyService.getList({bno:bnoVal,page:page},function(replyCnt,list){
		
		 
		 // 페이지 수 계산
		 if(page==-1){
			 pageNum=Math.ceil(replyCnt/10.0);
			 showList(pageNum);
			 return;
		 }
		 
		 var str="";
		 if(list == null || list.length == 0){
			 replyUL.html("");
			 return;
		 }
		 
		 // 리스트가 있는 경우 
		 for(var i=0; i<list.length; i++){
			 str+="<li class='left clearfix' data-rno='"+list[i].rno+"'>"; // 평소에는 안 보이지만 위임할떄 사용 
	         str+="<div>";
	         str+="<div class='header'>";
	         str+="<strong class='primary-font'>"+list[i].replyer+"</strong>";
	         str+="<small class='pull-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small>"
	         str+="</div>";
	         str+="<p>"+list[i].reply+"</p>";
	         str+="</div>";
	         str+="</li>";
		 }
		 replyUL.html(str);
		 showReplyPage(replyCnt);
	  });
	 }
	 

	 
	 // 댓글  ul한테 명령 위임
	 // 댓글의 리스트가 존재하는 것이 아니라 나중에 추가되는 형태이기 때문에
	 // 현재 존재하는 요소처럼 이벤트를 지정할 수 없음 => 따라서 이미 존재하는
	 // 요소에 이벤트를 걸고 나중에 변경을 하는 방식 사용(이벤트 위임)
	 $(".chat").on("click","li",function(){ // .chat = ul요소 (ul에게 먼저 걸어주고 li한테 넘겨준다는 의미 )
		 var rno=$(this).data("rno");
		 
		 replyService.get(rno,function(data){
			 console.log(data);
			 
			 // 넘어온 데이터를 모달창에 넣어서 보여주기 
			 modalInputReply.val(data.reply);
			 modalInputReplyer.val(data.replyer).attr("readonly","readonly");
			 modalInputReplyDate.val(replyService.displayTime(data.replyDate)).attr("readonly","readonly");
			 modal.data("rno",data.rno);
			 
			 modal.find("button[id!='modalCloseBtn']").hide();
			 modalModBtn.show();
			 modalRemoveBtn.show();
			 modal.modal("show");
			 
		 });
	 });
	 
	 
	 replyService.get(10,function(data){
		 console.log(data);
	 });
	 
	 // 댓글 모달 창
	 var modal = $(".modal");
	 var modalInputReply = modal.find("input[name='reply']");
	 var modalInputReplyer = modal.find("input[name='replyer']");
	 var modalInputReplyDate = modal.find("input[name='replyDate']");
	 
	 var modalModBtn=$("#modalModBtn");
	 var modalRemoveBtn=$("#modalRemoveBtn");
	 var modalRegisterBtn=$("#modalRegisterBtn");
	 
	 // 댓글은 로그인한 사용자만 달 수 있도록 하며 
	 // 따라서 댓글 창을 띄울 떄 replyer 은 현재 로그인한 사용자의 id를 보여주도록 한다.
	 var replyer = null;
	 <sec:authorize access="isAuthenticated()">;
	 replyer='<sec:authentication property="principal.username"/>';
	 </sec:authorize>
	 
	 
	 // 파일 첨부시 csrf 토큰 값 같이 보내기
	 var csrfHeaderName="${_csrf.headerName}";
	 var csrfTokenValue="${_csrf.token}";
	 // beforeSend 대신 사용
	 $(document).ajaxSend(function(e,xhr,options) {
		xhr.setRequestHeader(csrfHeaderName,csrfTokenValue);
	});
	 
	 
	 // 등록버튼 누르면
	 $("#addReplyBtn").on("click",function(){
		 modal.find("input").val("");
		 modalInputReplyer.val(replyer);
		 // 날짜 부분 안보이게 설정
		 modalInputReplyDate.closest("div").hide();
		 modalInputReplyer.attr("readonly",false); // Replyer ( Modify통해서 들어오면 막혀있음 )
		 //close버튼만 제외하고 다른 버튼 모두 안 보이게 설정
		 modal.find("button[id!='modalCloseBtn']").hide();
		 // 등록 버튼만 다시 보이게 설정
		 modalRegisterBtn.show();
		 modalInputReplyer.attr("readonly",true);
		 
		 modal.modal("show");
	 });
	 
	 // 모달 창 close
	 $("#modalCloseBtn").on("click",function(){
		 modal.modal("hide");
	 });
	 
	 // 모달 창 Remove 버튼 클릭
	 $("#modalRemoveBtn").on("click",function(){
		 
		// 삭제버튼을 막지 않았기 떄문에 로그인 여부 확인
		 if(!replyer){
			 alert("로그인 한 후 삭제가 가능합니다.");
			 modal.modal("hide");
			 return;
		 }
		 // 현재 모달창에 있는 작성자 가져오기
		 var oriReplyer = modalInputReplyer.val();
		 
		 // 모달창 작성자와 로그인한 정보가 같은지 확인 
		 if(oriReplyer != replyer){
			 alert("자신의 댓글만 삭제가 가능합니다.");
			 modal.modal("hide");
			 return;
		 }
		 
		 var rno = modal.data("rno");
	  replyService.remove(rno,oriReplyer,function(result){
		modal.modal("hide");
		showList(pageNum);
	  }); 		 
	 });
	 
	 // 모달 창 Modify 버튼 클릭
	 $("#modalModBtn").on("click",function(){
		 
		 // 수정버튼을 막지 않았기 떄문에 로그인 여부 확인
		 if(!replyer){
			 alert("로그인 한 후 수정이 가능합니다.");
			 modal.modal("hide");
			 return;
		 }
		 // 현재 모달창에 있는 작성자 가져오기
		 var oriReplyer = modalInputReplyer.val();
		 
		 // 모달창 작성자와 로그인한 정보가 같은지 확인 
		 if(oriReplyer != replyer){
			 alert("자신의 댓글만 수정이 가능합니다.");
			 modal.modal("hide");
			 return;
		 }
		 
		 
		 var reply2={
				 reply:modalInputReply.val(),
				 rno:modal.data("rno"),
				 replyer:modalInputReplyer.val()
		 }
		 
	  replyService.update(reply2,function(result){
	      modal.modal("hide");
	      showList(pageNum);
      }); 		 
	 });
		
	 
  });
  
  
  // 첨부파일 요청
  // 현재 글번호를 컨트롤러로 글번호에 해당하는 첨부파일 목록 가져오기
  // console.log()로 확인 
  // var bnoVal = ${vo.bno}
  //               <div class="form-group">
  //              <label for="">Reply Date</label>
  //              <input class="form-control" name="replyDate" value="" />
  //           </div>
  
  var bnoVal = ${vo.bno}
	 $.getJSON({
		 
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
                // DB를 통해서 이미지 가지고 옴 
               str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"'";
               str+=" data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"'>";
               str+="<div><a><img src='/display?fileName="+filePath+"'></a>";
               str+="</div></li>";
            }else{//이미지 외      \\ 는 경로 \ 하나만하면 인식을 못해서 \\를 2개넣어줌
               str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"'";
               str+=" data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"'>";
               str+="<div><span>"+obj.fileName+"</span><br>";
               str+="<a><img src='/resources/img/attach.png'></a>";
               str+="</div></li>";
            }
         });
         uploadResult.html(str);

		 
     }
     
     // 첨부파일 동작 정의 : 일반파일 -> 다운로드, 이미지 파일 -> 원본이미지 보여주기
     $(".uploadResult").on("click","li",function(){
    	 var liObj = $(this);
         var path = encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));
         
         if(liObj.data("type")){
        	 showImage(path.replace(new RegExp(/\\/g),"/"));
         }else{
        	 self.location="/download?fileName="+path;
         }
     
     });
     
     
     // 클릭한 이미지 보이게 하기
     	 
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
   })
  
  
  
</script>

<!-- 버튼용 스크립트 -->
<script>
         $(function() {
 var form=$("#operForm");
      
 console.log(form.find("input[name='pageNum']").val());
 console.log(form.find("input[name='amount']").val());
  // 보내기가 눌러지면 ( modify 버튼 )
 $(".btn-default").click(function() {
	form.submit();
});
// list가 눌러지면 #operForm의 속성을 조절해서 보냄
 $(".btn-info").click(function() {
	// bno는 필요없기 떄문에 제거하고 폼 보내기
	form.find("input[name='bno']").remove();
	// action 변경 후 폼 보내기
	form.attr("action","/board/list").submit();
	
});
         });
         
         
         
        </script>
<%@include file="../includes/footer.jsp" %>       