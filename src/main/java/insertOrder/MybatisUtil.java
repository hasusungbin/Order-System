package insertOrder;

import java.io.IOException;
import java.io.InputStream;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

public class MybatisUtil {
    private static SqlSessionFactory sqlSessionFactory;

    static {
        try {
            String resource = "Mybatis/config.xml"; // 경로 수정
            InputStream inputStream = Resources.getResourceAsStream(resource);
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("MyBatis 설정 파일 로딩 실패!");
        }
    }

    // 트랜잭션 명시적 관리 -> autoCommit = false
    public static SqlSession getSession() {
        if (sqlSessionFactory == null) {
            throw new IllegalStateException("MyBatis 설정이 로드되지 않았습니다.");
        }
        return sqlSessionFactory.openSession(false);  // 👈 트랜잭션 자동 커밋 해제
    }
}