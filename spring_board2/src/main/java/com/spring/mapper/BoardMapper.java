package com.spring.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.domain.BoardVO;
import com.spring.domain.Criteria;

public interface BoardMapper {
	 //public int insert(BoardVO vo);
	 public int insertSelectKey(BoardVO vo);
	 public int update(BoardVO vo);
	 public int delete(int bno);
	 public BoardVO read(int bno);
	 // public List<BoardVO> getList();
	 public List<BoardVO> getList(Criteria cri);
	 
	 public int countTBL(Criteria cri);
	 
	 public void updateReplyCnt(@Param("bno")int bno,@Param("amount")int amount);
}
