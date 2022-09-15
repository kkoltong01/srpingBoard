package com.board.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Update;

import com.board.entity.Board;


@Mapper
public interface BoardMapper {
	public List<Board> getLists();
	public void boardInsert(Board vo);
	public Board boardContent(int idx);
	public void boardDelete(int idx);
	public void boardUpdate(Board vo);
	
	//@Update("update myboard set count=count+1 where idx=#{idx}") 이렇게 바로 적어 줄 수도 있음 
	public void boardCount(int idx);
}
