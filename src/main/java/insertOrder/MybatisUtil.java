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
        	org.apache.ibatis.logging.LogFactory.useLog4J2Logging();
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
            synchronized (MybatisUtil.class) {
                if (sqlSessionFactory == null) {
                    try (InputStream inputStream = Resources.getResourceAsStream("Mybatis/config.xml")) {
                        sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
                    } catch (Exception e) {
                        throw new RuntimeException("MyBatis 설정 파일 로딩 실패!", e);
                    }
                }
            }
        }
        return sqlSessionFactory.openSession(false); // 자동 커밋 해제
    }
}