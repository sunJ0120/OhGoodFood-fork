package kr.co.ohgoodfood.util;

import lombok.extern.slf4j.Slf4j;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * StringSplitUtils
 *
 * DB에서 상품 상세를 가져올 때, 구분자(delimiter)로 구분해서 LIST로 만드는 역할을 하는 Utils
 * Utils 클래스의 경우, 순수하게 static method로만 사용하고 인스턴스화나 서브클래싱이 불가능하도록 처리
 */

@Slf4j
public enum StringSplitUtils {
    ;  // enum 상수를 없애서 인스턴스 생성 방지 (utils이라..)

    public static List<String> splitMenu(String rawMenu, String delimiter) {
        if (rawMenu == null || rawMenu.isBlank()) {
            return List.of();
        }

        List<String> list = Arrays.stream(rawMenu.split(delimiter))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .collect(Collectors.toList());

        return list;
    }
}
