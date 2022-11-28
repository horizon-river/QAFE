package com.kpk.exam.demo.repository;

import org.apache.ibatis.annotations.Mapper;

import com.kpk.exam.demo.vo.Board;

@Mapper
public interface BoardRepository {
	
	public Board getBoardById(int id);

}
