package com.kpk.exam.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.kpk.exam.demo.vo.Member;

@Mapper
public interface MemberRepository {

	public void join(String loginId, String loginPw, String name, String nickname, String cellphoneNum, String email);

	public int getLastInsertId();

	public Member getMemberById(int id);

	public Member getMemberByLoginId(String loginId);
	
	public Member getMemberByNameAndEmail(String name, String email);
	
	public Member getMemberByNickname(String nickname);
	
	public Member getMemberByEmail(String email);

	public void modify(int id, String loginPw, String name, String nickname, String cellphoneNum, String email);

	public int getMembersCount();

	public List<Member> getForPrintMembers(int limitStart, int limitTake);
}
