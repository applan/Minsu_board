package com.spring.mapper;

import java.util.List;

import com.spring.domain.BoardAttachVO;

public interface BoardAttachMapper {
  public int insert(BoardAttachVO attach);
  public int delete(int bno);
  public List<BoardAttachVO> findByBno(int bno);

  // Quartz를 위해 만든것
  public List<BoardAttachVO> selectAll();
}
