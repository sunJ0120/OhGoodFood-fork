package kr.co.ohgoodfood.service.store;

import java.util.List;
import kr.co.ohgoodfood.dto.Image;
import kr.co.ohgoodfood.dto.Product;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

import kr.co.ohgoodfood.dto.Store;

public interface StoreService {

	public Store login(Store vo);

	public boolean isDuplicateId(String store_id);
	
	public void registerStore(Store vo, MultipartFile[] storeImageFiles, String storeAddressDetail, HttpServletRequest request) throws Exception;
	
	public void saveImage(String storeId, MultipartFile file, HttpServletRequest request) throws Exception;
	
	public Store getStoreDetail(String store_id);

	public void updateStoreCategory(Store vo);
	
	public List<Image> getImagesByStoreId(String store_id);
	
	public Product getProductByStoreId(String store_id);
	
	public void updateStoreStatus(String store_id, String status);

}
