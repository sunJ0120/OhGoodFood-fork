package kr.co.ohgoodfood.util;

import lombok.extern.slf4j.Slf4j;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

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

        log.info("StringSplitUtils에서 list : {}", list);
        return list;
    }
}
