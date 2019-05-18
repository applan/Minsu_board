package com.spring.controller;


import javax.inject.Inject;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.spring.domain.Criteria;
import com.spring.domain.ReplyPageDTO;
import com.spring.domain.ReplyVO;
import com.spring.service.ReplyService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/replies/*")
@RestController
public class ReplyController {
 
	@Inject
	private ReplyService service;
	
	@PostMapping(value="/new")
	@PreAuthorize("isAuthenticated()")
	public ResponseEntity<String> create(@RequestBody ReplyVO vo){
		log.info("ReplyInsert 호출");
		
		return service.insert(vo) == 1?
				new ResponseEntity<>("success",HttpStatus.OK):
					new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); 
	}
	
	// @RequestBody : json으로 넘어오는 값을 객체에 담을떄 인식해주는것 
	
	@GetMapping(value="/pages/{bno}/{page}")
	public ResponseEntity<ReplyPageDTO> getList(@PathVariable("bno")int bno,
			@PathVariable("page")int page){
		log.info("ReplyGetList 호출");
		
		Criteria cri = new Criteria(page, 10);
		
		return new ResponseEntity<>(service.getList(cri,bno),HttpStatus.OK);
		// ResponseEntity 객체는 (결과값, 상태 코드)을 넣는 객체이다. 
		// 평소에 우리는  jsp에게 값을 넘기면 jsp가 상태를 알아서 처리 해줬는데 여긴 아니다.
	}
	
	// 댓글 수정시 댓글 데이터는 json 형태로 넘어오고, rno는 uri에 존재함
	// ps. http://localhost:9090/replies/1(rno)
	
	@RequestMapping(value="/{rno}",method= {RequestMethod.PATCH,RequestMethod.PUT})
	@PreAuthorize("principal.username==#vo.replyer")
	public ResponseEntity<String> update(@RequestBody ReplyVO vo,@PathVariable("rno")int rno){
		log.info("ReplyUpdate 호출");
		vo.setRno(rno);
		return service.update(vo) == 1?
				new ResponseEntity<>("success",HttpStatus.OK):
					new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}
	
	@DeleteMapping(value="/{rno}")
	@PreAuthorize("principal.username==#vo.replyer")
	public ResponseEntity<String> delete(@PathVariable("rno")int rno,@RequestBody ReplyVO vo){
		log.info("ReplyDelete 호출");
		return service.delete(rno) == 1?
				new ResponseEntity<>("success",HttpStatus.OK):
					new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}
	
	@GetMapping("/{rno}")
	public ResponseEntity<ReplyVO> get(@PathVariable("rno")int rno){
		log.info("댓글 조회..");
		return new ResponseEntity<>(service.get(rno),HttpStatus.OK);
	}
}
