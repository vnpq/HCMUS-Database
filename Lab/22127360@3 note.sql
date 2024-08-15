USE QLGiaoVienThamGiaDeTai;
GO

--TRUY VẤN CÓ ĐKIỆN LQUAN TỚI CHUỖI KÝ TỰ: LIKE, 
--VD3: Cho biết mã, họ tên và lương GV có tên Nguyễn Hoài An
select MAGV, HOTEN, LUONG
from GIAOVIEN
where HOTEN = N'Nguyễn Hoài An'

--VD4: CHo biết... có họ Nguyễn
select MAGV, HOTEN, LUONG
from GIAOVIEN
where HOTEN like N'Nguyễn%'
--Ghi chú: ko biết chính xác TOÀN BỘ chuỗi so sánh phải dùng LIKE/NOT LIKE

--VD5: .... có họ tên kết thúc bằng nh
select MAGV, HOTEN, LUONG
from GIAOVIEN
where HOTEN like N'%nh'


--DATEDIFF tính toán sự khác biệt giữa hai giá trị ngày tháng.
--Cú pháp: DATEDIFF (datepart, startdate, enddate)
select MAGV, HOTEN, 
	year(getdate()) - year(NGAYSINH) AS TUOI, --AS TUOI là đặt tên TUOI cho column này
	datediff(yy, NGAYSINH, GETDATE()) N'Tuổi' -- tương tự, có thể bỏ chữ AS - ngầm hiểu
from GIAOVIEN

-- In NAVG HOTEN với GV trên 50 tuổi
select MAGV, HOTEN, 
	datediff(yy, NGAYSINH, GETDATE()) TUOI
from GIAOVIEN
WHERE datediff(yy, NGAYSINH, GETDATE()) >=50

--NULL IS NULL...  đkiện logic AND OR
-- ko có ng quản lý

select MAGV, HOTEN from GIAOVIEN 
where (GVQLCM is null)

-- ko có ng quản lý và thuộc bộ môn HTTT
select MAGV, HOTEN from GIAOVIEN 
where (GVQLCM is null AND MABM = 'HTTT')

--between and/not between and