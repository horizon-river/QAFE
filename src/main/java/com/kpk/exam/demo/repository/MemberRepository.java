package com.kpk.exam.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.kpk.exam.demo.vo.Member;

@Mapper
public interface MemberRepository {

	public void join(String loginId, String loginPw, String name, 
			String nickname, String cellphoneNum, String email);
	
	public Member getMemberByNickname(String nickname);
	
	public Member getMemberByEmail(String email);

	public Member getMemberByNameAndEmail(String name, String email);

	public Member getMemberByLoginIdAndEmail(String loginId, String email);
	
	public Member getMemberByLoginId(String loginId);
	
	public int getLastInsertId();
	
	public Member getMemberById(int id);

	public void modify(int id, String loginPw, String name, String nickname, String cellphoneNum, String email);

	public int getMembersCount(String authLevel, String searchKeywordTypeCode, String searchKeyword);

	public List<Member> getForPrintMembers(String authLevel, String searchKeywordTypeCode, String searchKeyword, int limitStart, int limitTake);

	public void deleteMember(int id);

	public void recoveryMember(int id);
}
