package com.kpk.exam.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kpk.exam.demo.repository.BoardRepository;
import com.kpk.exam.demo.vo.Board;

@Service
public class BoardService {

	@Autowired
	private BoardRepository boardRepository;
	
	// 생성자
	public BoardService(BoardRepository boardRepository) {
		this.boardRepository = boardRepository;
	}
	
	public Board getBoardById(int id) {
		return boardRepository.getBoardById(id);
	}
}
