package departure;

import java.text.SimpleDateFormat;
import java.util.Date;

public class Departure {
	
	private long orderNumber;
	private String departureName;
	private String departureCities;
	private String departureTown;
	private String departureDetailedAddress;
	private String departureManager;
	private String departureManagerPhoneNum;
	private String etc;
	private Date regDate;
	private String userCompany;
	
	
	public Departure() {
	}
	
	public Departure( long orderNumber, String departureName, String departureCities, String departureTown, String departureDetailedAddress,
			String departureManager, String departureManagerPhoneNum, String etc, String userCompany ) {
		this.orderNumber = orderNumber;
		this.departureName = departureName;
		this.departureCities = departureCities;
		this.departureTown = departureTown;
		this.departureDetailedAddress = departureDetailedAddress;
		this.departureManager = departureManager;
		this.departureManagerPhoneNum = departureManagerPhoneNum;
		this.etc = etc;
		this.userCompany = userCompany;
	}
	public String getEtc() {
		return etc;
	}
	public void setEtc(String etc) {
		this.etc = etc;
	}
	public Date getRegDate() {
		return regDate;
	}
	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}
	public String getUserCompany() {
		return userCompany;
	}
	public void setUserCompany(String userCompany) {
		this.userCompany = userCompany;
	}
	public String getFormattedRegDate() {
        if (regDate == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 M월 d일");
        return sdf.format(regDate);
    }
	public String getDepartureName() {
		return departureName;
	}

	public void setDepartureName(String departureName) {
		this.departureName = departureName;
	}

	public String getDepartureCities() {
		return departureCities;
	}

	public void setDepartureCities(String departureCities) {
		this.departureCities = departureCities;
	}

	public String getDepartureTown() {
		return departureTown;
	}

	public void setDepartureTown(String departureTown) {
		this.departureTown = departureTown;
	}

	public String getDepartureDetailedAddress() {
		return departureDetailedAddress;
	}

	public void setDepartureDetailedAddress(String departureDetailedAddress) {
		this.departureDetailedAddress = departureDetailedAddress;
	}

	public String getDepartureManager() {
		return departureManager;
	}

	public void setDepartureManager(String departureManager) {
		this.departureManager = departureManager;
	}

	public String getDepartureManagerPhoneNum() {
		return departureManagerPhoneNum;
	}

	public void setDepartureManagerPhoneNum(String departureManagerPhoneNum) {
		this.departureManagerPhoneNum = departureManagerPhoneNum;
	}

	public long getOrderNumber() {
		return orderNumber;
	}

	public void setOrderNumber(long orderNumber) {
		this.orderNumber = orderNumber;
	}
}
