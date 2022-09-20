package com.board.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.board.entity.Board;
import com.board.mapper.BoardMapper;

@Controller
public class BoardController {
	
	@RequestMapping("/boardMain.do")
	public String main() {
		return "board/main";
	}
	
}	
