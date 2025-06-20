package kr.co.ohgoodfood.service.store;

import kr.co.ohgoodfood.dto.Review;
import kr.co.ohgoodfood.dto.Store;

public interface StoreService {

	public Store login(Store vo);

	public Review viewRiew(Store vo);
	

}
