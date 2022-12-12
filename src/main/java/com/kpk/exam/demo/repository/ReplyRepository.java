package com.kpk.exam.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.kpk.exam.demo.vo.Reply;

@Mapper
public interface ReplyRepository {

	public void writeReply(int memberId, String relTypeCode, int relId, String body);

	public int getLastInsertId();

	public List<Reply> getForPrintReplies(String relTypeCode, int relId);

	public Reply getForPrintReply(int id);

	public void modifyReply(int id, String body);

	public void deleteReply(int id);
}
