package com.spring.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.domain.BoardAttachVO;
import com.spring.domain.BoardVO;
import com.spring.domain.Criteria;
import com.spring.mapper.BoardAttachMapper;
import com.spring.mapper.BoardMapper;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class BoardServiceImpl implements BoardService{
   
	@Autowired
	private BoardMapper mapper;
	
	@Autowired
	private BoardAttachMapper attachMapper;
	
	@Transactional
	@Override
	public int insertSelectKey(BoardVO vo) {
		//return mapper.insert(vo); 단순 입력
		int result = 0;
		result = mapper.insertSelectKey(vo); // 입력 후 증가된 bno 값 사용할 떄 
		log.info("으아아아아 !!! -----"+vo.getBno());
		//파일 첨부 등록
		if(vo.getAttachList()==null || vo.getAttachList().size()<=0) {
			return result;
		}
		vo.getAttachList().forEach(attach->{ // 함수 형 형태로 (java 8 버전 부터 추가 됨)
			attach.setBno(vo.getBno());
			log.info("으아아아아 !!! -----dasdas"+vo);
			 attachMapper.insert(attach);
		});
		
//		for(BoardAttachVO attach : vo.getAttachList()) { ( 위에 있는 forEach문과 같음 ) 
//			attach.setBno(vo.getBno());
//			attachMapper.insert(attach);
//		}
		return result;
	}
	
	@Override
	public BoardVO read(int bno) {
		return mapper.read(bno);
	}

	@Override
	public List<BoardVO> getList(Criteria cri) {
		return mapper.getList(cri);
	}

	@Transactional
	@Override
	public int delete(int bno) {
		attachMapper.delete(bno);
		return mapper.delete(bno);
	}

	@Transactional
	@Override
	public int update(BoardVO vo) {
		// 첨부파일의 경우 기존 첨부물이 남아 있기 떄문에 이 부분에 대한 처리가 필요함
		// 기존 첨부 목록은 삭제/ 현재 첨부 목록 입력 
		attachMapper.delete(vo.getBno());
		
		int result = mapper.update(vo);
		log.info("으엉엉엉vo를 가져욧"+vo.getAttachList());
		
		if(vo.getAttachList() != null) {
		if(result >0 && vo.getAttachList().size()>0) {
		vo.getAttachList().forEach(attach->{ // 함수 형 형태로 (java 8 버전 부터 추가 됨)
			attach.setBno(vo.getBno());
			log.info("으아아아아 !!! -----dasdas"+vo);
			 attachMapper.insert(attach);
		});
	 }
		}
		return result;
	}

	@Override
	public int countTBL(Criteria cri) {	
		return mapper.countTBL(cri);
	}

	@Override
	public List<BoardAttachVO> attachList(int bno) {
		return attachMapper.findByBno(bno);
	}
	
	

 
}
