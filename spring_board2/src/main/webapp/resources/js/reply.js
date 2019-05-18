/*
 *   댓글 작성을 위한 스크립트
 *   
 *   클로저 메소드 방식 
 *   (외부에서 애는 호출 불가 [private])
 */
var replyService = (function(){
	function add(reply,callback){ // reply안에 들어있는 값 : {bno:bnoVal,reply:'댓글 추가',replyer:'홍길동'}
		console.log("add method 실행");
		$.ajax({ // jquery 방식 ajax를 사용할꺼야!
		   type : 'post',  // post방식으로 보낼꺼야
		   url:'/replies/new', // url은 여기야
		   data : JSON.stringify(reply), // JavaScript객체를 JSON타입으로 만드는 작업 ( reply값을 )
		   contentType : 'application/json;charset=utf-8', // contentType은 이런 타입이야 
		   success:function(result){ // collback 메소드 ( 넘어오는게 있으면 여기있는 result로 들어감 )
			   if(callback){  // 잘 됬으면 실행
				   callback(result); //넘어오는게 있으면 위쪽 result에 들어감
				   // callback은 return같은 느낌으로 jsp로 돌아가서 add(..,function(result)요놈 실행 ) 
			   }
		   },
		   error:function(xhr,status,err){ // 에러, 응답없음 등
			   if(error){
				   error(err);
				   
				   
			   }
		   }
		});
	}// add 함수 종료
	
	function update(reply,callback){
		console.log("update 호출");
	  $.ajax({
		 type:'put',
		 url : '/replies/'+reply.rno,
		 data : JSON.stringify(reply),
		 contentType : 'application/json;charset=utf-8',
		 success:function(result){
			 if(callback)
				 callback(result);
		 }
	  });
	} // update 함수 종료
	
	function getList(param,callback){
		var bno = param.bno;
		var page= param.page || 1;  // page값이 안 넘어오면 1로 세팅
		
		$.getJSON("/replies/pages/"+bno+"/"+page+".json", 
				function(data){
			        if(data!= null){
			        	if(callback){
			        		callback(data.replyCnt,data.list);
			  }
			}   
		})
	} // getList 함수 종료 
	
	function remove(rno,oriReplyer,callback){
		console.log("remove 호출");
		$.ajax({
			type: 'delete',
			url : '/replies/'+rno,
			contentType:"application/json;charset=utf-8",
			data:JSON.stringify({
				rno : rno,
				replyer:oriReplyer
			}),
			success:function(result){
				if(callback)
					callback(result);
			}
		});
	}  // remove 종료
	
	function get(rno,callback){
		console.log("get 호출");
		$.getJSON("/replies/"+rno,
				function(data){
			    	 if(callback){
			    		 callback(data);
			    	 }
		});
	} // get 종료
	
	function displayTime(timeValue){
		// 댓글 목록에서 날짜와 시간 변경
		var today = new Date();
		
		var gap = today.getTime()-timeValue;
		
		var dateObj = new Date(timeValue);
		var str="";
		if(gap < (1000*60*60*24)){ // 오늘 24시간 안에 만든 댓글 계산
			var hh=dateObj.getHours();
			var mi=dateObj.getMinutes();
			var ss=dateObj.getSeconds();
			return [(hh>9?'':'0')+hh,':',(mi>9?'':'0')+mi,':',(ss>9?'':'0')+ss].join(''); // 2자리 수인지 아닌지 확인 
		}else{
			var yy=dateObj.getFullYear();
			var mm=dateObj.getMonth()+1;
			var dd=dateObj.getDate();
			
			return [yy,'/',(mm>9?'':'0')+mm,'/',(dd>9?'':'0')+dd].join('');
		}
	}// diplayTime 종료
	return {
		    add:add,
		 update:update,
		getList:getList,
		 remove:remove,
		    get:get,
	displayTime:displayTime
	}; 
	//Uncaught TypeError: Cannot read property 'add' of undefined 그냥 사용하면 오류남 [ return 없이 사용시 ]
})();



































/**
 * 
 * ------------------ 수정 전 내용들 
 * reply.jsp의 댓글 구성을 위한 스크립트
 *//*
var replyService=(function(){
	//private
	function add(reply,callback){
		console.log("add method 실행");
		
		//가져온 데이터를 컨트롤러 호출
		$.ajax({
			type:'post',
			url : '/replies/new',
			contentType: 'application/json;charset=utf-8',
			data: JSON.stringify(reply),
			success:function(result){				
				if(callback)
					callback(result);
			}
		});		
	}//add 종료
	function getList(param,callback){
		var bno=param.bno;
		var page=param.page;
		
		console.log(bno+"bno ");
		console.log(page+" page");
		
		$.getJSON("/replies/"+bno+"/"+page,function(data){
			console.log(data.dto+" data");
			if(data!=null){
				if(callback)
					callback(data.dto,data.list);
			}
		});
	} //getList종료
	function remove(rno,callback){
		console.log("remove 호출");
		$.ajax({
			type : 'delete',
			url : '/replies/'+rno,
			contentType: 'application/json;charset=utf-8',
			data: JSON.stringify(rno),
			success : function(result){
				if(callback)
					callback(result);
			}
		});
	}//remove종료
	
	function update(reply,callback){
		console.log("update 호출");
		$.ajax({
			type : 'put',
			url : '/replies/'+reply.rno,
			data : JSON.stringify(reply),
			contentType : 'application/json;charset=utf-8',
			success : function(result){
				if(callback)
					callback(result);
			}
		});
	}//update 종료
	
	function get(rno,callback){
		console.log("get 호출");
		$.ajax({
			type : 'get',
			url : '/replies/'+rno,
			data : JSON.stringify(rno),
			contentType : 'application/json;charset=utf-8',
			success : function(result){
				if(callback)
					callback(result);
			}
		});
	}//get 종료
	
	//댓글 목록을 보여줄 때 시간이 1541473709000 나오는 것 수정
	function displayTime(timeValue){
		var today=new Date();
		
		var gap=today.getTime() - timeValue;
		var dateObj = new Date(timeValue);
		var str="";
		
		if(gap<(1000 * 60 * 60 * 24)){ //댓글 단 날짜가 오늘이면 시분초
			var hh=dateObj.getHours();
			var mi=dateObj.getMinutes();
			var ss=dateObj.getSeconds();
			
			return [(hh>9?'':'0')+hh,':',(mi>9?'':'0')+mi,':',(ss>9?'':'0')+ss].join('');
		}else{ //댓글 단 날짜가 오늘이 아니면 년/월/일
			var yy=dateObj.getFullYear();
			var mm=dateObj.getMonth()+1;//월은 0부터 시작함
			var dd=dateObj.getDate();
			return [yy,'/',(mm>9?'':'0')+mm,'/',(dd>9?'':'0')+dd].join('');
		}
	}
	
	return {   //외부에서 호출되는 부분
		add:add,
		getList : getList,
		remove : remove,
		update : update,
		get : get,
		displayTime:displayTime
	};
})();


*/


