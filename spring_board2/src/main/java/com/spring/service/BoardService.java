package com.spring.service;

import java.util.List;

import com.spring.domain.BoardAttachVO;
import com.spring.domain.BoardVO;
import com.spring.domain.Criteria;

public interface BoardService {
 //public int insert(BoardVO vo);
 public int insertSelectKey(BoardVO vo);
 public int update(BoardVO vo);
 public int delete(int bno);
 public BoardVO read(int bno);
 public List<BoardVO> getList(Criteria cri);
 public int countTBL(Criteria cri);
 
 // 첨부 파일 목록 
 public List<BoardAttachVO> attachList(int bno);
}
