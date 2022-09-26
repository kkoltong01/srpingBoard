package com.board.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import com.board.entity.AuthVO;
import com.board.entity.Member;
import com.board.entity.MemberUser;
import com.board.mapper.MemberMapper;
import com.board.security.MemberUserDetailsService;
@Controller
public class MemberController {
	
	@Autowired
	MemberMapper memberMapper;
	
	@Autowired
	PasswordEncoder pWEncoder;
	
	@Autowired
	MemberUserDetailsService memberUserDetailsService;
	
	@RequestMapping("/memJoin.do")
	public String memJoin() {
		return "member/join";
	}
	@RequestMapping("/memRegisterCheck.do")
	public @ResponseBody int memRegisterCheck(String memID) {
		Member m = memberMapper.registerCheck(memID);
		if(m != null || memID.equals("")) {
			return 0;
		} else {
			return 1;
		}
	}
	//회원가입 처리
	@RequestMapping("/memRegister.do")
	public String memRegister(Member m, String memPwd1, String memPwd2,
			RedirectAttributes attr, HttpSession session) { // 누락메세지 한번만 가져가면 되므로 RedirectAttributes
		if(m.getMemID()==null || m.getMemID().equals("") ||
				memPwd1==null || memPwd1.equals("") ||
				memPwd2==null || memPwd2.equals("") ||
				m.getMemName()==null || m.getMemName().equals("") ||
				m.getMemAge()==0 || m.getAuthList().size() ==0 ||
				m.getMemGender()==null || m.getMemGender().equals("") ||
				m.getMemEmail()==null || m.getMemEmail().equals("")) {
			attr.addFlashAttribute("msgType","누락 메세지");
			attr.addFlashAttribute("msg","모든 내용을 입력하세요.");
			return "redirect:/memJoin.do";
		}
		if(!memPwd1.equals(memPwd2)) {
			attr.addFlashAttribute("msgType","누락 메세지");
			attr.addFlashAttribute("msg","비밀번호가 다릅니다.");
			return "redirect:/memJoin.do";
		}
		m.setMemProfile(""); // 사진이미지는 없으므로 ""
		//회원을 테이블에 저장하기
		//추가 : 비밀번호를 암호화하ㅣ(API)
		String encyptPw=pWEncoder.encode(m.getMemPassword());
		m.setMemPassword(encyptPw);
		// register() 수정
		int result=memberMapper.register(m);
		if(result==1) {//회원가입성공메세지
			//추가 : 권한테이블에 회원의 권한을 저장하기
			List<AuthVO> list =m.getAuthList();
			for(AuthVO authVO : list) {
				if(authVO.getAuth()!=null) {
					AuthVO saveVo =new AuthVO();
					saveVo.setMemID(m.getMemID());
					saveVo.setAuth(authVO.getAuth());
					memberMapper.authInsert(saveVo);
				}
			}
			attr.addFlashAttribute("msgType","성공 메세지");
			attr.addFlashAttribute("msg","회원가입 성공");
			// 회원가입이 성공하면 자동로그인되게 하기 - 세션 줘서
			return "redirect:/memLoginForm.do";
		} else {
			attr.addFlashAttribute("msgType","실패 메세지");
			attr.addFlashAttribute("msg","회원가입 실패");
			return "redirect:/memJoin.do";	
		}
	}
	//로그인화면이동
	@RequestMapping("/memLoginForm.do")
	public String memLoginForm() {
		return "member/memLoginForm";
	}
	// 회원정보수정화면
	@RequestMapping("/memUpdateForm.do")
	public String memUpdateForm() {
		return "member/memUpdateForm";
	}
	@RequestMapping("/memUpdate.do")
	public String memUpdate(Member m, RedirectAttributes attr,
			String memPwd1, String memPwd2, HttpSession session) {
		if(m.getMemID()==null || m.getMemID().equals("") ||
				memPwd1==null || memPwd1.equals("") ||
				memPwd2==null || memPwd2.equals("") ||
				m.getMemName()==null || m.getMemName().equals("") ||
				m.getMemAge()==0 ||
				m.getMemGender()==null || m.getMemGender().equals("") ||
				m.getMemEmail()==null || m.getMemEmail().equals("")) {
			attr.addFlashAttribute("msgType","누락 메세지");
			attr.addFlashAttribute("msg","모든 내용을 입력하세요.");
			return "redirect:/memUpdateForm.do";
		}
		if(!memPwd1.equals(memPwd2)) {
			attr.addFlashAttribute("msgType","누락 메세지");
			attr.addFlashAttribute("msg","비밀번호가 다릅니다.");
			return "redirect:/memUpdateForm.do";
		}
		//회원을 수정하기
		String encyptPw=pWEncoder.encode(m.getMemPassword());
		m.setMemPassword(encyptPw);
		int result=memberMapper.memUpdate(m);
		if(result==1) {
			//기존 권한을 삭제하고
			memberMapper.authDelete(m.getMemID());
			
			// 새로운 권한을 추가하기	
			List<AuthVO> list=m.getAuthList();			
			for(AuthVO authVO : list) { 
				if(authVO.getAuth()!=null) {
					AuthVO saveVO=new AuthVO();
					saveVO.setMemID(m.getMemID()); 
					saveVO.setAuth(authVO.getAuth());
					memberMapper.authInsert(saveVO); 
				} 
	        }
			attr.addFlashAttribute("msgType","성공 메세지");
			attr.addFlashAttribute("msg","회원수정 성공");
			
			// 회원수정이 성공하면=>로그인처리하기
			   Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
			   MemberUser userAccount = (MemberUser) authentication.getPrincipal();
			   SecurityContextHolder.getContext().setAuthentication(createNewAuthentication(authentication,userAccount.getMember().getMemID()));
			return "redirect:/";
		} else {
			attr.addFlashAttribute("msgType","실패 메세지");
			attr.addFlashAttribute("msg","회원수정 실패");
			return "redirect:/memUpdateForm.do";	
		}
	}
	// 회원이미지수정화면
		@RequestMapping("/memImageForm.do")
		public String memImageForm() {
			return "member/memImageForm";
		}
		
