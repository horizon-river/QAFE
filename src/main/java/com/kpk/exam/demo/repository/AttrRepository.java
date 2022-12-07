package com.kpk.exam.demo.repository;

import org.apache.ibatis.annotations.Mapper;

import com.kpk.exam.demo.vo.Attr;

@Mapper
public interface AttrRepository {
	int remove(String relTypeCode, int relId, String typeCode, String type2Code);

	int setValue(String relTypeCode, int relId, String typeCode, String type2Code, String value, String expireDate);

	Attr get(String relTypeCode, int relId, String typeCode, String type2Code);

	String getValue(String relTypeCode, int relId, String typeCode, String type2Code);
}