package com.spring.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class MemberVO {
 private String userid;
 private String userpw;
 private String username;
 private Date regdate;
 private Date updateDate;
 private Boolean enabled;
 
 private List<AuthVO> authList;
}
