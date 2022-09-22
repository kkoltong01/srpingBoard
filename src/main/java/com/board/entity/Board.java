package com.board.entity;

import lombok.Data;

@Data // lombok API
public class Board {
	private int idx;
	private String memID;
	private String title;
	private String content;
	private String writer;
	private String indate;
	private int count;
}
