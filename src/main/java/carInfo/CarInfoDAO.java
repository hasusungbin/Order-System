package carInfo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;

import arrival.Arrival;
import insertOrder.MybatisUtil;

public class CarInfoDAO {

	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	private HttpSession session;
	private SqlSession sqlSession;
	
	public CarInfoDAO() {
	}
	public CarInfoDAO(SqlSession sqlSession) {
        this.sqlSession = sqlSession;
    }
	
	public void setSession(HttpSession session) {
        this.session = session;
    }
	
	// 회사별 고정차량 리스트 조회
    public List<CarInfo> getCarInfosByCompany(String userType, String userCompany) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
        	sqlSession = MybatisUtil.getSession();
        	System.out.println(userType + ": userType");
        	System.out.println(userCompany + ": userCompany");
        	Map<String, Object> params = new HashMap<>();
            params.put("userType", userType);
            params.put("userCompany", userCompany);
            return session.selectList( "CarInfoDAO.getCarInfosByCompany", params );
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    //  저장
    public int insertCarInfo( CarInfo carInfo ) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
            session.insert( "CarInfoDAO.insertCarInfo", carInfo );
            session.commit();
            return 1;
        } catch ( Exception e ) {
			e.printStackTrace();
		}
        return -1;
    }
	
    public CarInfo getCarInfoByCarNumber( String carNumber ) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
            return session.selectOne("CarInfoDAO.getCarInfoByCarNumber", carNumber);
        }
    }
    
    public int updateCarInfo( String carNumber, String driverName, String carWeight, String driverPhoneNumber, String kindOfCar, String userCompany ) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
        	sqlSession = MybatisUtil.getSession();
            Map<String, Object> params = new HashMap<>();
            params.put("carNumber", carNumber);
            params.put("driverName", driverName);
            params.put("carWeight", carWeight);
            params.put("driverPhoneNumber", driverPhoneNumber);
            params.put("kindOfCar", kindOfCar);
            params.put("userCompany", userCompany);

           int result = session.update("CarInfoDAO.updateCarInfo", params);
            session.commit();
            return (result > 0) ? 1 : -1;
        }
    }
    
    public boolean deleteCarInfo(List<String> carNumbers) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
        	sqlSession = MybatisUtil.getSession();
            int deletedRows = sqlSession.delete("CarInfoDAO.deleteCarInfo", carNumbers);
            sqlSession.commit(); // 삭제 반영
            return deletedRows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false; 
    }
}
