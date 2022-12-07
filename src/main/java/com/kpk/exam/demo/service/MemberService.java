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

	public ResultData<Integer> join(String loginId, String loginPw, String name, String nickname, String cellphoneNum, String email) {
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
		
		loginPw = Ut.sha256(loginPw);
		
		memberRepository.join(loginId, loginPw, name, nickname, cellphoneNum, email);
		int id = memberRepository.getLastInsertId();
		return ResultData.from("S-1", "회원가입이 완료되었습니다.", "id", id);
	}

	public Member getMemberByNameAndEmail(String name, String email) {
		return memberRepository.getMemberByNameAndEmail(name, email);
	}
	
	public Member getMemberByEmail(String email) {
		return memberRepository.getMemberByEmail(email);
	}
	
	public Member getMemberByNickname(String nickname) {
		return memberRepository.getMemberByNickname(nickname);
	}

	public Member getMemberById(int id) {
		return memberRepository.getMemberById(id);	
	}

	public Member getMemberByLoginId(String loginId) {
		return memberRepository.getMemberByLoginId(loginId);
	}

	public ResultData modify(int id, String loginPw, String name, String nickname, String cellphoneNum,
			String email) {
		
		// 회원 정보를 수정중인 회원 확인
		Member member = memberRepository.getMemberById(id);
		
		// 닉네임 중복체크
		Member existsMember = getMemberByNickname(nickname);
		
		// 닉네임 중복체크 했을 때, 수정중인 회원 번호와 중복체크의 회원 번호가 같지 않으면 리턴 
		if(existsMember != null && member.getId() != existsMember.getId()) {
			return ResultData.from("F-1", "이미 사용중인 닉네임입니다.");
		}

		// 이메일 중복체크
		existsMember = getMemberByEmail(email);
		
		if(existsMember != null && member.getId() != existsMember.getId()) {
			return ResultData.from("F-2", "이미 사용중인 이메일입니다.");
		}
		
		loginPw = Ut.sha256(loginPw);
		
		memberRepository.modify(id, loginPw, name, nickname, cellphoneNum, email);
		
		return ResultData.from("S-1", "회원정보가 수정되었습니다.");
	}

	public String genMemberModifyAuthKey(int actorId) {
		String memberModifyAuthKey = Ut.getTempPassword(10);
		
		attrService.setValue("member", actorId, "extra", "memberModifyAuthKey", memberModifyAuthKey, Ut.getDateStrLater(60 * 5));
		
		return memberModifyAuthKey;
	}

	public ResultData checkMemeberModifyAuthKey(int actorId, String memberModifyAuthKey) {
		String saved = attrService.getValue("member", actorId, "extra", "memberModifyAuthKey");
		
		if(!saved.equals(memberModifyAuthKey)) {
			return ResultData.from("F-1", "일치하지 않거나 만료되었습니다.");
		}
		
		return ResultData.from("S-1", "정상 코드입니다.");
			
	}
	
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

	private void setTempPassword(Member actor, String tempPassword) {
		memberRepository.modify(actor.getId(), Ut.sha256(tempPassword), null, null, null, null);
	}

	public int getMembersCount() {
		return memberRepository.getMembersCount();
	}

	public List<Member> getForPrintMembers(int itemsInAPage, int page) {
		int limitStart = (page - 1) * itemsInAPage;
		int limitTake = itemsInAPage;
		
		List<Member> members = memberRepository.getForPrintMembers(limitStart, limitTake);
		
		return members;
	}
	
}
