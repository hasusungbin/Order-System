package arrival;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import insertOrder.MybatisUtil;

public class ArrivalDAO {
	
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
    private HttpSession session;
	private SqlSessionFactory sqlSessionFactory;
	
	public ArrivalDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/ORDERS?serverTimezone=UTC&useSSL=false";;
			String dbID = "root";
			String dbPassword = "root";
			Class.forName( "com.mysql.jdbc.Driver" );
			conn = DriverManager.getConnection( dbURL, dbID, dbPassword );
		} catch ( Exception e ) {
			e.printStackTrace();
		}
	}
	
	private SqlSession sqlSession;

    public ArrivalDAO(SqlSession sqlSession) {
        this.sqlSession = sqlSession;
    }
	
	// 세션 설정 메서드
    public void setSession( HttpSession session ) {
        this.session = session;
    }
	
    // 도착지 저장
    public int insertArrival( Arrival arrival ) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
        	System.out.println(arrival.getOrderNumber() + ": arrival.OrderNumber");
            session.insert( "ArrivalDAO.insertArrival", arrival );
            session.commit();
            return 1;
        } catch ( Exception e ) {
			e.printStackTrace();
		}
        return -1;
    }

    // 회사별 출/도착지 리스트 조회
    public List<Arrival> getArrivalsByCompany(String userType, String userCompany) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
        	Map<String, Object> params = new HashMap<>();
            params.put("userType", userType);
            params.put("userCompany", userCompany);
            return session.selectList( "ArrivalDAO.getArrivalsByCompany", params );
        }
    }
    
    // 검색 조건 설정 후 리스트 조회
    public List<Arrival> getSearchArrivalByCompany(String userType, String userCompany) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
        	Map<String, Object> params = new HashMap<>();
            params.put("userType", userType);
            params.put("userCompany", userCompany);
            return session.selectList( "ArrivalDAO.getSearchArrivalByCompany", params );
        }
    }
    
    public Arrival getArrivalByName( String arrivalName ) {
        try (SqlSession session = MybatisUtil.getSession()) {
            return session.selectOne("ArrivalDAO.getArrivalByName", arrivalName);
        }
    }
    
    public int updateArrival( String arrivalName, String arrivalCities, String arrivalTown, String arrivalDetailedAddress, String arrivalManager, String arrivalManagerPhoneNum, String etc) {
        try (SqlSession session = MybatisUtil.getSession()) {
            Map<String, Object> params = new HashMap<>();
            params.put("arrivalName", arrivalName);
            params.put("arrivalCities", arrivalCities);
            params.put("arrivalTown", arrivalTown);
            params.put("arrivalDetailedAddress", arrivalDetailedAddress);
            params.put("arrivalManager", arrivalManager);
            params.put("arrivalManagerPhoneNum", arrivalManagerPhoneNum);
            params.put("etc", etc);

           int result = session.update("ArrivalDAO.updateArrival", params);
            session.commit();
            return (result > 0) ? 1 : -1;
        }
    }
    
    public boolean deleteArrival(List<String> orderNumbers) {
        try (SqlSession sqlSession = MybatisUtil.getSession()) {
            int deletedRows = sqlSession.delete("ArrivalDAO.deleteArrival", orderNumbers);
            sqlSession.commit(); // 삭제 반영
            return deletedRows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false; 
    }
    
    public List<Arrival> getArrivalList( String userType, String userCompany ) {
    	try( SqlSession session = MybatisUtil.getSession() ) {
    		Map<String, Object> params = new HashMap<>();
            params.put("userType", userType);
            params.put("userCompany", userCompany);
    		return session.selectList("ArrivalDAO.getArrivalList", params);
    	}
    }
    
    public Arrival getArrivalById(int orderNumber) {
    	try( SqlSession session = MybatisUtil.getSession() ) {
    		return session.selectOne("ArrivalDAO.getArrivalById", orderNumber);
    	}
    }
}
