package kr.co.ohgoodfood.dao;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.co.ohgoodfood.dto.Image;
import kr.co.ohgoodfood.dto.Store;

@Mapper
public interface StoreMapper {
	public Store login(Store vo);

	public int insert(Store vo);

	public Store findById(Map<String, Object> paramMap);

	public void insertImage(Image image);
	
}