		@RequestMapping("/memImageUpdate.do")
		public String memImageUpdate(HttpServletRequest request,HttpSession session, RedirectAttributes rttr) throws IOException {
			// 파일업로드 API(cos.jar, 3가지)
			MultipartRequest multi=null;
			int fileMaxSize=40*1024*1024; // 10MB
			String savePath=request.getRealPath("resources/upload"); // 1.png
			try {                                                                        // 1_1.png
				// 이미지 업로드
				multi = new MultipartRequest(request,savePath,fileMaxSize,"UTF-8", new DefaultFileRenamePolicy());
			
			} catch (Exception e) {
				e.printStackTrace();
				rttr.addFlashAttribute("msgType", "실패 메세지");
				rttr.addFlashAttribute("msg", "파일의 크기는 10MB를 넘을 수 없습니다.");			
				return "redirect:/memImageForm.do";
			}
			// 데이터베이스 테이블에 회원이미지를 업데이트
			String memID=multi.getParameter("memID");
			String newProfile="";
			File file=multi.getFile("memProfile");
			if(file != null) { //업로드가 된상태 (.png .jpg .gif)
				//이미지 파일여부 체크후 이미지파일이 아니면 삭제
				String ext=file.getName().substring(file.getName().lastIndexOf(".")+1);
				//소문자 대문자 나뉠 수도 있으니까
				ext=ext.toUpperCase();
				if(ext.equals("PNG") || ext.equals("GIF") || ext.equals("JPG")) {
					// 새로 업로드 된 이미지(NEW), 현재DB에 있는 이미지(OLD)
					String oldProfile= memberMapper.getMember(memID).getMemProfile();
					File oldFile=new File(savePath+"/"+oldProfile);
					if(oldFile.exists()) {
						oldFile.delete();
					}
					newProfile=file.getName();
				} else { //이미지 파일이 아니면
					if(file.exists()) { // 이미지 파일이 아닌데 파일이 있으면
						file.delete();
					}
					rttr.addFlashAttribute("msgType", "실패 메세지");
					rttr.addFlashAttribute("msg", "이미지 파일만 업로드 해주세요");			
					return "redirect:/memImageForm.do";
				}
			}
			//새로운 이미지를 DB에 저장
			Member mvo=new Member();
			mvo.setMemID(memID);
			mvo.setMemProfile(newProfile);
			memberMapper.memProfileUpdate(mvo); // 이미지 업데이트 성공
			
			// 스프링보안(새로운 인증 세션을 생성->객체바인딩)
			Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
			MemberUser userAccount = (MemberUser) authentication.getPrincipal();
			SecurityContextHolder.getContext().setAuthentication(createNewAuthentication(authentication,userAccount.getMember().getMemID()));
			
			rttr.addFlashAttribute("msgType", "성공 메세지");
			rttr.addFlashAttribute("msg", "이미지 변경 성공");			
			return "redirect:/";
		}
		
		// 스프링 보안(새로운 세션 생성 메서드)
		 // UsernamePasswordAuthenticationToken -> 회원정보+권한정보
		 protected Authentication createNewAuthentication(Authentication currentAuth, String username) {
			    UserDetails newPrincipal = memberUserDetailsService.loadUserByUsername(username);
			    UsernamePasswordAuthenticationToken newAuth = new UsernamePasswordAuthenticationToken(newPrincipal, currentAuth.getCredentials(), newPrincipal.getAuthorities());
			    newAuth.setDetails(currentAuth.getDetails());	    
			    return newAuth;
		 }
		
		@GetMapping("/access-denied")
		public String showAccessDenied() {
			return "access-denied";
		}
}
