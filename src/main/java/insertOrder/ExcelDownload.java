package insertOrder;

import insertOrder.OrderDAO;
import insertOrder.Order;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/downloadExcel")
public class ExcelDownload extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    OrderDAO orderDAO = new OrderDAO();

	    // 검색 조건 파라미터 받기
	    String startDate = request.getParameter("startDate");
	    String endDate = request.getParameter("endDate");
	    String refNumberStr = request.getParameter("refNumber");
	    Integer refNumber = (refNumberStr != null && !refNumberStr.isEmpty()) ? Integer.parseInt(refNumberStr) : null;
	    String userName = request.getParameter("userName");
	    String departureName = request.getParameter("departureName");
	    String arrivalName = request.getParameter("arrivalName");
	    String arrivalCities = request.getParameter("arrivalCities");
	    String orderNumber = request.getParameter("orderNumber");
	    String userType = request.getParameter("userType");
	    System.out.println(userType + ": userType");
	    
	    int pageSize = 1000; // 한 번에 가져올 데이터 개수
	    int pageNumber = 1;
	    
	    // 검색 조건이 있으면 필터링된 데이터 가져오기, 없으면 전체 데이터 가져오기
	    List<List<Order>> allPagedLists = new ArrayList<>();
	    
	    while (true) {
	        List<Order> orderList = orderDAO.getPagedList(pageNumber, pageSize, startDate, endDate, refNumber, userName, departureName, arrivalName, arrivalCities, orderNumber);
	        if (orderList.isEmpty()) {
	            break; // 더 이상 가져올 데이터가 없으면 반복 종료
	        }
	        allPagedLists.add(orderList);
	        pageNumber++;
	    }
	    
	    if (allPagedLists.isEmpty()) {
	        response.setContentType("text/html;charset=UTF-8");
	        response.getWriter().println("<script>alert('다운로드 할 데이터가 없습니다.'); history.back();</script>");
	        return;
	    }
	    	
	    boolean includeUserCompany = "admin".equals(userType);
	    // ✅ 엑셀 파일 생성
	    Workbook workbook = new XSSFWorkbook();
	    String[] columns = {
	            "오더번호", "운송요청일", "참조번호", "출발지명", "출발지 주소", 
	            "도착지명", "도착지 주소", "화물톤급", "차량종류", "상하차 방식", "차량번호",
	            "기사명", "기사연락처", "운송비금액", "담당자명", "등록일",
	            "옵션1", "옵션2", "옵션3", "옵션4" // ✅ 추가된 헤더
	    };
	    
	    String[] companyColumns;
	    if (includeUserCompany) {
	        companyColumns = new String[columns.length + 1]; // ✅ 배열 크기 +1
	        System.arraycopy(columns, 0, companyColumns, 0, columns.length);
	        companyColumns[columns.length] = "회사명"; // ✅ 마지막 인덱스에 회사명 삽입
	    } else {
	        companyColumns = columns; // ✅ admin이 아니면 기존 배열 사용
	    }

	    int sheetIndex = 1;

	    // ✅ 여러 개의 리스트를 반복하여 시트 생성
	    for (List<Order> orderList : allPagedLists) {
	        Sheet sheet = workbook.createSheet("Page " + sheetIndex++);
	        Row headerRow = sheet.createRow(0);

	        // ✅ 헤더 생성
	        if( userType.equals("admin") ) {
	        	for (int i = 0; i < companyColumns.length; i++) { // ✅ companyColumns 사용
	        	    Cell cell = headerRow.createCell(i);
	        	    cell.setCellValue(companyColumns[i]); // ✅ companyColumns에서 헤더 값 세팅
	        	    CellStyle style = workbook.createCellStyle();
	        	    Font font = workbook.createFont();
	        	    font.setBold(true);
	        	    style.setFont(font);
	        	    cell.setCellStyle(style);
	        	}
	        } else {
	        	for (int i = 0; i < columns.length; i++) {
		            Cell cell = headerRow.createCell(i);
		            cell.setCellValue(columns[i]);
		            CellStyle style = workbook.createCellStyle();
		            Font font = workbook.createFont();
		            font.setBold(true);
		            style.setFont(font);
		            cell.setCellStyle(style);
		        }
	        }

	        // ✅ 데이터 추가
	        int rowNum = 1;
	        for (Order order : orderList) {
	            Row row = sheet.createRow(rowNum++);
	            
	            row.createCell(0).setCellValue(order.getOrderNumber());
	            row.createCell(1).setCellValue(order.getOrderDate().toString().substring(0, 16)); // ✅ 시분까지만 출력
	            row.createCell(2).setCellValue(order.getRefNumber() != 0 ? order.getRefNumber() : 0);
	            row.createCell(3).setCellValue(order.getDepartureName() != null ? order.getDepartureName() : "");
	            row.createCell(4).setCellValue(order.getDepartureCities() + " " + order.getDepartureTown());
	            row.createCell(5).setCellValue(order.getArrivalName() != null ? order.getArrivalName() : "");
	            row.createCell(6).setCellValue(order.getArrivalCities() + " " + order.getDepartureTown());
	            row.createCell(7).setCellValue(order.getCarWeight());
	            row.createCell(8).setCellValue(order.getKindOfCar());
	            row.createCell(9).setCellValue(order.getUpDown());
	            row.createCell(10).setCellValue(order.getCarNumber() != null ? order.getCarNumber() : "");
	            row.createCell(11).setCellValue(order.getDriverName() != null ? order.getDriverName() : "");
	            row.createCell(12).setCellValue(order.getDriverPhoneNum() != null ? order.getDriverPhoneNum() : "");
	            row.createCell(13).setCellValue(order.getBasicFare() + order.getAddFare() == 0 ? 0 : order.getBasicFare() + order.getAddFare());
	            row.createCell(14).setCellValue(order.getUserName() != null ? order.getUserName() : "");
	            row.createCell(15).setCellValue(order.getRegDate().toString().substring(0, 10));

	            // ✅ 추가된 옵션 값들 (필요에 따라 수정 가능)
	            row.createCell(16).setCellValue(order.getOption1() != null ? order.getOption1() : "");
	            row.createCell(17).setCellValue(order.getOption2() != null ? order.getOption2() : "");
	            row.createCell(18).setCellValue(order.getOption3() != null ? order.getOption3() : "");
	            row.createCell(19).setCellValue(order.getOption4() != null ? order.getOption4() : "");
	            if (includeUserCompany) {
	                row.createCell(20).setCellValue(order.getUserCompany() != null ? order.getUserCompany() : "");
	            }
	        }

	        // ✅ 👉 자동 열 너비 조정
	        for (int i = 0; i < columns.length; i++) {
	            sheet.autoSizeColumn(i);
	            
	            // ✅ 너비 강제 설정 (값이 잘려 보이지 않게 여유 공간 추가)
	            int width = sheet.getColumnWidth(i);
	            sheet.setColumnWidth(i, width + 1000);
	        }
	    }
	    
	 // ✅ 엑셀 파일 제목 설정
	    String fileName = (startDate != null ? startDate : "운송내역") + " 운송내역.xlsx";
	    String encodedFileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");

	    // ✅ 응답 헤더 설정
	    response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
	    response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"");

	    // ✅ 엑셀 파일 출력
	    try (OutputStream outputStream = response.getOutputStream()) {
	        workbook.write(outputStream);
	    }
	    workbook.close(); // ✅ workbook.close()는 마지막에 호출
	}
}
