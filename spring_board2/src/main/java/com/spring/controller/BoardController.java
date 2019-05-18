package com.spring.controller;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.domain.BoardAttachVO;
import com.spring.domain.BoardVO;
import com.spring.domain.Criteria;
import com.spring.domain.PageDTO;
import com.spring.service.BoardService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/board/*")
public class BoardController {
 
	@Autowired
	private BoardService service;
	
	// register.jsp보여주는 컨트롤러 생성
	// 로그인 상태여야 글쓰기 폼 보여주기
	@PreAuthorize("isAuthenticated()")
	@GetMapping("register")
	public void register() {
		log.info("register 호출");
	}
	
	// 게시글 등록 컨트롤러 생성
	// 작업 완료 후 list 컨트롤러 이동
	@PostMapping("insert")
	@PreAuthorize("isAuthenticated()")
	public String insert(BoardVO vo,RedirectAttributes red) {
		log.info("insert 호출");
		int result = service.insertSelectKey(vo);
		if(result >0) {
			red.addFlashAttribute("result",vo.getBno());
			
		}else {
			return "redirect:register";
		}
		log.info("ㅇ어어ㅓ어어엉----"+vo.getAttachList());
		if(vo.getAttachList()!=null) {
			for(BoardAttachVO attach : vo.getAttachList()) {
				log.info("가나"+attach);
			}
		}
		//return "redirect:register";
		return "redirect:list";
	}
	//list 컨트롤러에서는 전체 내용 가지고 와서
	// list.jsp로 이동
	@GetMapping("list")
	public String getList(Model model,@ModelAttribute("cri")Criteria cri) {
		log.info("getList 호출");
	  List<BoardVO> list = service.getList(cri);
	  int total = service.countTBL(cri);
	  if(list.isEmpty() && cri == null) {
		  return "redirect:register";
	  }else {
		  model.addAttribute("list", list);
		  // 임읭의 토탈갯수를 넣어서 확인
		  model.addAttribute("pageMaker", new PageDTO(cri, total));
		  return  "board/list";
	  }
	
	}
	
	@GetMapping("read")
	//@GetMapping(value={"read","modify"}) 이렇게 하면 modify요청, read요청이 와도 가능 
	public String read(int bno,@ModelAttribute("cri")Criteria cri,Model model) {
		log.info("read 호출 bno:"+bno+" pageNum:"+cri.getPageNum());
	 BoardVO vo = service.read(bno);
	 if(vo == null) {
		 return "redirect:list";
	 }else {
		 model.addAttribute("cri",cri);
		 model.addAttribute("vo",vo);
		 return "board/read";
	 
		 //@ModelAttribute : jsp 페이지에서 값을 사용할 때 criteria.pageNum
		 //                   model.addAttribute() 까지 해주는 것 
	 
	 }
	}
	
	@GetMapping("modify")
	public String modify(int bno,Criteria cri,Model model,RedirectAttributes red) {
		log.info("modify 호출");
		BoardVO vo = service.read(bno);
		if(vo == null) {
			red.addAttribute("pageNum", cri.getPageNum());
			red.addAttribute("amount", cri.getAmount());
			red.addAttribute("keyword", cri.getKeyword());
			red.addAttribute("type", cri.getType());
			return "redirect:list";
		}else {
			model.addAttribute("vo",vo);
			model.addAttribute("cri",cri);
			red.addAttribute("keyword", cri.getKeyword());
			red.addAttribute("type", cri.getType());
			return "board/modify";
		}
	}
	
	@PostMapping("delete")
	@PreAuthorize("principal.username == #writer")
	public String delete(int bno,String writer,Criteria cri,RedirectAttributes red) {
		log.info("delete 호출");
		
		// 첨부된 파일 폴더에서 삭제하기
		List<BoardAttachVO> attachList = service.attachList(bno);
		
		int result = service.delete(bno);
		if(result >0) {
			deleteFile(attachList);
			red.addFlashAttribute("tf","true");
			red.addAttribute("pageNum", cri.getPageNum());
			red.addAttribute("amount", cri.getAmount());
			red.addAttribute("keyword", cri.getKeyword());
			red.addAttribute("type", cri.getType());
			return "redirect:list";
		}else {
			red.addFlashAttribute("tf","false");
			red.addAttribute("pageNum", cri.getPageNum());
			red.addAttribute("amount", cri.getAmount());
			red.addAttribute("keyword", cri.getKeyword());
			red.addAttribute("type", cri.getType());
			return "redirect:list";
		}
	}
	
	@PostMapping("update")
	@PreAuthorize("principal.username == #vo.writer") // 글쓴이와 로그인 사용자가 일치하는지 확인 
	public String update(BoardVO vo,Criteria cri,RedirectAttributes red) {
		log.info("update 호출"+cri.getPageNum()+"||"+cri.getAmount());
		if(vo.getAttachList()!= null) {
			for(BoardAttachVO attach:vo.getAttachList()) {
				log.info(""+attach);
			}
			
		}
		int result = service.update(vo);
		if(result >0) {
			red.addFlashAttribute("tf","true");
//			red.addAttribute("bno",vo.getBno()); 요렇게 (flash말고 그냥으로 사용하면 주소창에 bno값 보이면서 값을 읽을 수 있다. )
//			return "redirect:read"; // flash안 넣었을떄 return
			red.addAttribute("pageNum", cri.getPageNum());
			red.addAttribute("amount", cri.getAmount());
			red.addAttribute("keyword", cri.getKeyword());
			red.addAttribute("type", cri.getType());
			return "redirect:read?bno="+vo.getBno();
		}else {
			red.addFlashAttribute("tf","false");
			red.addAttribute("pageNum", cri.getPageNum());
			red.addAttribute("amount", cri.getAmount());
			red.addAttribute("keyword", cri.getKeyword());
			red.addAttribute("type", cri.getType());
			return "redirect:read?bno="+vo.getBno();
		}
	}
	
	// 첨부 파일 가져오기
    // uri  /getAttachList | 들어오는 것 bno 
	
	@GetMapping("findBno")
	@ResponseBody
	public List<BoardAttachVO> findList(int bno) {
		log.info("들어온 값 "+bno);
		List<BoardAttachVO> list = service.attachList(bno);
		
		return list;
	}
	
	 // 첨부 파일 삭제
	 private void deleteFile(List<BoardAttachVO> attachList){
		 // type이 image라면 썸네일과 원본파일 삭제+''
		 // type이 file 이라면 원본파일만 삭제
		 log.info("첨부파일 삭제 .. ");
		 
		 
		 if(attachList.size()==0 || attachList==null) {
		  return;
		 }
        
		 for(BoardAttachVO vo : attachList) {
			 Path file = Paths.get("e:\\upload\\"+vo.getUploadPath()+"\\"+vo.getUuid()+"_"+vo.getFileName());
			 
			 try {
				 // 일반 파일 및 이미지 원본 파일 삭제
				Files.deleteIfExists(file);
				
				if(Files.probeContentType(file).startsWith("image")) {
					Path thumbNail = Paths.get("e:\\upload\\"+vo.getUploadPath()+"\\s_"+vo.getUuid()+"_"+vo.getFileName());
					Files.deleteIfExists(thumbNail);
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		 }
	 }
	
	
}
