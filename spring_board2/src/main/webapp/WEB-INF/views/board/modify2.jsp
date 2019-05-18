<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@include file="../includes/header.jsp" %>
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
                           Board Modify Page
                           <div style="font-size: 10px;">${vo.regdate}</div>
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                			<form action="" role="form">
                				<div class="form-group">
                					<label>Bno</label>
                					<input class="form-control" name="bno" readonly="readonly" value="${vo.bno}">                				
                				</div> 
                				<div class="form-group">
                					<label>Title</label>
                					<input class="form-control" name="title" placeholder="${vo.title}">                				
                				</div>  
                				<div class="form-group">
                					<label>Content</label>
                					<textarea class="form-control" rows="3" name="content" placeholder="${vo.content}"></textarea>               				
                				</div> 
                				<div class="form-group">
                					<label>Writer</label>
                					<input class="form-control" name="writer" readonly="readonly" placeholder="${vo.writer}">                				
                				</div>  
                				<button type="submit" data-oper='modify' class="btn btn-default">Modify</button>              			
                				<button type="submit" data-oper='remove' class="btn btn-danger">Remove</button>              			
                				<button type="submit" data-oper='list' class="btn btn-info">List</button>              			
                			</form>
                		</div>
                	</div>
                </div>
            </div>
			<%-- remove와 list를 위한 폼--%>
            <form id="form1" method="post">
               <input type="hidden" name="bno" value="${vo.bno}"/>
            </form>
			<%-- 스크립트 --%>
			<script>
			 $(function() {
				 var formObj=$("#form1");
				 
				 $("button").click(function(e) {
					 // 세개의 버튼이 모두 submit 형태이기 떄문에 동작되는 것 막기
					 e.preventDefault();
					 
					 // 사용자가 누른 버튼 알아내기
					 var oper=$(this).data("oper");
					 
					 // 사용자가 선택한 버튼에 따라 각각의 이동방식 결정
					 if(oper ==='remove'){
						 formObj.attr("action","/board/remove");
					 }else if(oper === 'list'){
						 formObj.attr("action","/board/list");
					 }else if(oper === 'modify'){
						 formObj.attr("action","/board/update");
					 }
					 formObj.submit();
					 
				});
			})
			</script>
<%@include file="../includes/footer.jsp" %>       