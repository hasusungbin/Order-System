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

        // ✅ 검색 조건 파라미터 받기
        String endDate = request.getParameter("endDate");
        String endDate2 = request.getParameter("endDate2");
        String refNumber = request.getParameter("refNumber");
        String userName = request.getParameter("userName");
        String departureName = request.getParameter("departureName");
        String departureCities = request.getParameter("departureCities");
        String arrivalName = request.getParameter("arrivalName");
        String arrivalCities = request.getParameter("arrivalCities");
        String orderNumber = request.getParameter("orderNumber");
        String userType = request.getParameter("userType");

        int pageSize = 1000;
        int pageNumber = 1;

        // ✅ 검색 결과 저장할 리스트
        List<List<Order>> allPagedLists = new ArrayList<>();

        while (true) {
            List<Order> orderList = orderDAO.getPagedList(pageNumber, pageSize, endDate, endDate2, refNumber, userName, departureName, departureCities, arrivalName, arrivalCities, orderNumber);
            if (orderList.isEmpty()) {
                break;
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
            "오더번호", "운송요청일", "도착지 도착일시" , "참조번호", "출발지명", "출발지 주소",
            "도착지명", "도착지 주소", "화물톤급", "차량종류", "상하차 방식", "차량번호",
            "기사명", "기사연락처", "운송비금액", "담당자명", "등록일", "이착지 주소",
            "옵션1", "옵션2", "옵션3", "옵션4"
        };

        String[] companyColumns;
        if (includeUserCompany) {
            companyColumns = new String[columns.length + 1];
            System.arraycopy(columns, 0, companyColumns, 0, columns.length);
            companyColumns[columns.length] = "회사명";
        } else {
            companyColumns = columns;
        }

        int sheetIndex = 1;

        for (List<Order> orderList : allPagedLists) {
            Sheet sheet = workbook.createSheet("Page " + sheetIndex++);
            Row headerRow = sheet.createRow(0);

            // ✅ 헤더 생성
            String[] targetColumns = includeUserCompany ? companyColumns : columns;
            for (int i = 0; i < targetColumns.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(targetColumns[i]);
                CellStyle style = workbook.createCellStyle();
                Font font = workbook.createFont();
                font.setBold(true);
                style.setFont(font);
                cell.setCellStyle(style);
            }

            // ✅ 데이터 추가
            int rowNum = 1;
            for (Order order : orderList) {
                Row row = sheet.createRow(rowNum++);

                row.createCell(0).setCellValue(order.getOrderNumber());
                row.createCell(1).setCellValue(order.getOrderDate().toString().substring(0, 16));
                row.createCell(2).setCellValue(order.getEndDate().toString().substring(0, 16));
                row.createCell(3).setCellValue(order.getRefNumber() != null ? order.getRefNumber() : "");
                row.createCell(4).setCellValue(order.getDepartureName() != null ? order.getDepartureName() : "");
                row.createCell(5).setCellValue(order.getDepartureCities() + " " + order.getDepartureTown());
                row.createCell(6).setCellValue(order.getArrivalName() != null ? order.getArrivalName() : "");
                row.createCell(7).setCellValue(order.getArrivalCities() + " " + order.getDepartureTown());
                row.createCell(8).setCellValue(order.getCarWeight());
                row.createCell(9).setCellValue(order.getKindOfCar());
                row.createCell(10).setCellValue(order.getUpDown());
                row.createCell(11).setCellValue(order.getCarNumber() != null ? order.getCarNumber() : "");
                row.createCell(12).setCellValue(order.getDriverName() != null ? order.getDriverName() : "");
                row.createCell(13).setCellValue(order.getDriverPhoneNum() != null ? order.getDriverPhoneNum() : "");
                row.createCell(14).setCellValue(order.getBasicFare() + order.getAddFare());
                row.createCell(15).setCellValue(order.getUserName() != null ? order.getUserName() : "");
                row.createCell(16).setCellValue(order.getRegDate().toString().substring(0, 10));
                row.createCell(17).setCellValue(order.getDestinationAddress() != null ? order.getDestinationAddress() : "");
                row.createCell(18).setCellValue(order.getOption1() != null ? order.getOption1() : "");
                row.createCell(19).setCellValue(order.getOption2() != null ? order.getOption2() : "");
                row.createCell(20).setCellValue(order.getOption3() != null ? order.getOption3() : "");
                row.createCell(21).setCellValue(order.getOption4() != null ? order.getOption4() : "");
                if (includeUserCompany) {
                    row.createCell(22).setCellValue(order.getUserCompany() != null ? order.getUserCompany() : "");
                }
            }

            // ✅ 열 크기 강제 설정
            for (int i = 0; i < targetColumns.length; i++) {
                sheet.setColumnWidth(i, 4000);
            }
        }

        // ✅ 파일명 설정
        StringBuilder sb = new StringBuilder();
        sb.append(endDate != null ? endDate : "운송내역");
        sb.append(" 운송내역.xlsx");
        String fileName = URLEncoder.encode(sb.toString(), "UTF-8").replaceAll("\\+", "%20");

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        try (OutputStream outputStream = response.getOutputStream()) {
            workbook.write(outputStream);
        }

        workbook.close(); // ✅ 파일 닫기
    }
}