package kr.co.ohgoodfood.service.store;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.co.ohgoodfood.dao.StoreMapper;
import kr.co.ohgoodfood.dto.Image;
import kr.co.ohgoodfood.dto.Store;

@Service
public class StoreServiceImpl implements StoreService {

	@Autowired
	private StoreMapper mapper;

	@Override
	public Store login(Store vo) {
		return mapper.login(vo);
	}

	// 아이디 중복확인
	@Override
	public boolean isDuplicateId(String store_id) {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("store_id", store_id);
		Store store = mapper.findById(paramMap);
		return store != null;
	}

	// 회원가입
	@Override
	public void signup(Store vo) {
		mapper.insert(vo);
	}

	//
	@Override
    public void registerStore(Store vo, MultipartFile[] storeImageFiles, String storeAddressDetail, HttpServletRequest request) throws Exception {
        
        // 주소 합치기 
        if (storeAddressDetail != null && !storeAddressDetail.trim().isEmpty()) {
            vo.setStore_address(vo.getStore_address() + " " + storeAddressDetail);
        }

        // 카테고리 기본값 N
        if (vo.getCategory_bakery() == null) vo.setCategory_bakery("N");
        if (vo.getCategory_salad() == null) vo.setCategory_salad("N");
        if (vo.getCategory_fruit() == null) vo.setCategory_fruit("N");
        if (vo.getCategory_others() == null) vo.setCategory_others("N");

		// confiremd, store_status 기본값 N
        vo.setConfirmed("N");
        vo.setStore_status("N");

        mapper.insert(vo);

        // 이미지 저장
        if (storeImageFiles != null) {
            for (MultipartFile file : storeImageFiles) {
                if (!file.isEmpty()) {
                    saveImage(vo.getStore_id(), file, request);
                }
            }
        }
	}

		// 이미지 저장
		public void saveImage(String storeId, MultipartFile file, HttpServletRequest request) throws Exception {
			String uploadDir = request.getRealPath("/resources/upload/");
			String filename_org = file.getOriginalFilename();
			String filename_real = System.nanoTime() + filename_org.substring(filename_org.lastIndexOf("."));
			File saveFile = new File(uploadDir + filename_real);
			file.transferTo(saveFile);

			Image image = new Image();
			image.setStore_id(storeId);
			image.setStore_img(filename_real);
			mapper.insertImage(image);
		}

}
