package kr.co.ohgoodfood.dto;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum PickupStatus {
    TODAY("오늘픽업"),
    TOMORROW("내일픽업"),
    SOLD_OUT("매진"),
    CLOSED("마감");

    private final String displayName;

    @Override
    public String toString() {
        return displayName;
    }
}
