package com.spring.service;


import com.spring.domain.Criteria;
import com.spring.domain.ReplyPageDTO;
import com.spring.domain.ReplyVO;

public interface ReplyService {
 public int insert(ReplyVO vo);
 public ReplyPageDTO getList(Criteria cri,int bno);
 public int update(ReplyVO vo);
 public int delete(int rno);
 public ReplyVO get(int rno);
}
