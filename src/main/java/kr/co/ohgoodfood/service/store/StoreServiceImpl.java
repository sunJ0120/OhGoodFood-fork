package kr.co.ohgoodfood.service.store;

import java.io.File;
import java.security.MessageDigest;
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
		vo.setStore_pwd(md5(vo.getStore_pwd()));
		return mapper.login(vo);
	}

	// 아이디 중복확인
	@Override
	public boolean isDuplicateId(String store_id) {
		Store store = mapper.findById(store_id); // paramMap 없이 바로 전달
		return store != null;
	}

	@Override
	public void registerStore(Store vo, MultipartFile[] storeImageFiles, String storeAddressDetail,
			HttpServletRequest request) throws Exception {

		// 비밀번호 암호화
		String rawPwd = vo.getStore_pwd();
		if (rawPwd != null && !rawPwd.isEmpty()) {
			vo.setStore_pwd(md5(rawPwd));
		}

		// 주소 합치기 (주소가 null일 가능성도 체크)
		if (vo.getStore_address() == null) {
			vo.setStore_address("");
		}
		if (storeAddressDetail != null && !storeAddressDetail.trim().isEmpty()) {
			vo.setStore_address(vo.getStore_address() + " " + storeAddressDetail);
		}

		// 카테고리 기본값 N (null 방지)
		vo.setCategory_bakery(vo.getCategory_bakery() == null ? "N" : vo.getCategory_bakery());
		vo.setCategory_salad(vo.getCategory_salad() == null ? "N" : vo.getCategory_salad());
		vo.setCategory_fruit(vo.getCategory_fruit() == null ? "N" : vo.getCategory_fruit());
		vo.setCategory_others(vo.getCategory_others() == null ? "N" : vo.getCategory_others());

		// confirmed, store_status 기본값 N
		vo.setConfirmed("N");
		vo.setStore_status("N");

		// insert 실행
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

		// 폴더가 없으면 생성
		File folder = new File(uploadDir);
		if (!folder.exists()) {
			folder.mkdirs();
		}

		String filename_org = file.getOriginalFilename();
		String filename_real = System.nanoTime() + filename_org.substring(filename_org.lastIndexOf("."));
		File saveFile = new File(uploadDir + filename_real);
		file.transferTo(saveFile);

		Image image = new Image();
		image.setStore_id(storeId);
		image.setStore_img(filename_real);
		mapper.insertImage(image);
	}

	// MD5 암호화 메서드 추가
	private String md5(String input) {
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			byte[] messageDigest = md.digest(input.getBytes());
			StringBuilder sb = new StringBuilder();
			for (byte b : messageDigest) {
				sb.append(String.format("%02x", b));
			}
			return sb.toString();
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	// 마이페이지
	// store_i로 마이페이지 조회
	@Override
	public Store getStoreDetail(String store_id) {
		return mapper.findById(store_id);
	}

	@Override
	public void updateStoreCategory(Store store) {
		// 1. 카테고리 체크박스 null 처리 (체크 안되면 null로 넘어옴)
		store.setCategory_bakery(store.getCategory_bakery() != null ? "Y" : "N");
		store.setCategory_salad(store.getCategory_salad() != null ? "Y" : "N");
		store.setCategory_fruit(store.getCategory_fruit() != null ? "Y" : "N");
		store.setCategory_others(store.getCategory_others() != null ? "Y" : "N");

		// 2. DB 업데이트
		mapper.updateStore(store);
	}
}
