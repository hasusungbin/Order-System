package arrival;

import java.util.Date;

public class Arrival {
	
	private String Type;
	private String arrivalName;
	private String arrivalCities;
	private String arrivalTown;
	private String arrivalDetailedAddress;
	private String arrivalManager;
	private String arrivalManagerPhoneNum;
	private String etc;
	private Date regDate;
	
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
	public String getType() {
		return Type;
	}
	public void setType(String type) {
		Type = type;
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
}
