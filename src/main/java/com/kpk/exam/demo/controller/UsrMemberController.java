package com.kpk.exam.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kpk.exam.demo.service.AnswerService;
import com.kpk.exam.demo.service.ArticleService;
import com.kpk.exam.demo.service.MemberService;
import com.kpk.exam.demo.util.Ut;
import com.kpk.exam.demo.vo.Member;
import com.kpk.exam.demo.vo.ResultData;
import com.kpk.exam.demo.vo.Rq;

@Controller
public class UsrMemberController {
	
	@Autowired
	private Rq rq;
	@Autowired
	private MemberService memberService;
	@Autowired
	private AnswerService answerService;
	@Autowired
	private ArticleService articleService;

	@RequestMapping("/usr/member/join")
	public String showJoin() {
		return "usr/member/join"; 
	}

	// 회원가입 처리
	@RequestMapping("usr/member/doJoin")
	@ResponseBody
	public String doJoin(String loginId, String loginPw, String name, String nickname, 
			String cellphoneNum, String email, @RequestParam(defaultValue = "/") String afterLoginUri) {
				
		ResultData<Integer> joinRd = memberService.join(loginId, loginPw, name, nickname, cellphoneNum, email);
		
		if (joinRd.isFail()) {
			return rq.jsHistoryBack(joinRd.getMsg());
		}
		
		String afterJoinUri = "../member/login?afterLoginUri=" + Ut.getUriEncoded(afterLoginUri);
		
		return Ut.jsReplace("회원가입이 완료되었습니다. 로그인 후 이용해주세요.", afterJoinUri);
	}

	// 로그인 jsp 연결
	@RequestMapping("/usr/member/login")
	public String showLogin() {
		return "usr/member/login"; 
	}

	// 로그인 처리
	@RequestMapping("usr/member/doLogin")
	@ResponseBody
	public String doLogin(String loginId, String loginPw, 
			@RequestParam(defaultValue = "/") String afterLoginUri) {
		
		if (Ut.empty(loginId)) {
			return Ut.jsHistoryBack("아이디를 입력해주세요.");
		}
		
		if (Ut.empty(loginPw)) {
			return Ut.jsHistoryBack("비밀번호를 입력해주세요.");
		}
		
		Member member = memberService.getMemberByLoginId(loginId);
		
		if (member == null) {
			return Ut.jsHistoryBack("존재하지 않는 아이디입니다.");
		}
		
		if (member.getLoginPw().equals(Ut.sha256(loginPw)) == false) {
			return Ut.jsHistoryBack("비밀번호가 일치하지 않습니다.");
		}
		
		if (member.isDelStatus() == true) {
			return Ut.jsReplace("사용 정지 된 계정입니다", "/");
		}
		
		rq.login(member);
		
		return Ut.jsReplace(Ut.f("%s님 환영합니다.", member.getNickname()), afterLoginUri);
	}

	// 아이디 찾기 jsp 연결
	@RequestMapping("usr/member/findLoginId")
	public String showFindLoginId() {
		return "usr/member/findLoginId";
	}
	
	// 아이디 찾기 처리
	@RequestMapping("usr/member/doFindLoginId")
	@ResponseBody
	public String doFindLoginId(String name, String email,
			@RequestParam(defaultValue = "/") String afterFindLoginIdUri) {

		Member member = memberService.getMemberByNameAndEmail(name, email);

		if (member == null) {
			return Ut.jsHistoryBack("이름과 이메일을 확인해주세요.");
		}

		return Ut.jsReplace(Ut.f("회원님의 아이디는 [ %s ] 입니다", member.getLoginId()), afterFindLoginIdUri);
	}

	// 비밀번호 찾기 jsp 연결
	@RequestMapping("usr/member/findLoginPw")
	public String showFindLoginPw() {
		return "usr/member/findLoginPw";
	}

	// 비밀번호 찾기 처리
	@RequestMapping("usr/member/doFindLoginPw")
	@ResponseBody
	public String doFindLoginPw(String loginId, String email,
			@RequestParam(defaultValue = "/") String afterFindLoginPwUri) {

		Member member = memberService.getMemberByLoginIdAndEmail(loginId, email);

		if (member == null) {
			return Ut.jsHistoryBack("일치하는 회원이 없습니다");
		}

		if (member.getEmail().equals(email) == false) {
			return Ut.jsHistoryBack("이메일이 일치하지 않습니다");
		}

		ResultData notifyTempLoginPwByEmailRd = memberService.notifyTempLoginPwByEmailRd(member);

		return Ut.jsReplace(notifyTempLoginPwByEmailRd.getMsg(), afterFindLoginPwUri);
	}

