package com.spring.domain;

import java.util.Date;
import java.util.List;

// import java.sql.Date; // yyyy-MM-dd 로 자동 나옴


import lombok.Data;
@Data
public class BoardVO {
 private int bno;
 private String title;
 private String content;
 private String writer;
 private Date regdate;
 private Date updatedate;
 private int replycnt;
 
 // 파일 첨부 목록 
 
 private List<BoardAttachVO> attachList;
 
 
}
