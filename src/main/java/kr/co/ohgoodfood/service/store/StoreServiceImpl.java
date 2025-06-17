package kr.co.ohgoodfood.service.store;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.ohgoodfood.dto.Store;


@Service
public class StoreServiceImpl implements StoreService{

	@Autowired
	private StoreMapper mapper;
	
	@Override
	public Store login(Store vo) {
		return mapper.login(vo);
	}
}
