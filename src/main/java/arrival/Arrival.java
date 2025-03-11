package arrival;

import java.text.SimpleDateFormat;
import java.util.Date;

public class Arrival {
	
	private long orderNumber;
	private String arrivalName;
	private String arrivalCities;
	private String arrivalTown;
	private String arrivalDetailedAddress;
	private String arrivalManager;
	private String arrivalManagerPhoneNum;
	private String etc;
	private Date regDate;
	private String userCompany;
	
	
	public Arrival() {
	}
	
	public Arrival( long orderNumber, String arrivalName, String arrivalCities, String arrivalTown, String arrivalDetailedAddress,
			String arrivalManager, String arrivalManagerPhoneNum, String etc, String userCompany ) {
		this.orderNumber = orderNumber;
		this.arrivalName = arrivalName;
		this.arrivalCities = arrivalCities;
		this.arrivalTown = arrivalTown;
		this.arrivalDetailedAddress = arrivalDetailedAddress;
		this.arrivalManager = arrivalManager;
		this.arrivalManagerPhoneNum = arrivalManagerPhoneNum;
		this.etc = etc;
		this.userCompany = userCompany;
	}
	
	public String getArrivalName() {
		return arrivalName;
	}
	public void setArrivalName(String arrivalName) {
		this.arrivalName = arrivalName;
	}
	public String getArrivalCities() {
		return arrivalCities;
	}
	public void setArrivalCities(String arrivalCities) {
		this.arrivalCities = arrivalCities;
	}
	public String getArrivalTown() {
		return arrivalTown;
	}
	public void setArrivalTown(String arrivalTown) {
		this.arrivalTown = arrivalTown;
	}
	public String getArrivalDetailedAddress() {
		return arrivalDetailedAddress;
	}
	public void setArrivalDetailedAddress(String arrivalDetailedAddress) {
		this.arrivalDetailedAddress = arrivalDetailedAddress;
	}
	public String getArrivalManager() {
		return arrivalManager;
	}
	public void setArrivalManager(String arrivalManager) {
		this.arrivalManager = arrivalManager;
	}
	public String getArrivalManagerPhoneNum() {
		return arrivalManagerPhoneNum;
	}
	public void setArrivalManagerPhoneNum(String arrivalManagerPhoneNum) {
		this.arrivalManagerPhoneNum = arrivalManagerPhoneNum;
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

	public long getOrderNumber() {
		return orderNumber;
	}

	public void setOrderNumber(long orderNumber) {
		this.orderNumber = orderNumber;
	}
}
