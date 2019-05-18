package com.spring.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.domain.BoardAttachVO;

import lombok.extern.slf4j.Slf4j;
import net.coobird.thumbnailator.Thumbnailator;

@Slf4j
@Controller
public class AjaxUploadController {
  
	@GetMapping("/uploadAjax")
	public void uploadAjaxPage() {
		log.info("uploadAjaxPage 호출");
		
	}
	
	@PostMapping("/inputAll")
	public ResponseEntity<String> inputAll(String userid, String username){
		log.info("유저 아이디 : "+userid+"유저 이름 :"+username);
		// 결과값 전송
		// userid와 username이 비어있지 않고 제대로 전소이 되었다면
		// http상태코드 ok 전송, 문자열 success같이 전송
		
		// userid 나 username이 하나라도 비어있다면
		// http상태코드 bad request 전송, 문자열 fail 전송
		if(userid == "" || username == "") {
			//BAD_REQUEST : 400
			//INTERNAL_SERVER_ERROR  : 500
			return new ResponseEntity<>("fail",HttpStatus.BAD_REQUEST); // ResponseEntity안에 있는건 request 객체에 담는다는 느낌 !
		}
		return new ResponseEntity<>("succes",HttpStatus.OK);
	}
	

	
	@PostMapping(value="/uploadAjax",produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> uploadAjaxPost(MultipartFile[] uploadFile){
		log.info("ajax 파일 업로드 요청");
		
		String uploadFolder="e:\\upload";
		//년/월/일 폴더 형태로 가져오기
		String uploadFolderPath=getFolder();
		File uploadPath=new File(uploadFolder,uploadFolderPath);
		
		//폴더가 없으면 새로 생성하기
		if(!uploadPath.exists()) {
			uploadPath.mkdirs();
		}
		
				
		List<BoardAttachVO> attList = new ArrayList<BoardAttachVO>();
		String uploadFileName="";
		
		
		for(MultipartFile f:uploadFile) {
			log.info("file Name : "+f.getOriginalFilename());
			log.info("file Size : "+f.getSize());
			
			uploadFileName=f.getOriginalFilename();
			
			//uuid 값 생성 후 파일명과 함께 저장하기
			UUID uuid=UUID.randomUUID();	
			uploadFileName = uuid.toString()+"_"+uploadFileName; // 저장하는 파일 
			File saveFile= new File(uploadPath,uploadFileName);		
			
			// 현재 파일의 저장경로와 파일명, 이미지 여부, uuid값을 담는 객체 생성
			BoardAttachVO attach = new BoardAttachVO();
			attach.setUuid(uuid.toString());
			attach.setUploadPath(uploadFolderPath);
			attach.setFileName(f.getOriginalFilename());
			
			if(checkImageType(saveFile)) {
				attach.setFileType(true);
				// 썸네일 작업하기
				try {
				 	FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath,"s_"+uploadFileName));
				    Thumbnailator.createThumbnail(f.getInputStream(),thumbnail,100,100);
				    thumbnail.close();
				} catch (FileNotFoundException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			
			try {
				f.transferTo(saveFile);
				attList.add(attach);
			} catch (IllegalStateException e) {				
				e.printStackTrace();
			} catch (IOException e) {				
				e.printStackTrace();
			}			
		}		
		return new ResponseEntity<>(attList,HttpStatus.OK);
	}
	
	// 썸네일 이미지를 보여주는 작업
	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName){
		log.info("썸네일 이미지 가져오기");
		
		File file = new File("e:\\upload\\"+fileName);
        ResponseEntity<byte[]> result = null;		
		HttpHeaders header = new HttpHeaders();
		try {
			// File.probeContentType : MIME타입 알아내기 
			// MIME : https://developer.mozilla.org/ko/docs/Web/HTTP/Basics_of_HTTP/MIME_types
			//   ㄴ 항상 따라 다님 문서의 타입을 나열하게 되어있는데 우리가 직접하지 않아도 알아서 끌고와줌 
			// 브라우저가 해석이 가능한지 
			header.add("Content-Type", Files.probeContentType(file.toPath())); 
			// 서버에있는걸 카피해서 클라이언트에게 넘기는것
			result = new ResponseEntity<byte[]>(FileCopyUtils.copyToByteArray(file),header,HttpStatus.OK); 
		} catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	
	// 폴더 생
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		return str.replace("-", File.separator);
	}
	
