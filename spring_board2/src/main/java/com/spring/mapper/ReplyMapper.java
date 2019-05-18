package com.spring.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.domain.Criteria;
import com.spring.domain.ReplyVO;

public interface ReplyMapper {
 public int insert(ReplyVO vo);
 public List<ReplyVO> getList(@Param("cri")Criteria cri,@Param("bno")int bno); 
 /*
  *  @Param을 사용하는 이유 : 개별 파라메터로 넘길 떄는 @Param 어노테이션을 반드시 사용해야 함 
  *  - 전달인자를 전달할 떄 하나의 객체로 넘겨줘야 함
  *  getList(int bno,String name) => 이렇게 불가 ( 파라미터 2개 이상은  절대 불가 )
  *  => VO 객체로 담거나, HashMap 형태로 넘김 
  */
 public int update(ReplyVO vo);
 public int delete(int rno);
 public ReplyVO get(int rno);
 public int getCountByBno(int bno);
}
