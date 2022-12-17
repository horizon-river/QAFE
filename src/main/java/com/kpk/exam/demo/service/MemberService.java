package com.kpk.exam.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.kpk.exam.demo.repository.MemberRepository;
import com.kpk.exam.demo.util.Ut;
import com.kpk.exam.demo.vo.Member;
import com.kpk.exam.demo.vo.ResultData;

@Service
public class MemberService {
	@Value("${custom.siteMainUri}")
	private String siteMainUri;
	@Value("${custom.siteName}")
	private String siteName;
	
	@Autowired
	private MemberRepository memberRepository;
	@Autowired
	private AttrService attrService;
	@Autowired
	private MailService mailService;

	// 회원가입
	public ResultData<Integer> join(String loginId, String loginPw, String name, 
			String nickname, String cellphoneNum, String email) {
		// 로그인아이디 중복체크
		Member existsMember = memberRepository.getMemberByLoginId(loginId);
		
		if (existsMember != null) {
			return ResultData.from("F-1", Ut.f("이미 사용중인 아이디(%s)입니다.", loginId));
		}
		
		// 닉네임 중복체크
		existsMember = getMemberByNickname(nickname);
		
		if(existsMember != null) {
			return ResultData.from("F-2", "이미 사용중인 닉네임입니다.");
		}

		// 이메일 중복체크
		existsMember = getMemberByEmail(email);
		
		if(existsMember != null) {
			return ResultData.from("F-3", "이미 사용중인 이메일입니다.");
		}
		
		// 비밀번호 암호화
		loginPw = Ut.sha256(loginPw);
		
		memberRepository.join(loginId, loginPw, name, nickname, cellphoneNum, email);
		int id = memberRepository.getLastInsertId();
		return new ResultData("S-1", "회원가입이 완료되었습니다.", "id", id);
	}
	// 이메일로 회원정보 조회
	public Member getMemberByEmail(String email) {
		return memberRepository.getMemberByEmail(email);
	}
	
	// 닉네임으로 회원정보 조회
	public Member getMemberByNickname(String nickname) {
		return memberRepository.getMemberByNickname(nickname);
	}

	// id(데이터 베이스의 id)로 회원정보 조회
	public Member getMemberById(int id) {
		return memberRepository.getMemberById(id);	
	}

	// 이름과 이메일로 회원정보 조회
	public Member getMemberByNameAndEmail(String name, String email) {
		return memberRepository.getMemberByNameAndEmail(name, email);
	}

	// 로그인 아이디와 이메일로 회원정보 조회
	public Member getMemberByLoginIdAndEmail(String loginId, String email) {
		return memberRepository.getMemberByLoginIdAndEmail(loginId, email);
	}
	
	// loginId(로그인용 아이디)로 회원정보 조회
	public Member getMemberByLoginId(String loginId) {
		return memberRepository.getMemberByLoginId(loginId);
	}

	// 회원정보 수정
	public ResultData modify(int actorId, String loginPw, String name, String nickname, 
			String cellphoneNum, String email) {
		
		// 회원 정보를 수정중인 회원 확인
		Member member = memberRepository.getMemberById(actorId);
		
		// 닉네임 중복체크
		Member existsMember = getMemberByNickname(nickname);
		
		// 닉네임 중복체크 했을 때, 수정중인 회원 번호와 중복체크의 회원 번호가 같지 않으면 리턴 
		if(existsMember != null && member.getId() != existsMember.getId()) {
			return ResultData.from("F-1", "이미 사용중인 닉네임입니다.");
		}

		// 이메일 중복체크
		existsMember = getMemberByEmail(email);

		// 닉네임 중복체크 했을 때, 수정중인 회원 번호와 중복체크의 회원 번호가 같지 않으면 리턴
		if(existsMember != null && member.getId() != existsMember.getId()) {
			return ResultData.from("F-2", "이미 사용중인 이메일입니다.");
		}
		
//		loginPw = Ut.sha256(loginPw); // 2중 암호화 방지로 인한 제거
		
		memberRepository.modify(actorId, loginPw, name, nickname, cellphoneNum, email);

		if (loginPw != null) {
			attrService.remove("member", actorId, "extra", "useTempPassword");
		}
		return ResultData.from("S-1", "회원정보가 수정되었습니다.");
	}

	// 회원정보 수정용 키 발급
	public String genMemberModifyAuthKey(int actorId) {
		String memberModifyAuthKey = Ut.getTempPassword(10);
		
		attrService.setValue("member", actorId, "extra", "memberModifyAuthKey", 
				memberModifyAuthKey, Ut.getDateStrLater(60 * 5));
		
		return memberModifyAuthKey;
	}

	// 발급된 수정용 키가 맞는지 체크
	public ResultData checkMemeberModifyAuthKey(int actorId, String memberModifyAuthKey) {
		String saved = attrService.getValue("member", actorId, "extra", "memberModifyAuthKey");
		
		if(!saved.equals(memberModifyAuthKey)) {
			return ResultData.from("F-1", "일치하지 않거나 만료되었습니다.");
		}
		
		return ResultData.from("S-1", "정상 코드입니다.");
			
	}
	
	// 임시 패스워드 전송
	public ResultData notifyTempLoginPwByEmailRd(Member actor) {
		String title = "[" + siteName + "] 임시 패스워드가 발송됐습니다.";
		String tempPassword = Ut.getTempPassword(6);
		String body = "<h1>임시 패스워드 : " + tempPassword + "</h1>";
		body += "<a href=\"" + siteMainUri + "/usr/member/login\" target=\"_blank\">로그인 하러가기</a>";

		ResultData sendResultData = mailService.send(actor.getEmail(), title, body);

		if (sendResultData.isFail()) {
			return sendResultData;
		}

		setTempPassword(actor, tempPassword);

		return ResultData.from("S-1", "계정의 이메일주소로 임시 패스워드가 발송되었습니다.");
	}

	// 임시 패스워드 설정
	private void setTempPassword(Member actor, String tempPassword) {
		memberRepository.modify(actor.getId(), Ut.sha256(tempPassword), null, null, null, null);
	}

	public int getMembersCount(String authLevel, String searchKeywordTypeCode, String searchKeyword) {
		return memberRepository.getMembersCount(authLevel, searchKeywordTypeCode, searchKeyword);
	}

	public List<Member> getForPrintMembers(String authLevel, String searchKeywordTypeCode, String searchKeyword, int itemsInAPage, int page) {
		int limitStart = (page - 1) * itemsInAPage;
		int limitTake = itemsInAPage;
		List<Member> members = memberRepository.getForPrintMembers(authLevel, searchKeywordTypeCode, searchKeyword,limitStart, limitTake);

		return members;
	}
	
	public void deleteMembers(List<Integer> memberIds) {
		for (int memberId : memberIds) {
			Member member = getMemberById(memberId);

			if (member != null) {
				deleteMember(member);
			}
		}
	}
	
	public void deleteMember(Member member) {
		memberRepository.deleteMember(member.getId());
	}
	
	public void recoveryMembers(List<Integer> memberIds) {
		for (int memberId : memberIds) {
			Member member = getMemberById(memberId);

			if (member != null) {
				recoveryMember(member);
			}
		}
	}
	
	private void recoveryMember(Member member) {
		memberRepository.recoveryMember(member.getId());
	}
	
}
