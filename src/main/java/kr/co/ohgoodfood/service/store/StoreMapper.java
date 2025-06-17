package kr.co.ohgoodfood.service.store;

import org.apache.ibatis.annotations.Mapper;

import kr.co.ohgoodfood.dto.Store;

@Mapper
public interface StoreMapper {
	public Store login(Store vo);
}
