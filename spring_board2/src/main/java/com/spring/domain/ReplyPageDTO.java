package com.spring.domain;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class ReplyPageDTO {
  private int replyCnt; // 게시물 전체 댓글 수 
  private List<ReplyVO> list; 
}
