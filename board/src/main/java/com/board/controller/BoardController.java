package com.board.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.board.entity.Board;
import com.board.mapper.BoardMapper;

@Controller
public class BoardController {
	// boardList.do
	@Autowired
	private BoardMapper mapper;
	// HandlerMapping 클래스가 연결해줌
	@RequestMapping("/boardList.do")
	public String boardList(Model model) { //메소드 이름은 마음대로
		List<Board> list= mapper.getLists();
		model.addAttribute("list", list);
		return "boardList"; // /WEB-INF/views/--.jsp viewResolver가 다 해주기때문에 .jsp 안해도됨
	}
	
	@GetMapping("/boardForm.do")
	public String boardForm() {
		return "boardForm"; // forword
	}
	
	@PostMapping("/boardInsert.do")
	public String boardInsert(Board vo) { // Board.vo는 파라메터수집 / title,content,writer 가져올 것임
		mapper.boardInsert(vo);
		return "redirect:/boardList.do"; // redirect
	}
	
	
	@GetMapping("/boardContent.do")
	public String boardContent(@RequestParam("idx") int idx,Model model) { // idx값 받아옴 / 단일값 받을 때 / int idx에 저장
		Board vo = mapper.boardContent(idx);
		//조회수 올리고
		mapper.boardCount(idx);
		//담자
		model.addAttribute("vo", vo);
		return "boardContent";
	}
	
	@GetMapping("/boardDelete.do/{idx}")
	public String boardDelete(@PathVariable("idx") int idx) {
		mapper.boardDelete(idx);
		return "redirect:/boardList.do";
	}
	
	@GetMapping("/boardUpdateForm.do/{idx}")
	public String boardUpdateForm(@PathVariable("idx") int idx,Model model) {
		Board vo = mapper.boardContent(idx);
		model.addAttribute("vo",vo);
		
		return "boardUpdate"; //boardUpdate.jsp
	}
	
	@PostMapping("/boardUpdate.do")
	public String boardUpdate(Board vo) { //idx, title, content 넘어옴
		mapper.boardUpdate(vo);
		return "redirect:/boardList.do";
	}
}
