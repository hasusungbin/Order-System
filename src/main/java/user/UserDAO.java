package user;

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

import insertOrder.MybatisUtil;

public class UserDAO {
	
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
    private HttpSession session;
	
	public UserDAO() {
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
	
	// 세션 설정 메서드
    public void setSession(HttpSession session) {
        this.session = session;
    }
	
	public int login( String userID, String userPassword ) {
		String SQL = "SELECT userPassword FROM USER WHERE userID = ?";
		try {
			pstmt = conn.prepareStatement( SQL );
			pstmt.setString( 1, userID );
			rs = pstmt.executeQuery();
			if( rs.next() ) {
				if(rs.getString(1).equals(userPassword)) {
					return 1; // 로그인 성공
				} else
					return 0; // 비밀번호 불일치
			}
			return -1; // 아이디가 없음
		} catch( Exception e ) {
			e.printStackTrace();
		}
		return -2; // 데이터베이스 오류
	}
	
	public ArrayList<User> getUserList() {
		String SQL = "SELECT * FROM USER WHERE userType <> 'admin'";
		ArrayList<User> userList = new ArrayList<User>();
		try {
			pstmt = conn.prepareStatement( SQL );
			rs = pstmt.executeQuery();
			while( rs.next() ) {
				User user = new User();
				user.setUserID( rs.getString(1) );
				user.setUserPassword( rs.getString(2) );
				user.setUserName( rs.getString(3) );
				user.setUserType( rs.getString(4) );
				user.setUserPhoneNumber( rs.getString(5) );
				user.setUserCompany( rs.getString(6) );
				user.setUserTeam( rs.getString(7) );
				userList.add( user );
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		return userList;
	}
	
	public ArrayList<User> getAdminUserList() {
		String SQL = "SELECT * FROM USER WHERE userType = 'admin'";
		ArrayList<User> userList = new ArrayList<User>();
		try {
			pstmt = conn.prepareStatement( SQL );
			rs = pstmt.executeQuery();
			while( rs.next() ) {
				User user = new User();
				user.setUserID( rs.getString(1) );
				user.setUserPassword( rs.getString(2) );
				user.setUserName( rs.getString(3) );
				user.setUserType( rs.getString(4) );
				user.setUserPhoneNumber( rs.getString(5) );
				user.setUserCompany( rs.getString(6) );
				user.setUserTeam( rs.getString(7) );
				userList.add( user );
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		return userList;
	}
	
	// 현재 로그인한 사용자의 userType 가져오기
    public String getUserType() {
        try (SqlSession sqlSession = MybatisUtil.getSession()) {
            String userID = getUserID();
            if (userID != null) {
                return sqlSession.selectOne("UserDAO.getUserType", userID);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
	
	public User getAdminUser(String userID) {
	    User user = null;
	    try {
	        String SQL = "SELECT userID, userPassword, userType FROM user WHERE userID = ?";
	        PreparedStatement pstmt = conn.prepareStatement(SQL);
	        pstmt.setString(1, userID);
	        ResultSet rs = pstmt.executeQuery();
	        
	        if (rs.next()) {
	            user = new User();
	            user.setUserID(rs.getString("userID"));
	            user.setUserPassword(rs.getString("userPassword"));
	            user.setUserType(rs.getString("userType"));  // userType 저장
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return user;
	}
	
	// 현재 로그인한 사용자의 userName 가져오기
    public String getUserName() {
        try (SqlSession sqlSession = MybatisUtil.getSession()) {
            String userID = getUserID();
            if (userID != null) {
                return sqlSession.selectOne("UserDAO.getUserName", userID);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 현재 로그인한 사용자의 userCompany 가져오기
    public String getUserCompany() {
        try (SqlSession sqlSession = MybatisUtil.getSession()) {
            String userID = getUserID();
            if (userID != null) {
                return sqlSession.selectOne("UserDAO.getUserCompany", userID);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 같은 userCompany에 속한 sales 유저 목록 가져오기 (manager 용)
    public List<String> getSalesUsersInCompany() {
        List<String> userList = new ArrayList<>();
        try (SqlSession sqlSession = MybatisUtil.getSession()) {
            String userCompany = getUserCompany();
            if (userCompany != null) {
                userList = sqlSession.selectList("UserDAO.getSalesUsersInCompany", userCompany);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userList;
    }
    
 // 현재 로그인한 userID 가져오기
    private String getUserID() {
        if (session != null) {
            return (String) session.getAttribute("userID");
        }
        return null;
    }
    
    public List<User> getUsersByCompany(String userCompany) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
            return session.selectList( "UserDAO.getUserByCompany", userCompany );
        }
    }
    
    public boolean isUserExists(String userID, String userPassword) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
            Map<String, Object> params = new HashMap<>();
            params.put("userID", userID);
            params.put("userPassword", userPassword);
            int count = session.selectOne("UserDAO.isUserExists", params);
            return count > 0;
        }
    }
    
    public void insertUser(User user) { 
        try ( SqlSession session = MybatisUtil.getSession() ) {
            session.insert("UserDAO.insertUser", user);
            session.commit();
        }
    }
}
