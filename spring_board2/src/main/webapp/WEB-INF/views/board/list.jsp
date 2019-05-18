<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> <!-- 날짜 format형식 출력 -->
<%@include file="../includes/header.jsp" %>
<%
  String tf = (String)request.getAttribute("tf");
  if(tf == null){
	  tf = "";
  }else if(tf.equals("true")){
	  %>
	   <script>
	   alert("삭제 성공했습니다");
	   </script>
	  <% 
  }else if(tf.equals("false")){
	  %>
	   <script>
	   alert("삭제 실패했습니다");
	   </script>
	  <% 
 }
%>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Board List</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Board List Page
                            <button id='regBtn' type='button' class='btn btn-xs pull-right' onclick="location.href='register'">Register New Board</button>
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <table class="table table-striped table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th>번 호</th>
                                        <th>제 목</th>
                                        <th>작성자</th>
                                        <th>작성일</th>
                                        <th>수정일</th>
                                    </tr>									
                                </thead>
								<!-- 게시판 리스트 반복문 -->
								<c:forEach var="list" items="${list}">
								<tr>
								    <td>${list.bno}</td>
								    <td><a href="${list.bno}" class="move">${list.title}</a><b>[${list.replycnt}]</b></td>
								    <td>${list.writer }</td>
								    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${list.regdate }"/></td>
								    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${list.updatedate }"/></td>
								</tr>
								</c:forEach>
                            </table>
							<div class="row"> <!-- start search -->
                            	<div class="col-md-12">
                            	  <div class="col-md-8"><!--search Form-->
                            		 <form action="" id="searchForm">
                            		 <select name="type" id="choice">                            		 
                            		    <option value="">--------</option>
                            		    <option value="T" <c:out value="${empty cri.type?'selected':''}"/>>제목</option>
                            		    <option value="C" <c:out value="${cri.type=='T'?'selected':''}"/>>내용</option>
                            		    <option value="W" <c:out value="${cri.type=='C'?'selected':''}"/>>작성자</option>
                            		    <option value="TC" <c:out value="${cri.type=='TC'?'selected':''}"/>>제목 or 내용</option>
                            		    <option value="TW" <c:out value="${cri.type=='TW'?'selected':''}"/>>제목 or 작성자</option>
                            		    <option value="TCW" <c:out value="${cri.type=='TCW'?'selected':''}"/>>제목 or 내용 or 작성자</option>
                            		 </select>
                            		 <input type="text" name="keyword" id="keyword" value="${cri.keyword}"/>
                            		   <input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }"/>
                                       <input type="hidden" name="amount" value="${pageMaker.cri.amount }"/>
                            		 <button class="btn btn-default">Search</button>
                            		 </form>
                            	   </div>
                            	   <div class="col-md-2 col-md-offset-2">
                            	   	<!--페이지 목록 갯수 지정하는 폼-->
                            	   	<select name="" id="amount" class="form-control">
                            	   	 <option value="10" <c:out value="${pageMaker.cri.amount==10?'selected':''}"/>>10</option>
                            	   	 <option value="20" <c:out value="${pageMaker.cri.amount==20?'selected':''}"/>>20</option>
                            	   	 <option value="30" <c:out value="${pageMaker.cri.amount==30?'selected':''}"/>>30</option>
                            	   	 <option value="40" <c:out value="${pageMaker.cri.amount==40?'selected':''}"/>>40</option>
                            	   	</select>
								  </div>
                             	 </div>                             	 
                      		 </div><!-- end search -->
                            <!-- start Pagination -->
                            <div class="text-center">
                            	<ul class="pagination">
                            	<c:if test="${pageMaker.prev}">
                            		<li class="paginate_button previous">
                            		<a href="${pageMaker.startPage-1 }">Previous</a>
                            	</c:if>
                            	 <c:forEach var="idx" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                            		<li class="paginate_button ${pageMaker.cri.pageNum==idx?'active':'' }">
                            		<a href="${idx}">${idx}</a>
                            		</li>
                            	 </c:forEach>
                            	<c:if test="${pageMaker.next}">
                            		<li class="paginate_button next">
                            		<a href="${pageMaker.endPage+1}">Next</a>
                            	</c:if>
                            	</ul>
                            </div>
                            <!-- end Pagination -->   
                            </div>
                            <!-- end panel-body -->
                        </div>
                        <!-- end panel -->
                    </div>                   
                </div>               
            <!-- /.row -->
