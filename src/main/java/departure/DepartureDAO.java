package departure;

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

public class DepartureDAO {
	
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
    private HttpSession session;
	
	public DepartureDAO() {
	}
	
	private SqlSession sqlSession;

    public DepartureDAO(SqlSession sqlSession) {
        this.sqlSession = sqlSession;
    }
	
	// 세션 설정 메서드
    public void setSession( HttpSession session ) {
        this.session = session;
    }
	
    // 도착지 저장
    public int insertDeparture( Departure departure ) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
            session.insert( "DepartureDAO.insertDeparture", departure );
            session.commit();
            return 1;
        } catch ( Exception e ) {
			e.printStackTrace();
		}
        return -1;
    }

    // 회사별 출/도착지 리스트 조회
    public List<Departure> getDeparturesByCompany(String userType, String userCompany) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
        	Map<String, Object> params = new HashMap<>();
            params.put("userType", userType);
            params.put("userCompany", userCompany);
            session.commit();
            return session.selectList( "DepartureDAO.getDeparturesByCompany", params );
        }
    }
    
    public Departure getDepartureByName( String departureName ) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
            return session.selectOne("DepartureDAO.getDepartureByName", departureName);
        }
    }
    
    public int updateDeparture( String departureName, String departureCities, String departureTown, String departureDetailedAddress, String departureManager, String departureManagerPhoneNum, String etc) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
            Map<String, Object> params = new HashMap<>();
            params.put("departureName", departureName);
            params.put("departureCities", departureCities);
            params.put("departureTown", departureTown);
            params.put("departureDetailedAddress", departureDetailedAddress);
            params.put("departureManager", departureManager);
            params.put("departureManagerPhoneNum", departureManagerPhoneNum);
            params.put("etc", etc);

           int result = session.update("DepartureDAO.updateDeparture", params);
            session.commit();
            return (result > 0) ? 1 : -1;
        }
    }
    
    public boolean deleteDeparture(List<String> orderNumbers) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
        	sqlSession = MybatisUtil.getSession();
            int deletedRows = sqlSession.delete("DepartureDAO.deleteDeparture", orderNumbers);
            sqlSession.commit(); // 삭제 반영
            return deletedRows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false; 
    }
    
    public List<Departure> getDepartureList( String userType, String userCompany ) {
    	try( SqlSession session = MybatisUtil.getSession() ) {
    		Map<String, Object> params = new HashMap<>();
            params.put("userType", userType);
            params.put("userCompany", userCompany);
    		return session.selectList("DepartureDAO.getDepartureList", params);
    	}
    }
    
    public Departure getDepartureById(long orderNumber) {
    	try( SqlSession session = MybatisUtil.getSession() ) {
    		return session.selectOne("DepartureDAO.getDepartureById", orderNumber);
    	}
    }
    
    public int checkDuplicateDeparture(String departureName) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
            int count = session.selectOne("DepartureDAO.checkDuplicateDeparture", departureName);
            return count;
        } catch (Exception e) {
            e.printStackTrace();
            return -1; // 오류 발생 시 -1 반환
        }
    }
}