	// 파일이 이미지인지 확인하는 메소드
	private boolean checkImageType(File file) {
		try {
			String contentType = Files.probeContentType(file.toPath()); // contentType으로 돌려주는 정해진 메소드 
			return contentType.startsWith("image"); // 이미지로 시작하면 true 시작 안 하면 false
		} catch (IOException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	   @GetMapping(value="/download",produces=MediaType.APPLICATION_OCTET_STREAM_VALUE)
	   @ResponseBody
	   public ResponseEntity<Resource> download(String fileName, @RequestHeader("User-Agent")String userAgent) {
	      log.info("download 요청 : " + fileName);

	      Resource resource = new FileSystemResource("d:\\upload\\"+fileName);
	      
	      // uuid값 파일명
	      String resourceName = resource.getFilename();
	      // uuid값과_ 잘라내기
	      resourceName=resourceName.substring(resourceName.indexOf("_")+1);
	      
	      
	      
	      HttpHeaders headers = new HttpHeaders();
	      
	      try {
	         String downloadName=null;
	         // Trident : explorer 11
	         if(userAgent.contains("Trident") || userAgent.contains("Edge")) {
	            // URLEncoder.encode()을 할 때 공백이 있으면 + 로 변환시킴
	            downloadName=URLEncoder.encode(resourceName,"UTF-8").replaceAll("\\+"," ");
	            
	         } else {
	            downloadName = new String(resourceName.getBytes("utf-8"),"ISO-8859-1");
	         }
	         
	         headers.add("Content-Disposition", "attachment;fileName="+downloadName);
	         
	         headers.add("Content-Disposition", "attachment;fileName="+new String(resourceName.getBytes("utf-8"),"ISO-8859-1"));
	      } catch (UnsupportedEncodingException e) {
	         e.printStackTrace();
	      }
	      return new ResponseEntity<>(resource,headers,HttpStatus.OK);
	}
	   
		 // 첨부 파일 삭제
	   @PostMapping("/deleteFile")
	   @PreAuthorize("isAuthenticated()")
		 public ResponseEntity<String> deleteFile(String fileName, String type){
			 // type이 image라면 썸네일과 원본파일 삭제+''
			 // type이 file 이라면 원본파일만 삭제
			 log.info("첨부파일 목록에서 삭제 .. ");
			
			    File file = null;
				 try {
					 // 일반 파일 및 이미지 원본 파일 삭제
                    file = new File("e:\\upload\\"+URLDecoder.decode(fileName,"utf-8"));
					 
					if(type.equals("image")) {
						String largeName = file.getAbsolutePath().replace("s_", "");
						file = new File(largeName);
						
						// 원본 파일 삭제
						file.delete();
					}
				} catch (IOException e) {
					e.printStackTrace();
				}
				 
				 return new ResponseEntity<String>("deleted",HttpStatus.OK);
			 }
		 }
	
//	 @GetMapping(value="/download",produces=MediaType.APPLICATION_OCTET_STREAM_VALUE)
//	 @ResponseBody
//	 public ResponseEntity<Resource> download(String fileName,@RequestHeader("User-Agent")String userAgent){
//		 log.info("download 요청 : " + fileName);
//		 
//		 Resource resource = new FileSystemResource("e:\\upload\\"+fileName);
//		 
//		 String resourceName = resource.getFilename();
//		 
//		 HttpHeaders headers = new HttpHeaders();
//		 
//		 try {
//			  // 유저의 브라우저가 엣지이거나 익스플로어일떄 
//			 String downloadName = null;
//			 if(userAgent.contains("Trident") || userAgent.contains("Edge")){
//				 // URLEncoder.encode()을 할 떄 공백이 있으면 + 로 변환을 시킴 
//				 // 공백 : " " = %2B(유니코드)
//				 downloadName = URLEncoder.encode(resourceName, "UTF-8").replaceAll("\\+", " ");
//			 }else {
//				 downloadName=new String(resourceName.getBytes("utf-8"),"ISO-8859-1");
//			 }
//			 downloadName = downloadName.substring(downloadName.lastIndexOf("_")+1); // uuid값과 _ 잘라내기
//			 // 선생님은                   o                       o 두군데  resourceName으로 되어있음  
//			headers.add("Content-Disposition","attachment;fileName="+downloadName); 
//		} catch (UnsupportedEncodingException e) {
//			e.printStackTrace();
//		}
//		 return new ResponseEntity<>(resource,headers,HttpStatus.OK);
//	 }
	   
	   
	 

