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
    private SqlSession sqlSession = MybatisUtil.getSession();
	
	public UserDAO() {
	}
	
	// 세션 설정 메서드
    public void setSession(HttpSession session) {
        this.session = session;
    }
	
    public User login(String userID, String userPassword) {
        User user = null;
        try {
            sqlSession = MybatisUtil.getSession();

            user = sqlSession.selectOne("UserDAO.login", 
                new User(userID, userPassword));

            if (user != null) {
            } else {
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (sqlSession != null) {
                sqlSession.close(); // ✅ 세션 닫기
            }
        }

        return user;
    }
	
    public List<User> getUserList() {
        List<User> userList = null;
        try ( SqlSession session = MybatisUtil.getSession() ) {
            // ✅ MyBatis selectList 사용
            userList = sqlSession.selectList("UserDAO.getUserList");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (sqlSession != null) {
                sqlSession.close(); // ✅ 세션 닫기
            }
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
        try (SqlSession session = MybatisUtil.getSession()) {
            String userID = getUserID();
            if (userID != null) {
                return sqlSession.selectOne("UserDAO.getUserType", userID);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public String getUserTypeByID( String userID ) {
        try (SqlSession session = MybatisUtil.getSession()) {
            if (userID != null) {
                return sqlSession.selectOne("UserDAO.getUserTypeByID", userID);
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
        try (SqlSession session = MybatisUtil.getSession()) {
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
        try (SqlSession session = MybatisUtil.getSession()) {
            String userID = getUserID();
            if (userID != null) {
                return sqlSession.selectOne("UserDAO.getUserCompany", userID);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
 // 현재 로그인한 사용자의 userCompany 가져오기
    public String getUserCompany( String userID ) {
        try (SqlSession session = MybatisUtil.getSession()) {
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
        try (SqlSession session = MybatisUtil.getSession()) {
            String userCompany = getUserCompany();
            if (userCompany != null) {
                userList = sqlSession.selectList( "UserDAO.getSalesUsersInCompany", userCompany );
            }
        } catch ( Exception e ) {
            e.printStackTrace();
        }
        return userList;
    }
    
 // 현재 로그인한 userID 가져오기
    public String getUserID() {
        if ( session != null ) {
            return ( String ) session.getAttribute( "userID" );
        }
        return null;
    }
    
    public List<User> getUserByCompany( String userCompany ) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
            return session.selectList( "UserDAO.getUserByCompany", userCompany );
        }
    }
    
    public boolean isUserExists( String userID, String userPassword ) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
            Map<String, Object> params = new HashMap<>();
            params.put( "userID", userID );
            params.put( "userPassword", userPassword );
            int count = session.selectOne( "UserDAO.isUserExists", params );
            return count > 0;
        }
    }
    
    public void insertUser( User user ) { 
        try ( SqlSession session = MybatisUtil.getSession() ) {
            session.insert( "UserDAO.insertUser", user );
            session.commit();
        }
    }
    
 // 로그인한 사용자 리스트 조회
    public List<User> getModifyUserList( String userType, String userID, String userCompany ) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
            if ( "admin".equals(userType) ) {
                return session.selectList( "UserDAO.getAdminUserList", userID );
            } else if ( "manager".equals(userType) ) {
                Map<String, Object> paramMap = new HashMap<>();
                paramMap.put( "userID", userID );
                paramMap.put( "userCompany", userCompany );
                List<User> modifyUserList = session.selectList( "UserDAO.getManagerUserList", paramMap );
                return (modifyUserList != null) ? modifyUserList : new ArrayList<>(); // Null 방지
            }
        } catch ( Exception e ) {
            e.printStackTrace();
        }
        return null;
    }
    
 // 선택한 유저 삭제 메서드
    public boolean deleteUser(List<String> userIDs) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
            int deletedRows = sqlSession.delete("UserDAO.deleteUser", userIDs);
            sqlSession.commit(); // 삭제 반영
            return deletedRows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false; 
    }
    
    public User getUserById( String userID ) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
            return session.selectOne("UserDAO.getUserById", userID);
        }
    }
    
    public int updateUser( String userID, String userPassword, String userName, String userType, String userPhoneNumber, String userCompany, String userTeam) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
            Map<String, Object> params = new HashMap<>();
            params.put("userID", userID);
            params.put("userPassword", userPassword);
            params.put("userName", userName);
            params.put("userType", userType);
            params.put("userPhoneNumber", userPhoneNumber);
            params.put("userCompany", userCompany);
            params.put("userTeam", userTeam);

           int result = session.update("UserDAO.updateUser", params);
            session.commit();
            return (result > 0) ? 1 : -1;
        }
    }
}
