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
        
        int pageSize = 1000;  // 한 번에 가져올 데이터 개수
        int pageNumber = 1;
        
        // 검색 조건이 있으면 필터링된 데이터 가져오기, 없으면 전체 데이터 가져오기
        List<List<Order>> allPagedLists = new ArrayList<>();
        
        while (true) {
            List<Order> orderList = orderDAO.getPagedList(pageNumber, pageSize, startDate, endDate, refNumber, userName, departureName, arrivalName, arrivalCities, orderNumber);
            if (orderList.isEmpty()) {
                break;  // 더 이상 가져올 데이터가 없으면 반복 종료
            }
            allPagedLists.add(orderList);
            pageNumber++;
        }
        
        
        if( allPagedLists.isEmpty() ) {
        	response.setContentType("text/html;charset=UTF-8");
        	response.getWriter().println("<script>alert('다운로드 할 데이터가 없습니다.'); history.back();</script>");
        	return;
        }
        
     // 엑셀 파일 생성
        Workbook workbook = new XSSFWorkbook();
        String[] columns = {"오더번호", "운송요청일", "참조번호", "출발지명", "출발지 주소", "도착지명", "도착지 주소", "화물톤급", "차량종류", "차량번호", "기사명", "기사연락처", "운송비금액", "담당자명", "등록일"};

        // 여러 개의 리스트를 반복하여 시트 생성
        int sheetIndex = 1;
        for (List<Order> orderList : allPagedLists) {
            Sheet sheet1 = workbook.createSheet("Page " + sheetIndex++);
            Row headerRow1 = sheet1.createRow(0);

            // 헤더 생성
            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow1.createCell(i);
                cell.setCellValue(columns[i]);
                CellStyle style = workbook.createCellStyle();
                Font font = workbook.createFont();
                font.setBold(true);
                style.setFont(font);
                cell.setCellStyle(style);
            }

            // 데이터 추가
            int rowNum = 1;
            for ( Order order : orderList ) {
                Row row = sheet1.createRow( rowNum++ );
                row.createCell( 0 ).setCellValue( order.getOrderNumber() );
                row.createCell( 1 ).setCellValue( order.getOrderDate().toString() );
                row.createCell( 2 ).setCellValue( order.getRefNumber() != 0 ? order.getRefNumber() : 0);
                row.createCell( 3 ).setCellValue( order.getDepartureName() != null ? order.getDepartureName() : "" );
                row.createCell( 4 ).setCellValue( order.getDepartureCities() + " " + order.getDepartureTown() );
                row.createCell( 5 ).setCellValue( order.getArrivalName() != null ? order.getArrivalName() : "" );
                row.createCell( 6 ).setCellValue( order.getArrivalCities() + " " + order.getDepartureTown() );
                row.createCell( 7 ).setCellValue( order.getCarWeight() );
                row.createCell( 8 ).setCellValue( order.getKindOfCar() );
                row.createCell( 9 ).setCellValue( order.getCarNumber() != null ? order.getCarNumber() : "" );
                row.createCell( 10 ).setCellValue( order.getDriverName() != null ? order.getDriverName() : "" );
                row.createCell( 11 ).setCellValue( order.getDriverPhoneNum() != null ? order.getDriverPhoneNum() : "" );
                row.createCell( 12 ).setCellValue( order.getBasicFare() + order.getAddFare() == 0 ? 0 : order.getBasicFare() + order.getAddFare());
                row.createCell( 13 ).setCellValue( order.getUserName() != null ? order.getUserName() : "" );
                row.createCell( 14 ).setCellValue( order.getRegDate().toString() );
            }
        }

        // 응답 헤더 설정
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=화물조회 리스트.xlsx");

        // 엑셀 파일 출력
        OutputStream outputStream = response.getOutputStream();
        workbook.write(outputStream);
        workbook.close();
        outputStream.close();
    }
}
