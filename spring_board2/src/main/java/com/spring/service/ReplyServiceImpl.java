package com.spring.service;


import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.domain.Criteria;
import com.spring.domain.ReplyPageDTO;
import com.spring.domain.ReplyVO;
import com.spring.mapper.BoardMapper;
import com.spring.mapper.ReplyMapper;

@Service
public class ReplyServiceImpl implements ReplyService{

	@Inject
	private ReplyMapper mapper;
	@Inject
	private BoardMapper boardMapper;
	
	@Transactional
	@Override
	public int insert(ReplyVO vo) {
		// 댓글 등록과 함께 spring_board 의 댓글 수 변경 필요 
		boardMapper.updateReplyCnt(vo.getBno(), 1);
		return mapper.insert(vo);
	}

	@Override
	public ReplyPageDTO getList(Criteria cri,int bno) {
		return new ReplyPageDTO(mapper.getCountByBno(bno), mapper.getList(cri, bno));
	}

	@Override
	public int update(ReplyVO vo) {
		return mapper.update(vo);
	}

	@Transactional
	@Override
	public int delete(int rno) {
		// rno를 이용해서 bno가져오기 
		ReplyVO vo = mapper.get(rno);
		
		// 댓글 삭제와 함께 spring_board 의 댓글 수 변경 필요 
		boardMapper.updateReplyCnt(vo.getBno(), -1);
		return mapper.delete(rno);
	}

	
	@Override
	public ReplyVO get(int rno) {
		return mapper.get(rno);
	}



}
