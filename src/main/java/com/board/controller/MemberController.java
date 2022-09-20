package com.board.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.board.entity.Member;
import com.board.mapper.MemberMapper;

@Controller
public class MemberController {
	
	@Autowired
	MemberMapper memberMapper;
	
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
				m.getMemAge()==0 ||
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
		int result=memberMapper.register(m);
		if(result==1) {
			attr.addFlashAttribute("msgType","성공 메세지");
			attr.addFlashAttribute("msg","회원가입 성공");
			// 회원가입이 성공하면 자동로그인되게 하기 - 세션 줘서
			session.setAttribute("mvo", m);
			return "redirect:/";
		} else {
			attr.addFlashAttribute("msgType","실패 메세지");
			attr.addFlashAttribute("msg","회원가입 실패");
			return "redirect:/memJoin.do";
			
		}
	}
	
	//로그아웃
	@RequestMapping("/memLogout.do")
	public String memLogout(HttpSession session) {
		session.invalidate();
		return "redirect:/";
	}
	
	//로그인화면이동
	@RequestMapping("/memLoginForm.do")
	public String memLoginForm() {
		return "member/memLoginForm";
	}
	//로그인
	@RequestMapping("/memLogin.do")
	public String memLogin(Member m,  RedirectAttributes attr, HttpSession session) {
		if(m.getMemID()==null || m.getMemID().equals("") ||
				m.getMemPassword()==null || m.getMemPassword().equals("")) {
			attr.addAttribute("msgType", "실패 메세지");
			attr.addAttribute("msg", "아이디와 비밀번호를 입력하세요.");
			return "redirect:/memLoginForm.do";
		}
		Member mvo=memberMapper.memLogin(m);
		if(mvo!=null) {
			attr.addAttribute("msgType", "성공 메세지");
			attr.addAttribute("msg", "로그인 성공");
			session.setAttribute("mvo", mvo);
			return "redirect:/";
		} else {
			attr.addAttribute("msgType", "실패 메세지");
			attr.addAttribute("msg", "로그인 실패");
			return "redirect:/memLoginForm.do";
		}
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
		int result=memberMapper.memUpdate(m);
		if(result==1) {
			attr.addFlashAttribute("msgType","성공 메세지");
			attr.addFlashAttribute("msg","회원수정 성공");
			// 회원가입이 성공하면 자동로그인되게 하기 - 세션 줘서
			session.setAttribute("mvo", m);
			return "redirect:/";
		} else {
			attr.addFlashAttribute("msgType","실패 메세지");
			attr.addFlashAttribute("msg","회원가입 실패");
			return "redirect:/memUpdateForm.do";	
		}
	}
	// 회원이미지수정화면
		@RequestMapping("/memImageForm.do")
		public String memImageForm() {
			return "member/memImageForm";
		}
		
		@RequestMapping("/memImageUpdate.do")
		public String memImageUpdate() {
			//파일 업로드api
			return "";
		}
}
