package kr.co.ohgoodfood.config;

import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;

import javax.sql.DataSource;
import java.sql.Connection;

/**
 * MvcConfigTest.java
 * - DB Connection을 test하기 위한 test code
 */

@Slf4j
@ExtendWith(SpringExtension.class) //JUnit5 기반 test
@WebAppConfiguration
@ContextConfiguration(classes = {kr.co.ohgoodfood.config.MvcConfig.class})
public class MvcConfigTest {
    @Autowired
    private DataSource dataSource;

    @Test
    @DisplayName("✅ [Correct] DB testConnection() 테스트")
    void testConnection() throws Exception {
        //given

        //when
        Connection conn = dataSource.getConnection();

        //then
        log.info("Connection : {}", conn); //Connection 객체를 로그로 출력한다.
        Assertions.assertNotNull(conn); //connection이 존재할 경우, 객체가 null이 아니다.
    }
}