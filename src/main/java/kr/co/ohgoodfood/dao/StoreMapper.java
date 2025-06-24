package kr.co.ohgoodfood.dao;

import org.apache.ibatis.annotations.Mapper;
import kr.co.ohgoodfood.dto.Image;
import kr.co.ohgoodfood.dto.Store;

@Mapper
public interface StoreMapper {
	public Store login(Store vo);

	public int insert(Store vo);

	public Store findById(String store_id);

	public void insertImage(Image image);

	public void updateStore(Store vo);
	
}