	// 로그아웃 처리
	@RequestMapping("usr/member/doLogout")
	@ResponseBody
	public String doLogout(@RequestParam(defaultValue = "/") String afterLogoutUri) {
		
		rq.logout();
		
		return Ut.jsReplace("로그아웃 되었습니다.", afterLogoutUri);
	}

	// 마이 페이지 jsp 연결
	@RequestMapping("usr/member/myPage")
	public String showMyPage(Model model) {
		int answerCount = answerService.getAnswerCountByMemberId(rq.getLoginedMemberId());
		
		model.addAttribute("answerCount", answerCount);
		
		int choicedAnswerCount = answerService.getChoicedAnswerCountByMemberId(rq.getLoginedMemberId());
		
		model.addAttribute("choicedAnswerCount", choicedAnswerCount);
		
		int questionCount = articleService.getQuestionCountByMemberId(rq.getLoginedMemberId());
		
		model.addAttribute("questionCount", questionCount);
		
		return "usr/member/myPage";
	}
	
	// 비밀번호 확인 jsp 연결
	@RequestMapping("usr/member/checkPassword")
	public String showCheckPassword() {
		return "usr/member/checkPassword";
	}
	
	// 비밀번호 확인 처리
	@RequestMapping("usr/member/doCheckPassword")
	@ResponseBody
	public String doCheckPassword(String loginPw, String replaceUri) {
		if(Ut.empty(loginPw)) {
			return rq.jsHistoryBack("비밀번호를 입력해주세요.");
		}
		
		if(rq.getLoginedMember().getLoginPw().equals(Ut.sha256(loginPw)) == false) {
			return rq.jsHistoryBack("비밀번호가 일치하지 않습니다.");
		}
		
		if(replaceUri.equals("../member/modify")) {
			String memberModifyAuthKey = memberService.genMemberModifyAuthKey(rq.getLoginedMemberId());
			
			replaceUri += "?memberModifyAuthKey=" + memberModifyAuthKey;
		}
		
		return Ut.jsReplace("", replaceUri);
	}
	
	// 회원정보 수정 jsp 연결
	@RequestMapping("usr/member/modify")
	public String showModify(String memberModifyAuthKey) {
		if(Ut.empty(memberModifyAuthKey)) {
			return rq.jsHistoryBackOnView("회원 수정 인증코드가 필요합니다.");
		}
		
		ResultData checkMemeberModifyAuthKeyRd = 
				memberService.checkMemeberModifyAuthKey(rq.getLoginedMemberId(), memberModifyAuthKey);
		
		if(checkMemeberModifyAuthKeyRd.isFail()) {
			return rq.jsHistoryBackOnView(checkMemeberModifyAuthKeyRd.getMsg());
		}
		
		return "usr/member/modify";
	}
	
	// 회원정보 수정 처리
	@RequestMapping("usr/member/doModify")
	@ResponseBody
	public String doModify(String memberModifyAuthKey, String loginPw, String name, 
			String nickname, String cellphoneNum, String email) {
		if(Ut.empty(memberModifyAuthKey)) {
			return rq.jsHistoryBackOnView("회원 수정 인증코드가 필요합니다.");
		}
		
		ResultData checkMemeberModifyAuthKeyRd = 
				memberService.checkMemeberModifyAuthKey(rq.getLoginedMemberId(), memberModifyAuthKey);
		
		if(checkMemeberModifyAuthKeyRd.isFail()) {
			return rq.jsHistoryBack(checkMemeberModifyAuthKeyRd.getMsg());
		}
		
		if(Ut.empty(loginPw)) {
			loginPw = null;
			return rq.jsHistoryBack("유지할 비밀번호 또는 새 비밀번호를 입력해주세요.");
		}
		
		ResultData modifyRd = 
				memberService.modify(rq.getLoginedMemberId(), loginPw, name, nickname, cellphoneNum, email);
		
		if(modifyRd.isFail()) {
			return rq.jsHistoryBack(modifyRd.getMsg());
		}
		
		return rq.jsReplace(modifyRd.getMsg(), "/usr/member/myPage");
		
	}
	
	// 중복 아이디 체크
	@RequestMapping("usr/member/getLoginIdDup")
	@ResponseBody
	public ResultData getLoginIdDup(String loginId) {
		
		if (Ut.empty(loginId)) {	
			return ResultData.from("F-1", "아이디를 입력해주세요.");
		}
		
		Member oldMember = memberService.getMemberByLoginId(loginId);
		
		if (oldMember != null) {
			return ResultData.from("F-2", "해당 아이디는 이미 사용중입니다.", "loginId", loginId);
		}
		
		return ResultData.from("S-1", "사용 가능한 아이디입니다.", "loginId", loginId);
	}
}