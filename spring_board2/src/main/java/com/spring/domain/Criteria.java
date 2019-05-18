package com.spring.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Criteria {
 private int pageNum; // 페이지 번호
 private int amount;  // 한 페이지에 보여줄 게시물 수

 // 검색 떄문에 추가 되는 요소
 private String type;
 private String keyword;
 
 public Criteria() {
	this(1,10);
}

public Criteria(int pageNum, int amount) {
	super();
	this.pageNum = pageNum;
	this.amount = amount;
}

 public String[] getTypeArr() { // TCW value로 받아오면 t, c, w로 나누어줌 
	 return type==null? new String[] {} : type.split("");
 }
}
