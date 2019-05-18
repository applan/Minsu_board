package com.spring.task;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.stream.Collectors;

import javax.inject.Inject;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.spring.domain.BoardAttachVO;
import com.spring.mapper.BoardAttachMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class FileCheckTask {
	
	@Inject
	private BoardAttachMapper attachMapper;


 
 // 어제 날짜의 폴더 구하기
private String getFolderYesterday() {
	 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	 
	 Calendar cal = Calendar.getInstance();
	 cal.add(Calendar.DATE, -1);
	 String str = sdf.format(cal.getTime());
	 
	 return str.replace("-", File.separator);
 }

@Scheduled(cron="0 * * * * *")	
// cron : 유닉스에서 시작했다고 함.
/*
 * 첫번쨰 인자 : seconds (0~59)
 * 두번째 인자 : minutes (0~59)
 * 세번쨰 인자 : hour    (0~23)
 * 네번째 인자 : day     (1~31)
 * 다섯번째 인자 : Months (1~12)
 * 여섯번쨰 인자 : day of week (1~7)
 */
 public void checkFiles() {
	 log.warn("file check Task run...");
	 // 로그에 이 패키지를 적용 하지 않아서 로그에서의 부모 느낌인 warn을 사용하면 적용하지 않아도 사용 가능 
	 
	 // 데이터 베이스에서 첨부 파일 목록 가져오기
	 // 어제 날짜 까지 !
	 List<BoardAttachVO> list =attachMapper.selectAll();
 

	 List<Path> fileListPaths=list.stream().map(vo ->Paths.get("e:\\upload",vo.getUploadPath(),
			 vo.getUuid()+"_"+vo.getFileName())).collect(Collectors.toList()); // 리스트 안에있는 값들 map()구조의 형태로(map구조)뽑아낸것
	 
	 
	 // .stream은 자바의 NIO -> IO부분의 향상된 것 
	 list.stream().filter(vo -> vo.isFileType() == true).map(
		     vo -> Paths.get("e:\\upload",vo.getUploadPath(),"s_"+vo.getUuid()+"_"+vo.getFileName()))
		     .forEach(p -> fileListPaths.add(p));
 			 
	 File targetDir = Paths.get("e:\\upload",getFolderYesterday()).toFile(); // 어디에 들어가야 하는지 
	 File[] remoFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath())==false);
	 
	 for(File f:remoFiles) {
		 f.delete();
	 }
		
}
}