<!-- 모달 추가 -->
<div class="modal" tabindex="-1" role="dialog" id="myModal">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">게시글 등록 결과</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <p>새로운 게시글 처리가 완료되었습니다.</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
<!-- 하단의 페이지번호를 누르면 사용할 폼 -->
<form id="actionForm" action="/board/list" method="get">
  <input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }"/>
  <input type="hidden" name="amount" value="${pageMaker.cri.amount }"/>
  <input type="hidden" name="keyword" value="${cri.keyword }"/>
  <input type="hidden" name="type" value="${cri.type }"/>
</form>

<!-- 스크립트 -->
<script>
 // 모달 창 제어
 $(function() {
	var result = '${result}';
    
	checkModal(result);
	
	history.replaceState({},null,null); 
	
	function checkModal(resutl) {
		if(result ==='' || history.state){
			return;
		}
		if(parseInt(result)>0){
			$(".modal-body").html("게시글 "+parseInt(result)+" 번이 등록되었습니다.");
		}
		$("#myModal").modal("show");
	}
	
	
	
	// 하단의 페이지 번호 클릭시 a태그의 기능은 막고
	// actionForm 보내기
	var actionForm = $('#actionForm');
	$(".paginate_button a").click(function(e) {
		e.preventDefault();
		// <a>태그 중 pageNum 에 있는 href 안쪽에있는 값을 넣어줘
		// 여기서 this = .paginate_button a class네임을 가지고있는애 
	   actionForm.find("input[name='pageNum']").val($(this).attr("href")); // 현재 내가 누른 숫자를 가지고와서 form에 넣어줘
	   actionForm.submit();
	
	});
	
   // 목록의 갯수가 변하면 사용자가 선택한 목록의 갯수를 가져온 후 
   // actionForm에 값을 세팅하고 actionForm 보내기
	var actionForm2 = $('#actionForm');
   $(".form-control").change(function(e) {
	 console.log($(this).val());
	 e.preventDefault();
	 actionForm2.find("input[name='pageNum']").val(1); // pageNum의 값을 1로 만들어줘
	 console.log(actionForm2.find("input[name='pageNum']").val());
     actionForm2.find("input[name='amount']").val($(this).val());  // amount에 .form-control안 값을 가지고 와서 넣어주기 
     actionForm2.submit();
   });
   
   // 제목을 클릭하면 기본적인 a 태그의 기능은 막고
   // actionForm+bno 값을 추가해서 보내기
   $(".move").click(function(e) {
	   // 태그의 모든 기능이 막힘 
	   e.preventDefault();
	   // bno 태그 추가
	   actionForm.append("<input type='hidden' name='bno' value='"+$(this).attr("href")+"'>");
	   // actionForm의 action을 변경(/board/read)
	   actionForm.attr("action", "/board/read");
	   actionForm.submit();
   });
   
   // 검색 폼
   $(".btn-default").click(function(e) {
	 // 검색기준과 검색어가 입력되었는지 확인한 후 
     // 비어있는 상태이면 경고창을 띄우고 입력하도록 한다.
     // 내용이 전부 입력되었다면 검색폼을 submit 시킨다
      e.preventDefault();
	 if($("#choice").val()===""){
		 alert("검색할 타입을 선택하세요");
		 $("#choice").focus();
	 }else if($("#keyword").val()===""){
		 alert("검색할 조건을 입력하세요")
		 $("#keyword").focus();
	 }
	 
	 // 검색 폼이 가지고 있는 pageNum 값 변경하기 => 무조건 1로 세팅
	 $("#searchForm").find("input[name='pageNum']").val(1);
	 $("#searchForm").submit();
   })
   
   
   
   
   
 });
 // 폼 태그가 가지고 있는 값을 가져올떄
 // value() : 자바 스크립트
 // val() : jquery꺼 
 
 // 값을 부여 하고 싶을때 
 // val(3) : jquery꺼 ( 3을 부여한다 )
</script>

<%@include file="../includes/footer.jsp" %>       