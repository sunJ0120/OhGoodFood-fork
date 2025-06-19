package kr.co.ohgoodfood.dao;

import org.apache.ibatis.annotations.Mapper;

import kr.co.ohgoodfood.dto.Store;

@Mapper
public interface StoreMapper {
	public Store login(Store vo);

	public int insert(Store vo);

	
}
